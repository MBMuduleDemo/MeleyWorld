//
//  MLServiceRequestModel.m
//  meyley
//
//  Created by chsasaw on 2017/6/1.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLServiceRequestModel.h"
#import "HXSUserAccount.h"

@implementation MLServiceRequestModel

+ (void)getWaiterListWithProvince:(NSNumber *)provinceId
                             city:(NSNumber *)cityId
                         district:(NSNumber *)districtId
                         complete:(void (^)(HXSErrorCode, NSString *, NSArray<MLWaiterModel *> *))block {
    if(!provinceId || !cityId || !districtId) {
        block(kHXSNormalError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:provinceId forKey:@"province"];
    [dic setObject:cityId forKey:@"city"];
    [dic setObject:districtId forKey:@"district"];
    
    [HXStoreWebService getRequest:ML_WAITER_ALL
                       parameters:dic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              DLog(@"------社区 全部地区 %@",data);
                              
                              if(kHXSNoError == status){
                                  
                                  NSMutableArray *resultArray = [NSMutableArray array];
                                  if(DIC_HAS_ARRAY(data, @"list")){
                                      NSArray *arr = [data objectForKey:@"list"];
                                      for(NSDictionary *dic in arr ){
                                          MLWaiterModel *temp = [[MLWaiterModel alloc] initWithDictionary:dic error:nil];
                                          [resultArray addObject:temp];
                                      }
                                  }
                                  
                                  block(status,msg,resultArray);
                                  
                              } else {
                                  block(status,msg,nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];
    

}

+ (void)getRecommendWaiterListWithComplete:(void (^)(HXSErrorCode, NSString *, NSArray<MLWaiterModel *> *))block {
    
    [HXStoreWebService getRequest:ML_WAITER_RECOMMEND
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              DLog(@"------ 推荐客服 %@",data);
                              
                              if(kHXSNoError == status){
                                  
                                  NSMutableArray *resultArray = [NSMutableArray array];
                                  if(DIC_HAS_ARRAY(data, @"list")){
                                      NSArray *arr = [data objectForKey:@"list"];
                                      for(NSDictionary *dic in arr ){
                                          MLWaiterModel *temp = [[MLWaiterModel alloc] initWithDictionary:dic error:nil];
                                          [resultArray addObject:temp];
                                      }
                                  }
                                  
                                  block(status,msg,resultArray);
                                  
                              } else {
                                  block(status,msg,nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];
    
    
}

+ (void)getHistoryWaiterListWithComplete:(void (^)(HXSErrorCode, NSString *, NSArray<MLWaiterModel *> *))block {
    if(![HXSUserAccount currentAccount].userID) {
        block(kHXSNormalError, @"您还未登录", nil);
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    [HXStoreWebService getRequest:ML_WAITER_HISTORY
                       parameters:dic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              DLog(@"------ 推荐客服 %@",data);
                              
                              if(kHXSNoError == status){
                                  
                                  NSMutableArray *resultArray = [NSMutableArray array];
                                  if(DIC_HAS_ARRAY(data, @"list")){
                                      NSArray *arr = [data objectForKey:@"list"];
                                      for(NSDictionary *dic in arr ){
                                          MLWaiterModel *temp = [[MLWaiterModel alloc] initWithDictionary:dic error:nil];
                                          [resultArray addObject:temp];
                                      }
                                  }
                                  
                                  block(status,msg,resultArray);
                                  
                              } else {
                                  block(status,msg,nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];
    
    
}

+ (void)getNearbyWaiterListWithComplete:(void (^)(HXSErrorCode, NSString *, NSArray<MLWaiterModel *> *))block {
    if(![HXSUserAccount currentAccount].userID) {
        block(kHXSNormalError, @"您还未登录", nil);
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@"杭州市" forKey:@"cityName"];
    [HXStoreWebService getRequest:ML_WAITER_NEARBY
                       parameters:dic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              DLog(@"------ 推荐客服 %@",data);
                              
                              if(kHXSNoError == status){
                                  
                                  NSMutableArray *resultArray = [NSMutableArray array];
                                  if(DIC_HAS_ARRAY(data, @"list")){
                                      NSArray *arr = [data objectForKey:@"list"];
                                      for(NSDictionary *dic in arr ){
                                          MLWaiterModel *temp = [[MLWaiterModel alloc] initWithDictionary:dic error:nil];
                                          [resultArray addObject:temp];
                                      }
                                  }
                                  
                                  block(status,msg,resultArray);
                                  
                              } else {
                                  block(status,msg,nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];
}

+ (void)getWaiterListWithKeyword:(NSString *)keyword complete:(void (^)(HXSErrorCode, NSString *, NSArray<MLWaiterModel *> *))block {
    if(![HXSUserAccount currentAccount].userID) {
        block(kHXSNormalError, @"您还未登录", nil);
        return;
    }
    
    if(keyword.length == 0 || ![keyword isKindOfClass:[NSString class]]) {
        block(kHXSNormalError, @"输入有误", nil);
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@"杭州市" forKey:@"cityName"];
    [dic setObject:keyword forKey:@"keywords"];
    [HXStoreWebService getRequest:ML_WAITER_SEARCH
                       parameters:dic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              DLog(@"------ 推荐客服 %@",data);
                              
                              if(kHXSNoError == status){
                                  
                                  NSMutableArray *resultArray = [NSMutableArray array];
                                  if(DIC_HAS_ARRAY(data, @"list")){
                                      NSArray *arr = [data objectForKey:@"list"];
                                      for(NSDictionary *dic in arr ){
                                          MLWaiterModel *temp = [[MLWaiterModel alloc] initWithDictionary:dic error:nil];
                                          [resultArray addObject:temp];
                                      }
                                  }
                                  
                                  block(status,msg,resultArray);
                                  
                              } else {
                                  block(status,msg,nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];
}

@end
