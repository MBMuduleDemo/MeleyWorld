//
//  LGCommitOrderBottomBar.h
//  meyley
//
//  Created by Bovin on 2018/9/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGCommitOrderBottomBar : UIView

@property (nonatomic, copy) NSString *totalCost;

@property (nonatomic, copy) void(^CommitOrderBlock)(void);

@end
