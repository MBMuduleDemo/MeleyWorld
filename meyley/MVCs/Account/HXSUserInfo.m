//
//  HXSUserInfo.m
//  store
//
//  Created by chsasaw on 14/10/26.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSUserInfo.h"

#import "HXSUserAccountModel.h"
#import "HXSUserBasicInfo.h"
#import "HXMacrosDefault.h"
#import "HXSUserAccount.h"
#import "MLWaiterModel.h"

@interface HXSUserInfo()

@end

@implementation HXSUserInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadBasicInfo];
        
        [self updateUserInfo];
        [self updateMyWaiter];
    }
    return self;
}

- (void)loadBasicInfo {
    NSDictionary *basicInfo = [[NSDictionary alloc] initWithContentsOfFile:[self pathForUserInfo]];
    
    _basicInfo = [[HXSUserBasicInfo alloc] initWithDictionary:basicInfo error:nil];
}

- (void)updateUserInfo
{
    if([HXSUserAccount currentAccount].isLogin) {
        __weak typeof(self) weakSelf = self;
        
        [HXSUserAccountModel getUserInfo:[HXSUserAccount currentAccount].userID complete:^(HXSErrorCode code, NSString *message, HXSUserBasicInfo *info) {
            if (kHXSNoError == code) {
                
                weakSelf.basicInfo      = info;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoUpdated
                                                                    object:nil
                                                                  userInfo:nil];
            }
        }];
    }
}

- (void)updateMyWaiter
{
    if([HXSUserAccount currentAccount].isLogin) {
        __weak typeof(self) weakSelf = self;
        
        [HXSUserAccountModel getMyWaiterInfoWithComplete:^(HXSErrorCode code, NSString *message, MLWaiterModel *info) {
            if (kHXSNoError == code) {
                
                weakSelf.myWaiter      = info;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kMywaiterUpated
                                                                    object:nil
                                                                  userInfo:nil];
            }else if(kHXSNormalError == code){
                weakSelf.myWaiter = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:kMywaiterUpated
                                                                    object:nil
                                                                  userInfo:nil];
            }
        }];
    }
}

- (void)addMyWaiter:(NSNumber *)waiterId complete:(void (^)(BOOL, NSString *))block {
    if([HXSUserAccount currentAccount].isLogin) {
        __weak typeof(self) weakSelf = self;
        
        [HXSUserAccountModel addMyWaiterWithWaiterId:waiterId complete:^(HXSErrorCode code, NSString *message, MLWaiterModel *info) {
            if (kHXSNoError == code) {
                
                weakSelf.myWaiter      = nil;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kMywaiterUpated
                                                                    object:nil
                                                                  userInfo:nil];
            }
            
            if(block) {
                block(kHXSNoError == code, message);
            }
        }];
    }else {
        if(block) {
            block(NO, @"您还未登录");
        }
    }
}

- (void)removeMyWaiter:(void (^)(BOOL, NSString *))block {
    if([HXSUserAccount currentAccount].isLogin) {
        if(!_myWaiter || !_myWaiter.waiterId) {
            if(block) {
                block(NO, @"您没有客服");
            }
            
            return;
        }
        __weak typeof(self) weakSelf = self;
        
        [HXSUserAccountModel removeMyWaiterWithWaiterId:_myWaiter.waiterId complete:^(HXSErrorCode code, NSString *message, MLWaiterModel *info) {
            if (kHXSNoError == code) {
                
                weakSelf.myWaiter      = nil;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kMywaiterUpated
                                                                    object:nil
                                                                  userInfo:nil];
            }
            
            if(block) {
                block(kHXSNoError == code, message);
            }
        }];
    }else {
        if(block) {
            block(NO, @"您还未登录");
        }
    }
}

- (void)logout
{
    self.basicInfo      = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoUpdated
                                                        object:nil
                                                      userInfo:nil];
}

- (void)setBasicInfo:(HXSUserBasicInfo *)basicInfo {
    _basicInfo = basicInfo;
    
    [[_basicInfo toDictionary] writeToFile:[self pathForUserInfo] atomically:YES];
}

- (NSString *)pathForUserInfo {
    return [[[HXSUserAccount currentAccount] homeDirectory] stringByAppendingFormat:@"/%@.plist", [HXSUserAccount currentAccount].userID];
}

@end
