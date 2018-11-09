//
//  LGCategoryView.m
//  meyley
//
//  Created by mac on 2018/7/31.
//  Copyright © 2018年 Meyley. All rights reserved.
//  类目

#import "LGCategoryView.h"

@interface LGCategoryView ()

@property (nonatomic , strong)NSMutableArray *viewArry;

@property (nonatomic , strong)UIImageView *favourImageView;

@property (nonatomic , strong)UIImageView *releaseImageView;

@end

@implementation LGCategoryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}

-(void)setCategoryArry:(NSArray *)categoryArry{
    _categoryArry = categoryArry;
    if (categoryArry.count>=6) {
        if (self.viewArry.count<8) {
            for (NSInteger i=self.viewArry.count-1; i<7; i++) {
                UIView *view = [self creatGoodsViewWithIndex:i];
                [self addSubview:view];
            }
        }
    }else{
        if (self.viewArry.count>categoryArry.count+2) {
            for (NSInteger i=categoryArry.count; i<self.viewArry.count-1; i++) {
                UIView *view = self.viewArry[i];
                [self.viewArry removeObject:view];
                [view removeFromSuperview];
            }
            UIView *view = [self.viewArry lastObject];
            UIImageView *imageView = [self viewWithTag:view.tag+1000];
            UILabel *titleLabel = [self viewWithTag:view.tag+2000];
            view.tag = 1000+self.viewArry.count-1;
            imageView.tag = view.tag+1000;
            titleLabel.tag = view.tag+2000;
        }
    }
    [self layoutCategoryView];
}

-(void)layoutCategoryView{
    CGFloat width = Screen_W/4.0;
    CGFloat height = viewPix(70);
    for (NSInteger i=0; i<self.viewArry.count; i++) {
        UIView *view = self.viewArry[i];
        UIImageView *imageView = (UIImageView *)[view viewWithTag:2000+i];
        UILabel *titleLabel = (UILabel *)[view viewWithTag:3000+i];
        view.frame = CGRectMake(width*(i%4), (height+viewPix(20))*(i/4), width, height);
        if (i == 0) {
            imageView.image = [UIImage imageNamed:@"2"];
            titleLabel.text = @"品牌";
        }else if (i == self.viewArry.count-1){
            imageView.image = [UIImage imageNamed:@"8"];
            titleLabel.text = @"更多";
        }else{
            NSDictionary *dic = self.categoryArry[i-1];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"catPicUrl"]]]];
            titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"catName"]];
        }
    }
}

-(void)viewTapAction:(UITapGestureRecognizer *)sender{
    CGPoint point =  [sender locationInView:self];
    NSInteger index = -1;
    NSInteger tag = -1;
    NSInteger lastIndex = 1000+self.viewArry.count-1;
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        if (CGRectContainsPoint(view.frame, point)) {
            index = i;
            tag = view.tag;
            break;
        }
    }
    if (-1 == index || tag == -1) {
        return;
    }
    
    if (tag == 500) {
        //今日特惠
        if ([self.delegate respondsToSelector:@selector(goToTodayFavour)]) {
            [self.delegate goToTodayFavour];
        }
    }else if (tag == 600){
        //新品发布
        if ([self.delegate respondsToSelector:@selector(goToNewGoodsActive)]) {
            [self.delegate goToNewGoodsActive];
        }
    }else if (tag == 1000){
        //品牌
        if ([self.delegate respondsToSelector:@selector(goToBrandPage)]) {
            [self.delegate goToBrandPage];
        }
    }else if (tag == lastIndex){
        //更多
        if ([self.delegate respondsToSelector:@selector(goToMoreGoodsPage)]) {
            [self.delegate goToMoreGoodsPage];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(goToGoodsPageWithIndex:)]) {
            [self.delegate goToGoodsPageWithIndex:tag-1001];
        }
    }
}




#pragma mark -- 创建控件
-(void)creatSubView{
    CGFloat width = Screen_W/4.0;
    CGFloat height = viewPix(70);
    for (NSInteger i=0; i<8; i++) {
        UIView *view = [self creatGoodsViewWithIndex:i];
        view.frame = CGRectMake(width*(i%4), (height+viewPix(20))*(i/4), width, height);
        [self addSubview:view];
        [self.viewArry addObject:view];
    }
    //319*176
    CGFloat leftMargin = (Screen_W-viewPix(320)-viewPix(15))/2.0;
    self.favourImageView.frame = CGRectMake(leftMargin, viewPix(180), viewPix(160), viewPix(88));
    self.releaseImageView.frame = CGRectMake(kMaxX(self.favourImageView.frame)+viewPix(15), viewPix(180), viewPix(160), viewPix(88));
    [self addSubview:self.favourImageView];
    [self addSubview:self.releaseImageView];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapAction:)]];
}

-(NSMutableArray *)viewArry{
    if (!_viewArry) {
        _viewArry = [NSMutableArray array];
    }
    return _viewArry;
}

-(UIImageView *)favourImageView{
    if (!_favourImageView) {
        _favourImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tehui"]];
        _favourImageView.userInteractionEnabled = YES;
        _favourImageView.tag = 500;
    }
    return _favourImageView;
}

-(UIImageView *)releaseImageView{
    if (!_releaseImageView) {
        _releaseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xinpin"]];
        _releaseImageView.userInteractionEnabled = YES;
        _releaseImageView.tag = 600;
    }
    return _releaseImageView;
}


-(UIView *)creatGoodsViewWithIndex:(NSInteger)index{
    UIView *baseView = [[UIView alloc]init];
    baseView.tag = 1000+index;
    
    UIImageView *iconImageView = [[UIImageView alloc]init];
    iconImageView.tag = 2000+index;
    iconImageView.userInteractionEnabled = YES;
    [baseView addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(51, 51, 51) font:11 textAlignment:NSTextAlignmentCenter lines:1];
    titleLabel.tag = 3000+index;
    [baseView addSubview:titleLabel];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(baseView);
        make.top.equalTo(baseView).offset(viewPix(5));
        make.width.equalTo(@(viewPix(51)));
        make.height.equalTo(@(viewPix(44)));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(viewPix(5));
        make.centerX.equalTo(baseView);
    }];
    
    return baseView;
}


@end
