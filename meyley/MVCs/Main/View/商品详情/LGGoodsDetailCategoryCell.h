//
//  LGGoodsDetailCategoryCell.h
//  meyley
//
//  Created by Bovin on 2018/8/29.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGGoodsCategoryModel.h"
@protocol LGGoodsDetailCategoryDelegate <NSObject>

-(void)selectCategoryAtRow:(NSInteger)row index:(NSInteger)index;

@end;

@interface LGGoodsDetailCategoryCell : UITableViewCell

@property (nonatomic , assign)id <LGGoodsDetailCategoryDelegate> delegate;

@property (nonatomic , strong)LGGoodsCategoryModel *model;

@property (nonatomic , assign)NSInteger row;

@end
