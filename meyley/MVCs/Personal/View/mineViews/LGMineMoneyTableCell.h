//
//  LGMineMoneyTableCell.h
//  meyley
//
//  Created by Bovin on 2018/9/30.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGMineMoneyTableCell : UITableViewCell

@property (nonatomic, copy) NSString *userMoney;

@property (nonatomic, strong) NSArray *numbersArray;

@property (nonatomic, copy) void(^chargeOrWithdrawHandler)(void);
//点击某一个类型详情
@property (nonatomic, copy) void(^oneModuleDetailHandler)(NSString *moduleName);

@end
