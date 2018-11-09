//
//  LGReceiveAddressModel.h
//  meyley
//
//  Created by Bovin on 2018/9/13.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGReceiveAddressModel : NSObject

@property (nonatomic, copy) NSString *address;      //收货地址
@property (nonatomic, copy) NSString *addressId;    //商品ID
@property (nonatomic, copy) NSString *city;         //城市id
@property (nonatomic, copy) NSString *cityName;     //城市名
@property (nonatomic, copy) NSString *consignee;    //收件人
@property (nonatomic, copy) NSString *district;     //地区id
@property (nonatomic, copy) NSString *districtName; //地区名称
@property (nonatomic, copy) NSString *isDefault;    //是否默认地址
@property (nonatomic, copy) NSString *mobile;       //手机号
@property (nonatomic, copy) NSString *province;     //省份id
@property (nonatomic, copy) NSString *provinceName; //省份名称
@property (nonatomic, copy) NSString *userId;       //用户ID

//自定义属性，记录当前商品的indexpath
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
