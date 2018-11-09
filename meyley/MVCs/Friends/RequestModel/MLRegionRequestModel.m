//
//  MLRegionRequestModel.m
//  meyley
//
//  Created by chsasaw on 2017/5/14.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLRegionRequestModel.h"

@implementation MLRegionRequestModel

+ (void)getRegionWithParentId:(NSNumber *)parentId complete:(void (^)(HXSErrorCode, NSString *, NSArray<MLRegion *> *))block {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if(parentId) {
        [dic setObject:parentId forKey:@"regionId"];
    }
    
    [HXStoreWebService getRequest:ML_COMMUNITY_GET_REGION
                       parameters:dic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              DLog(@"------社区 全部地区 %@",data);
                              
                              if(kHXSNoError == status){
                                  
                                  NSMutableArray *resultArray = [NSMutableArray array];
                                  if(DIC_HAS_ARRAY(data, @"list")){
                                      NSArray *arr = [data objectForKey:@"list"];
                                      for(NSDictionary *dic in arr ){
                                          MLRegion *temp = [[MLRegion alloc] initWithDictionary:dic error:nil];
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

+ (void)getRegionListWithComplete:(void (^)(HXSErrorCode, NSString *, NSArray<MLRegion *> *))block {
    [HXStoreWebService getRequest:ML_COMMUNITY_REGION_LIST
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              DLog(@"------社区 全部地区 %@",data);
                              
                              if(kHXSNoError == status){
                                  
                                  NSMutableArray *resultArray = [NSMutableArray array];
                                  if(DIC_HAS_ARRAY(data, @"list")){
                                      NSArray *arr = [data objectForKey:@"list"];
                                      for(NSDictionary *dic in arr ){
                                          MLRegion *temp = [[MLRegion alloc] initWithDictionary:dic error:nil];
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
