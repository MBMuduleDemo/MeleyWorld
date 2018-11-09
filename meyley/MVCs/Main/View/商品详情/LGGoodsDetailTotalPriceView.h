//
//  LGGoodsDetailTotalPriceView.h
//  meyley
//
//  Created by Bovin on 2018/8/28.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGGoodsDetailTotalPriceViewDelegate <NSObject>

-(void)getGoodsNumer:(NSInteger)numer;

@end

@interface LGGoodsDetailTotalPriceView : UIView

@property (nonatomic , assign)id <LGGoodsDetailTotalPriceViewDelegate> delegate;
//最大数量
@property (nonatomic , assign)NSInteger maxNum;

@property (nonatomic , copy)NSString *totalPrice;

@property (nonatomic , copy)NSString *singPrice;

@end
