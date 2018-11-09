//
//  LGBrandCategoryView.h
//  meyley
//
//  Created by Bovin on 2018/9/27.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGBrandDetailModel;

@interface LGBrandCategoryView : UIView

@property (nonatomic, strong) LGBrandDetailModel *model;

@property (nonatomic, copy) void(^FilterGoodsBlock)(NSString *catId);

@property (nonatomic, copy) void(^SearchGoodsBlock)(NSString *keyWords);

@end


@interface LGBrandCategoryHeaderView : UIView

@property (nonatomic, copy) void(^seeAllBrandGoodsBlock)(void);

@property (nonatomic, copy) void(^SearchBrandGoodsBlock)(NSString *keyWords);


@end
