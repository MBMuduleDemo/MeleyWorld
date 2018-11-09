//
//  HXSCommunityModel.m
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityModel.h"
#import "HXSPost.h"
#import "MLUserSpace.h"
#import "HXSUserAccount.h"
#import "NSMutableDictionary+Safety.h"

//每页请求的数量
NSInteger const PageNum = 20;

@implementation HXSCommunityModel


+ (void)getCommunityPostListWithUserId:(NSNumber *)userId
                                  page:(NSNumber *)page
                              complete:(void (^)(HXSErrorCode, NSString *, NSArray *, NSString *))block {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:page forKey:@"page"];
    [dic setObject:@(PageNum) forKey:@"pageSize"];
    if(userId) {
        [dic setObject:userId forKey:@"userId"];
    }
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_FETCHMYPOSTS
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       DLog(@"------社区 全部帖子 %@",data);
                       
                       if(kHXSNoError == status){
                           
                           NSMutableArray *resultArray = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"dynamicsList")){
                               NSArray *arr = [data objectForKey:@"dynamicsList"];
                               for(NSDictionary *dic in arr ){
                                   HXSPost *temp = [HXSPost objectFromJSONObject:dic];
                                   [resultArray addObject:temp];
                               }
                           }
                           NSString *shareLinkStr = nil;
                           if (DIC_HAS_STRING(data, @"share_link")) {
                               shareLinkStr = data[@"share_link"];
                           }
                           
                           block(status,msg,resultArray,shareLinkStr);
                           
                       } else {
                           block(status,msg,nil,nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status,msg,nil,nil);
                   }];

}

+ (void)getCommunityPostDetialWithPostId:(NSString *)post_id complete:(void(^)(HXSErrorCode code, NSString * message, HXSPost * post))block{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:post_id forKey:@"dynamicsId"];
    if([HXSUserAccount currentAccount].isLogin) {
        [dic setObjectExceptNil:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    }
    
    [HXStoreWebService getRequest:ML_COMMUNITY_POST_DETIAL
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        DLog(@"------社区 获取帖子详情 %@",data);
        if(kHXSNoError == status){
            
            HXSPost *temp = [HXSPost objectFromJSONObject:data];

            block(status,msg,temp);
        } else {
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)communityDeletePostWithPostId:(NSString *)post_id complete:(void(^)(HXSErrorCode code, NSString * message, NSNumber * result_status))block{
    if(post_id.length == 0) {
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObjectExceptNil:post_id forKey:@"dynamicsId"];
    if([HXSUserAccount currentAccount].isLogin) {
        [dic setObjectExceptNil:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    }
    
    [HXStoreWebService postRequest:ML_COMMUNITY_POST_DELETE
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status) {
            NSNumber *resultStatus = [data objectForKey:@"result_status"];
            block(status,msg,resultStatus);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kMLPOSTSTATUSCHANGED object:nil];
        } else {
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)getCommunityUserSpaceInfoWithUserId:(NSString *)userId complete:(void (^)(HXSErrorCode, NSString *, MLUserSpace *))block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObjectExceptNil:userId forKey:@"ownerUserId"];
    if([HXSUserAccount currentAccount].isLogin) {
        [dic setObjectExceptNil:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    }
    [HXStoreWebService getRequest:HXS_USER_SPACE
                        parameters:dic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if(kHXSNoError == status) {
                                   MLUserSpace *result = [[MLUserSpace alloc] initWithDictionary:data error:nil];
                                   block(status,msg,result);
                               } else {
                                   block(status,msg,nil);
                               }
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,nil);
                           }];
}

+ (void)getCommunityUserFollowListWithUserId:(NSNumber *)userId complete:(void (^)(HXSErrorCode, NSString *, NSArray<HXSUserBasicInfo *> *))block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObjectExceptNil:userId forKey:@"userId"];
//    if([HXSUserAccount currentAccount].isLogin) {
//        [dic setObjectExceptNil:[HXSUserAccount currentAccount].userID forKey:@"userId"];
//    }
    [HXStoreWebService getRequest:ML_COMMUNITY_FOLLOW_LIST
                       parameters:dic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if(kHXSNoError == status) {
                                  NSMutableArray *users = [NSMutableArray array];
                                  NSArray *userDatas = [data objectForKey:@"list"];
                                  if(userDatas && userDatas.count > 0) {
                                      for(NSDictionary *dic in userDatas) {
                                          HXSUserBasicInfo *result = [[HXSUserBasicInfo alloc] initWithDictionary:dic error:nil];
                                          if(result) {
                                              [users addObject:result];
                                          }
                                      }
                                  }
                                  
                                  block(status,msg,users);
                              } else {
                                  block(status,msg,nil);
                              }
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];
}

@end
