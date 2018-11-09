//
//  LGPromotionHomeModel.h
//  meyley
//
//  Created by Bovin on 2018/10/23.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGPromotionHomeModel : NSObject

@property (nonatomic, copy) NSString *userId;      //用户Id
@property (nonatomic, copy) NSString *userName;      //我的昵称
@property (nonatomic, copy) NSString *inviteCode;   //邀请码
@property (nonatomic, copy) NSString *invitePicUrl; //邀请码图片
@property (nonatomic, copy) NSString *isWaiter;      //是否是服务人员

@property (nonatomic, copy) NSString *totalMoney;      //服务佣金
@property (nonatomic, copy) NSString *totalPoint;      //奖励积分
@property (nonatomic, copy) NSString *unsettledOrderNum; //未结算订单数

@property (nonatomic, copy) NSString *allOrderNum; //订单数
@property (nonatomic, copy) NSString *myInviteUserCount;  //我邀请的人
@property (nonatomic, copy) NSString *myUserCount;      //我服务的会员

@property (nonatomic, copy) NSString *status;      //状态

@end
