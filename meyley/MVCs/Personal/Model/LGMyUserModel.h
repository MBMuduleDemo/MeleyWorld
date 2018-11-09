//
//  LGMyUserModel.h
//  meyley
//
//  Created by Bovin on 2018/10/23.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGMyUserModel : NSObject

@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userSn;
@property (nonatomic, copy) NSString *headpic;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *email;


@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *userMoney;
@property (nonatomic, copy) NSString *frozenMoney;
@property (nonatomic, copy) NSString *payPoints;
@property (nonatomic, copy) NSString *rankPoints;
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *regTime;

@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *inviteCodeUrl;

@property (nonatomic, copy) NSString *userRank;
@property (nonatomic, copy) NSString *ecSalt;
@property (nonatomic, copy) NSString *salt;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *weixin;
@property (nonatomic, copy) NSString *qrCode;
@property (nonatomic, copy) NSString *lastLogin;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *isDelete;
@property (nonatomic, assign) Boolean verify;


@end
