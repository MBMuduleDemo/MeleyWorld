//
//  MLRecommendWaiterView.h
//  meyley
//
//  Created by chsasaw on 2017/6/2.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLRecommendWaiterView : UIView

+ (instancetype)waiterView;

- (void)showInViewController:(UIViewController *)controller;
- (void)setDescText:(NSString *)desc;

@end
