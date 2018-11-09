//
//  LGMyBunsTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/10/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMyBunsTableViewCell.h"
#import "LGRedEnvelopModel.h"

@interface LGMyBunsTableViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *redBgImageView;
//红包优惠价格
@property (nonatomic, strong) UILabel *priceLabel;
//使用条件
@property (nonatomic, strong) UILabel *conditionLabel;
//期限
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *deadLineLabel;
//是否使用
@property (nonatomic, strong) UILabel *indicterLabel;


@end

@implementation LGMyBunsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    [self.containerView addSubview:self.indicterLabel];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(5));
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(5));
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
    [self.indicterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.containerView);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(15));
    }];
}
#pragma mark--setter---
- (void)setRedEnvelopModel:(LGRedEnvelopModel *)redEnvelopModel {
    _redEnvelopModel = redEnvelopModel;
}
#pragma mark---lazy-------
- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
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
        _priceLabel.text = @"10 元";
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:16];
    }
    return _priceLabel;
}
- (UILabel *)conditionLabel {
    
    if (!_conditionLabel) {
        
        _conditionLabel = [[UILabel alloc]init];
        _conditionLabel.textColor = RGB(97, 96, 96);
        _conditionLabel.text = @"满100元可用";
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
        _deadLineLabel.text = @"2018.8.30-2018.10.30";
        _deadLineLabel.font = [UIFont systemFontOfSize:11];
    }
    return _deadLineLabel;
}
- (UILabel *)indicterLabel {
    
    if (!_indicterLabel) {
        
        _indicterLabel = [[UILabel alloc]init];
        _indicterLabel.textAlignment = NSTextAlignmentLeft;
        _indicterLabel.textColor = RGB(66, 62, 62);
        _indicterLabel.text = @"未使用";
        _indicterLabel.font = [UIFont systemFontOfSize:14];
    }
    return _indicterLabel;
}
@end
