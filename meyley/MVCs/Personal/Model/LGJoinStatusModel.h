//
//  LGJoinStatusModel.h
//  meyley
//
//  Created by 李保洋 on 2018/11/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGJoinStatusModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *weixin;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *detailAddr;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *waiterType;
@property (nonatomic, copy) NSString *waiterTypeName;
@property (nonatomic, copy) NSString *businessCode;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *statusName;
@property (nonatomic, copy) NSString *statusQuery;
@property (nonatomic, copy) NSString *authInfo;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *orderTypeId;
@property (nonatomic, copy) NSString *orderTypeName;
@property (nonatomic, copy) NSString *orderTypeMoney;
@property (nonatomic, copy) NSString *applytime;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *payNo;
@property (nonatomic, copy) NSString *payTime;

@end
