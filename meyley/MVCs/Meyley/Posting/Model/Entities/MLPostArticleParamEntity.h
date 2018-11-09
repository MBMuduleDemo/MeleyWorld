//
//  MLPostArticleParamEntity.h
//  meyley
//
//  Created by chsasaw on 2017/4/1.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCommunitUploadImageEntity.h"

@interface MLPostArticleParamEntity : NSObject

@property (nonatomic, copy) NSString * articleTitle;
@property (nonatomic, copy) NSString * articleContent;
@property (nonatomic, copy) NSString * articleUrl;
@property (nonatomic, copy) NSNumber * articleType;
@property (nonatomic, strong) HXSCommunitUploadImageEntity * coverImage;
@property (nonatomic, copy) NSNumber * userId;

@end
