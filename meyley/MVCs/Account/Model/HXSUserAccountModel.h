//
//  HXSUserAccountModel.h
//  store
//
//  Created by ArthurWang on 15/11/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebServiceErrorCode.h"

@class MLWaiterModel;
@class HXSUserBasicInfo;

@interface HXSUserAccountModel : NSObject

// 获取账户信息
+ (void)getUserInfo:(NSNumber *)uidNum complete:(void (^)(HXSErrorCode code, NSString *message, HXSUserBasicInfo *info))block;
// 获取客服信息
+ (void)getMyWaiterInfoWithComplete:(void (^)(HXSErrorCode code, NSString *message, MLWaiterModel *info))block;
+ (void)addMyWaiterWithWaiterId:(NSNumber *)waiterId complete:(void (^)(HXSErrorCode code, NSString *message, MLWaiterModel *info))block;
+ (void)removeMyWaiterWithWaiterId:(NSNumber *)waiterId complete:(void (^)(HXSErrorCode code, NSString *message, MLWaiterModel *info))block;

@end
