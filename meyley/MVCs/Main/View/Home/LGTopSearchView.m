//
//  LGTopSearchView.m
//  meyley
//
//  Created by mac on 2018/7/31.
//  Copyright © 2018年 Meyley. All rights reserved.
//  搜索

#import "LGTopSearchView.h"
#import "LGPickView.h"
@interface LGTopSearchView()<UITextFieldDelegate,LGPickViewDelegate>

@property (nonatomic , strong)UIView *searchView;
@property (nonatomic , strong)UILabel *cityLabel;
@property (nonatomic , strong)UIImageView *searchImageView;
@property (nonatomic , strong)UIButton *cancelBtn;

@end

@implementation LGTopSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
        [self creatSearchView];
    }
    return self;
}

-(void)selectCityAction{
    [self.searchTF resignFirstResponder];
    if (self.cityArry.count>0) {
        LGPickView *pickView = [[LGPickView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
        pickView.pickArry = @[self.cityArry];
        pickView.units = @[];
        pickView.titleLabel.text = @"请选择所在城市";
        pickView.topColor = RGB(250, 0, 102);
        pickView.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:pickView];
    }
}

-(void)sendPickViewResult:(NSString *)result selectStr:(NSString *)selectStr {
    self.cityLabel.text = result;
}

-(void)sendSelectResult:(NSString *)result{
//    self.cityLabel.text = result;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        [self.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(viewPix(230)));
        }];
        [self.searchView layoutSubviews];
        [self.searchView.superview layoutSubviews];
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        [self.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(viewPix(275)));
        }];
        [self.searchView layoutSubviews];
        [self.searchView.superview layoutSubviews];
    }completion:^(BOOL finished) {
        self.searchTF.text = nil;
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchGoodsWithText:)]) {
        [self.delegate searchGoodsWithText:textField.text];
    }
    return YES;
}

-(void)cancelSearchAction{
    [self.searchTF resignFirstResponder];
}


#pragma mark---懒加载
-(void)creatSubView{
    [self addSubview:self.categoryBtn];
    [self addSubview:self.searchView];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.shareBtn];
    __weak typeof(self) weakSelf = self;
    [self.categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.searchView);
        make.left.equalTo(weakSelf).offset(viewPix(18));
        make.width.height.equalTo(@(viewPix(23)));
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(statusBarHeight+viewPix(10));
        make.left.equalTo(weakSelf.categoryBtn.mas_right).offset(viewPix(12));
        make.height.equalTo(@(viewPix(42)));
        make.width.equalTo(@(viewPix(275)));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.searchView);
        make.width.height.equalTo(@(viewPix(40)));
        make.left.equalTo(weakSelf.searchView.mas_right).offset(viewPix(5.0));
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.searchView);
        make.right.equalTo(weakSelf).offset(-viewPix(2));
        make.height.equalTo(@(viewPix(40)));
        make.width.equalTo(@(viewPix(45)));
    }];
}

-(void)creatSearchView{
    [self.searchView addSubview:self.cityLabel];
    [self.searchView addSubview:self.searchTF];
    [self.searchView addSubview:self.searchImageView];
    UIImageView *tipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala"]];
    [self.searchView addSubview:tipImageView];
    UIImageView *lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fengexian"]];
    [self.searchView addSubview:lineView];
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityBtn addTarget:self action:@selector(selectCityAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:cityBtn];
    
    __weak typeof(self) weakSelf = self;
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.searchView);
        make.left.equalTo(weakSelf.searchView).offset(viewPix(13));
    }];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.searchView);
        make.left.equalTo(lineView.mas_right).offset(viewPix(12));
        make.right.equalTo(weakSelf.searchImageView.mas_left);
        make.height.equalTo(weakSelf.searchView);
    }];
    [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.searchView);
        make.right.equalTo(weakSelf.searchView).offset(-viewPix(15));
        make.width.height.equalTo(@(viewPix(17)));
    }];
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.searchView);
        make.left.equalTo(weakSelf.cityLabel.mas_right).offset(viewPix(4));
        make.width.equalTo(@(viewPix(11)));
        make.height.equalTo(@(viewPix(6)));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.searchView);
        make.left.equalTo(tipImageView.mas_right).offset(viewPix(10));
        make.width.equalTo(@(1.0));
        make.height.equalTo(@(viewPix(18)));
    }];
    [cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(weakSelf.searchView);
        make.right.equalTo(lineView.mas_left);
    }];
}

-(UIButton *)categoryBtn{
    if (!_categoryBtn) {
        _categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_categoryBtn setImage:[UIImage imageNamed:@"fenleiicon"] forState:UIControlStateNormal];
        [_categoryBtn setImage:[UIImage imageNamed:@"fenleiicon"] forState:UIControlStateHighlighted];
    }
    return _categoryBtn;
}

-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"gd"] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"gd"] forState:UIControlStateHighlighted];
        _shareBtn.backgroundColor = [UIColor whiteColor];
    }
    return _shareBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.titleLabel.font = LGFont(16);
        [_cancelBtn addTarget:self action:@selector(cancelSearchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc]init];
        _searchView.backgroundColor = RGB(245, 245, 245);
        _searchView.cornerRidus = viewPix(10);
    }
    return _searchView;
}
-(UILabel *)cityLabel{
    if (!_cityLabel) {
        _cityLabel = [UILabel lableWithFrame:CGRectZero text:@"杭州" textColor:RGB(102, 102, 102) font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _cityLabel;
}

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]init];
        _searchTF.tintColor = RGB(153, 153, 153);
        _searchTF.placeholder = @"搜索关键字";
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.delegate = self;
        _searchTF.font = LGFont(14);
    }
    return _searchTF;
}

-(UIImageView *)searchImageView{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
    }
    return _searchImageView;
}




@end
