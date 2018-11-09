//
//  MLServiceCollectionViewCell.m
//  meyley
//
//  Created by chsasaw on 2017/5/7.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLServiceCollectionViewCell.h"

@interface MLServiceCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UIImageView *shimingImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *evaluateLabel;

@end

@implementation MLServiceCollectionViewCell

- (void)setWaiter:(MLWaiterModel *)waiter {
    [self.headImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:waiter.headPic] placeholderImage:[UIImage imageNamed:@"dsfdl-tx"]];
    
    [self.nameLabel setText:waiter.waiterName];
    [self.evaluateLabel setText:[NSString stringWithFormat:@"%0.1f", waiter.rank.floatValue]];
    [self.shimingImageView setHidden:!waiter.isRenzheng.boolValue];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Initialization code
    
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width*0.5;
    self.headImageView.layer.masksToBounds = YES;
}

@end
