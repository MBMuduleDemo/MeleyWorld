//
//  ShopDetailsViewController.h
//  haoshuimian365
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 CZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGGoodsDetailViewController : HKBaseViewController

/**  */
@property (nonatomic , copy)NSString *goodsId;

/**peek时上拉出来的菜单*/
@property(nonatomic,strong)NSArray<id<UIPreviewActionItem>> *actions;

@end
