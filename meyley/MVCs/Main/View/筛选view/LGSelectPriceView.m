//
//  LGSelectPriceView.m
//  meyley
//
//  Created by Bovin on 2018/8/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGSelectPriceView.h"

@interface LGSelectPriceView()<UITextFieldDelegate>

@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UITextField *lowPriceTF;
@property (nonatomic , strong)UITextField *highPriceTF;
@property (nonatomic , strong)UIView *lineView;
@property (nonatomic , strong)UIView *bottomLineView;


@end

@implementation LGSelectPriceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}

-(void)restAction{
    self.lowPriceTF.text = nil;
    self.highPriceTF.text = nil;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.lowPriceTF) {
        if ([self.delegate respondsToSelector:@selector(selectLowPrice:)]) {
            [self.delegate selectLowPrice:textField.text];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(selectHighPrice:)]) {
            [self.delegate selectHighPrice:textField.text];
        }
    }
}

#pragma mark -- 懒加载
-(void)creatSubView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.lowPriceTF];
    [self addSubview:self.lineView];
    [self addSubview:self.highPriceTF];
    [self addSubview:self.bottomLineView];
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.lowPriceTF);
        make.left.equalTo(weakSelf).offset(viewPix(15));
    }];
    
    [self.lowPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(viewPix(85)));
        make.height.equalTo(@(viewPix(33)));
        make.bottom.equalTo(weakSelf).offset(-viewPix(10));
        make.right.equalTo(weakSelf.lineView.mas_left).offset(-viewPix(8));
    }];
    [self.highPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(weakSelf.lowPriceTF);
        make.right.equalTo(weakSelf).offset(-viewPix(8));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.lowPriceTF);
        make.right.equalTo(weakSelf.highPriceTF.mas_left).offset(-viewPix(8));
        make.width.equalTo(@(viewPix(15)));
        make.height.equalTo(@(1.0));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf);
        make.height.equalTo(@(1.0));
    }];
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:@"价格区间" textColor:RGB(106, 106, 106) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _titleLabel;
}

-(UITextField *)lowPriceTF{
    if (!_lowPriceTF) {
        _lowPriceTF = [[UITextField alloc]init];
        _lowPriceTF.placeholder = @"最低价";
        _lowPriceTF.font = LGFont(12);
        _lowPriceTF.textColor = RGB(106, 106, 106);
        _lowPriceTF.textAlignment = NSTextAlignmentCenter;
        _lowPriceTF.keyboardType = UIKeyboardTypeNumberPad;
        _lowPriceTF.backgroundColor = [UIColor colorWithString:@"f1f1f1"];
        _lowPriceTF.tintColor = RGB(180, 180, 180);
        _lowPriceTF.cornerRidus = 3.0;
        _lowPriceTF.delegate = self;
    }
    return _lowPriceTF;
}

-(UITextField *)highPriceTF{
    if (!_highPriceTF) {
        _highPriceTF = [[UITextField alloc]init];
        _highPriceTF.placeholder = @"最高价";
        _highPriceTF.font = LGFont(12);
        _highPriceTF.textColor = RGB(106, 106, 106);
        _highPriceTF.textAlignment = NSTextAlignmentCenter;
        _highPriceTF.keyboardType = UIKeyboardTypeNumberPad;
        _highPriceTF.backgroundColor = [UIColor colorWithString:@"f1f1f1"];
        _highPriceTF.tintColor = RGB(180, 180, 180);
        _highPriceTF.cornerRidus = 5.0;
        _highPriceTF.delegate = self;
    }
    return _highPriceTF;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(106, 106, 106);
    }
    return _lineView;
}

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = RGB(234, 234, 234);
    }
    return _bottomLineView;
}


@end
