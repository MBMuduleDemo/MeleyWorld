//
//  RequestUtil+RequestUtil.h
//  chebaoSimple
//
//  Created by HERUNLIN on 15/7/26.
//  Copyright (c) 2015年 leiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUtil :NSObject

/**  post请求:failure不显示弹框 */
+(NSURLSessionDataTask *)withPOST:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+(NSURLSessionDataTask *)withGET:(NSString *)URLString
                       parameters:(NSString *)parameters
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


+(NSURLSessionDataTask *)GetAddressWithGET:(NSString *)URLString
                      parameters:(NSString *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
