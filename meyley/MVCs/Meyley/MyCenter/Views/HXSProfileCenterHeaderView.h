//
//  HXSProfileCenterHeaderView.h
//  store
//
//  Created by J006 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSUserBasicInfo.h"
#import "HXSUITapImageView.h"
#import "UIImageView+HXSImageViewRoundCorner.h"

@interface HXSProfileCenterHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView        *backGroundImageView;
@property (weak, nonatomic) IBOutlet HXSUITapImageView  *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel            *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *signatureNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backGroundTopViewTopConsit;

+ (id)profileCenterHeaderView;

/**
 *  初始化社区个人中心界面顶部名称和头像展示
 *
 *  @param user entity,如果是当前用户则可以设置为nil
 */
- (void)initTheProfileCenterHeaderViewWithUser:(HXSUserBasicInfo *)user;

@end
