//
//  MLCommunityCommentCell.h
//  meyley
//
//  Created by chsasaw on 2017/4/9.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSComment;

@interface MLCommunityCommentCell : UITableViewCell

- (void)setComments:(NSArray<HXSComment *> *)comments;

+ (CGFloat)getCellHeight:(NSArray<HXSComment *> *)comments;

@end
