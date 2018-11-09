//
//  MLServiceRequestModel.h
//  meyley
//
//  Created by chsasaw on 2017/6/1.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLWaiterModel.h"

@interface MLServiceRequestModel : NSObject

/**
 *  客服列表
 *
 */
+ (void)getWaiterListWithProvince:(NSNumber *)provinceId
                             city:(NSNumber *)cityId
                         district:(NSNumber *)districtId
                         complete:(void(^)(HXSErrorCode code, NSString * message, NSArray<MLWaiterModel *> * waiters))block;


/**
 获取推荐客服

 @param block 回调
 */
+ (void)getRecommendWaiterListWithComplete:(void(^)(HXSErrorCode code, NSString * message, NSArray<MLWaiterModel *> * waiters))block;

/**
 获取历史客服
 
 @param block 回调
 */
+ (void)getHistoryWaiterListWithComplete:(void(^)(HXSErrorCode code, NSString * message, NSArray<MLWaiterModel *> * waiters))block;

/**
 获取附近客服
 
 @param block 回调
 */
+ (void)getNearbyWaiterListWithComplete:(void(^)(HXSErrorCode code, NSString * message, NSArray<MLWaiterModel *> * waiters))block;

/**
 查找客服
 
 @param block 回调
 */
+ (void)getWaiterListWithKeyword:(NSString *)keyword complete:(void(^)(HXSErrorCode code, NSString * message, NSArray<MLWaiterModel *> * waiters))block;

@end
