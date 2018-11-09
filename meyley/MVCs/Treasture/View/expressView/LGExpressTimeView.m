//
//  LGExpressTimeView.m
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGExpressTimeView.h"

@interface LGExpressTimeView ()

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UIView *expressContainerView;

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSArray<NSString *> *timeArray;

@end

@implementation LGExpressTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.timeArray = @[@"工作日",@"周末",@"节假日均可"];
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self addSubview:self.indicatorView];
    [self addSubview:self.typeLabel];
    [self addSubview:self.sepLine];
    [self addSubview:self.expressContainerView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.typeLabel.mas_centerY);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(5);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self.indicatorView.mas_right).offset(23);
        make.height.mas_equalTo(44);
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    [self.expressContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sepLine.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-9);
    }];
    [self setupTimeBtns];
}
- (void)setupTimeBtns {
    for (NSInteger i=0; i<self.timeArray.count; i++) {
        NSString *time = self.timeArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((8+80)*i, 0, 80, 40);
        [button setBackgroundImage:[UIImage imageNamed:@"selNormalBG"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"selSelectBG"] forState:UIControlStateSelected];
        [button setTitleColor:RGB(77, 77, 77) forState:UIControlStateNormal];
        [button setTitleColor:RGB(255, 0, 82) forState:UIControlStateSelected];
        [button setTitle:time forState:UIControlStateNormal];
        [button addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = LGFont(12);
        button.tag = 2000+i;
        [self.expressContainerView addSubview:button];
        if (i == 0) {
            [self timeButtonAction:button];
        }
    }
}
#pragma mark--action----
- (void)timeButtonAction:(UIButton *)button {
    
    if (self.selectBtn != button) {
        self.selectBtn.selected = NO;
        button.selected = YES;
    }
    self.selectBtn = button;
    NSString *time = self.timeArray[button.tag-2000];
    if (self.expressTimeChooseBlock) {
        self.expressTimeChooseBlock(time);
    }
}
#pragma mark--lazy-----
- (UIView *)indicatorView {
    
    if (!_indicatorView) {
        
        _indicatorView = [[UIView alloc]init];
        _indicatorView.backgroundColor = RGB(255, 0, 82);
    }
    return _indicatorView;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.text = @"配送时间";
        _typeLabel.textColor = RGB(66, 62, 62);
    }
    return _typeLabel;
}

- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithString:@"#DBDBDB"];
    }
    return _sepLine;
}
- (UIView *)expressContainerView {
    
    if (!_expressContainerView) {
        
        _expressContainerView = [[UIView alloc]init];
        _expressContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _expressContainerView;
}
@end
