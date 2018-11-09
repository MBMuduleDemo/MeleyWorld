//
//  LGHomeFooterView.m
//  meyley
//
//  Created by Bovin on 2018/8/5.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGHomeFooterView.h"


@interface LGHomeFooterView ()

@property (nonatomic , strong)UIView *categoryView;

@property (nonatomic , strong)UIView *brandView;

@property (nonatomic , strong)UIView *activeView;

@property (nonatomic , strong)UIView *favourView;

@property (nonatomic , strong)UIImageView *logoImageView;

@end

@implementation LGHomeFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)]];
    }
    return self;
}


-(void)tapGestureAction:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self];
    if (CGRectContainsPoint(self.categoryView.frame, point)) {
        if ([self.delegate respondsToSelector:@selector(goToMoreGoodsPage)]) {
            [self.delegate goToMoreGoodsPage];
        }
    }else if(CGRectContainsPoint(self.brandView.frame, point)){
        if ([self.delegate respondsToSelector:@selector(goToBrandPage)]) {
            [self.delegate goToBrandPage];
        }
    }else if (CGRectContainsPoint(self.activeView.frame, point)){
        if ([self.delegate respondsToSelector:@selector(goToNewGoodsActive)]) {
            [self.delegate goToNewGoodsActive];
        }
    }else if (CGRectContainsPoint(self.favourView.frame, point)){
        if ([self.delegate respondsToSelector:@selector(goToTodayFavour)]) {
            [self.delegate goToTodayFavour];
        }
    }
}

-(void)creatSubView{
    self.categoryView = [self creatGoodsViewWithImage:@"fenlei" title:@"分类"];
    self.brandView = [self creatGoodsViewWithImage:@"pinpai" title:@"品牌"];
    self.activeView = [self creatGoodsViewWithImage:@"huodong" title:@"活动"];
    self.favourView = [self creatGoodsViewWithImage:@"tejia" title:@"今日特价"];
    self.logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zi"]];
    [self addSubview:self.categoryView];
    [self addSubview:self.brandView];
    [self addSubview:self.activeView];
    [self addSubview:self.favourView];
    [self addSubview:self.logoImageView];
    __weak typeof(self) weakSelf = self;
    CGFloat width = (Screen_W-viewPix(20))/4.0;
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(viewPix(15));
        make.left.equalTo(weakSelf).offset(viewPix(10));
        make.width.equalTo(@(width));
        make.height.equalTo(@(viewPix(80)));
    }];
    [self.brandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(weakSelf.categoryView);
        make.left.equalTo(weakSelf.categoryView.mas_right);
    }];
    [self.activeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(weakSelf.categoryView);
        make.left.equalTo(weakSelf.brandView.mas_right);
    }];
    [self.favourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(weakSelf.categoryView);
        make.left.equalTo(weakSelf.activeView.mas_right);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-viewPix(5));
        make.width.equalTo(@(viewPix(111)));
        make.height.equalTo(@(viewPix(42)));
    }];
}


-(UIView *)creatGoodsViewWithImage:(NSString *)image title:(NSString *)title{
    UIView *baseView = [[UIView alloc]init];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    iconImageView.userInteractionEnabled = YES;
    [baseView addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel lableWithFrame:CGRectZero text:title textColor:RGB(153, 153, 153) font:12 textAlignment:NSTextAlignmentCenter lines:1];
    [baseView addSubview:titleLabel];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(baseView);
        make.top.equalTo(baseView).offset(viewPix(5));
        make.width.height.equalTo(@(viewPix(49)));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(viewPix(10));
        make.centerX.equalTo(baseView);
    }];
    
    return baseView;
}


@end
