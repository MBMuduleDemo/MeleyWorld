//
//  LGOrderPayView.h
//  meyley
//
//  Created by Bovin on 2018/9/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, LGPayType) {
    LGPayTypeAlipay,
    LGPayTypeWechatPay,
};

@protocol LGOrderPayViewDelegate <NSObject>

@optional
- (void)closeOrderPayView;
- (void)userBlancePay;
- (void)cancelBlancePay;
- (void)sureUseBlancePay;
- (void)endPay;
- (void)goToHomeVC;
- (void)useBlanceWithTextField:(UITextField *)textField;
- (void)chooseThirdPayWithType:(LGPayType)payType;

//余额支付完成
- (void)seeOrderDetail;
@end

@interface LGOrderPayView : UIView

@property (nonatomic,weak)id<LGOrderPayViewDelegate>delegate;
//订单金额
@property (nonatomic, copy) NSString *orderPrice;
//用户余额
@property (nonatomic, copy) NSString *userMoney;

@property (nonatomic, assign) LGPayType payType;

//支付成功时使用了多少余额
@property (nonatomic, copy) NSString *useBlanceMoney;
//更新frame
- (void)needUpdateBlanceViewFrameWithSuccess:(BOOL)success;
//余额支付成功
- (void)showPaySuccessView;
@end
