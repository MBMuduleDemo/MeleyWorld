//
//  MLFollowListTableViewCell.h
//  meyley
//
//  Created by chsasaw on 2017/4/4.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSUserBasicInfo;

@interface MLFollowListTableViewCell : UITableViewCell

/** 加载发帖人中心 */
@property (nonatomic, copy) void (^loadPostUserCenter)();
/** 关注用户 */
@property (nonatomic, copy) void (^followUserBlock)(BOOL follow);

- (void)setUserInfo:(HXSUserBasicInfo *)userInfo;

@end
