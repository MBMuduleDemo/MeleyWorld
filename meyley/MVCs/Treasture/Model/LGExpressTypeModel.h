//
//  LGExpressTypeModel.h
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGExpressTypeModel : NSObject

@property (nonatomic, copy) NSString *shippingCode;     //配送方式代码
@property (nonatomic, copy) NSString *shippingFee;      //配送费用
@property (nonatomic, copy) NSString *shippingId;       //配送方式Id
@property (nonatomic, copy) NSString *shippingMsg;      //提示
@property (nonatomic, copy) NSString *shippingName;     //配送方式名称
@property (nonatomic, copy) NSString *shippingStatus;   //配送方式状态（是否可选）
@property (nonatomic, copy) NSString *sortOrder;        //排序

@end
