//
//  UIView+MLConfig.m
//  meyley
//
//  Created by chsasaw on 2017/5/9.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "UIView+MLConfig.h"

IB_DESIGNABLE
@implementation UIView (MLConfig)

- (void)setHk_cornerRadius:(CGFloat)hk_cornerRadius {
    self.layer.cornerRadius = hk_cornerRadius>=0?hk_cornerRadius:0;
}

- (CGFloat)hk_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setHk_borderWith:(CGFloat)hk_borderWith {
    self.layer.borderWidth = hk_borderWith>=0?hk_borderWith:0;
}
- (CGFloat)hk_borderWith {
    return self.layer.borderWidth;
}

- (void)setHk_borderColor:(UIColor *)hk_borderColor {
    self.layer.borderColor = hk_borderColor?hk_borderColor.CGColor:[UIColor clearColor].CGColor;
}

- (UIColor *)hk_borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
