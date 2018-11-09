//
//  HXSCommunityPostingModel.m
//  store
//
//  Created by J.006 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityPostingModel.h"
#import "HXSUserAccount.h"
#import "HXSPost.h"

@implementation HXSCommunityPostingModel

- (void)postTheContent:(NSString *)content photos:(NSArray<HXSCommunitUploadImageEntity *> *)entities complete:(void (^)(HXSErrorCode, NSString *, NSString *))block
{
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionary];
    [pramaDic setObject:content forKey:@"content"];
    [pramaDic setObject:[HXSUserAccount currentAccount].userID forKey:@"userId"];
    [HXStoreWebService uploadRequest:ML_COMMUNITY_ADDPOST
                          parameters:pramaDic
           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
               if(entities && [entities count] > 0) {
                   for (HXSCommunitUploadImageEntity *imageEntity in entities) {
                       [formData appendPartWithFileData:imageEntity.formData  name:imageEntity.nameStr fileName:imageEntity.filenameStr mimeType:imageEntity.mimeTypeStr];
                   }
               }
    }
                            progress:nil
                             success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if (kHXSNoError != status) {
            block(status, msg, nil);
            return ;
        }
        NSString *postIDStr = [data objectForKey:@"dynamicsId"];
        block(status,msg,postIDStr);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status, msg, nil);
    }];
}

- (void)postTheArticle:(MLPostArticleParamEntity *)entity complete:(void (^)(HXSErrorCode, NSString *, HXSPost *))block {
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionary];
    [pramaDic setObjectExceptNil:entity.articleContent forKey:@"articleContent"];
    [pramaDic setObjectExceptNil:entity.articleTitle forKey:@"articleTitle"];
    [pramaDic setObjectExceptNil:entity.articleType forKey:@"articleType"];
    [pramaDic setObjectExceptNil:entity.articleUrl forKey:@"articleUrl"];
    [pramaDic setObjectExceptNil:entity.userId forKey:@"userId"];
    [HXStoreWebService uploadRequest:ML_COMMUNITY_ADD_ARTICLE
                          parameters:pramaDic
           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
               HXSCommunitUploadImageEntity *imageEntity = entity.coverImage;
               if(imageEntity && [imageEntity.formData length] > 0) {
                       [formData appendPartWithFileData:imageEntity.formData  name:imageEntity.nameStr fileName:imageEntity.filenameStr mimeType:imageEntity.mimeTypeStr];
               }
           }
                            progress:nil
                             success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                                 if (kHXSNoError != status) {
                                     block(status, msg, nil);
                                     return ;
                                 }
                                 HXSPost *post = [[HXSPost alloc] initWithDictionary:data error:nil];
                                 block(status,msg,post);
                             } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                                 block(status, msg, nil);
                             }];
}

@end
