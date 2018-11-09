//
//  LGMyCommissionModel.h
//  meyley
//
//  Created by Bovin on 2018/10/23.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGMyCommissionModel : NSObject

@property (nonatomic, copy) NSString *orderSn;       //订单编号
@property (nonatomic, copy) NSString *orderId;      //订单ID
@property (nonatomic, copy) NSString *orderUser;   //订单拥有服务者
@property (nonatomic, copy) NSString *statusName;  //状态
@property (nonatomic, copy) NSString *orderAmount;   //订单金额
@property (nonatomic, copy) NSString *goodsCount;   //订单商品数量
@property (nonatomic, copy) NSString *money;        //佣金
@property (nonatomic, copy) NSString *affiliateStatus;   //状态码
@property (nonatomic, copy) NSString *point;        //积分

@end
