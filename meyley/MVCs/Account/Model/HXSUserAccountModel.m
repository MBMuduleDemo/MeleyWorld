//
//  HXSUserAccountModel.m
//  store
//
//  Created by ArthurWang on 15/11/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSUserAccountModel.h"
#import "HXStoreWebService.h"
#import "HXSUserBasicInfo.h"
#import "HXMacrosUtils.h"
#import "HXSUserAccount.h"
#import "MLWaiterModel.h"

@implementation HXSUserAccountModel

+ (void)getUserInfo:(NSNumber *)uidNum complete:(void (^)(HXSErrorCode, NSString *, HXSUserBasicInfo *))block
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     uidNum,@"ownerUserId", nil];
    if([[HXSUserAccount currentAccount] isLogin]) {
        [paramDic setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    }
    
    [HXStoreWebService getRequest:HXS_USER_INFO
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSUserBasicInfo * info = [[HXSUserBasicInfo alloc] initWithDictionary:data error:nil];
                       
                       block(status, msg, info);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

+ (void)getMyWaiterInfoWithComplete:(void (^)(HXSErrorCode, NSString *, MLWaiterModel *))block
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if([[HXSUserAccount currentAccount] isLogin]) {
        [paramDic setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    }else {
        block(kHXSNormalError, @"未登录", nil);
    }
    
    [HXStoreWebService getRequest:ML_MY_WAITER
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(kHXSNoError, msg, nil);
                                  
                                  return ;
                              }
                              
                              MLWaiterModel * info = [[MLWaiterModel alloc] initWithDictionary:data error:nil];
                              
                              block(status, msg, info);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

+ (void)addMyWaiterWithWaiterId:(NSNumber *)waiterId complete:(void (^)(HXSErrorCode, NSString *, MLWaiterModel *))block
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if([[HXSUserAccount currentAccount] isLogin]) {
        [paramDic setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
        [paramDic setObject:waiterId forKey:@"waiterId"];
    }else {
        block(kHXSNormalError, @"未登录", nil);
    }
    
    [HXStoreWebService postRequest:ML_ADD_WAITER
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(kHXSNoError, msg, nil);
                                  
                                  return ;
                              }
                              
                              MLWaiterModel * info = [[MLWaiterModel alloc] initWithDictionary:data error:nil];
                              
                              block(status, msg, info);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

+ (void)removeMyWaiterWithWaiterId:(NSNumber *)waiterId complete:(void (^)(HXSErrorCode, NSString *, MLWaiterModel *))block
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if([[HXSUserAccount currentAccount] isLogin]) {
        [paramDic setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
        [paramDic setObject:waiterId forKey:@"waiterId"];
    }else {
        block(kHXSNormalError, @"未登录", nil);
    }
    
    [HXStoreWebService postRequest:ML_REMOVE_MY_WAITER
                       parameters:paramDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(kHXSNoError, msg, nil);
                                  
                                  return ;
                              }
                              
                              MLWaiterModel * info = [[MLWaiterModel alloc] initWithDictionary:data error:nil];
                              
                              block(status, msg, info);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

@end
