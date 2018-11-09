//
//  LGOrderCommonTableCell.m
//  meyley
//
//  Created by Bovin on 2018/9/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderCommonTableCell.h"

@interface LGOrderCommonTableCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIImageView *rightArrow;

@property (nonatomic, strong) UIView *sepLine;


@end

@implementation LGOrderCommonTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraits];
        self.disableInteraction = NO;
    }
    return self;
}
- (void)setupSubviewsAndConstraits {
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.rightArrow];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(10));
    }];
    [self.typeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.textLabel layoutIfNeeded];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.typeLabel.mas_right).offset(5);
    }];
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(16));
        make.width.mas_equalTo(viewPix(6));
        make.height.mas_equalTo(viewPix(12));
    }];
}
#pragma mark--setter---
- (void)setTypeName:(NSString *)typeName {
    _typeName = typeName;
    self.typeLabel.text = typeName;
    if ([self.typeName isEqualToString:@"订单留言"]) {
        self.textField.userInteractionEnabled = YES;
        self.rightArrow.hidden = YES;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-viewPix(16));
        }];
    }else if ([self.typeName isEqualToString:@"商品金额"] || [self.typeName isEqualToString:@"优惠金额"] || [self.typeName isEqualToString:@"运费"]) {
        self.textField.userInteractionEnabled = NO;
        self.rightArrow.hidden = YES;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-viewPix(16));
        }];
    }else {
        self.textField.userInteractionEnabled = NO;
        self.rightArrow.hidden = NO;
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightArrow.mas_left).offset(-viewPix(15));
        }];
    }
}
- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}
- (void)setValueString:(NSString *)valueString {
    _valueString = valueString;
    self.textField.text = valueString;
    if (valueString.length) {
        self.typeLabel.textColor = RGB(66, 62, 62);
    }else {
        if (self.disableInteraction) {
            self.typeLabel.textColor = RGB(66, 62, 62);
        }else {
            self.typeLabel.textColor = RGB(179, 179, 179);
        }
    }
    if ([self.typeName isEqualToString:@"商品金额"] || [self.typeName isEqualToString:@"优惠金额"] || [self.typeName isEqualToString:@"运费"]) {
        self.textField.textColor = RGB(255, 0, 82);
    }else {
        self.textField.textColor = RGB(66, 62, 62);
    }
}
- (void)setDisableInteraction:(BOOL)disableInteraction {
    _disableInteraction = disableInteraction;
    self.textField.enabled = !disableInteraction;
}
#pragma mark--
- (void)valueChanged:(UITextField *)textField {
    if (textField.text.length>40) {
        textField.text = [textField.text substringToIndex:40];
    }
    if (textField.text.length>0) {
        self.typeLabel.textColor = RGB(66, 62, 62);
    }else {
        if (self.disableInteraction) {
            self.typeLabel.textColor = RGB(66, 62, 62);
        }else {
            self.typeLabel.textColor = RGB(179, 179, 179);
        }
    }
    if (self.orderTipsMessageBlock) {
        self.orderTipsMessageBlock(textField.text);
    }
}

#pragma mark--lazy------
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textColor = RGB(179, 179, 179);
        _typeLabel.font = [UIFont systemFontOfSize:15];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        [_typeLabel sizeToFit];
    }
    return _typeLabel;
}

- (UITextField *)textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = RGB(66, 62, 62);
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.tintColor = RGB(255, 0, 82);
        _textField.placeholder = @"选填:给商家留言(40字以内)";
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
- (UIImageView *)rightArrow {
    
    if (!_rightArrow) {
        
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"you"]];
    }
    return _rightArrow;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    }
    return _sepLine;
}

@end
