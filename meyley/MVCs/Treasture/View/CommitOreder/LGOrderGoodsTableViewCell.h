//
//  LGOrderGoodsTableViewCell.h
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGShoppingGoodsModel;
@class LGOrderGoodsListModel;
@interface LGOrderGoodsTableViewCell : UITableViewCell

@property (nonatomic, strong) LGShoppingGoodsModel *model;

//详情页model
@property (nonatomic, strong) LGOrderGoodsListModel *detailModel;
@end
