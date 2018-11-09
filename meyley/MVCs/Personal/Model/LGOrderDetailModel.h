//
//  LGOrderDetailModel.h
//  meyley
//
//  Created by Bovin on 2018/10/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LGOrderDetailModel : NSObject

@property (nonatomic, copy) NSString *orderId;      //订单ID
@property (nonatomic, copy) NSString *brandName;    //品牌名称
@property (nonatomic, copy) NSString *orderStatus;   //订单状态码
@property (nonatomic, copy) NSString *orderStatusName;   //订单状态
@property (nonatomic, copy) NSString *orderSn;       //订单编号
@property (nonatomic, copy) NSString *addTime;      //下单时间

@property (nonatomic, copy) NSString *addressId;    //商品ID
@property (nonatomic, copy) NSString *consignee;    //收件人
@property (nonatomic, copy) NSString *mobile;       //手机号
@property (nonatomic, copy) NSString *province;     //省份id
@property (nonatomic, copy) NSString *provinceName; //省份名称
@property (nonatomic, copy) NSString *city;         //城市id
@property (nonatomic, copy) NSString *cityName;     //城市名
@property (nonatomic, copy) NSString *district;     //地区id
@property (nonatomic, copy) NSString *districtName; //地区名称
@property (nonatomic, copy) NSString *address;      //收货地址

@property (nonatomic, copy) NSString *payNote;      //备注
@property (nonatomic, copy) NSString *paySn;      //支付流水号
@property (nonatomic, copy) NSString *payTime;      //支付时间
@property (nonatomic, copy) NSString *confirmTime;  //订单确认时间

@property (nonatomic, copy) NSString *shippingId; //配送方式
@property (nonatomic, copy) NSString *shippingTime; //发货时间
@property (nonatomic, copy) NSString *confirmName;  //配送方式名称
@property (nonatomic, copy) NSString *bestTime;      //最佳配送时间
@property (nonatomic, copy) NSString *shippingFee;      //配送费用
@property (nonatomic, copy) NSString *shippingName;      //快递公司名称

@property (nonatomic, copy) NSString *orderAmount;  //订单总额
@property (nonatomic, copy) NSString *goodsAmount;      //商品总额
@property (nonatomic, strong) NSArray *goodsList;   //订单商品列表

//@property (nonatomic, strong) LGOrderDetailBounsModel *bouns;   //红包

@end


@interface LGOrderDetailBounsModel : NSObject

@property (nonatomic, copy) NSString *bonusCode;      //红包码
@property (nonatomic, copy) NSString *bonusStatus;    //红包状态
@property (nonatomic, copy) NSString *createTime;      //领红包时间
@property (nonatomic, copy) NSString *isDelete;         //是否删除
@property (nonatomic, copy) NSString *maxAmount;        //最大金额
@property (nonatomic, copy) NSString *minAmount;        //最小金额
@property (nonatomic, copy) NSString *minGoodsAmount;      //最小商品金额
@property (nonatomic, copy) NSString *postscript;         //
@property (nonatomic, copy) NSString *sendEndDate;      //
@property (nonatomic, copy) NSString *sendStartDate;    //
@property (nonatomic, copy) NSString *sendTotal;      //
@property (nonatomic, copy) NSString *sendType;         //

@property (nonatomic, copy) NSString *typeId;      //红包ID
@property (nonatomic, copy) NSString *typeName;     //红包类型名称
@property (nonatomic, copy) NSString *typeMoney;    //红包金额

@property (nonatomic, copy) NSString *useStartDate; //红包可以使用的开始时间
@property (nonatomic, copy) NSString *useEndDate;   //红包可以使用的结束时间
@property (nonatomic, copy) NSString *useLimitDays; //使用显示天数
@property (nonatomic, copy) NSString *updateTime;   //红包更新时间
@property (nonatomic, copy) NSString *useTotal;     //
@property (nonatomic, copy) NSString *useType;

@end



