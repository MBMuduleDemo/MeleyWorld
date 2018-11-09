//
//  HXSUserBasicInfo.h
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface HXSUserBasicInfo : JSONModel

@property (nonatomic, copy) NSNumber * userId;
@property (nonatomic, copy) NSString<Optional> * userName;
@property (nonatomic, copy) NSString<Optional> * realName;
@property (nonatomic, copy) NSString<Optional> * signature;
@property (nonatomic, copy) NSString<Optional> * mobile;

@property (nonatomic, copy) NSString<Optional> * inviteCodeUrl;
@property (nonatomic, copy) NSString<Optional> * headPic;
@property (nonatomic, copy) NSString<Optional> * inviteCode;

@property (nonatomic, copy) NSNumber<Optional> * sex;
@property (nonatomic, copy) NSNumber<Optional> * isVerify;
@property (nonatomic, copy) NSNumber<Optional> * rank;

@property (nonatomic, copy) NSString<Optional> * birthday; // 用户注册时间
@property (nonatomic, copy) NSString<Optional> * createTime;

@property (nonatomic, copy) NSNumber<Optional> * waiterId;
@property (nonatomic, copy) NSString<Optional> * waiterName;
@property (nonatomic, copy) NSString<Optional> * duty;
@property (nonatomic, copy) NSString<Optional> * weixin;
@property (nonatomic, copy) NSString<Optional> * qr_code;

@property (nonatomic, copy) NSString<Optional> * provinceName;
@property (nonatomic, copy) NSString<Optional> * cityName;
@property (nonatomic, copy) NSString<Optional> * isRenzheng;
@property (nonatomic, copy) NSNumber<Optional> * isMyWaiter;
@property (nonatomic, copy) NSNumber<Optional> * isWaiter;

@property (nonatomic, copy) NSString<Optional> *adPic;
@property (nonatomic, copy) NSNumber<Optional> *ownerUserId;
@property (nonatomic, copy) NSString<Optional> *tag;
@property (nonatomic, copy) NSNumber<Optional> *tagRenzheng;

- (NSString *)getSexString;

@end
