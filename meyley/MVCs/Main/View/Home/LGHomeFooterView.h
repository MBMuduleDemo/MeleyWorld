//
//  LGHomeFooterView.h
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LGHomeFooterDelegate <NSObject>

@optional

//分类
-(void)goToMoreGoodsPage;
//品牌
-(void)goToBrandPage;
//活动
-(void)goToNewGoodsActive;
//今日特价
-(void)goToTodayFavour;


@end
@interface LGHomeFooterView : UIView
@property (nonatomic , weak) id <LGHomeFooterDelegate> delegate;
@end
