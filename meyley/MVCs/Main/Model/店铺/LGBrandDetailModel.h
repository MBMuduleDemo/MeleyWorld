//
//  LGBrandDetailModel.h
//  meyley
//
//  Created by Bovin on 2018/9/26.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGBrandDetailModel : NSObject

@property (nonatomic , copy)NSString *brandBgpPath;
@property (nonatomic , copy)NSString *brandId;
@property (nonatomic , copy)NSString *brandLogo;
@property (nonatomic , copy)NSString *brandName;
@property (nonatomic , strong)NSArray *category;
@property (nonatomic , copy)NSString *desc;
@property (nonatomic , copy)NSString *englishName;
@property (nonatomic , copy)NSString *siteUrl;
@property (nonatomic , strong)NSArray *goodsList;

@end


@interface LGBrandDetailGoodsModel : NSObject

@property (nonatomic , copy)NSString *brandId;
@property (nonatomic , copy)NSString *goodsId;
@property (nonatomic , copy)NSString *goodsName;
@property (nonatomic , copy)NSString *goodsNumber;
@property (nonatomic , copy)NSString *goodsSn;
@property (nonatomic , copy)NSString *goodsThumb;
@property (nonatomic , copy)NSString *marketPrice; //市场价
@property (nonatomic , copy)NSString *promotePrice;//促销价
@property (nonatomic , copy)NSString *shopPrice;    //平台商品价格

@end

@interface LGBrandDetailCategoryModel : NSObject

@property (nonatomic , copy)NSString *catId;
@property (nonatomic , copy)NSString *catName;
@property (nonatomic , copy)NSString *parentId;
@property (nonatomic , copy)NSString *sortOrder;
@property (nonatomic , strong)NSArray *children;

//是否展示所有的子分类
@property (nonatomic , assign)BOOL isOpen;

@end
