//
//  HXSCommunityModel.h
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HXSPost;
@class MLUserSpace;
@class HXSUserBasicInfo;

@interface HXSCommunityModel : NSObject

/**
 *  根据帖子列表类型获取帖子列表
 *
 */
+ (void)getCommunityPostListWithUserId:(NSNumber *)userId
                               page:(NSNumber *)page
                           complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts, NSString *topicShareLinkStr))block;

/**
 *  获取帖子详情
 *
 *  @param post_id 帖子id
 */
+ (void)getCommunityPostDetialWithPostId:(NSString *)post_id
                                complete:(void(^)(HXSErrorCode code, NSString * message, HXSPost * post))block;


/**
 *  根据帖子id删除帖子
 *
 *  @param post_id 帖子id
 */
+ (void)communityDeletePostWithPostId:(NSString *)post_id
                             complete:(void(^)(HXSErrorCode code, NSString * message, NSNumber * result_status))block;


/**
 获取用户信息

 @param userId 用户id
 @param block 回调
 */
+ (void)getCommunityUserSpaceInfoWithUserId:(NSString *)userId
                                complete:(void(^)(HXSErrorCode code, NSString * message, MLUserSpace *userSpace))block;

/**
 获取用户信息
 
 @param userId 用户id
 @param block 回调
 */
+ (void)getCommunityUserFollowListWithUserId:(NSNumber *)userId
                                   complete:(void(^)(HXSErrorCode code, NSString * message, NSArray<HXSUserBasicInfo *> *users))block;
@end
