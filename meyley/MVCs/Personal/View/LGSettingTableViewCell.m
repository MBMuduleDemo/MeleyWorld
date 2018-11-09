//
//  LGSettingTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/9/30.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGSettingTableViewCell.h"

@interface LGSettingTableViewCell ()

@property (nonatomic, strong) UIView *containerView;
//类型
@property (nonatomic, strong) UILabel *typeLabel;
//详细的
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation LGSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = ML_BG_MAIN_COLOR;
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.typeLabel];
        [self.containerView addSubview:self.detailLabel];
        [self.containerView addSubview:self.rightArrow];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
        }];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView.mas_centerY);
            make.left.equalTo(self.containerView.mas_left).offset(15);
        }];
        [self.typeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView.mas_centerY);
            make.right.equalTo(self.containerView.mas_right).offset(-15);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(12);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView.mas_centerY);
            make.right.equalTo(self.rightArrow.mas_left).offset(-10);
            make.left.equalTo(self.typeLabel.mas_right).offset(15);
        }];
    }
    return self;
}
- (void)setTypeName:(NSString *)typeName {
    _typeName = typeName;
    self.typeLabel.text = typeName;
}
- (void)setDetailValue:(NSString *)detailValue {
    _detailValue = detailValue;
    self.detailLabel.text = detailValue;
}
#pragma mark--lazy-------
- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.textColor = RGB(66, 62, 62);
    }
    return _typeLabel;
}
- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
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
