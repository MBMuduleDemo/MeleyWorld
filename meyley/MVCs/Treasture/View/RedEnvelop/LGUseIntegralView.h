//
//  LGUseIntegralView.h
//  meyley
//
//  Created by Bovin on 2018/9/27.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGUseIntegralView : UIView

@property (nonatomic, copy) NSString *allIntegral;

@property (nonatomic, copy) void(^useIntegralBlock)(NSString *disCount);

@end
