//
//  LGRedEnvelopTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGRedEnvelopTableViewCell.h"
#import "LGRedEnvelopModel.h"

@interface LGRedEnvelopTableViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *redBgImageView;
//红包优惠价格
@property (nonatomic, strong) UILabel *priceLabel;
//使用条件
@property (nonatomic, strong) UILabel *conditionLabel;
//期限
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *deadLineLabel;
//选中指示框
@property (nonatomic, strong) UIButton *indicatorBtn;

@end

@implementation LGRedEnvelopTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = ML_BG_MAIN_COLOR;
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.redBgImageView];
    [self.redBgImageView addSubview:self.priceLabel];
    [self.containerView addSubview:self.conditionLabel];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.deadLineLabel];
    [self.containerView addSubview:self.indicatorBtn];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(15));
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(15));
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.redBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.containerView);
        make.width.mas_equalTo(63);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.redBgImageView);
    }];
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redBgImageView.mas_right).offset(viewPix(16));
        make.top.equalTo(self.containerView.mas_top).offset(viewPix(6));
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-viewPix(10));
        make.left.equalTo(self.conditionLabel.mas_left);
        make.width.height.mas_equalTo(viewPix(12));
    }];
    [self.deadLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(viewPix(6));
    }];
    [self.indicatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.containerView);
        make.width.mas_equalTo(viewPix(44));
    }];
}
#pragma mark--setter---
- (void)setModel:(LGRedEnvelopModel *)model {
    _model = model;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",model.typeMoney];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:self.priceLabel.text];
    NSString *price = model.typeMoney;
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(0, price.length)];
    self.priceLabel.attributedText = string;
    self.conditionLabel.text = model.typeName;
    self.deadLineLabel.text = [NSString stringWithFormat:@"%@-%@",model.useStartDate,model.useEndDate];
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.indicatorBtn.selected = selected;
}
#pragma mark--lazy------
- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 3;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UIImageView *)redBgImageView {
    
    if (!_redBgImageView) {
        
        _redBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_envolop_bg"]];
    }
    return _redBgImageView;
}

- (UILabel *)priceLabel {
    
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:16];
    }
    return _priceLabel;
}

- (UILabel *)conditionLabel {
    
    if (!_conditionLabel) {
        
        _conditionLabel = [[UILabel alloc]init];
        _conditionLabel.textColor = RGB(97, 96, 96);
        _conditionLabel.font = [UIFont systemFontOfSize:14];
        _conditionLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _conditionLabel;
}

- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"deadline_icon"]];
    }
    return _iconImageView;
}
- (UILabel *)deadLineLabel {
    
    if (!_deadLineLabel) {
        
        _deadLineLabel = [[UILabel alloc]init];
        _deadLineLabel.textAlignment = NSTextAlignmentLeft;
        _deadLineLabel.textColor = RGB(149, 149, 149);
        _deadLineLabel.font = [UIFont systemFontOfSize:11];
    }
    return _deadLineLabel;
}
- (UIButton *)indicatorBtn {
    
    if (!_indicatorBtn) {
        
        _indicatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_indicatorBtn setImage:[UIImage imageNamed:@"x2"] forState:UIControlStateNormal];
        [_indicatorBtn setImage:[UIImage imageNamed:@"x1"] forState:UIControlStateSelected];
        _indicatorBtn.userInteractionEnabled = NO;
    }
    return _indicatorBtn;
}
@end
