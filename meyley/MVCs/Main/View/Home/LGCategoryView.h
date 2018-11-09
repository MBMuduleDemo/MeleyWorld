//
//  LGCategoryView.h
//  meyley
//
//  Created by mac on 2018/7/31.
//  Copyright © 2018年 Meyley. All rights reserved.
//  类目

#import <UIKit/UIKit.h>

@protocol LGCategoryViewDelegate <NSObject>

@optional
//今日特惠
-(void)goToTodayFavour;
//新品发布
-(void)goToNewGoodsActive;
//品牌
-(void)goToBrandPage;
//更多
-(void)goToMoreGoodsPage;
//详情
-(void)goToGoodsPageWithIndex:(NSInteger)index;

@end

@interface LGCategoryView : UIView
@property (nonatomic , weak) id <LGCategoryViewDelegate> delegate;
@property (nonatomic , strong)NSArray *categoryArry;

@end
