//
//  LGBrandCategoryController.h
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//  分类--品牌

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGShowType) {
    LGShowTypeBrand,
    LGShowTypeCategory,
};
@interface LGBrandCategoryController : HKBaseViewController

@property (nonatomic, assign) LGShowType selectType;

@end
