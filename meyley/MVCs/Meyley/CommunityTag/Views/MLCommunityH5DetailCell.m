//
//  MLCommunityH5DetailCell.m
//  meyley
//
//  Created by chsasaw on 2017/4/9.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLCommunityH5DetailCell.h"

@implementation MLCommunityH5DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeightWithText:(NSString *)contentText
{
    
    CGSize size = [contentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT)
                                            options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                            context:nil].size;
    
    
    return ceilf(size.height + (SCREEN_WIDTH - 32)*0.6 + 25 + 41);//10为上下约束边距
}

@end
