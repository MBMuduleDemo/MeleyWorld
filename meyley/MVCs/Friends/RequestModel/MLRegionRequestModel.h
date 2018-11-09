//
//  MLRegionRequestModel.h
//  meyley
//
//  Created by chsasaw on 2017/5/14.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLRegion.h"

@interface MLRegionRequestModel : NSObject

/**
 *  省份列表
 *
 */
+ (void)getRegionListWithComplete:(void(^)(HXSErrorCode code, NSString * message, NSArray<MLRegion *> * regions))block;

/**
 *  地区列表
 *
 */
+ (void)getRegionWithParentId:(NSNumber *)parentId
                              complete:(void(^)(HXSErrorCode code, NSString * message, NSArray<MLRegion *> * regions))block;

@end
