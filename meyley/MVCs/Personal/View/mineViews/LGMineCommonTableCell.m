//
//  LGMineCommonTableCell.m
//  meyley
//
//  Created by Bovin on 2018/9/30.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMineCommonTableCell.h"

@interface LGMineCommonTableCell ()

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation LGMineCommonTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.rightArrow];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(12);
            make.width.height.mas_equalTo(22);
        }];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.logoImageView.mas_right).offset(10);
        }];
        
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(12);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.rightArrow.mas_left).offset(-10);
            make.left.equalTo(self.typeLabel.mas_right);
        }];
        [self.detailLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}
#pragma marlk---setter---
- (void)setIcon:(NSString *)icon {
    _icon = icon;
    self.logoImageView.image = [UIImage imageNamed:icon];
}
- (void)setTypeName:(NSString *)typeName {
    _typeName = typeName;
    self.typeLabel.text = typeName;
}
- (void)setDetailValue:(NSString *)detailValue {
    _detailValue = detailValue;
    self.detailLabel.text = detailValue;
}
#pragma mark--lazy----
- (UIImageView *)logoImageView {
    
    if (!_logoImageView) {
        
        _logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"you"]];
    }
    return _logoImageView;
}
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:16];
        _typeLabel.textColor = RGB(66, 62, 62);
    }
    return _typeLabel;
}
- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.textColor = RGB(149, 149, 149);
    }
    return _detailLabel;
}
- (UIImageView *)rightArrow {
    
    if (!_rightArrow) {
        
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"you"]];
    }
    return _rightArrow;
}
@end
