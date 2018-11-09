//
//  LGMineOrderTableCell.h
//  meyley
//
//  Created by Bovin on 2018/9/30.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGMineOrderTableCell : UITableViewCell

@property (nonatomic, strong) NSArray *unreadNumberArray;

@property (nonatomic, copy) void(^OrderCenterHandler)(void);
//点击某一个订单状态详情
@property (nonatomic, copy) void(^OrderStateDetailHandler)(NSString *stateName);
@end
