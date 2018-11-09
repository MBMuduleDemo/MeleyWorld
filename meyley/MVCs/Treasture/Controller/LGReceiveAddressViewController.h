//
//  LGReceiveAddressViewController.h
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "HKBaseViewController.h"
@class LGReceiveAddressModel;
@interface LGReceiveAddressViewController : HKBaseViewController

@property (nonatomic, copy) void(^motifyReceiveAddressBlock)(LGReceiveAddressModel *model);
@end
