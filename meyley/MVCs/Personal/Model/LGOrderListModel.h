//
//  LGOrderListModel.h
//  meyley
//
//  Created by Bovin on 2018/10/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGOrderListModel : NSObject

@property (nonatomic, copy) NSString *userId;      //用户Id
@property (nonatomic, copy) NSString *orderStatusName; //订单状态
@property (nonatomic, copy) NSString *orderStatus;   //订单状态码
@property (nonatomic, copy) NSString *orderSn;       //订单编号
@property (nonatomic, copy) NSString *orderId;      //订单ID
@property (nonatomic, copy) NSString *orderAmount;  //订单总额
@property (nonatomic, copy) NSString *addTime;      //下单时间
@property (nonatomic, copy) NSString *brandName;    //品牌名称
@property (nonatomic, strong) NSArray *goodsList;   //订单商品列表


@end

@interface LGOrderGoodsListModel : NSObject

@property (nonatomic, copy) NSString *goodsAttrs;       //商品属性
@property (nonatomic, copy) NSString *goodsAttrsId;      //商品属性ID
@property (nonatomic, copy) NSString *goodsId;          //商品Id
@property (nonatomic, copy) NSString *goodsName;       //商品名称
@property (nonatomic, copy) NSString *goodsNumber;     //商品数量
@property (nonatomic, copy) NSString *goodsPrice;      //商品价格
@property (nonatomic, copy) NSString *goodsThumb;      //商品缩略图
@property (nonatomic, copy) NSString *supply;          //货源



@end
