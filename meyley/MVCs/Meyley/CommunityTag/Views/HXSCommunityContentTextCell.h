//
//  HXSCommunityContentCell.h
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPost.h"

@protocol HXSCommunityContentTextCellDelegate <NSObject>

@optional

/**
 *  复制帖子
 *
 */
- (void)copyTheContentWithEntity:(HXSPost *)postEntity;

/**
 *  举报帖子
 *
 */
- (void)reportTheContentWithEntity:(HXSPost *)postEntity;

/**
 *  删除帖子
 *
 */
- (void)deleteTheContentWithEntity:(HXSPost *)postEntity;

@end

/**
 *  帖子主题 【内容，文字  图片】
 */
@interface HXSCommunityContentTextCell : UITableViewCell

@property (nonatomic, weak) id<HXSCommunityContentTextCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//帖子内容Label

@property (nonatomic, strong) HXSPost *postEntity;

/**
 *  根据内容返回cell的高度
 */
+ (CGFloat)getCellHeightWithText:(NSString *)contentText lines:(int)lines;

@end
