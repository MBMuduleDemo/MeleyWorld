//
//  LGPayViewController.m
//  meyley
//
//  Created by Bovin on 2018/9/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGPayViewController.h"
#import "LGCommitOrderResultModel.h"
#import "LGOrderPayView.h"
#import "LGUserMoneyIntegralModel.h"
#import "AppDelegate.h"

//支付的文件
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@interface LGPayViewController ()<LGOrderPayViewDelegate>

@property (nonatomic, strong) LGOrderPayView *payView;

@property (nonatomic, strong) LGUserMoneyIntegralModel *userModel;

@property (nonatomic, copy) NSString *useBlance;

@property (nonatomic, strong) NSNumber *surplusOrderPrice;

@property (nonatomic, assign) BOOL isPaySuccess;
@end

@implementation LGPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.payView];
    [self getUserAllBlance];
    self.isPaySuccess = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handlerWechatPayResult:) name:LGWechatPayResultNotification object:nil];
    
}
//获取用户余额积分信息
- (void)getUserAllBlance {
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSString *action = [NSString stringWithFormat:@"userId=%@",userId];
    [RequestUtil withGET:@"/api/ecs/user/moneyinfo.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            
            self.userModel = [LGUserMoneyIntegralModel mj_objectWithKeyValues:responseObject[@"result"]];
            self.payView.userMoney = self.userModel.userMoney;
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//余额支付接口
- (void)payOrderWithBlance {
    if ([self.useBlance floatValue]==0) {
        [TooltipView showMessage:@"您的余额不足，请使用其他方式支付" offset:0];
        return;
    }
    NSDictionary *action = @{@"orderSn":self.model.orderSn,@"surplus":self.useBlance.length?self.useBlance:@"0"};
    [RequestUtil withPOST:@"/api/ecs/pay/surplus.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [self getUserAllBlance];
            self.surplusOrderPrice = responseObject[@"result"][@"orderAmount"];
            if ([self.surplusOrderPrice integerValue] == 0) { //订单支付完成
                NSLog(@"dsdsfs");
                self.isPaySuccess = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    self.payView.frame = CGRectMake(0, Screen_H-240, Screen_W, 240);
                    [self.payView showPaySuccessView];
                }];
                
            }else {
                self.payView.useBlanceMoney = self.useBlance;
                [UIView animateWithDuration:0.3 animations:^{
                    self.payView.frame = CGRectMake(0, Screen_H-340, Screen_W, 340);
                    [self.payView needUpdateBlanceViewFrameWithSuccess:YES];
                }];
            }
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:50];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//支付宝支付
- (void)getAlipayOrderSign {
    NSString *orderPrice;
    if (self.surplusOrderPrice) {
        orderPrice = [NSString stringWithFormat:@"%0.2f",[self.surplusOrderPrice floatValue]];
    }else {
        orderPrice = self.model.orderAmount;
    }
    NSDictionary *action = @{@"orderSn":self.model.orderSn,@"orderAmount":orderPrice};
    [RequestUtil withPOST:@"/api/ecs/pay/alipay/createOrder.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            NSString *rsult = responseObject[@"result"];
            NSURL *AliPay_APPURL = [NSURL URLWithString:@"alipay:"];
            [[AlipaySDK defaultService] payOrder:rsult fromScheme:@"meyley" callback:^(NSDictionary *resultDic) {
                
                if (![[UIApplication sharedApplication] canOpenURL:AliPay_APPURL]) {
                    
                    NSArray *array = [[UIApplication sharedApplication] windows];
                    
                    UIWindow* win=[array objectAtIndex:0];
                    
                    [win setHidden:NO];
                }
                [self handlerAlipayResultWithDic:resultDic];
            }];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:50];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//微信支付
- (void)getWechatPayOrderSign {
    NSString *orderPrice;
    if (self.surplusOrderPrice) {
        orderPrice = [NSString stringWithFormat:@"%0.2f",[self.surplusOrderPrice floatValue]];
    }else {
        orderPrice = self.model.orderAmount;
    }
    NSDictionary *action = @{@"orderSn":self.model.orderSn,@"orderAmount":orderPrice};
    [RequestUtil withPOST:@"/api/ecs/pay/weixin/createOrder.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            if (![WXApi isWXAppInstalled]) {
                [TooltipView showMessage:@"请安装微信客户端" offset:50];
                return ;
            }
            
            NSDictionary *dict = responseObject[@"result"];
            //调起微信支付
            PayReq *req = [[PayReq alloc] init];
            req.openID = [dict objectForKey:@"appid"];//应用ID  微信开放平台审核通过的应用APPID
            req.partnerId = [dict objectForKey:@"partnerid"];//商户号  微信支付分配的商户号
            req.prepayId = [dict objectForKey:@"prepayid"];//预支付交易会话ID  微信返回的支付交易会话ID

            req.nonceStr = [dict objectForKey:@"noncestr"];//随机字符串
            req.timeStamp = [[dict objectForKey:@"timestamp"] intValue];//时间戳
            req.package = [dict objectForKey:@"pkg"];//扩展字段
            req.sign = [dict objectForKey:@"sign"];//签名
            [WXApi sendReq:req];
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:50];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark--处理支付宝,微信支付回调---
- (void)handlerAlipayResultWithDic:(NSDictionary *)resultDic {
    if([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
       
        NSLog(@"成功支付");
        [TooltipView showMessage:@"支付成功" offset:50];
        self.isPaySuccess = YES;
        [self closeOrderPayView];
        
    }else{ //支付失败
        [TooltipView showMessage:@"支付失败" offset:50];
    }
}
- (void)handlerWechatPayResult:(NSNotification *)notification {
    NSInteger flag = [[notification object] integerValue];//0 成功   -1 错误   -2 用户取消
    NSLog(@"微信支付回调 - %@", [notification object]);
    
    if(flag == 0) {
        [TooltipView showMessage:@"支付成功" offset:50];
        self.isPaySuccess = YES;
        [self closeOrderPayView];
        
        NSLog(@"成功");
    } else {
        
        if (flag == -1) {
            [TooltipView showMessage:@"支付失败" offset:50];
        }else if (flag == -2) {
            [TooltipView showMessage:@"取消支付" offset:50];
        }
        NSLog(@"%@", @[@"普通错误类型",@"用户点击取消并返回",@"发送失败",@"授权失败",@"微信不支持"][0-flag-1]);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.payView.frame = CGRectMake(0, Screen_H-285, Screen_W, 285);
    }];
}

#pragma amrk---LGOrderPayViewDelegate--
- (void)closeOrderPayView {
    [UIView animateWithDuration:0.3 animations:^{
        self.payView.frame = CGRectMake(0, Screen_H, Screen_W, 285);
    } completion:^(BOOL finished) {
        if (self.payFinishBlock) {
            self.payFinishBlock(NO);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}
- (void)userBlancePay {
    [UIView animateWithDuration:0.3 animations:^{
        self.payView.frame = CGRectMake(0, Screen_H-400, Screen_W, 400);
    }];
    
}
- (void)cancelBlancePay {
    [UIView animateWithDuration:0.3 animations:^{
        self.payView.frame = CGRectMake(0, Screen_H-285, Screen_W, 285);
    }];
}
- (void)sureUseBlancePay {
    
    [self payOrderWithBlance];
}
- (void)chooseThirdPayWithType:(LGPayType)payType {
    if (payType == LGPayTypeWechatPay) {
        [self getWechatPayOrderSign];
    }else {
        [self getAlipayOrderSign];
    }
}

- (void)endPay {
    [self closeOrderPayView];
}
- (void)goToHomeVC {
    [self closeOrderPayView];
}

- (void)useBlanceWithTextField:(UITextField *)textField {
    self.useBlance = textField.text;
}
- (void)seeOrderDetail {
    [UIView animateWithDuration:0.3 animations:^{
        self.payView.frame = CGRectMake(0, Screen_H, Screen_W, 285);
    } completion:^(BOOL finished) {
        if (self.payFinishBlock) {
            self.payFinishBlock(self.isPaySuccess);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (LGOrderPayView *)payView {
    
    if (!_payView) {
        
        _payView = [[LGOrderPayView alloc]initWithFrame:CGRectMake(0, Screen_H, Screen_W, 285)];
        _payView.orderPrice = self.model.orderAmount;
        _payView.delegate = self;
    }
    return _payView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
