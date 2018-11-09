//
//  LGSearchResultNavBar.m
//  meyley
//
//  Created by Bovin on 2018/8/4.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGSearchResultNavBar.h"

@interface LGSearchResultNavBar ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UITextField *textfield;

@property (nonatomic, strong) UIButton *searchBtn;


@end

@implementation LGSearchResultNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ML_MAIN_COLOR;
        [self addSubview:self.backBtn];
        [self addSubview:self.textfield];
        [self addSubview:self.searchBtn];
        
        [self setupSubviewsContraits];
    }
    return self;
}
- (void)setupSubviewsContraits {
    self.backBtn.frame = CGRectMake(0, statusBarHeight, viewPix(32), 44);
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(viewPix(5));
        make.top.mas_equalTo(statusBarHeight+viewPix(5));
        make.bottom.equalTo(self.mas_bottom).offset(-viewPix(5));
        make.right.equalTo(self.searchBtn.mas_left).offset(-viewPix(14));
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusBarHeight);
        make.left.equalTo(self.textfield.mas_right).offset(viewPix(14));
        make.bottom.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-viewPix(14));
    }];
}

#pragma mark---setter----
- (void)setKeywords:(NSString *)keywords {
    _keywords = keywords;
    self.textfield.text = keywords;
}

#pragma mark--action----
- (void)back {
    if (self.backBlock) {
        self.backBlock();
    }
}
- (void)research:(UIButton *)sender {
    if (self.textfield.isEditing) {
        [self.textfield endEditing:YES];
    }
    if (self.searchBlock) {
        self.searchBlock(self.textfield.text);
    }
}
#pragma mark----UITextFieldDelegate--
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.searchBlock) {
        self.searchBlock(self.textfield.text);
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textfield resignFirstResponder];
    return YES;
}

#pragma mark--lazy------

- (UIButton *)backBtn {
    
    if (!_backBtn) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UITextField *)textfield {
    
    if (!_textfield) {
        
        _textfield = [[UITextField alloc]init];
        _textfield.borderStyle = UITextBorderStyleRoundedRect;
        _textfield.placeholder = @"搜索关键字";
        _textfield.font = LGFont(14);
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewPix(30), 44-viewPix(10))];
        UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
        searchIcon.center = CGPointMake(leftView.center.x+viewPix(5), leftView.center.y);
        [leftView addSubview:searchIcon];
        _textfield.leftView = leftView;
        _textfield.leftViewMode = UITextFieldViewModeAlways;
        _textfield.tintColor = ML_MAIN_COLOR;
        _textfield.delegate = self;
    }
    return _textfield;
}
- (UIButton *)searchBtn {
    
    if (!_searchBtn) {
        
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = LGFont(14);
        [_searchBtn addTarget:self action:@selector(research:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
@end
