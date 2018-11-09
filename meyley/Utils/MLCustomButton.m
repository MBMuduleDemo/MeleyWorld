//
//  MLCustomButton.m
//  meyley
//
//  Created by chsasaw on 2017/2/23.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLCustomButton.h"
#import "UIImage+Extension.h"

@implementation MLCustomButton

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundImage:[UIImage imageFromColor:ML_ACCENT_COLOR] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageFromColor:ML_SUB_COLOR] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageFromColor:ML_DISABLE_COLOR] forState:UIControlStateDisabled];
}


@end
