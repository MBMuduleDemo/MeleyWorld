//
//  LGUseIntegralView.m
//  meyley
//
//  Created by Bovin on 2018/9/27.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGUseIntegralView.h"

@interface LGUseIntegralView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *allIntegralLabel;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation LGUseIntegralView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.tipLabel];
        [self.containerView addSubview:self.textField];
        [self.containerView addSubview:self.discountLabel];
        [self.containerView addSubview:self.allIntegralLabel];
        [self.containerView addSubview:self.sepLine];
        [self addSubview:self.sureBtn];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(viewPix(40));
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left).offset(viewPix(10));
            make.top.bottom.equalTo(self.containerView);
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipLabel.mas_right).offset(viewPix(10));
            make.centerY.equalTo(self.containerView.mas_centerY);
            make.width.mas_equalTo(viewPix(50));
            make.height.mas_equalTo(viewPix(30));
        }];
        [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.containerView);
            make.left.equalTo(self.textField.mas_right).offset(viewPix(10));
        }];
        [self.allIntegralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.containerView);
            make.centerY.equalTo(self.containerView.mas_centerY);
            make.right.equalTo(self.containerView.mas_right).offset(-viewPix(15));
        }];
        [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.containerView);
            make.height.mas_equalTo(0.5);
        }];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(viewPix(40));
            make.right.equalTo(self.mas_right).offset(-viewPix(40));
            make.bottom.equalTo(self.mas_bottom).offset(-viewPix(15));
            make.height.mas_equalTo(viewPix(45));
        }];
        
    }
    return self;
}
#pragma mark--setter---
- (void)setAllIntegral:(NSString *)allIntegral {
    _allIntegral = allIntegral;
    self.allIntegralLabel.text = [NSString stringWithFormat:@"积分:%@分",allIntegral];
    NSInteger integral = [allIntegral integerValue];
    if (integral>100) {
        NSInteger count = integral/100;
        self.textField.text = [NSString stringWithFormat:@"%ld",count*100];
        self.discountLabel.text = [NSString stringWithFormat:@"抵扣现金%ld元",count];
    }else {
        self.textField.text = [NSString stringWithFormat:@"0"];
    }
}
#pragma mark--action---
- (void)sureIntegralDiscount {
    NSInteger integral = [self.textField.text integerValue];
    NSInteger num = integral/100;
    NSString *discount = [NSString stringWithFormat:@"%ld",num];
    if (self.useIntegralBlock) {
        self.useIntegralBlock(discount);
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger integral = [self.allIntegral integerValue];
    
    if (integral<100) {
        [TooltipView showMessage:@"积分抵扣只能是100的倍数" offset:0];
        textField.text = @"";
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger integral = [textField.text integerValue];
    NSInteger num = integral/100;
    textField.text = [NSString stringWithFormat:@"%ld",num*100];
    self.discountLabel.text = [NSString stringWithFormat:@"抵扣现金%ld元",num];
}

#pragma mark--lazy------
- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc]init];
    }
    return _containerView;
}
- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.textColor = RGB(66, 62, 62);
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.text = @"使用";
    }
    return _tipLabel;
}

- (UITextField *)textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc]init];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.textColor = RGB(66, 62, 62);
        _textField.tintColor = RGB(255, 0, 82);
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (UILabel *)discountLabel {
    
    if (!_discountLabel) {
        
        _discountLabel = [[UILabel alloc]init];
        _discountLabel.textColor = RGB(66, 62, 62);
        _discountLabel.font = [UIFont systemFontOfSize:13];
        _discountLabel.text = @"抵扣现金0元";
    }
    return _discountLabel;
}
- (UILabel *)allIntegralLabel {
    
    if (!_allIntegralLabel) {
        
        _allIntegralLabel = [[UILabel alloc]init];
        _allIntegralLabel.textColor = RGB(66, 62, 62);
        _allIntegralLabel.font = [UIFont systemFontOfSize:13];
        _allIntegralLabel.text = @"积分:0分";
    }
    return _allIntegralLabel;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = ML_BG_MAIN_COLOR;
    }
    return _sepLine;
}
- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:RGB(255, 0, 82)];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureIntegralDiscount) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end
