//
//  HXSCommunityPostingModel.h
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCommunitUploadImageEntity.h"
#import "MLPostArticleParamEntity.h"

@class HXSPost;

@interface HXSCommunityPostingModel : NSObject

/**
 *  发布帖子
 *
 */
- (void)postTheContent:(NSString *)content photos:(NSArray<HXSCommunitUploadImageEntity *>*)entities complete:(void (^)(HXSErrorCode code, NSString *message, NSString *postIdStr))block;

/**
 *  发布文章
 *
 */
- (void)postTheArticle:(MLPostArticleParamEntity *)entity
             complete:(void (^)(HXSErrorCode code, NSString *message, HXSPost *post))block;

@end
