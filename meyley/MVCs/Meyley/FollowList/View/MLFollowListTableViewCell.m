//
//  MLFollowListTableViewCell.m
//  meyley
//
//  Created by chsasaw on 2017/4/4.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLFollowListTableViewCell.h"
#import "UIImageView+WebCache.m"
#import "HXSUserBasicInfo.h"

@interface MLFollowListTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *signatureLabel;
@property (nonatomic, weak) IBOutlet UIButton *followButton;

@end

@implementation MLFollowListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width*0.5;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapUserGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadPostUserCenterAction)];
    
    [self.headImageView addGestureRecognizer:tapUserGestureRecognizer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserInfo:(HXSUserBasicInfo *)userInfo {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.headPic] placeholderImage:[UIImage imageNamed: @"dsfdl-tx"]];
    [self.userNameLabel setText:userInfo.userName];
    [self.signatureLabel setText:userInfo.signature];
    [self.followButton setSelected:YES];
}

/**
 *  跳转贴主中心
 */
- (void)loadPostUserCenterAction
{
    
    if (self.loadPostUserCenter) {
        
        self.loadPostUserCenter();
    }
}

/**
 关注
 */
- (IBAction)followUserAction {
    if (self.followUserBlock) {
        
        self.followUserBlock(!self.followButton.selected);
        self.followButton.selected = !self.followButton.selected;
    }
}

@end
