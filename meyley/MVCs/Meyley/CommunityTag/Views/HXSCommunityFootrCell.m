//
//  HXSHXSCommunityFootrCell.m
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityFootrCell.h"
#import "NSDate+Extension.h"
#import "HXSUserAccount.h"

@interface HXSCommunityFootrCell()

@end

@implementation HXSCommunityFootrCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.likeButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.praiseButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.commentButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/**
 *  点赞操作
 *
 */
- (IBAction)likeTheCommunityAction:(id)sender
{
    if (self.likeActionBlock) {
        self.likeActionBlock();
    }
}

/**
 *  回复操作
 *
 */
- (IBAction)replyTheCommunityAction:(id)sender
{
    if (self.replyActionBlock) {
        self.replyActionBlock();
    }
}

/**
 *  分享操作
 *
 */
- (IBAction)praiseTheCommunityAction:(id)sender
{
    if (self.praiseActionBlock) {
        self.praiseActionBlock();
    }
    
}

- (void)setPostEntity:(HXSPost *)postEntity 
{
    NSInteger praiseCount = postEntity.praiseCount.integerValue;
    
    if (praiseCount == 0) {

        [self.praiseButton setTitle:@"0" forState:UIControlStateNormal];
        [self.praiseButton setTitle:@"0" forState:UIControlStateSelected];
    } else {
        if(praiseCount > 1000000)
        {
            [self.praiseButton setTitle:[NSString stringWithFormat:@"100万+"] forState:UIControlStateNormal];
            [self.praiseButton setTitle:[NSString stringWithFormat:@"100万+"] forState:UIControlStateSelected];
        } else if(praiseCount == 1000000)
        {
            [self.praiseButton setTitle:[NSString stringWithFormat:@"100万"] forState:UIControlStateNormal];
            [self.praiseButton setTitle:[NSString stringWithFormat:@"100万"] forState:UIControlStateSelected];
        } else if(praiseCount >= 10000)
        {
            [self.praiseButton setTitle:[NSString stringWithFormat:@"%zd万",praiseCount/10000] forState:UIControlStateNormal];
            [self.praiseButton setTitle:[NSString stringWithFormat:@"%zd万",praiseCount/10000] forState:UIControlStateSelected];
        } else {
            [self.praiseButton setTitle:[NSString stringWithFormat:@"%zd",praiseCount] forState:UIControlStateNormal];
            [self.praiseButton setTitle:[NSString stringWithFormat:@"%zd",praiseCount] forState:UIControlStateSelected];
        }
    }
    
    self.likeButton.selected = postEntity.isCollect.integerValue;
    self.praiseButton.selected = postEntity.isPraise.integerValue;
}

@end
