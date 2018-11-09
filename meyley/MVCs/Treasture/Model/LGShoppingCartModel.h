//
//  LGShoppingCartModel.h
//  meyley
//
//  Created by Bovin on 2018/9/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGShoppingCartModel : NSObject

@property (nonatomic, copy) NSString *brandName;      //品牌名称
@property (nonatomic, copy) NSString *brandId;       //品牌Id
@property (nonatomic, strong) NSArray *goodsList;

//自定义属性，记录当前品牌下商品是否有选中
@property (nonatomic, assign) BOOL isSelected;
@end

@interface LGShoppingGoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsId;      //商品Id
@property (nonatomic, copy) NSString *cartId;       //商品
@property (nonatomic, copy) NSString *goodsPrice;   //商品价格
@property (nonatomic, copy) NSString *goodsNumber;  //商品数量
@property (nonatomic, copy) NSString *goodsThumb;   //商品图片
@property (nonatomic, copy) NSString *goodsAttrsId; //商品规格Id
@property (nonatomic, copy) NSString *useIntegral;  //购买商品用户积分
@property (nonatomic, copy) NSString *goodsName;    //商品名称
@property (nonatomic, copy) NSString *goodsAttrs; //商品规格
@property (nonatomic, copy) NSString *promotePrice; //促销价

//自定义属性，记录当前商品的indexpath
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isSelected;
@end
