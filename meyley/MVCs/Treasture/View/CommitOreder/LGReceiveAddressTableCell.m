//
//  LGReceiveAddressTableCell.m
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGReceiveAddressTableCell.h"
#import "LGReceiveAddressModel.h"

#import "LGOrderDetailModel.h"

@interface LGReceiveAddressTableCell ()
//名字
@property (nonatomic, strong) UILabel *nameLabel;
//默认标识
@property (nonatomic, strong) UILabel *defaultLabel;
//地址icon
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *addressLabel;
//指示箭头
@property (nonatomic, strong) UIImageView *rightArrow;
//底部分割线
@property (nonatomic, strong) UIImageView *bottomImageView;
@end

@implementation LGReceiveAddressTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.defaultLabel];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.rightArrow];
    [self.contentView addSubview:self.bottomImageView];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(18));
        make.top.equalTo(self.contentView.mas_top).offset(viewPix(19));
    }];
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.left.equalTo(self.nameLabel.mas_right).offset(viewPix(8));
        make.width.mas_equalTo(35);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressLabel.mas_centerY);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.mas_equalTo(9);
        make.height.mas_equalTo(12);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(viewPix(9));
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(30));
    }];
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(16));
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(11);
    }];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(3);
    }];
}
#pragma mark--setter-----
- (void)setModel:(LGReceiveAddressModel *)model {
    _model = model;
    self.nameLabel.text = model.consignee;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.provinceName.length?model.provinceName:@"",model.cityName.length?model.cityName:@"",model.districtName.length?model.districtName:@"",model.address.length?model.address:@""];
}
- (void)setIsHasDefaultAddress:(BOOL)isHasDefaultAddress {
    _isHasDefaultAddress = isHasDefaultAddress;
    if (isHasDefaultAddress) {
        [self setupHasDefaultAddress];
    }else {
        [self setupNoneAddress];
    }
}
- (void)setupHasDefaultAddress {
    self.defaultLabel.hidden = NO;
    self.iconImageView.hidden = NO;
    [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(viewPix(9));
    }];
}
- (void)setupNoneAddress {
    self.defaultLabel.hidden = YES;
    self.iconImageView.hidden = YES;
    [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
    }];
}
- (void)setIsDefault:(BOOL)isDefault {
    _isDefault = isDefault;
    if (isDefault && self.isHasDefaultAddress) {
        self.defaultLabel.hidden = NO;
    }else {
        self.defaultLabel.hidden = YES;
    }
}
- (void)setDetailModel:(LGOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    self.nameLabel.text = detailModel.consignee;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",detailModel.provinceName.length?detailModel.provinceName:@"",detailModel.cityName.length?detailModel.cityName:@"",detailModel.districtName.length?detailModel.districtName:@"",detailModel.address.length?detailModel.address:@""];
}

#pragma mark---lazy------
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = RGB(66, 62, 62);
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"暂无地址";
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}
- (UILabel *)defaultLabel {
    
    if (!_defaultLabel) {
        
        _defaultLabel = [[UILabel alloc]init];
        _defaultLabel.textColor = [UIColor whiteColor];
        _defaultLabel.backgroundColor = RGB(255, 0, 82);
        _defaultLabel.font = [UIFont systemFontOfSize:12];
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
        _defaultLabel.layer.cornerRadius = 2;
        _defaultLabel.layer.masksToBounds = YES;
        _defaultLabel.text = @"默认";
        [_defaultLabel sizeToFit];
    }
    return _defaultLabel;
}
- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_Icon"]];
    }
    return _iconImageView;
}
- (UILabel *)addressLabel {
    
    if (!_addressLabel) {
        
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = RGB(149, 149, 149);
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.text = @"请点击这里添加新地址";
        [_addressLabel sizeToFit];
    }
    return _addressLabel;
}
- (UIImageView *)rightArrow {
    
    if (!_rightArrow) {
        
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"you"]];
    }
    return _rightArrow;
}
- (UIImageView *)bottomImageView {
    
    if (!_bottomImageView) {
        
        _bottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sepLine_address"]];
    }
    return _bottomImageView;
}
@end
