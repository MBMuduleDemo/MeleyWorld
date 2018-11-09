//
//  LGOrderDetailBottomBar.h
//  meyley
//
//  Created by Bovin on 2018/10/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGOrderDetailBottomBarType) {
    LGOrderDetailBottomBarTypeWaitPay,
    LGOrderDetailBottomBarTypeWaitSend,
    LGOrderDetailBottomBarTypeWaitReceive,
    LGOrderDetailBottomBarTypeWaitComment,
    LGOrderDetailBottomBarTypeFinish,
    LGOrderDetailBottomBarTypeCancel,
};

@interface LGOrderDetailBottomBar : UIView

@property (nonatomic, assign) LGOrderDetailBottomBarType type;

@property (nonatomic, copy) void(^sureActionBlock)(LGOrderDetailBottomBarType type);
@property (nonatomic, copy) void(^cancelActionBlock)(LGOrderDetailBottomBarType type);

@end
