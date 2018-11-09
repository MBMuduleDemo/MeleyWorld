//
//  LGBlanceShowView.m
//  meyley
//
//  Created by Bovin on 2018/10/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBlanceShowView.h"

@interface LGBlanceShowView ()
//余额
@property (nonatomic, strong) UILabel *blanceLabel;
//充值
@property (nonatomic, strong) UIButton *chargeBtn;

@end

@implementation LGBlanceShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(255, 0, 82);
        [self addSubview:self.blanceLabel];
        [self addSubview:self.chargeBtn];
        [self.blanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(viewPix(22));
        }];
        [self.chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-viewPix(12));
            make.width.mas_equalTo(viewPix(70));
            make.height.mas_equalTo(viewPix(35));
        }];
    }
    return self;
}
#pragma mark--setter---
- (void)setUserBlanceMoney:(NSString *)userBlanceMoney {
    _userBlanceMoney = userBlanceMoney;
    self.blanceLabel.text = [NSString stringWithFormat:@"现金余额:%@ 元",self.userBlanceMoney];
}
#pragma mark--action---
//用户账户充值
- (void)chargeForUserAccount {
    
}
#pragma mark--lazy-----
- (UILabel *)blanceLabel {
    
    if (!_blanceLabel) {
        
        _blanceLabel = [[UILabel alloc]init];
        _blanceLabel.font = [UIFont systemFontOfSize:14];
        _blanceLabel.textColor = [UIColor whiteColor];
        [_blanceLabel sizeToFit];
    }
    return _blanceLabel;
}

- (UIButton *)chargeBtn {
    
    if (!_chargeBtn) {
        
        _chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_chargeBtn setBackgroundColor:ML_BG_MAIN_COLOR forState:UIControlStateNormal];
        [_chargeBtn setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        [_chargeBtn addTarget:self action:@selector(chargeForUserAccount) forControlEvents:UIControlEventTouchUpInside];
        _chargeBtn.hidden = YES;
    }
    return _chargeBtn;
}
@end
