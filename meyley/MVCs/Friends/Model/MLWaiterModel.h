//
//  MLWaiterModel.h
//  meyley
//
//  Created by chsasaw on 2017/5/6.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLBaseModel.h"

@interface MLWaiterModel : MLBaseModel

@property (nonatomic, copy) NSString<Optional> *address;
@property (nonatomic, copy) NSString<Optional> *districtName;
@property (nonatomic, copy) NSString<Optional> *signature;
@property (nonatomic, copy) NSString<Optional> *waiterName;
@property (nonatomic, copy) NSNumber<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *headPic;
@property (nonatomic, copy) NSNumber<Optional> *isRenzheng;
@property (nonatomic, copy) NSString<Optional> *cityName;
@property (nonatomic, copy) NSString<Optional> *storePhone;
@property (nonatomic, copy) NSNumber<Optional> *rank;
@property (nonatomic, copy) NSNumber<Optional> *waiterId;
@property (nonatomic, copy) NSString<Optional> *storeName;
@property (nonatomic, copy) NSString<Optional> *provinceName;

@property (nonatomic, copy) NSString<Optional> *realName;
@property (nonatomic, copy) NSString<Optional> *adPic;
@property (nonatomic, copy) NSNumber<Optional> *ownerUserId;
@property (nonatomic, copy) NSString<Optional> *inviteCodeUrl;
@property (nonatomic, copy) NSNumber<Optional> *isWaiter;
@property (nonatomic, copy) NSString<Optional> *tag;
@property (nonatomic, copy) NSNumber<Optional> *tagRenzheng;
@property (nonatomic, copy) NSNumber<Optional> *isMyWaiter;

@end
