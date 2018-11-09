//
//  MLWaiterTableViewCell.m
//  meyley
//
//  Created by chsasaw on 2017/6/6.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLWaiterTableViewCell.h"

@implementation MLWaiterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.headImageView.layer setCornerRadius:self.headImageView.frame.size.width*0.5];
    self.headImageView.layer.masksToBounds = YES;
}

@end
