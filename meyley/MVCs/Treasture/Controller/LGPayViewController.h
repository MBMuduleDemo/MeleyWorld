//
//  LGPayViewController.h
//  meyley
//
//  Created by Bovin on 2018/9/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"
@class LGCommitOrderResultModel;
@interface LGPayViewController : UIViewController
//提交订单返回的结果model
@property (nonatomic, strong) LGCommitOrderResultModel *model;

@property (nonatomic, copy) void(^payFinishBlock)(BOOL paySuccess);

@end
