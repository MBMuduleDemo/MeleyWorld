//
//  ManagerUtil+ManagerUtil.m
//  chebaoSimple
//
//  Created by HERUNLIN on 15/7/27.
//  Copyright (c) 2015年 leiyi. All rights reserved.
//

#import "ManagerUtil.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;

static AFHTTPSessionManager *manager;

@interface ManagerUtil()

@end

@implementation ManagerUtil 

/**
 * 构建manager
 * @return AFHTTPSessionManager httpSessionManager
 */
+(AFHTTPSessionManager*)buildManager{
    if (manager == nil) {
        //设置和加入头信息
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:15];//超时时间为20s
    
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"application/octet-stream",@"text/plain",@"application/x-www-form-urlencoded",nil];
    }

    return manager;
}

/**
 * 构建自定义manager
 * @return AFHTTPSessionManager httpSessionManager
 */
+(AFHTTPSessionManager*)buildCustomManager:(NSString*)serverAddr{
    //设置和加入头信息
    AFHTTPSessionManager * custom = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    
    custom.responseSerializer = [AFHTTPResponseSerializer serializer];
    [custom.requestSerializer setTimeoutInterval:5];//超时时间为20s
    
    custom.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"application/octet-stream",@"text/plain",nil];
    
    return custom;
}
@end
