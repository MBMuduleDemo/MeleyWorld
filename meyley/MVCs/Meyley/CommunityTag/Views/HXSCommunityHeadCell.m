//
//  HXSCommunityHeadCellTableViewCell.m
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityHeadCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>
#import "NSDate+Meyley.h"
#import "HXSUserAccount.h"

@implementation HXSCommunityHeadCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.userIconImageView.layer.cornerRadius = self.userIconImageView.bounds.size.width/2;
    self.userIconImageView.layer.masksToBounds = YES;
    self.userIconImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapUserGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadPostUserCenterAction)];
    
    [self.userIconImageView addGestureRecognizer:tapUserGestureRecognizer];
    
    self.likeButton.layer.masksToBounds = YES;
    self.likeButton.layer.cornerRadius = 3;
    self.likeButton.layer.borderColor = ML_ACCENT_COLOR.CGColor;
    self.likeButton.layer.borderWidth = 1;
    [self.likeButton setBackgroundImage:[UIImage imageWithColor:ML_ACCENT_COLOR] forState:UIControlStateSelected];
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
        
        self.followUserBlock();
    }
}

/**
 下拉
 */
- (IBAction)dropdownAction {
    if (self.dropdownBlock) {
        
        self.dropdownBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setPostEntity:(HXSPost *)postEntity
{
    _postEntity = postEntity;
    
    NSString *userNickNameStr         = postEntity.owner;
    self.userNickNameLabel.text       = userNickNameStr;
    
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:postEntity.ownerHeadPic]
                              placeholderImage:[UIImage imageNamed:@"dsfdl-tx"]];
    
    self.createTimeLabel.text = [[NSDate dateWithTimeIntervalSince1970:(postEntity.createTime.longLongValue/1000)] meyleyFormatString];
    
    [self.likeButton setSelected:postEntity.isFollow.boolValue];
    
    [self.likeButton setHidden: [postEntity.ownerUserId.stringValue isEqualToString:[HXSUserAccount currentAccount].userID.stringValue]];
    [self.dropdownButton setHidden: ![postEntity.ownerUserId.stringValue isEqualToString:[HXSUserAccount currentAccount].userID.stringValue]];
}

@end



