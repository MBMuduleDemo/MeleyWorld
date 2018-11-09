//
//  LGShoppingCartTableHeaderView.m
//  meyley
//
//  Created by Bovin on 2018/8/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGShoppingCartTableHeaderView.h"

@interface LGShoppingCartTableHeaderView ()

@property (nonatomic, strong) UIButton *selectBtn;
//商品名称
@property (nonatomic, strong) UILabel *nameLabel;
//删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;
//分割线
@property (nonatomic, strong) UIView *sepLine;

@end

@implementation LGShoppingCartTableHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self addSubview:self.selectBtn];
    [self addSubview:self.nameLabel];
//    [self addSubview:self.deleteBtn];
    [self addSubview:self.sepLine];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(viewPix(42));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.selectBtn.mas_right);
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)setBrandName:(NSString *)brandName {
    _brandName = brandName;
    self.nameLabel.text = brandName;
}
- (void)setIsShouldSelect:(BOOL)isShouldSelect {
    _isShouldSelect = isShouldSelect;
    self.selectBtn.selected = isShouldSelect;
}
#pragma mark--action---
- (void)selectAllBrandGoods:(UIButton *)selectBtn {
    selectBtn.selected =! selectBtn.selected;
    if (self.SelectAllBrandGoods) {
        self.SelectAllBrandGoods(selectBtn.selected);
    }
}
- (void)deleteSelectGoods {
    
}
#pragma mark--lazy-----
- (UIButton *)selectBtn {
    
    if (!_selectBtn) {
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"x2"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"x1"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectAllBrandGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}
- (UIButton *)deleteBtn {
    
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteSelectGoods) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#DBDBDB"];
    }
    return _sepLine;
}
@end
