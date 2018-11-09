//
//  HXSAlipayManager.m
//  store
//
//  Created by chsasaw on 15/4/23.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSAlipayManager.h"

#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+Addition.h"
#import "HXMacrosUtils.h"
#import "ApplicationSettings.h"
#import "HXSOrderInfo.h"
#import "HXMacrosEnum.h"

static HXSAlipayManager * alipay_instance = nil;

@interface HXSAlipayManager()

@end

@implementation HXSAlipayManager

+ (HXSAlipayManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (alipay_instance == nil) alipay_instance = [[HXSAlipayManager alloc] init];
    });
    return alipay_instance;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        
    }
    
    return self;
}

- (void)login {
    APayAuthInfo *authInfo = [[APayAuthInfo alloc] initWithAppID:@"" pid:@"" redirectUri:@""];
    [[AlipaySDK defaultService] authWithInfo:authInfo callback:^(NSDictionary *resultDic) {
        [self loginResult:resultDic];
    }];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (url && [url.host isEqualToString:@"safepay"]) {
        
        NSString * urlString = [NSString decodeString:url.query];
        id json = [NSJSONSerialization JSONObjectWithData:[urlString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];;
        if(json && [json isKindOfClass:[NSDictionary class]]) {
            if(DIC_HAS_DIC(json, @"memo")) {
                NSDictionary * memoDic = [json objectForKey:@"memo"];
                if(DIC_HAS_STRING(memoDic, @"memo") && DIC_HAS_STRING(memoDic, @"ResultStatus")) {
                    NSString * message = [memoDic objectForKey:@"memo"];
                    NSString * status = [memoDic objectForKey:@"ResultStatus"];
                    NSDictionary * result = nil;
                    if(DIC_HAS_DIC(memoDic, @"result")) {
                        result = [memoDic objectForKey:@"result"];
                    }
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                        [self.delegate payCallBack:status message:message result:result];
                    }
                }
            }
        }
        
        return YES;
    }else {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self loginResult:resultDic];
        }];
        
        return NO;
    }
}

- (void)loginResult:(NSDictionary *)dic {
    if(self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(thirdAccountDidLogin:)]) {
        [self.loginDelegate thirdAccountDidLogin:kHXSAlipayAccount];
    }
}

- (void)pay:(HXSOrderInfo *)orderInfo delegate:(id<HXSAlipayDelegate>)delegate
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    NSString *partner = nil;
    NSString *seller = nil;
    NSString *privateKey = nil;
    HXSEnvironmentType environmentType = [[ApplicationSettings instance] currentEnvironmentType];
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    if (HXSEnvironmentStage == environmentType
        || HXSEnvironmentQA == environmentType
        || HXSEnvironmentTemai == environmentType) {
        partner = @"2088021264733879";
        seller = @"ningff@59store.com";
        privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMDFzGuCF/YB2ycy\nA6EzLHTW1qVn4d3APcjvGFU7FpnX0P83n3ybHxDjv12y3jp9m1aONjCw9LGuJ63d\n5hXt6C3eww7+iz3k9QWWjB2ssvq0a9pfh5824IUAf1zFNANznaLDZzyOMLPpZjMt\nuN1w06t7dR0JDl1wb3PnacTIXQB9AgMBAAECgYAMjdUeOz6sOrq29r7dxKNkiIk6\nBGXlNxvO9iMzicGTC0cFF+4/Aysmwm43/+oRDRUMsf49dYi5+YmD/St6yh+QoBCj\n+w7J6BvYHcWJdyjIl8CLfdzePzh/DEU3Rb47c/XScxhM6/MfSO8RvNOt2sopk4R0\nEqiEvagCFiPEGcYLgQJBAPggDqT8WLPTP0Lb9BFB/GML3Epmn09rjm1l2vM9WHE7\ncT0GlmCfEdPk58fSYlTm8Y39T35iQjs1Km4TzeeQR4kCQQDG5ASvw9xhfeR15fOV\nEYSkzPa9iOFtpn3YqX1S8/UDvyPLT50LvKApRxKKw4fqvTL9LmkQ/q0xGqHgoeLf\nO0BVAkAw1Q5MxiUm7vJKVEOKifQEAjeOpPfBh6d2PE+FA5O+ZTZ6DivWRDgb/bbo\nCq2zi+gKS8ozU185i9MX6unhIvIRAkAtRd4jPExADO4iQDPQLOqqsNVBk5Ts5sci\nuIIEje+p6Kp3Lyoqb8dtXfZEi/m2X1bp9tSHv9EgqlVK0s7XzZ75AkEAjZuRy3V0\ncKS42q6nJRohPhyd1L+YyMUFFntxqKNg2AGQ7re/+jJVx9swgN95lljB4a26CArQ\nlaqAkJpC0jXTdw==";
    } else {
        partner = @"2088901490646751";
        seller = @"zkp@59food.com";
        privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAPdS8wdz1Gf+7T7j8b4Tw62QqThmfl5GA4D3XsOfg8zWgyagvvTng1f2QwouwBmxV4Yd5oAYK4/B3ZP+KfX6GT7vBHVBAtIWZdfFXFvj/kofaG2BVD+4cNNFaPApEFt8R91pV6TVWrO4rnbE0lz10Q/L5j1VLAKNXK/Nr8TqU/MVAgMBAAECgYA5drlmwt/YJeADm7ygOEFfw1u98fpsdwH7Zf5Ln3VlE3Y3dGPJzTy0JFChPgl+LrkyPSJAIt2EMjwEVap0L17LzpavPY0cvjBR3vmf76rBEQ2HCPNBVH5dF18oEdDSVu9eq8cQ5XCU1k0jAMFM4bJoG7mLUG3PVzvLboVLNhDqZQJBAP8i/6f/5N6JfS35Ic+5PgYIxpYNx1oLm1NRWv/B4JwHQs8KZzy7AA/GwGfRmfgdVda3s7KV7//HP0mNGWLAW28CQQD4KS7qQlIWKwAi9FoEfPxu8B4+ipsBlISysGG3Y34f9XW21iXuz+omdZpBSpLS8ZT39i6ua4H73qmWoi23sOe7AkEAi/U4B4HBnC4R5FlJKfk1Q/wmbAQs+oFpeIAlii1huFXnWUocrdzrQLxHqev6KXh2MS5evjWwDUDQv9lONrTMswJBAOAMRpgncncjMYddd1wv/7SlQ5kRiKrfjQLLLh3lTLzL3xBIvYyj2HIKoU8rZe3fQLCyaij9VSiyOgiOuZnrtPsCQBooAQ6R8roe9L0vl0i7pBkm8QoQdNhd/dtmLphCWHeT2WWLkoA7Mdvzo8CSC943jq9sDJlL1Fjcfkks8a+tiHg=";
    }
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.delegate = delegate;
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.app_id = partner;
    // NOTE: 商品数据
    order.biz_content = [[BizContent alloc] init];
    order.biz_content.timeout_express = @"30m";
    order.biz_content.out_trade_no = orderInfo.order_sn; //订单ID（由商家自行制定）
    order.biz_content.subject = [NSString stringWithFormat:@"59store%@订单", orderInfo.typeName]; //商品标题
    
    if (0 < [orderInfo.attach length]) {
        order.biz_content.body = orderInfo.attach;
    }
    
    if (environmentType == HXSEnvironmentStage) {
        order.notify_url =  @"http://pay.59store.net/pay/alipay/notify";
    } else if(environmentType == HXSEnvironmentQA) {
        order.notify_url = @"http://61.130.1.150:28081/pay/alipay/notify";
    } else if(environmentType == HXSEnvironmentTemai){
        order.notify_url = @"http://61.130.1.150:58091/pay/alipay/notify";
    }
    else {
        order.notify_url =  @"http://pay.59store.com/pay/alipay/notify";
    }
    
    order.method = @"alipay.trade.app.pay";
    order.charset = @"utf-8";
    
    // 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // 支付版本
    order.version = @"1.0";
    
    // sign_type设置
    order.sign_type = @"RSA";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"hxstore";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    DLog(@"orderSpec = %@",orderInfo);
    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
    NSString *signedString = @"";
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString != nil) {
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if(resultDic) {
                if(DIC_HAS_DIC(resultDic, @"memo")) {
                    NSDictionary * memoDic = [resultDic objectForKey:@"memo"];
                    if(DIC_HAS_STRING(memoDic, @"memo") && DIC_HAS_STRING(memoDic, @"ResultStatus")) {
                        NSString * message = [memoDic objectForKey:@"memo"];
                        NSString * status = [memoDic objectForKey:@"ResultStatus"];
                        NSDictionary * result = nil;
                        if(DIC_HAS_DIC(memoDic, @"result")) {
                            result = [memoDic objectForKey:@"result"];
                        }
                        
                        if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                            [self.delegate payCallBack:status message:message result:result];
                        }
                    }
                }else if(DIC_HAS_STRING(resultDic, @"memo") && [resultDic objectForKey:@"resultStatus"]) {
                    NSString * message = [resultDic objectForKey:@"memo"];
                    NSString * status = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"resultStatus"]];
                    NSString * result = [resultDic objectForKey:@"result"];
                    if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                        [self.delegate payCallBack:status message:message result:@{@"result":result}];
                    }
                }
            }
        }];
    }
}

@end
