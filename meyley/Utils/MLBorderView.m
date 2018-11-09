//
//  MLBorderView.m
//  meyley
//
//  Created by chsasaw on 2017/2/23.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLBorderView.h"

@implementation MLBorderView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.masksToBounds = YES;
    self.layer.borderColor = ML_BORDER_COLOR.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
}

@end
