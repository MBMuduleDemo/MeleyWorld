//
//  LGAddReceiveAddressViewController.h
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"
@class LGReceiveAddressModel;

typedef NS_ENUM(NSUInteger, LGAddressStyle) {
    LGAddressStyleNew,
    LGAddressStyleEditing,
};

@interface LGAddReceiveAddressViewController : HKBaseViewController

@property (nonatomic, assign) LGAddressStyle style;

@property (nonatomic, strong) LGReceiveAddressModel *model;

@property (nonatomic, copy) void(^refreshReceiveAddress)(void);

@end
