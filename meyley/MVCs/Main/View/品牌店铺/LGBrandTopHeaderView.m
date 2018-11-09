//
//  LGBrandTopHeaderView.m
//  meyley
//
//  Created by Bovin on 2018/9/26.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBrandTopHeaderView.h"
#import "LGBrandDetailModel.h"

@interface LGBrandTopHeaderView ()
//背景图
@property (nonatomic, strong) UIImageView *bgImageView;
//品牌logo
@property (nonatomic, strong) UIImageView *logoImageView;
//底部半透明view
@property (nonatomic, strong) UIView *alphaView;
//品牌名称
@property (nonatomic, strong) UILabel *nameLabel;
//关注
@property (nonatomic, strong) UIButton *concernBtn;

@property (nonatomic, strong) UITapGestureRecognizer *bgTap;

@end

@implementation LGBrandTopHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithString:@"201341"];
        [self setupSubviewsAndConstraints];
        
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.alphaView];
    [self.bgImageView addSubview:self.logoImageView];
    [self.alphaView addSubview:self.nameLabel];
    [self.alphaView addSubview:self.concernBtn];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bgImageView);
        make.height.mas_equalTo(viewPix(50));
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(viewPix(10));
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-viewPix(10));
        make.width.height.mas_equalTo(viewPix(60));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alphaView.mas_left).offset(viewPix(80));
        make.top.bottom.equalTo(self.alphaView);
        make.right.equalTo(self.concernBtn.mas_left).offset(-20);
    }];
    [self.concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.alphaView);
        make.height.equalTo(self.concernBtn.mas_width);
    }];
}
- (void)setModel:(LGBrandDetailModel *)model {
    _model = model;
    NSString *bgImageUrl = model.brandBgpPath.length?model.brandBgpPath:@"";
    if (!bgImageUrl.length) {
        bgImageUrl = model.brandLogo;
    }
    bgImageUrl = [bgImageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:nil];
    
    NSString *logoUrl = model.brandLogo.length?model.brandLogo:@"";
    logoUrl = [logoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@\n%@",model.brandName.length?model.brandName:@"",model.englishName.length?model.englishName:@""];
    
}
#pragma mark--action---
//品牌简介
- (void)showBrandIntroduce {
    if (self.showBrandIntroduceBlock) {
        self.showBrandIntroduceBlock();
    }
}
/** 关注店铺*/
- (void)concernCurrentBrand:(UIButton *)sender {
    sender.selected =! sender.selected;
}
#pragma mark--lazy----
- (UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
- (UIImageView *)logoImageView {
    
    if (!_logoImageView) {
        
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBrandIntroduce)];
        [_logoImageView addGestureRecognizer:tap];
    }
    return _logoImageView;
}
- (UIView *)alphaView {
    
    if (!_alphaView) {
        
        _alphaView = [[UIView alloc]init];
        _alphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    }
    return _alphaView;
}
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = RGB(66, 62, 62);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
- (UIButton *)concernBtn {
    
    if (!_concernBtn) {
        
        _concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_concernBtn setImage:[UIImage imageNamed:@"mlq-guanzhu-qx"] forState:UIControlStateNormal];
        [_concernBtn setImage:[UIImage imageNamed:@"mlq-guanzhu"] forState:UIControlStateSelected];
        [_concernBtn addTarget:self action:@selector(concernCurrentBrand:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _concernBtn;
}
@end
