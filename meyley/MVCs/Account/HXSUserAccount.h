//
//  HXSUserAccount.h
//  store
//
//  Created by chsasaw on 14/10/26.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSRegisterRequest.h"

@class HXSUserInfo, HXSUserBasicInfo;

@interface HXSUserAccount : NSObject

@property (copy, nonatomic) NSString * strToken;
@property (copy, nonatomic) NSNumber * userID;

+ (HXSUserAccount *) currentAccount;

- (void)updateToken;

- (void)registerWithMobile:(NSString *)mobile
                  password:(NSString *)password
            invitationcode:(NSString *)invitationcode
             completeBlock:(void (^)(HXSErrorCode code, NSString * msg, HXSUserBasicInfo *info))block;

- (void)login:(NSString *)mobile password:(NSString *)password;
- (void)loginWithThirdAccount:(NSString *)userID token:(NSString *)token;

- (void)logout;

- (BOOL)isLogin;

- (void) loadUserInfo;

// 我的用户信息
@property (strong, nonatomic) HXSUserInfo * userInfo;

- (NSString *)homeDirectory;

@end
