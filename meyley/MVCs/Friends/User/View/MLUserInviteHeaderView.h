//
//  MLUserInviteHeaderView.h
//  meyley
//
//  Created by chsasaw on 16/4/18.
//  Copyright © 2016年 meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSUserBasicInfo.h"
#import "HXSUITapImageView.h"
#import "UIImageView+HXSImageViewRoundCorner.h"

@interface MLUserInviteHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView        *backGroundImageView;
@property (weak, nonatomic) IBOutlet HXSUITapImageView  *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel            *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *signatureNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backGroundTopViewTopConsit;
@property (weak, nonatomic) IBOutlet UIButton           *waiterActionButton;
@property (weak, nonatomic) IBOutlet UIImageView        *zhengshuImageView;

@property (nonatomic, strong) dispatch_block_t waiterAction;

+ (id)headerView;

/**
 *  初始化社区个人中心界面顶部名称和头像展示
 *
 *  @param user entity,如果是当前用户则可以设置为nil
 */
- (void)initTheHeaderViewWithUser:(HXSUserBasicInfo *)user;

@end
