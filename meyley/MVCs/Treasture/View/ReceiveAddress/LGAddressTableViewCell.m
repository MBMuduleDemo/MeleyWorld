//
//  LGAddressTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGAddressTableViewCell.h"
#import "LGReceiveAddressModel.h"

@interface LGAddressTableViewCell ()

//名字电话
@property (nonatomic, strong) UILabel *nameLabel;
//电话
@property (nonatomic, strong) UILabel *telPhoneLabel;
//地址
@property (nonatomic, strong) UILabel *addressLabel;
//分割线
@property (nonatomic, strong) UIView *sepLine;
//设置默认地址
@property (nonatomic, strong) UIButton *setDefaultBtn;
//编辑按钮
@property (nonatomic, strong) UIButton *editBtn;
//删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;



@end

@implementation LGAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.telPhoneLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.sepLine];
    [self.contentView addSubview:self.setDefaultBtn];
    [self.contentView addSubview:self.editBtn];
    [self.contentView addSubview:self.deleteBtn];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(viewPix(16));
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(17));
    }];
    [self.nameLabel layoutIfNeeded];
    [self.telPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(16));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(viewPix(8));
        //        make.bottom.equalTo(self.sepLine.mas_top).offset(-viewPix(12));
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(17));
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_bottom).offset(-viewPix(31));
        make.height.mas_equalTo(0.5);
    }];
    [self.setDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.equalTo(self.sepLine.mas_bottom);
        make.width.mas_equalTo(100);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.setDefaultBtn);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-viewPix(10));
        make.width.mas_equalTo(50);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.setDefaultBtn);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(12));
        make.width.mas_equalTo(50);
    }];
    
}
#pragma mark--setter------
- (void)setModel:(LGReceiveAddressModel *)model {
    _model = model;
    self.nameLabel.text = model.consignee.length?model.consignee:@"";
    self.telPhoneLabel.text = model.mobile.length?model.mobile:@"";
    NSString *detailAddress = [NSString stringWithFormat:@"%@%@%@%@",model.provinceName.length?model.provinceName:@"",model.cityName.length?model.cityName:@"",model.districtName.length?model.districtName:@"",model.address.length?model.address:@""];
    self.addressLabel.text = detailAddress;
    if ([model.isDefault isEqualToString:@"1"]) {
        self.setDefaultBtn.selected = YES;
    }else {
        self.setDefaultBtn.selected = NO;
    }
}

#pragma mark---action----
- (void)setDefaultReceiveAddress:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setDefaultReceivingAddressWithIndexPath:)]) {
        [self.delegate setDefaultReceivingAddressWithIndexPath:self.model.indexPath];
    }
}

- (void)editCurrentReceiveAdress {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editCurrentReceivingAddressWithIndexPath:)]) {
        [self.delegate editCurrentReceivingAddressWithIndexPath:self.model.indexPath];
    }
}
- (void)deleteCurrentAddress {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCurrentReceivingAddressWithIndexPath:)]) {
        [self.delegate deleteCurrentReceivingAddressWithIndexPath:self.model.indexPath];
    }
}
#pragma mark--lazy-------
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#423e3e"];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}
- (UILabel *)telPhoneLabel {
    
    if (!_telPhoneLabel) {
        
        _telPhoneLabel = [[UILabel alloc]init];
        _telPhoneLabel.textAlignment = NSTextAlignmentRight;
        _telPhoneLabel.textColor = RGB(66, 62, 62);
        _telPhoneLabel.font = [UIFont systemFontOfSize:13];
        [_telPhoneLabel sizeToFit];
    }
    return _telPhoneLabel;
}
- (UILabel *)addressLabel {
    
    if (!_addressLabel) {
        
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = RGB(149, 149, 149);
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.numberOfLines = 0;
        [_addressLabel sizeToFit];
    }
    return _addressLabel;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    }
    return _sepLine;
}
- (UIButton *)setDefaultBtn {
    
    if (!_setDefaultBtn) {
        
        _setDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setDefaultBtn setImage:[UIImage imageNamed:@"x2"] forState:UIControlStateNormal];
        [_setDefaultBtn setImage:[UIImage imageNamed:@"x1"] forState:UIControlStateSelected];
        [_setDefaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
        [_setDefaultBtn setTitleColor:RGB(149, 149, 149) forState:UIControlStateNormal];
        _setDefaultBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_setDefaultBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [_setDefaultBtn addTarget:self action:@selector(setDefaultReceiveAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setDefaultBtn;
}
- (UIButton *)editBtn {
    
    if (!_editBtn) {
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"edit_address"] forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor colorWithHexString:@"#565a5c"] forState:UIControlStateNormal];
        [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editBtn addTarget:self action:@selector(editCurrentReceiveAdress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}
- (UIButton *)deleteBtn {
    
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithHexString:@"#565a5c"] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_deleteBtn addTarget:self action:@selector(deleteCurrentAddress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}



@end
