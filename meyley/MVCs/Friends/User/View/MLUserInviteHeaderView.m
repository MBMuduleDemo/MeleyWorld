//
//  MLUserInviteHeaderView.m
//  meyley
//
//  Created by chsasaw on 16/4/18.
//  Copyright © 2016年 meyley. All rights reserved.
//

#import "MLUserInviteHeaderView.h"
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"

@interface MLUserInviteHeaderView()

@property (nonatomic ,strong) HXSUserBasicInfo     *user;

@end

@implementation MLUserInviteHeaderView


#pragma mark -life cycle

+ (id)headerView
{
    MLUserInviteHeaderView *viewFromNib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    
    return viewFromNib;
}

#pragma mark - init

- (void)initTheHeaderViewWithUser:(HXSUserBasicInfo *)user;
{
    NSString *avatarURLStr;
    NSString *nameStr;
    NSString *signature;
    if(user) {
        _user = user;
    }
    
    avatarURLStr = user.headPic;
    nameStr      = user.realName;
    signature = user.tag;

    [_waiterActionButton setSelected:user.isMyWaiter.boolValue];
    [_waiterActionButton setHidden:!_user.isWaiter.boolValue];
    [_zhengshuImageView setHidden:!_user.isWaiter.boolValue];
    
    [_avatarImageView setImage:[UIImage imageNamed:@"dsfdl-tx"]];
    [_backGroundImageView setImage:[UIImage imageNamed:@"img_community@2x.jpg"]];
    if(avatarURLStr
       && ![avatarURLStr isEqualToString:@""]
       && ![avatarURLStr isEqualToString:@"bundlenew_logo"]) {
        NSURL *avatarURL = [[NSURL alloc]initWithString:avatarURLStr];
        [_avatarImageView sd_setImageWithURL:avatarURL
                            placeholderImage:[UIImage imageNamed:@"dsfdl-tx"]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            if(image)
                [_avatarImageView cornerRadiusForImageViewWithImage:image];
        }];
//        [_backGroundImageView sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"img_community@2x.jpg"]];
    }
    if(nameStr && ![nameStr isEqualToString:@""]) {
        [_userNameLabel setText:nameStr];
    }else {
        [_userNameLabel setText:@""];
    }
    if(signature && ![signature isEqualToString:@""]) {
        [_signatureNameLabel setText:signature];
    }else {
        [_signatureNameLabel setText:@""];
    }
    
    [_avatarImageView cornerRadiusForImageViewWithImage:_avatarImageView.image];
}

- (IBAction)cancelOrAddWaiter:(id)sender {
    if(self.waiterAction) {
        self.waiterAction();
    }
}

@end
