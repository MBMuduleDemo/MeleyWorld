//
//  HXSUserInfo.h
//  store
//
//  Created by chsasaw on 14/10/26.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kMywaiterUpated @"kMywaiterUpated"

@class HXSUserBasicInfo;
@class MLWaiterModel;

/*
 *  manager user info
 */
@interface HXSUserInfo : NSObject

@property (nonatomic, strong) HXSUserBasicInfo            *basicInfo;
@property (nonatomic, strong) MLWaiterModel *myWaiter;

- (void)logout;

#pragma mark - User info

- (void)updateUserInfo;
- (void)updateMyWaiter;
- (void)removeMyWaiter:(void (^)(BOOL success, NSString *msg))block;
- (void)addMyWaiter:(NSNumber *)waiterId complete:(void (^)(BOOL success, NSString *msg))block;
                     
@end
