//
//  LGBaseOrderViewController.h
//  meyley
//
//  Created by Bovin on 2018/10/8.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"

//  0待付款 1待发货 2待收货 3待评论 4售后 5 取消)
typedef NS_ENUM(NSUInteger, LGOrderInfoStatus) {
    LGOrderInfoStatusAll = 99,
    LGOrderInfoStatusWaitPay = 0,
    LGOrderInfoStatusWaitSend = 1,
    LGOrderInfoStatusWaitReceive = 2,
    LGOrderInfoStatusWaitComment = 3,
    LGOrderInfoStatusAfterSales = 4,
    LGOrderInfoStatusCancel = 5,
    LGOrderInfoStatusFinished,
};

@interface LGBaseOrderViewController : HKBaseTableViewController

@property (nonatomic, assign) LGOrderInfoStatus orderStatus;

@property (nonatomic, assign) BOOL isLoadData;

@end
