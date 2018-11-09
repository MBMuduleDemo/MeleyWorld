//
//  HXStoreWebService.h
//  Pods
//
//  Created by ArthurWang on 16/6/8.
//
//

#import <Foundation/Foundation.h>

#import "HXStoreWebServiceErrorCode.h"
#import "HXStoreWebServiceURL.h"
#import "AFNetworking.h"

#define SYNC_RESPONSE_STATUS @"status"
#define SYNC_RESPONSE_MSG  @"msg"
#define SYNC_RESPONSE_DATA @"result"

@interface HXStoreWebService : NSObject

+ (NSURLSessionDataTask *)postRequest:(NSString*)path
                           parameters:(id)parameters
                             progress:(void (^)(NSProgress *))uploadProgress
                              success:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))success
                              failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure;

+ (NSURLSessionDataTask *)getRequest:(NSString*)path
                          parameters:(NSDictionary*)parameters
                            progress:(void (^)(NSProgress *))downloadProgress
                             success:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))success
                             failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure;

+ (NSURLSessionDataTask *)uploadRequest:(NSString*)path
                             parameters:(NSDictionary*)parameters
                          constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                               progress:(void (^)(NSProgress *))uploadProgress
                                success:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))success
                                failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure;

+ (NSURLSessionDataTask *)putRequest:(NSString*)path
                          parameters:(NSDictionary*)parameters
                             success:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))success
                             failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure;

+ (NSURLSessionDataTask *)deleteRequest:(NSString*)path
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))success
                                failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure;

@end
