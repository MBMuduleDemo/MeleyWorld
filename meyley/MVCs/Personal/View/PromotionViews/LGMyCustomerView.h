//
//  LGMyCustomerView.h
//  meyley
//
//  Created by Bovin on 2018/10/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGPromotionHomeModel;

@interface LGMyCustomerView : UIView

@property (nonatomic, strong) LGPromotionHomeModel *model;

@property (nonatomic, copy) void(^myCustomDetailInfo)(NSInteger index);

@end
