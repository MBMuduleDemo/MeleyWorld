//
//  LGOrderCenterViewController.h
//  meyley
//
//  Created by Bovin on 2018/10/8.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"

@interface LGOrderCenterViewController : HKBaseViewController

@property (nonatomic, copy) NSString *stateName;
//在订单中心操作（付款，收货等）完成时，跳会订单中心要跳转到对应的状态列表
@property (nonatomic, assign) BOOL allowChangeState;

@end
