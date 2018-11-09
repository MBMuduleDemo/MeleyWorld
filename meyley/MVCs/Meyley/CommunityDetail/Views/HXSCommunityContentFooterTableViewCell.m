//
//  HXSCommunityContentFooterTableViewCell.m
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityContentFooterTableViewCell.h"
#import "NSDate+Extension.h"
#import "HXSAccountManager.h"
@implementation HXSCommunityContentFooterTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setPostEntity:(HXSPost *)postEntity {
    [super setPostEntity:postEntity];
    
    self.commentButton.titleLabel.text = [NSString stringWithFormat:@"%ld", postEntity.commentCount.integerValue];
}

@end
