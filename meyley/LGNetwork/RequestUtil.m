//
//  RequestUtil+RequestUtil.m
//  chebaoSimple
//
//  Created by HERUNLIN on 15/7/26.
//  Copyright (c) 2015年 leiyi. All rights reserved.
//

#import "RequestUtil.h"
#import "ManagerUtil.h"
#import "SingleClass.h"


@interface RequestUtil ()

@end

@implementation RequestUtil
/**  post请求:failure不显示弹框 */
+(NSURLSessionDataTask *) withPOST:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    //单例类
    SingleClass *single = [SingleClass shareSingleClass];
    NSDictionary *singleDic = @{@"action":URLString,@"params":parameters};
    BOOL isExist = [single searchObjectWithDic:singleDic];
    if (isExist == YES) {
        return nil;
    }else{
        [single insertObjectWithDic:singleDic];
        
        //进行post请求
        AFHTTPSessionManager *manager =[ManagerUtil buildManager];
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,URLString];
        NSURLSessionDataTask *task = [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [single delegateObjectWithDic:singleDic];
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            NSLog(@"params:%@\nresult:%@",singleDic,dataDic);
            
            if ([dataDic[@"code"] isEqualToString:@"520"]) {
                //弹出登录页 未登录
                
            }  else if ([dataDic[@"code"] isEqualToString:@"420"]){
                //重新登录
                NSUserDefaults *defauts = [NSUserDefaults standardUserDefaults];
                [defauts removeObjectForKey:@"utoken"];
                [defauts synchronize];
               
            } else if ([dataDic[@"code"] isEqualToString:@"200"]) {
                
            }
            if (success) {
                success(task,dataDic);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [single delegateObjectWithDic:singleDic];
            NSLog(@"params:%@\nerror:%@",singleDic,error);
            if (failure) {
                failure(task,error);
            }
        }];
        
        return task;
    }
}

+(NSURLSessionDataTask *)withGET:(NSString *)URLString
                      parameters:(NSString *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    //单例类
    SingleClass *single = [SingleClass shareSingleClass];
    NSDictionary *singleDic = @{@"action":URLString,@"params":parameters};
    BOOL isExist = [single searchObjectWithDic:singleDic];
    if (isExist == YES) {
        return nil;
    }else{
        if (parameters) {
            [single insertObjectWithDic:singleDic];
        }
        
        //进行post请求
        AFHTTPSessionManager *manager =[ManagerUtil buildManager];
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,URLString];
        if (parameters.length>0) {
            url = [NSString stringWithFormat:@"%@?%@",url,parameters];
        }

        url =  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLSessionDataTask *task = [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [single delegateObjectWithDic:singleDic];
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            NSLog(@"params:%@\nresult:%@",singleDic,dataDic);
            if (success) {
                success(task,dataDic);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [single delegateObjectWithDic:singleDic];
            NSLog(@"params:%@\nerror:%@",singleDic,error);
            if (failure) {
                failure(task,error);
            }
        }];
        return task;
    }
}



/**  获取当前屏幕显示的viewcontroller */
+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
}



+ (NSURLSessionDataTask *)GetAddressWithGET:(NSString *)URLString parameters:(NSString *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    //单例类
    SingleClass *single = [SingleClass shareSingleClass];
    NSDictionary *singleDic = @{@"action":URLString,@"params":parameters};
    BOOL isExist = [single searchObjectWithDic:singleDic];
    if (isExist == YES) {
        return nil;
    }else{
        if (parameters) {
            [single insertObjectWithDic:singleDic];
        }
        
        //进行post请求
        AFHTTPSessionManager *manager =[ManagerUtil buildManager];
        NSString *url = [NSString stringWithFormat:@"%@%@",addressUrl,URLString];
        if (parameters.length>0) {
            url = [NSString stringWithFormat:@"%@?%@",url,parameters];
        }
        
        url =  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLSessionDataTask *task = [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [single delegateObjectWithDic:singleDic];
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            NSLog(@"params:%@\nresult:%@",singleDic,dataDic);
            if (success) {
                success(task,dataDic);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [single delegateObjectWithDic:singleDic];
            NSLog(@"params:%@\nerror:%@",singleDic,error);
            if (failure) {
                failure(task,error);
            }
        }];
        return task;
    }
}

@end
