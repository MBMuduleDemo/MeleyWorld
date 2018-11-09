//
//  AppDelegate+LGPay.m
//  meyley
//
//  Created by Bovin on 2018/9/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "AppDelegate+LGPay.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate ()<WXApiDelegate>


@end

@implementation AppDelegate (LGPay)

- (void)thirdPayApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [WXApi registerApp:@"wx3c4dbf905d0a540f" enableMTA:YES];
}
#pragma mark - 支付
//微信支付
- (void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        NSLog(@"response.errCode = %d",response.errCode);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LGWechatPayResultNotification object:[NSString stringWithFormat:@"%d",response.errCode]];
    }
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    if (url!=nil && [[url host] isEqualToString:@"pay"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
//ios 9.0之后，支付完成返回app回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"url====%@",[url host]);
    if ([[url host] isEqualToString:@"safepay"]){   //支付宝
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付结果==%@",resultDic);
        }];
    }else if([[url host] isEqualToString:@"pay"]) {   //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
//ios 9.0之前，支付完成返回app回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"url====%@",[url host]);
    if ([[url host] isEqualToString:@"safepay"]) {   //支付宝
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付结果==%@",resultDic);
        }];
    }else if([[url host] isEqualToString:@"pay"]) {   //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
@end
