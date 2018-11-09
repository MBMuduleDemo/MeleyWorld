//
//  ApplicationSettings.h
//  dorm
//
//  Created by hudezhi on 15/7/10.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXSEnvironmentType) {
    HXSEnvironmentProduct = 0,              //发布环境
    HXSEnvironmentTemai,                    // Dev环境
    HXSEnvironmentStage,                    // Stage测试
    HXSEnvironmentQA,                       // 测试环境

    HXSServiceURLCounts
};

@interface ApplicationSettings : NSObject

+ (ApplicationSettings *)instance;
+ (void)clearInstance;

// service base surl
- (NSString*)currentServiceURL;
- (NSString*)currentHttpsServiceURL;

- (HXSEnvironmentType)currentEnvironmentType;
- (void)setCurrentEnvironmentType:(HXSEnvironmentType)type;
- (NSString *)serviceURLForEnvironmentType:(HXSEnvironmentType) type;

@end
