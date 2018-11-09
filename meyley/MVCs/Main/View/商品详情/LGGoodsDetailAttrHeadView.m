//
//  LGGoodsDetailAttrHeadView.m
//  meyley
//
//  Created by Bovin on 2018/8/28.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailAttrHeadView.h"

@interface LGGoodsDetailAttrHeadView ()

@property (nonatomic , strong)UILabel *categoryLabel;

@property (nonatomic , strong)UILabel *countLabel;

@end

@implementation LGGoodsDetailAttrHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}

-(void)setCategoryTitle:(NSString *)categoryTitle{
    _categoryTitle = categoryTitle;
    self.categoryLabel.text = categoryTitle;
}

-(void)setGoodsNum:(NSInteger)goodsNum{
    _goodsNum = goodsNum;
    self.countLabel.text = [NSString stringWithFormat:@"%ld个",goodsNum];
}


#pragma mark -- 懒加载
-(void)creatSubView{
    [self addSubview:self.categoryLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.openBtn];
    __weak typeof(self) weakSelf = self;
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(viewPix(15));
        make.centerY.equalTo(weakSelf);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.categoryLabel.mas_right).offset(viewPix(20));
    }];
    
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(weakSelf);
        make.width.equalTo(@(viewPix(50)));
    }];
}

-(UILabel *)categoryLabel{
    if (!_categoryLabel) {
        _categoryLabel = [UILabel lableWithFrame:CGRectZero text:@"请选择规格" textColor:RGB(62, 62, 62) font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _categoryLabel;
}


-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel lableWithFrame:CGRectZero text:@"1个" textColor:RGB(62, 62, 62) font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _countLabel;
}

-(MBButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        [_openBtn setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
        [_openBtn setImage:[UIImage imageNamed:@"NoramlUp"] forState:UIControlStateSelected];
        _openBtn.selected = YES;
    }
    return _openBtn;
}

@end
