//
//  LGGoodsDetailBrandView.m
//  meyley
//
//  Created by mac on 2018/9/1.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailShopView.h"

@interface LGGoodsDetailShopView()

@property (nonatomic , strong)UIImageView *headImageView;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *numerLabel;


@end

@implementation LGGoodsDetailShopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatSubView];
    }
    return self;
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
}

-(void)setNumerStr:(NSString *)numerStr{
    _numerStr = numerStr;
    self.numerLabel.text = [NSString stringWithFormat:@"共有%@件商品",numerStr];
}


#pragma mark -- 懒加载
-(void)creatSubView{
    [self addSubview:self.headImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.numerLabel];
    [self addSubview:self.checkBtn];
    __weak typeof(self) weakSelf = self;
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(viewPix(15));
        make.width.height.equalTo(@(viewPix(60)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headImageView).offset(viewPix(5));
        make.left.equalTo(weakSelf.headImageView.mas_right).offset(viewPix(10));
    }];
    
    [self.numerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(viewPix(10));
        make.left.equalTo(weakSelf.titleLabel);
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).offset(-viewPix(17));
        make.width.equalTo(@(viewPix(60)));
        make.height.equalTo(@(viewPix(30)));
    }];
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(66, 66, 66) font:16 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _titleLabel;
}

-(UILabel *)numerLabel{
    if (!_numerLabel) {
        _numerLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(99, 99, 99) font:13 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _numerLabel;
}

-(UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:RGB(255, 0, 82) forState:UIControlStateNormal];
        [_checkBtn setTitleColor:RGB(255, 0, 82) forState:UIControlStateHighlighted];
        _checkBtn.layer.borderColor = RGB(255, 0, 82).CGColor;
        _checkBtn.layer.borderWidth = 1.0;
        _checkBtn.layer.cornerRadius = 5.0;
        _checkBtn.titleLabel.font = LGFont(14);
    }
    return _checkBtn;
}

@end
