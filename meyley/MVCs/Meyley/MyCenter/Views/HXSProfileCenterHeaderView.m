//
//  HXSProfileCenterHeaderView.m
//  store
//
//  Created by J006 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSProfileCenterHeaderView.h"
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"

@interface HXSProfileCenterHeaderView()

@property (nonatomic ,strong) HXSUserBasicInfo     *user;

@end

@implementation HXSProfileCenterHeaderView


#pragma mark -life cycle

+ (id)profileCenterHeaderView
{
    HXSProfileCenterHeaderView *viewFromNib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    
    return viewFromNib;
}

#pragma mark - init

- (void)initTheProfileCenterHeaderViewWithUser:(HXSUserBasicInfo *)user;
{
    NSString *avatarURLStr;
    NSString *nameStr;
    NSString *signature;
    if(user) {
        _user = user;
    }
    
    avatarURLStr = user.headPic;
    nameStr      = user.userName;
    signature = user.signature;

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


@end
