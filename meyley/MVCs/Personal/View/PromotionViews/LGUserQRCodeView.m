//
//  LGUserQRCodeView.m
//  meyley
//
//  Created by Bovin on 2018/10/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGUserQRCodeView.h"
#import "LGPromotionHomeModel.h"

@interface LGUserQRCodeView ()
//我的邀请码
@property (nonatomic, strong) UILabel *myInviteCodeLabel;
//专属二维码
@property (nonatomic, strong) UILabel *tipsLabel;
//二维码
@property (nonatomic, strong) UIImageView *rcCodeImageView;
//分割条
@property (nonatomic, strong) UIView *sepBar;
@end

@implementation LGUserQRCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.myInviteCodeLabel];
        [self addSubview:self.rcCodeImageView];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.sepBar];
        [self.myInviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(viewPix(12));
            make.top.equalTo(self.mas_top);
            make.height.mas_equalTo(viewPix(49));
        }];
        [self.rcCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-viewPix(12));
            make.centerY.equalTo(self.myInviteCodeLabel.mas_centerY);
            make.width.height.mas_equalTo(viewPix(40));
        }];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.myInviteCodeLabel.mas_centerY);
            make.right.equalTo(self.rcCodeImageView.mas_left).offset(-viewPix(5));
        }];
        [self.sepBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(viewPix(10));
        }];
    }
    return self;
}
- (void)setModel:(LGPromotionHomeModel *)model {
    _model = model;
    self.myInviteCodeLabel.text = [NSString stringWithFormat:@"我的邀请码: %@",model.inviteCode];
    NSString *imageUrl = model.invitePicUrl;
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.rcCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
#pragma mark--lazy-----
- (UILabel *)myInviteCodeLabel {
    
    if (!_myInviteCodeLabel) {
        
        _myInviteCodeLabel = [[UILabel alloc]init];
        _myInviteCodeLabel.textColor = RGB(66, 62, 62);
        _myInviteCodeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _myInviteCodeLabel;
}
- (UILabel *)tipsLabel {
    
    if (!_tipsLabel) {
        
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.textColor = RGB(149, 149, 149);
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.textAlignment = NSTextAlignmentRight;
        _tipsLabel.text = @"专属二维码";
    }
    return _tipsLabel;
}
- (UIImageView *)rcCodeImageView {
    
    if (!_rcCodeImageView) {
        
        _rcCodeImageView = [[UIImageView alloc]init];
    }
    return _rcCodeImageView;
}
- (UIView *)sepBar {
    
    if (!_sepBar) {
        
        _sepBar = [[UIView alloc]init];
        _sepBar.backgroundColor = ML_BG_MAIN_COLOR;
    }
    return _sepBar;
}
@end
