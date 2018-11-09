//
//  LGShoppingCartGoodsTableCell.h
//  meyley
//
//  Created by Bovin on 2018/8/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGShoppingGoodsModel;
@class LGShoppingCartGoodsTableCell;

@protocol LGShoppingCartGoodsTableCellDelegate<NSObject>

@optional
- (void)selectCurrentGoodsWithIndexPath:(NSIndexPath *)indexPath;

- (void)editGoodsCountWithTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath;

- (void)reduceGoodsCountFinishWithIndexPath:(NSIndexPath *)indexPath;

- (void)addGoodsCountFinishWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface LGShoppingCartGoodsTableCell : UITableViewCell

@property (nonatomic, weak) id<LGShoppingCartGoodsTableCellDelegate>delegate;
@property (nonatomic, strong) LGShoppingGoodsModel *goodsModel;
@end
