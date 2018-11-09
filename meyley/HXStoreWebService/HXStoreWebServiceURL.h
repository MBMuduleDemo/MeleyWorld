//
//  HXStoreWebServiceURL.h
//  Pods
//
//  Created by ArthurWang on 16/6/12.
//
//

#ifndef HXStoreWebServiceURL_h
#define HXStoreWebServiceURL_h

// path

#define kBundlePath @"bundle"

#define HXS_SERVER_URL                  [[ApplicationSettings instance] currentServiceURL]
#define HXS_HTTPS_SERVER_URL            [[ApplicationSettings instance] currentHttpsServiceURL]

//token
#define HXS_TOKEN_UPDATE                @"token/create"

//device
#define HXS_DEVICE_UPDATE               @"device/update"

//user
#define HXS_USER_LOGIN                  @"user/login.action"
#define HXS_USER_LOGOUT                 @"user/logout"
#define HXS_USER_REGISTER               @"user/register.action"
#define HXS_USER_PASSWORD_RESET         @"user/reset/password.action"
#define HXS_USER_INFO                   @"user/detail.action"
#define HXS_USER_MODIFY                 @"user/modify.action"
#define HXS_USER_SPACE                  @"user/space.action"
#define ML_USER_INVITE                  @"user/invite.action"

//waiter
#define ML_MY_WAITER                    @"userwaiter/mywaiter.action"
#define ML_REMOVE_MY_WAITER             @"userwaiter/cancel.action"
#define ML_ADD_WAITER                   @"userwaiter/add.action"
#define ML_WAITER_HISTORY               @"userwaiter/list.action"
#define ML_WAITER_ALL                   @"waiter/list.action"
#define ML_WAITER_SEARCH                @"waiter/list.action"
#define ML_WAITER_NEARBY                @"waiter/nearby/list.action"
#define ML_WAITER_RECOMMEND             @"waiter/recommend/list.action"

// verify
#define HXS_SMS_SEND                    @"sms/send.action"
#define HXS_SMS_VERIFY                  @"sms/verify.action"

//MEYLEY
#define ML_COMMUNITY_POST_ALL              @"dynamics/list.action"                   // 全部帖子列表
#define ML_COMMUNITY_POST_DETIAL           @"dynamics/detail.action"                // 获取帖子详情
#define ML_COMMUNITY_ADDPOST               @"dynamics/add.action"                  // 发帖
#define ML_COMMUNITY_ADD_ARTICLE           @"dynamics/article/add.action"
#define ML_COMMUNITY_COMMENT_ADD           @"comment/add.action"               // 评论
#define ML_COMMUNITY_FOLLOW_LIST            @"follow/myFollow.action"
#define ML_COMMUNITY_POST_DELETE           @"dynamics/delete.action"
#define ML_COMMUNITY_DELCOMMENT         @"comment/delete.action"            // 删除评论
#define ML_COMMUNITY_REGION_LIST        @"region/list.action"
#define ML_COMMUNITY_GET_REGION         @"region/getRegionById.action"

//Community
#define HXS_COMMUNITY_UPLOADPHOTO        @"community/common/upload_img_ios"     // 社区上传图片
#define HXS_COMMUNITY_FETCHALLTOPICS     @"community/topic/list_all"            // 所有话题
#define HXS_COMMUNITY_COMMENTSFORME      @"community/user/comment_receive_list" // 获取用户收到的评论列表
#define HXS_COMMUNITY_MYCOMMENTS         @"community/user/comment_list"         // 获取用户给出的评论列表
#define HXS_COMMUNITY_FETCHMYPOSTS       @"community/user/post_list"            // 获取用户发的帖子

#define HXS_COMMUNITY_FOLLOW_USER        @"follow/add.action"                  //  关注
#define HXS_COMMUNITY_FOLLOW_CANCEL        @"follow/cancel.action"                  //  取消关注

#define HXS_COMMUNITY_COLLECT_ADD           @"collect/add.action"                  // 收藏
#define HXS_COMMUNITY_COLLECT_CANCEL           @"collect/cancel.action"                  // 取消收藏
#define HXS_COMMUNITY_PRAISE_ADD           @"praise/add.action"                    //点赞
#define HXS_COMMUNITY_PRAISE_CANCEL           @"praise/cancel.action"                    //取消点赞

#define HXS_COMMUNITY_COMMENT_LIST       @"community/comment/list"              // 评论列表
#define HXS_COMMUNITY_MESSAGE_NEW           @"community/message/new"                // 获取帖子详情

#endif /* HXStoreWebServiceURL_h */
