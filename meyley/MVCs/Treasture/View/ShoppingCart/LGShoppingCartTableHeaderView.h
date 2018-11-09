//
//  LGShoppingCartTableHeaderView.h
//  meyley
//
//  Created by Bovin on 2018/8/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGShoppingCartTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *brandName;      //品牌名称
//是否选中
@property (nonatomic, assign) BOOL isShouldSelect;
//选中当前品牌下所有商品回调
@property (nonatomic, copy) void(^SelectAllBrandGoods)(BOOL isSelect);

@end
