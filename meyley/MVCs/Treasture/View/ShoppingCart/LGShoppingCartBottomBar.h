//
//  LGShoppingCartBottomBar.h
//  meyley
//
//  Created by Bovin on 2018/9/1.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLWaiterModel;
typedef NS_ENUM(NSUInteger, LGCartState) {
    LGCartStateDefault,   //默认状态
    LGCartStateEditing,   //编辑状态
};

@class LGShoppingCartBottomBar;

@protocol LGShoppingCartBottomBarDelegate <NSObject>

@optional
//全选
- (void)selectAllShoppingCartGoodsWithIsSelect:(BOOL)isSelect;
//联系客服
- (void)contactCustomerService;
//商品优惠
- (void)goodsPrefrenceWithRedEnvelopOrIntegral;
//结算，提交订单
- (void)commitGoodsOrder;
//加入收藏
- (void)collectionAllSelectGoods;
//删除
- (void)deleteAllSelectGoodsFromShoppingCart;

@end

@interface LGShoppingCartBottomBar : UIView

@property (nonatomic, assign) LGCartState state;

@property (nonatomic, weak)id<LGShoppingCartBottomBarDelegate>delegate;
//全选按钮选中状态
@property (nonatomic, assign) BOOL isShouldSelect;
//所有选中商品的价格
@property (nonatomic, copy) NSString *totalPrice;
//选中的商品数量
@property (nonatomic, assign) NSInteger goodsCount;
//优惠金额
@property (nonatomic, copy) NSString *discountPrice;

//我的客服
@property (nonatomic, strong) MLWaiterModel *waiterModel;
@end
