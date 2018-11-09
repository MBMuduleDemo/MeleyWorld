//
//  LGOrderDetailViewController.h
//  meyley
//
//  Created by Bovin on 2018/10/9.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"
@class LGOrderListModel;
typedef NS_ENUM(NSUInteger, LGOrderDetailType) {
    LGOrderDetailTypeWaitPay,
    LGOrderDetailTypeWaitSend,
    LGOrderDetailTypeWaitReceive,
    LGOrderDetailTypeWaitComment,
    LGOrderDetailTypeReturned,
    LGOrderDetailTypeFinished,
    LGOrderDetailTypeCancel,
};

@interface LGOrderDetailViewController : HKBaseViewController
//详情页类型
@property (nonatomic, assign) LGOrderDetailType type;

@property (nonatomic, strong) LGOrderListModel *orderModel;

@property (nonatomic, copy) void(^refreshOrderStateBlock)(void);

@end
