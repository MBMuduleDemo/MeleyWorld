//
//  LGOrderStateTableViewCell.h
//  meyley
//
//  Created by Bovin on 2018/10/8.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGOrderListModel;

typedef NS_ENUM(NSUInteger, LGOrderCellType) {
    LGOrderCellTypeDefault,     //没有按钮
    LGOrderCellTypeOneAction,   //有一个按钮
    LGOrderCellTypeTwoAction,   //有两个按钮
};

@interface LGOrderStateTableViewCell : UITableViewCell

@property (nonatomic, strong) LGOrderListModel *orderModel;

@property (nonatomic, assign) LGOrderCellType cellType;

@property (nonatomic, copy) void(^OrderSureActionHandler)(void);
@property (nonatomic, copy) void(^OrderCancelActionHandler)(void);

@end
