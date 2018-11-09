//
//  LGMyPerformanceView.h
//  meyley
//
//  Created by Bovin on 2018/10/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGPromotionHomeModel;

@interface LGMyPerformanceView : UIView

@property (nonatomic, strong) LGPromotionHomeModel *model;

@property (nonatomic, copy) void(^checkMyCommissionRecode)(void);

@end
