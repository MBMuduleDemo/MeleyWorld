//
//  LGCommissionTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/10/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGCommissionTableViewCell.h"
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"
#import "LGMyCommissionModel.h"

@interface LGCommissionTableViewCell ()
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//昵称
@property (nonatomic, strong) UILabel *nickNameLabel;
//订单
@property (nonatomic, strong) UILabel *orderNoLabel;
//结算状态
@property (nonatomic, strong) UILabel *stateLabel;
//订单描述
@property (nonatomic, strong) UILabel *orderDescLabel;
//积分拥金
@property (nonatomic, strong) UILabel *commissionLabel;

@end

@implementation LGCommissionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviewsAndConstaints];
    }
    return self;
}
- (void)setupSubviewsAndConstaints {
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.orderNoLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.orderDescLabel];
    [self.contentView addSubview:self.commissionLabel];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(10));
        make.top.equalTo(self.contentView.mas_top).offset(viewPix(5));
        make.width.height.mas_equalTo(viewPix(60));
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(viewPix(10));
        make.width.mas_equalTo(viewPix(60));
    }];
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickNameLabel.mas_centerY);
        make.left.equalTo(self.nickNameLabel.mas_right).offset(viewPix(5));
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickNameLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(10));
    }];
    [self.orderDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(viewPix(10));
        make.bottom.equalTo(self.headImageView.mas_bottom);
    }];
    [self.commissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-viewPix(5));
    }];
}
#pragma mark--setter---
- (void)setModel:(LGMyCommissionModel *)model {
    _model = model;
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单号:%@",model.orderSn];
    self.stateLabel.text = model.statusName;
    self.orderDescLabel.text = [NSString stringWithFormat:@"共%@件商品，%@元",model.goodsCount,model.orderAmount];
    self.commissionLabel.text = [NSString stringWithFormat:@"佣金 %@元，积分%@ 分",model.money,model.point];
}

#pragma mark--lazy----
- (UIImageView *)headImageView {
    
    if (!_headImageView) {
        
        _headImageView = [[UIImageView alloc]init];
        HXSUserInfo *userInfo = [HXSUserAccount currentAccount].userInfo;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.basicInfo.headPic]];
    }
    return _headImageView;
}
- (UILabel *)nickNameLabel {
    
    if (!_nickNameLabel) {
        
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.textColor = RGB(66, 62, 62);
        HXSUserInfo *userInfo = [HXSUserAccount currentAccount].userInfo;
        _nickNameLabel.text = userInfo.basicInfo.userName;
        _nickNameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nickNameLabel;
}
- (UILabel *)orderNoLabel {
    
    if (!_orderNoLabel) {
        
        _orderNoLabel = [[UILabel alloc]init];
        _orderNoLabel.textColor = RGB(149, 149, 149);
        _orderNoLabel.font = [UIFont systemFontOfSize:12];
    }
    return _orderNoLabel;
}
- (UILabel *)stateLabel {
    
    if (!_stateLabel) {
        
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textColor = RGB(149, 149, 149);
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _stateLabel;
}
- (UILabel *)orderDescLabel {
    
    if (!_orderDescLabel) {
        
        _orderDescLabel = [[UILabel alloc]init];
        _orderDescLabel.textColor = RGB(66, 62, 62);
        _orderDescLabel.font = [UIFont systemFontOfSize:12];
    }
    return _orderDescLabel;
}
- (UILabel *)commissionLabel {
    
    if (!_commissionLabel) {
        
        _commissionLabel = [[UILabel alloc]init];
        _commissionLabel.textColor = RGB(66, 62, 62);
        _commissionLabel.font = [UIFont systemFontOfSize:14];
        _commissionLabel.textAlignment = NSTextAlignmentRight;
    }
    return _commissionLabel;
}
@end
