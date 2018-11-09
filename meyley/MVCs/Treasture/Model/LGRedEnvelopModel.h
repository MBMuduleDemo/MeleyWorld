//
//  LGRedEnvelopModel.h
//  meyley
//
//  Created by Bovin on 2018/9/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGRedEnvelopModel : NSObject


@property (nonatomic, copy) NSString *bonusId;      //红包ID
@property (nonatomic, copy) NSString *bonusTypeId;  //红包类型id
@property (nonatomic, copy) NSString *typeName;     //红包类型名称
@property (nonatomic, copy) NSString *typeMoney;    //红包金额
@property (nonatomic, copy) NSString *minAmount;    //最小订单金额
@property (nonatomic, copy) NSString *useStartDate; //红包可以使用的开始时间
@property (nonatomic, copy) NSString *useEndDate;   //红包可以使用的结束时间
@property (nonatomic, copy) NSString *bonusSn;      //红包编号
@property (nonatomic, copy) NSString *userId;       //用户ID
@property (nonatomic, copy) NSString *isUsed;       //是否被使用
@property (nonatomic, copy) NSString *usedTime;     //使用的时间
@property (nonatomic, copy) NSString *orderId;      //使用红包的订单号

@end
