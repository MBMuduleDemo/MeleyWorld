//
//  HXSCommunityTagModel.m
//  store
//
//  Created by 格格 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityTagModel.h"
#import "HXSPost.h"

@implementation HXSCommunityTagModel

/**
 关注
 */
+ (void)communityFollowUserWithUserId:(NSString *)userId complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block {
    if(userId.length == 0) return;
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:userId forKey:@"followUserId"];
    [diction setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_FOLLOW_USER
                        parameters:diction
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if(status == kHXSNoError) {
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kMLPOSTSTATUSCHANGED object:nil];
                               }
                               
                               block(status,msg,data);
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
                           }];

}

/**
 取消关注
 */
+ (void)communityUnFollowUserWithUserId:(NSString *)userId complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block {
    if(userId.length == 0) return;
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:userId forKey:@"followUserId"];
    [diction setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_FOLLOW_CANCEL
                        parameters:diction
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if(status == kHXSNoError) {
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kMLPOSTSTATUSCHANGED object:nil];
                               }
                               
                               block(status,msg,data);
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
                           }];
    
}

// 收藏
+(void)communityAddLikeWithPostId:(NSString *)post_id complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block
{
    if(post_id.length == 0) return;
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"dynamicsId"];
    [diction setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    [HXStoreWebService postRequest:HXS_COMMUNITY_COLLECT_ADD
                        parameters:diction
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               
                               if(status == kHXSNoError) {
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kMLPOSTSTATUSCHANGED object:nil];
                               }
                               
                               block(status,msg,data);
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
                           }];
}

// 取消收藏
+(void)communityCancelLikeWithPostId:(NSString *)post_id complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block
{
    if(post_id.length == 0) return;
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"dynamicsId"];
    [diction setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    [HXStoreWebService postRequest:HXS_COMMUNITY_COLLECT_CANCEL
                        parameters:diction
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               
                               if(status == kHXSNoError) {
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kMLPOSTSTATUSCHANGED object:nil];
                               }
                               
                               block(status,msg,data);
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
                           }];
}

// 点赞
+(void)communityPraiseWithPostId:(NSString *)post_id complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block
{
    if(post_id.length == 0) return;
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"dynamicsId"];
    [diction setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];

    [HXStoreWebService postRequest:HXS_COMMUNITY_PRAISE_ADD
                 parameters:diction
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
                        if(status == kHXSNoError) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kMLPOSTSTATUSCHANGED object:nil];
                        }
                        
                        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

// 取消点赞
+(void)communityCancelPraiseWithPostId:(NSString *)post_id complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block
{
    if(post_id.length == 0) return;
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"dynamicsId"];
    [diction setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_PRAISE_CANCEL
                        parameters:diction
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               
                               if(status == kHXSNoError) {
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kMLPOSTSTATUSCHANGED object:nil];
                               }
                               
                               block(status,msg,data);
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
                           }];
}

+ (void)communityAddShareWithPostId:(NSString *)post_id
                           complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block
{
//    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
//    [diction setObject:post_id forKey:@"post_id"];
//    
//    [HXStoreWebService postRequest:HXS_COMMUNITY_SHARE_ADD
//                 parameters:diction
//                   progress:nil
//                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
//                        
//                        block(status,msg,data);
//                        
//                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
//                        block(status,msg,data);
//                    }];
}

// 评论帖子
+(void)communityAddCommentWithPostId:(NSString *)post_id content:(NSString *)content complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary*dic))block
{
 
    if(post_id.length == 0) return;
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"dynamicsId"];
    [diction setObject:content forKey:@"content"];
    if([HXSUserAccount currentAccount].userID) {
        [diction setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    }
    
    [HXStoreWebService postRequest:ML_COMMUNITY_COMMENT_ADD
                 parameters:diction
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

+(void)communityAddCommentWithPostId:(NSString *)post_id
                             content:(NSString *)content
                     commentedUserId:(NSNumber *)commentedUserId
                    commentedContent:(NSString *)commentedContent
                            complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block
{
    if(post_id.length == 0) return;
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"dynamicsId"];
    [diction setObject:content forKey:@"content"];
    [diction setObject:commentedUserId forKey:@"replyUser"];
    [diction setObject:commentedContent forKey:@"replyContent"];
    if([HXSUserAccount currentAccount].userID) {
        [diction setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    }
    
    [HXStoreWebService postRequest:ML_COMMUNITY_COMMENT_ADD
                 parameters:diction
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];

}

+(void)getCommunityCommentListWithPostId:(NSString *)post_id page:(NSNumber *)page complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *comments))block{
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"post_id"];
    [diction setObject:page forKey:@"page"];
    [diction setObject:@(20) forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_COMMENT_LIST
                parameters:diction
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        if(kHXSNoError == status){
            
            DLog(@"社区-评论列表：%@",data);
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"comment_list"];
            if(arr){
                for(NSDictionary *dic in arr){
                    
                    HXSComment *temp = [HXSComment objectFromJSONObject:dic];
                    [resultArray addObject:temp];
                }
            }
            block(status,msg,resultArray);
        
        }else{
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
    }];
}

@end
