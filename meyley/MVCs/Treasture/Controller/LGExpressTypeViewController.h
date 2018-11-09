//
//  LGExpressTypeViewController.h
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"
@class LGExpressTypeModel;

@interface LGExpressTypeViewController : HKBaseViewController
//商品的cartIDs
@property (nonatomic, copy) NSString *cartIds;
//收货地址的ID
@property (nonatomic, copy) NSString *addressId;
/**
 选择配送方式完成携带参数为 配送方式ID 配送时间选择
 */
@property (nonatomic, copy) void(^chooseExpressFinishBlock)(LGExpressTypeModel *typeModel,NSString *sendTime);

@end
