//
//  LGBrandDetailModel.m
//  meyley
//
//  Created by Bovin on 2018/9/26.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBrandDetailModel.h"

@implementation LGBrandDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc":@"description"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList":[LGBrandDetailGoodsModel class],@"category":[LGBrandDetailCategoryModel class]};
}
@end


@implementation LGBrandDetailGoodsModel


@end


@implementation LGBrandDetailCategoryModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children":[LGBrandDetailCategoryModel class]};
}
@end
