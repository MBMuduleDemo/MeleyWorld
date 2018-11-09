//
//  LGGoodsDetailTotalPriceView.m
//  meyley
//
//  Created by Bovin on 2018/8/28.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailTotalPriceView.h"

@interface LGGoodsDetailTotalPriceView()<UITextFieldDelegate>

@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *priceLabel;
@property (nonatomic , strong)UIImageView *baseImageView;
@property (nonatomic , strong)UIButton *minusBtn;
@property (nonatomic , strong)UIButton *addBtn;
@property (nonatomic , strong)UITextField *numerTF;
@property (nonatomic , assign)NSInteger count;
@end

@implementation LGGoodsDetailTotalPriceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.count = 1;
        [self creatSubView];
    }
    return self;
}

-(void)setTotalPrice:(NSString *)totalPrice{
    _totalPrice = totalPrice;
    self.priceLabel.text = totalPrice;
}

-(void)setSingPrice:(NSString *)singPrice{
    _singPrice = singPrice;
    CGFloat price = [singPrice floatValue]*self.count;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",price];
}

-(void)setCount:(NSInteger)count{
    _count = count;
    if (count <= 1) {
        self.minusBtn.selected = YES;
        self.minusBtn.enabled = NO;
        [self.addBtn setImage:[UIImage imageNamed:@"add_enable"] forState:UIControlStateNormal];
        [self.minusBtn setImage:[UIImage imageNamed:@"minute_disable"] forState:UIControlStateNormal];
    }else if (count>=self.maxNum){
        [self.addBtn setImage:[UIImage imageNamed:@"add_disable"] forState:UIControlStateNormal];
        [self.minusBtn setImage:[UIImage imageNamed:@"minutes_enable"] forState:UIControlStateNormal];
        self.addBtn.selected = YES;
        self.addBtn.enabled = NO;
    }else{
        [self.addBtn setImage:[UIImage imageNamed:@"add_enable"] forState:UIControlStateNormal];
        [self.minusBtn setImage:[UIImage imageNamed:@"minutes_enable"] forState:UIControlStateNormal];
        self.minusBtn.selected = NO;
        self.minusBtn.enabled = YES;
        self.addBtn.selected = NO;
        self.addBtn.enabled = YES;
    }
    self.numerTF.text = [NSString stringWithFormat:@"%ld",self.count];
    CGFloat price = [self.singPrice floatValue]*self.count;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",price];
    if ([self.delegate respondsToSelector:@selector(getGoodsNumer:)]) {
        [self.delegate getGoodsNumer:count];
    }
}

-(void)minusGoodsNumer:(UIButton *)sender{
    if (self.count>1) {
        self.count--;
    }
}

-(void)addGoodsNumer:(UIButton *)sender{
    if (self.count<self.maxNum) {
        self.count++;
    }else{
        //弹框提示
        [TooltipView showMessage:@"超过最大数量" offset:0];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger numer = [textField.text integerValue];
    if (numer>0 && numer<=self.maxNum) {
        self.count = numer;
    }else{
        //弹框提示
        [TooltipView showMessage:@"超过最大数量" offset:0];
        self.numerTF.text = @"1";
        self.count = 1;
    }
}


#pragma mark -- 懒加载
-(void)creatSubView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.baseImageView];
    [self.baseImageView addSubview:self.minusBtn];
    [self.baseImageView addSubview:self.addBtn];
    [self.baseImageView addSubview:self.numerTF];
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(viewPix(15));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.titleLabel.mas_right).offset(viewPix(2));
    }];
    
    [self.baseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).offset(-viewPix(15));
        make.width.equalTo(@(viewPix(86)));
        make.height.equalTo(@(viewPix(24)));
    }];
    
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(weakSelf.baseImageView);
        make.width.equalTo(weakSelf.baseImageView.mas_height);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(weakSelf.baseImageView);
        make.width.equalTo(weakSelf.baseImageView.mas_height);
    }];
    
    [self.numerTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.baseImageView);
        make.left.equalTo(weakSelf.minusBtn.mas_right);
        make.right.equalTo(weakSelf.addBtn.mas_left);
    }];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:@"合计：" textColor:RGB(140, 140, 140) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _titleLabel;
}
-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(255, 0, 82) font:17 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _priceLabel;
}

-(UIImageView *)baseImageView{
    if (!_baseImageView) {
        _baseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"numerBG"]];
        _baseImageView.userInteractionEnabled = YES;
    }
    return _baseImageView;
}

-(UITextField *)numerTF{
    if (!_numerTF) {
        _numerTF = [[UITextField alloc]init];
        _numerTF.tintColor = RGB(56, 56, 56);
        _numerTF.keyboardType = UIKeyboardTypeNumberPad;
        _numerTF.delegate = self;
        _numerTF.textAlignment = NSTextAlignmentCenter;
        _numerTF.textColor = RGB(53, 53, 56);
        _numerTF.font = LGFont(13);
        _numerTF.text = @"1";
    }
    return _numerTF;
}

-(UIButton *)minusBtn{
    if (!_minusBtn) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setImage:[UIImage imageNamed:@"minute_disable"] forState:UIControlStateNormal];
        [_minusBtn addTarget:self action:@selector(minusGoodsNumer:) forControlEvents:UIControlEventTouchUpInside];
        _minusBtn.selected = YES;
    }
    return _minusBtn;
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"add_enable"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addGoodsNumer:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}


@end
