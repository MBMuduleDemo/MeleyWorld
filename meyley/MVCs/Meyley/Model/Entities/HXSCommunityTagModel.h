//
//  HXSCommunityTagModel.h
//  store
//
//  Created by 格格 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCommunityTagModel : NSObject

/**
 *  关注
 *
 *  @param userId 用户id
 */
+ (void)communityFollowUserWithUserId:(NSString *)userId
                          complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;

/**
 取消关注
 */
+ (void)communityUnFollowUserWithUserId:(NSString *)userId
                               complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block;

/**
 *  收藏
 *
 *  @param post_id 帖子id
 */
+ (void)communityAddLikeWithPostId:(NSString *)post_id
                         complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;

/**
 *  取消收藏
 *
 *  @param post_id 帖子id
 */
+ (void)communityCancelLikeWithPostId:(NSString *)post_id
                          complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;
/**
 *  点赞
 *
 *  @param post_id 帖子id
 */
+ (void)communityPraiseWithPostId:(NSString *)post_id
                          complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;

/**
 *  取消点赞
 *
 *  @param post_id 帖子id
 */
+ (void)communityCancelPraiseWithPostId:(NSString *)post_id
                         complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;

/**
 *  评论帖子
 *
 */
+(void)communityAddCommentWithPostId:(NSString *)post_id
                             content:(NSString *)content complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary*dic))block;

/**
 *  评论回复的回复
 *
 *  @param post_id          帖子id
 *  @param content          回复内容
 *  @param commentedUserId  被回复人id 【可选】
 *  @param commentedContent 被回复人内容 【可选】
 */
+ (void)communityAddCommentWithPostId:(NSString *)post_id
                             content:(NSString *)content
                     commentedUserId:(NSNumber *)commentedUserId
                    commentedContent:(NSString *)commentedContent
                            complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;

/**
 *  获取评论列表
 *
 *  @param post_id 帖子id
 */
+ (void)getCommunityCommentListWithPostId:(NSString *)post_id
                                     page:(NSNumber *)page
                                 complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *comments))block;

/**
 *  分享成功后调用
 *
 */
+ (void)communityAddShareWithPostId:(NSString *)post_id
                          complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;
@end
