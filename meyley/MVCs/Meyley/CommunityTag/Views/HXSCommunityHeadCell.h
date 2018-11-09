//
//  HXSCommunityHeadCellTableViewCell.h
//  store
//
//  Created by  陈斯 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  帖子头部cell  【头像，用户名，学校】

#import <UIKit/UIKit.h>
#import "HXSPost.h"

@interface HXSCommunityHeadCell : UITableViewCell

/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
/** 用户昵称 */
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
/** 创建时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 关注 */
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
/** 下拉按钮 */
@property (weak, nonatomic) IBOutlet UIButton *dropdownButton;

/** 加载发帖人中心 */
@property (nonatomic, copy) void (^loadPostUserCenter)();
/** 关注用户 */
@property (nonatomic, copy) void (^followUserBlock)();
/** 下拉按钮 */
@property (nonatomic, copy) void (^dropdownBlock)();

@property (nonatomic, strong)HXSPost *postEntity;

@end
