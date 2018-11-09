//
//  LGCommitOrderResultModel.h
//  meyley
//
//  Created by Bovin on 2018/9/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGCommitOrderResultModel : NSObject

@property (nonatomic, copy) NSString *orderAmount; //订单金额
@property (nonatomic, copy) NSString *orderId;      //订单ID
@property (nonatomic, copy) NSString *orderSn;      //订单号

@end
