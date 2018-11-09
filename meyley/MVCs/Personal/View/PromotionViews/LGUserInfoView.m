//
//  LGUserInfoView.m
//  meyley
//
//  Created by Bovin on 2018/10/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGUserInfoView.h"
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"

@interface LGUserInfoView ()
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//昵称
@property (nonatomic, strong) UILabel *nickNameLabel;
//我的会员等级
@property (nonatomic, strong) UILabel *levelLabel;
//加盟或升级
@property (nonatomic, strong) UIButton *joinBtn;
//分割条
@property (nonatomic, strong) UIView *sepBar;

@property (nonatomic, strong) HXSUserInfo *userInfo;


@end

@implementation LGUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInfo = [HXSUserAccount currentAccount].userInfo;
        [self addSubview:self.headImageView];
        [self addSubview:self.nickNameLabel];
        [self addSubview:self.levelLabel];
        [self addSubview:self.joinBtn];
        [self addSubview:self.sepBar];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(viewPix(12));
            make.top.equalTo(self.mas_top).offset(viewPix(4));
            make.width.height.mas_equalTo(viewPix(40));
        }];
        [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headImageView.mas_centerY);
            make.left.equalTo(self.headImageView.mas_right).offset(viewPix(10));
            make.width.mas_equalTo(viewPix(70));
        }];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.headImageView.mas_centerY);
        }];
    
        [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-viewPix(12));
            make.centerY.equalTo(self.headImageView.mas_centerY);
            make.height.mas_equalTo(viewPix(30));
        }];
        [self.sepBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(viewPix(10));
        }];
        
    }
    return self;
}

#pragma mark--action------
- (void)joinMeOrUpdate {
    if (self.applicationToJoinOrUpdate) {
        self.applicationToJoinOrUpdate();
    }
}
#pragma mark--lazy-----
- (UIImageView *)headImageView {
    
    if (!_headImageView) {
        
        _headImageView = [[UIImageView alloc]init];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.basicInfo.headPic]];
    }
    return _headImageView;
}
- (UILabel *)nickNameLabel {
    
    if (!_nickNameLabel) {
        
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.textColor = RGB(66, 62, 62);
        _nickNameLabel.text = self.userInfo.basicInfo.userName;
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nickNameLabel;
}

- (UILabel *)levelLabel {
    
    if (!_levelLabel) {
        
        _levelLabel = [[UILabel alloc]init];
        _levelLabel.textColor = RGB(66, 62, 62);
        _levelLabel.font = [UIFont systemFontOfSize:14];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _levelLabel;
}
- (UIButton *)joinBtn {
    
    if (!_joinBtn) {
        
        _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinBtn setTitle:@"加盟/升级赚佣金" forState:UIControlStateNormal];
        [_joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_joinBtn setBackgroundColor:RGB(255, 0, 82) forState:UIControlStateNormal];
        _joinBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_joinBtn addTarget:self action:@selector(joinMeOrUpdate) forControlEvents:UIControlEventTouchUpInside];
        _joinBtn.layer.cornerRadius = 3;
        _joinBtn.layer.masksToBounds = YES;
    }
    return _joinBtn;
}
- (UIView *)sepBar {
    
    if (!_sepBar) {
        
        _sepBar = [[UIView alloc]init];
        _sepBar.backgroundColor = ML_BG_MAIN_COLOR;
    }
    return _sepBar;
}
@end
