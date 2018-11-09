//
//  LGBaseInputView.m
//  meyley
//
//  Created by Bovin on 2018/10/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBaseInputView.h"

@interface LGBaseInputView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *typeLabel;



@end

@implementation LGBaseInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor colorWithString:@"#DBDBDB"].CGColor;
        self.layer.borderWidth = 1;
        [self addSubview:self.typeLabel];
        [self addSubview:self.textField];
        
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(viewPix(10));
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.left.equalTo(self.typeLabel.mas_right);
        }];
    }
    return self;
}

#pragma mark--setter----
- (void)setTypeName:(NSString *)typeName {
    _typeName = typeName;
    self.typeLabel.text = typeName;
}
- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}
#pragma mark--action---
- (void)valueChanged:(UITextField *)textField {
    NSString *result = textField.text.length>0?textField.text:@"";
    if (self.userInputInfoHandler) {
        self.userInputInfoHandler(result);
    }
}

#pragma mark--lazy----
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.textColor = RGB(66, 62, 62);
        _typeLabel.text = @"提现至:";
        [_typeLabel sizeToFit];
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
        _textField.placeholder = @"选填:给商家留言(40字以内)";
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

@end
