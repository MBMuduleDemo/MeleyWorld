//
//  HXSHXSCommunityFootrCell.h
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPost.h"\

/**
 *  帖子底部  【时间  点赞，评论，分享】
 */
@interface HXSCommunityFootrCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *praiseButton;

/** 收藏回调 */
@property (nonatomic, copy) void (^likeActionBlock)();
/** 回复回调 */
@property (nonatomic, copy) void (^replyActionBlock)();
/** 点赞回调 */
@property (nonatomic, copy) void (^praiseActionBlock)();

@property (nonatomic, strong)HXSPost *postEntity;

@end
