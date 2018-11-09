//
//  LGAddRedEnvelopAlertView.m
//  meyley
//
//  Created by Bovin on 2018/9/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGAddRedEnvelopAlertView.h"

@interface LGAddRedEnvelopAlertView ()

@property (nonatomic, copy) NSString *redCodeText;

@end

@implementation LGAddRedEnvelopAlertView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title commitBtnTitle:(NSString *)commitTitle {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAlertView)];
        [self addGestureRecognizer:tap];
        
        
        CGFloat viewWidth = Screen_W-60;
        CGFloat viewHeight = 220;
        UIView *showView = [[UIView alloc]initWithFrame:CGRectMake((Screen_W - viewWidth)/2, (Screen_H-viewHeight)/2, viewWidth, viewHeight)];
        showView.backgroundColor = [UIColor whiteColor];
        showView.layer.cornerRadius = 10;
        showView.layer.masksToBounds = YES;
        [self addSubview:showView];
        
        UILabel *lb_title = [[UILabel alloc]init];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = title;
        lb_title.font = [UIFont systemFontOfSize:16];
        lb_title.numberOfLines = 0;
        lb_title.textColor = RGB(66, 62, 62);
        lb_title.textAlignment = NSTextAlignmentCenter;
        [lb_title sizeToFit];
        [lb_title layoutIfNeeded];
        [showView addSubview:lb_title];
        [lb_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(showView);
            make.height.mas_equalTo(44);
        }];
        UIView *sepLine = [[UIView alloc]init];
        sepLine.backgroundColor = RGB(168, 168, 168);
        [showView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(showView);
            make.top.equalTo(lb_title.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = @"请输入红包码";
        tipLabel.font = [UIFont systemFontOfSize:11];
        tipLabel.textColor = RGB(168, 168, 168);
        [showView addSubview:tipLabel];
        
        UITextField *textField = [[UITextField alloc]init];
        textField.borderStyle = UITextBorderStyleLine;
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
        textField.tintColor = RGB(255, 0, 82);
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = RGB(66, 62, 62);
        [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [showView addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(showView.mas_centerY);
            make.left.equalTo(showView.mas_left).offset(35);
            make.right.equalTo(showView.mas_right).offset(-35);
            make.height.mas_equalTo(44);
        }];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textField.mas_left).offset(5);
            make.bottom.equalTo(textField.mas_top).offset(-6);
        }];
        
        UIButton *rightBtn;
        if (commitTitle && commitTitle.length >0) {
            rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setBackgroundColor:RGB(255, 0, 82)];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rightBtn setTitle:commitTitle forState:UIControlStateNormal];
            rightBtn.layer.cornerRadius = 3;
            rightBtn.layer.masksToBounds = YES;
            [rightBtn addTapBlock:^(UIButton *btn) {
                if (self.sureBtnClickBlock) {
                    self.sureBtnClickBlock();
                }
            }];
            [showView addSubview:rightBtn];
        }
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showView.mas_left).offset(40);
            make.bottom.equalTo(showView.mas_bottom).offset(-20);
            make.right.equalTo(showView).offset(-40);
            make.height.offset(40);
        }];
    }
    return self;
}
- (void)textFieldValueChanged:(UITextField *)textField {
    if (self.redEnvelopCode) {
        self.redEnvelopCode(textField.text);
    }
}
- (void)closeAlertView {
    [self removeFromSuperview];
}
@end
