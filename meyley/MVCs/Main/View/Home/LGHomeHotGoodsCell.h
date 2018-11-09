//
//  LGHomeHotGoodsCell.h
//  meyley
//
//  Created by mac on 2018/8/1.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGHomeHotGoodsDelegate <NSObject>

@optional

-(void)selectHotGoods:(NSDictionary *)dic;
-(void)selectHotBrand:(NSDictionary *)dic;

@end

@interface LGHomeHotGoodsCell : UITableViewCell

@property (nonatomic , assign) id <LGHomeHotGoodsDelegate> delegate;

@property (nonatomic , strong)NSDictionary *dataDic;

@property (nonatomic , strong)UIView *lineView;

@end
