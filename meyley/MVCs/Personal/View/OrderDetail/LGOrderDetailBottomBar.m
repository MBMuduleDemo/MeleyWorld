//
//  LGOrderDetailBottomBar.m
//  meyley
//
//  Created by Bovin on 2018/10/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderDetailBottomBar.h"


@interface LGOrderDetailBottomBar ()

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation LGOrderDetailBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sureBtn];
        [self addSubview:self.cancelBtn];
    }
    return self;
}
- (void)setType:(LGOrderDetailBottomBarType)type {
    _type = type;
    [self setNeedsLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.type) {
        case LGOrderDetailBottomBarTypeWaitPay:
        {
            [self.sureBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-viewPix(12));
                make.width.mas_equalTo(viewPix(74));
                make.height.mas_equalTo(viewPix(40));
            }];
            [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.sureBtn.mas_left).offset(-viewPix(20));
                make.width.mas_equalTo(viewPix(74));
                make.height.mas_equalTo(viewPix(40));
            }];
        }
            break;
        case LGOrderDetailBottomBarTypeWaitSend:
        {
            self.cancelBtn.hidden = YES;
            [self.sureBtn setTitle:@"未发货" forState:UIControlStateNormal];
            self.sureBtn.enabled = NO;
            self.sureBtn.backgroundColor = ML_DISABLE_COLOR;
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-viewPix(12));
                make.width.mas_equalTo(viewPix(74));
                make.height.mas_equalTo(viewPix(40));
            }];
        }
            break;
        case LGOrderDetailBottomBarTypeWaitReceive:
        {
            self.cancelBtn.hidden = YES;
            [self.sureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-viewPix(12));
                make.width.mas_equalTo(viewPix(74));
                make.height.mas_equalTo(viewPix(40));
            }];
        }
            break;
        case LGOrderDetailBottomBarTypeWaitComment:
        {
            [self.cancelBtn setTitle:@"查看" forState:UIControlStateNormal];
            [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.sureBtn.mas_left).offset(-viewPix(20));
                make.width.mas_equalTo(viewPix(74));
                make.height.mas_equalTo(viewPix(40));
            }];
            [self.sureBtn setTitle:@"评论/晒单" forState:UIControlStateNormal];
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-viewPix(12));
                make.left.equalTo(self.mas_left).offset(viewPix(12));
                make.height.mas_equalTo(viewPix(40));
            }];
        }
            break;
        case LGOrderDetailBottomBarTypeFinish:
        {
            self.cancelBtn.hidden = YES;
            [self.sureBtn setTitle:@"查看" forState:UIControlStateNormal];
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-viewPix(12));
                make.height.mas_equalTo(viewPix(40));
                make.width.mas_equalTo(viewPix(74));
            }];
        }
            break;
        case LGOrderDetailBottomBarTypeCancel:
        {
            self.cancelBtn.hidden = YES;
            [self.sureBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-viewPix(12));
                make.height.mas_equalTo(viewPix(40));
                make.width.mas_equalTo(viewPix(74));
            }];
        }
            break;
            
            
        default:
            break;
    }
}
#pragma mark--action---
- (void)sureBtnClick {
    if (self.sureActionBlock) {
        self.sureActionBlock(self.type);
    }
}
- (void)cancelBtnActionComplete {
    if (self.cancelActionBlock) {
        self.cancelActionBlock(self.type);
    }
}
#pragma mark--lazy-------
- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setBackgroundColor:RGB(255, 0, 62)];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _cancelBtn.layer.borderWidth = 0.5;
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancelBtnActionComplete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end
