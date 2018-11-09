//
//  HXSPost.h
//  store
//
//  Created by 格格 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSCommunityCommentUser.h"
#import "HXBaseJSONModel.h"

/**
 *  点赞
 */
@protocol HXSLike 
@end
@interface HXSLike : HXBaseJSONModel

@property(nonatomic, copy) NSString *idStr;
@property(nonatomic, copy) NSString *postIdStr;
@property(nonatomic, copy) NSNumber *likeUidLongNum;
@property(nonatomic, copy) NSNumber *statusIntNum;
@property(nonatomic, strong) HXSCommunityCommentUser *likeUser;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
/**
 *  评论对象
 */
@protocol HXSComment
@end
@interface HXSComment : HXBaseJSONModel

@property(nonatomic, copy) NSNumber *commentId;
@property(nonatomic, copy) NSNumber *commentUserId;
@property(nonatomic, copy) NSString *commentUserName;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSNumber *createTime;
@property(nonatomic, copy) NSNumber *dynamicsId;
@property(nonatomic, copy) NSNumber *status;
@property(nonatomic, copy) NSString *headPic;

@property(nonatomic, strong) HXSCommunityCommentUser *commentUser;     //评论的人
@property(nonatomic, strong) HXSCommunityCommentUser *commentedUser;   //被评论的人
@property(nonatomic, strong) HXSCommunityCommentUser *postOwner;       //帖子主人

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end

@protocol HXSPost
@end
/**
 *  帖子对象
 */
@interface HXSPost : HXBaseJSONModel

@property(nonatomic, copy) NSString *dynamicsId; // 帖子id
@property(nonatomic, copy) NSNumber<Optional> *ownerUserId; // 用户id
@property(nonatomic, copy) NSString<Optional> *owner; // 用户名
@property(nonatomic, copy) NSString<Optional> *ownerHeadPic; // 用户头像
@property(nonatomic, copy) NSString<Optional> *content; // 内容
@property(nonatomic, copy) NSNumber<Optional> *type;
@property(nonatomic, copy) NSNumber<Optional> *createTime; // 创建时间
@property(nonatomic, copy) NSNumber<Optional> *praiseCount; // 点赞数量
@property(nonatomic, copy) NSNumber<Optional> *commentCount; // 评论数量
@property(nonatomic, copy) NSString<Optional> *articleUrl; // 分享链接
@property(nonatomic, copy) NSString<Optional> *articleContent; //文章内容
@property(nonatomic, copy) NSString<Optional> *articleCover;
@property(nonatomic, copy) NSString<Optional> *articleTitle;

@property(nonatomic, copy) NSNumber<Optional> *isPraise; // 如果用户未登录，直接返回0，如果用户已登录，0 表示未点赞，1表示点赞
@property(nonatomic, copy) NSNumber<Optional> *isFollow; // 1:是否关注
@property(nonatomic, copy) NSNumber<Optional> *isCollect;//是否收藏
@property(nonatomic, strong) NSArray<HXSComment> *commentList; // 评论列表
@property(nonatomic, strong) NSArray<HXSLike> *likeListArr; // 点赞列表
@property(nonatomic, strong) NSArray<NSString *> *dynamicsImgList; // 图片集合
@property(nonatomic, strong) HXSCommunityCommentUser *postUser;  //发帖的人

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
