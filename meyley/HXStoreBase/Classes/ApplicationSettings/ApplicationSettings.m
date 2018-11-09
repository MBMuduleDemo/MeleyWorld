//
//  ApplicationSettings.m
//  dorm
//
//  Created by hudezhi on 15/7/10.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.


#import "ApplicationSettings.h"

#import "HXMacrosDefault.h"

#pragma mark - Service Url
//==============================================================================
//// http
//NSString* const HXSServiceURLProduct      = @"http://www.meyley.cn/api";
//
//NSString* const HXSServiceURLTest         = @"http://www.meyley.cn/api";
//
//NSString* const HXSServiceURLStage        = @"http://www.meyley.cn/api";
//
//NSString* const HXSServiceURLQA           = @"http://www.meyley.cn/api";
//
//// https
//NSString* const HXSServiceHttpsURLProduct = @"https://www.meyley.cn/api";
//
//NSString* const HXSServiceHttpsURLTest    = @"https://www.meyley.cn/api";
//
//NSString* const HXSServiceHttpsURLStage   = @"https://www.meyley.cn/api";
//
//NSString* const HXSServiceHttpsURLQA      = @"https://www.meyley.cn/api";

// http
NSString* const HXSServiceURLProduct      = @"http://www.meyley.com:8080/api";

NSString* const HXSServiceURLTest         = @"http://www.meyley.com:8080/api";

NSString* const HXSServiceURLStage        = @"http://www.meyley.com:8080/api";

NSString* const HXSServiceURLQA           = @"http://www.meyley.com:8080/api";

// https
NSString* const HXSServiceHttpsURLProduct = @"http://www.meyley.com/api";

NSString* const HXSServiceHttpsURLTest    = @"http://www.meyley.com/api";

NSString* const HXSServiceHttpsURLStage   = @"https://www.meyley.cn/api";

NSString* const HXSServiceHttpsURLQA      = @"https://www.meyley.cn/api";

#pragma mark - ApplicationSettings Keys
//==============================================================================

NSString* const kServiceURL                    = @"kServiceURL";
NSString* const kServiceURLType                = @"kServiceURLType";

static ApplicationSettings * instance;

@interface ApplicationSettings() {
    
}

@end

@implementation ApplicationSettings

+ (ApplicationSettings *)instance {
    @synchronized(self) {
        if (!instance) {
            instance = [[ApplicationSettings alloc] init];
        }
    }
    return instance;
}

+ (void)clearInstance {
    @synchronized(self) {
        if (instance) {
            instance = nil;
        }
    }
}

- (NSString*)currentServiceURL
{
    NSString *urlStr = [self serviceURLForEnvironmentType:[self currentEnvironmentType]];
    
    return urlStr;
}

- (NSString*)currentHttpsServiceURL
{
    NSString *urlStr = [self serviceHttpsURLForEnvironmentType:[self currentEnvironmentType]];
    
    return urlStr;
}

- (void)setCurrentServiceURL:(NSString*)urlString
{
    [[NSUserDefaults standardUserDefaults] setObject:urlString forKey:kServiceURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (HXSEnvironmentType)currentEnvironmentType
{
#if DEBUG
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: kServiceURLType];
    
    return (number == nil) ? HXSEnvironmentQA : (HXSEnvironmentType)[number intValue];
#else
    return HXSEnvironmentProduct;
#endif
}

- (void)setCurrentEnvironmentType:(HXSEnvironmentType)type
{
    [[NSUserDefaults standardUserDefaults] setObject:@(type) forKey:kServiceURLType];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UPDATE_DEVICE_FINISHED];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSUserID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSToken];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)serviceURLForEnvironmentType:(HXSEnvironmentType) type {
    switch(type) {
        case HXSEnvironmentProduct:    return HXSServiceURLProduct;
        case HXSEnvironmentTemai:       return HXSServiceURLTest;
        case HXSEnvironmentStage:      return HXSServiceURLStage;
        case HXSEnvironmentQA:         return HXSServiceURLQA;
        default:
            break;
    }
    return @"";
}

- (NSString *)serviceHttpsURLForEnvironmentType:(HXSEnvironmentType) type {
    switch(type) {
        case HXSEnvironmentProduct:    return HXSServiceHttpsURLProduct;
        case HXSEnvironmentTemai:       return HXSServiceHttpsURLTest;
        case HXSEnvironmentStage:      return HXSServiceHttpsURLStage;
        case HXSEnvironmentQA:         return HXSServiceHttpsURLQA;
        default:
            break;
    }
    return @"";
}

@end
