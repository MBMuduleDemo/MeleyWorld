//
//  LGAddNewAddressTableCell.m
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGAddNewAddressTableCell.h"

@interface LGAddNewAddressTableCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UIImageView *downArrow;

@end

@implementation LGAddNewAddressTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
        
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.downArrow];
    
}
#pragma mark---setter-----
- (void)setType:(LGAddressCellType)type {
    _type = type;
    [self setNeedsLayout];
}
- (void)setTypeString:(NSString *)typeString {
    _typeString = typeString;
    self.typeLabel.text = typeString;
}
- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc]initWithString:placeHolder];
    [atts addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#c0c0c0"] range:NSMakeRange(0, placeHolder.length)];
    self.textField.attributedPlaceholder = atts;
}
- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = text;
}
#pragma mark---action--------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.type == LGAddressCellTypeChoose) {
        if (self.editUserInfoBlock) {
            self.editUserInfoBlock(textField, self.type);
        }
        return NO;
    }
    if ([self.typeString isEqualToString:@"手机号码"]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }else {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    }
    return YES;
}

- (void)valueChanged:(UITextField *)textField  { //限制手机号输入
    if (self.type == LGAddressCellTypeDefault && [self.typeString isEqualToString:@"手机号码"]) {
        if (textField.text.length>11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    if (self.editUserInfoBlock) {
        self.editUserInfoBlock(textField, self.type);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.type) {
        case LGAddressCellTypeDefault:
            [self setupDefaultTypeConstraints];
            break;
        case LGAddressCellTypeChoose:
            [self setupChooseTypeCellConstraints];
            break;
        default:
            break;
    }
}
//布局默认样式
- (void)setupDefaultTypeConstraints {

    self.downArrow.hidden = YES;
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(16));
    }];
    [self.typeLabel layoutIfNeeded];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.typeLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(16));
    }];
}
//布局选择器cell
- (void)setupChooseTypeCellConstraints {

    self.downArrow.hidden = NO;
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(16));
    }];
    [self.typeLabel layoutIfNeeded];
    [self.downArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(16));
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(7);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.typeLabel.mas_right).offset(10);
        make.right.equalTo(self.downArrow.mas_left).offset(-viewPix(10));
    }];
}
#pragma mark--lazy-----
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textColor = RGB(66, 62, 62);
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}
- (UITextField *)textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = RGB(66, 62, 62);
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.tintColor = RGB(255, 0, 82);
        _textField.delegate = self;
        _textField.userInteractionEnabled = NO;
        [_textField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
- (UIImageView *)downArrow {
    
    if (!_downArrow) {
        
        _downArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala"]];
    }
    return _downArrow;
}



@end
