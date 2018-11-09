//
//  MLDashBorderView.m
//  meyley
//
//  Created by chsasaw on 2017/3/31.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLDashBorderView.h"

@interface MLDashBorderView()

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation MLDashBorderView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(!self.borderLayer) {
        self.borderLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.borderLayer];
    }
    self.borderLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    //    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    self.borderLayer.path = [UIBezierPath bezierPathWithRect:self.borderLayer.bounds].CGPath;
    self.borderLayer.lineWidth = 1.;
    //虚线边框
    self.borderLayer.lineDashPattern = @[@8, @8];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    self.borderLayer.fillColor = [UIColor clearColor].CGColor;
    self.borderLayer.strokeColor = ML_BORDER_COLOR.CGColor;
}

@end
