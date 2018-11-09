//
//  LGSearchTopView.m
//  meyley
//
//  Created by Bovin on 2018/8/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGSearchTopView.h"
#import "MBButton.h"
#define btnWidth  Screen_W/4.0
@interface LGSearchTopView()

@property (nonatomic , strong)UIButton *latestBtn;
@property (nonatomic , strong)MBButton *saleBtn;
@property (nonatomic , strong)MBButton *priceBtn;
@property (nonatomic , strong)MBButton *selectBtn;
@property (nonatomic , assign)BOOL saleDesc;//从高到低
@property (nonatomic , assign)BOOL priceDesc;//从高到低

@property (nonatomic, strong) UIView *indicatorLine;

@end
@implementation LGSearchTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}

-(void)setSaleDesc:(BOOL)saleDesc{
    _saleDesc = saleDesc;
    if (saleDesc == YES) {
        
    }else{
        
    }
}

-(void)setPriceDesc:(BOOL)priceDesc{
    _priceDesc = priceDesc;
    if (priceDesc == YES) {
        
    }else{
        
    }
}

-(void)latestBtnTapAction:(UIButton *)sender{
    if (sender.selected == YES) {
        return;
    }else{
        sender.selected = YES;
        self.saleBtn.selected = NO;
        self.priceBtn.selected = NO;
    }
    
    if (self.saleDesc == NO) {
//        [self.saleBtn setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
    }else{
//        [self.saleBtn setImage:[UIImage imageNamed:@"NoramlUp"] forState:UIControlStateNormal];
    }
    
    if (self.priceDesc == NO) {
        [self.priceBtn setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
    }else{
        [self.priceBtn setImage:[UIImage imageNamed:@"NoramlUp"] forState:UIControlStateNormal];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(selectSearchKey:)]) {
        [self.delegate selectSearchKey:@"latest"];
    }
}

-(void)saleBtnTapAction:(UIButton *)sender{
    if (sender.selected == YES) {
        self.saleDesc = !self.saleDesc;
    }else{
        sender.selected = YES;
        self.latestBtn.selected = NO;
        self.priceBtn.selected = NO;
    }
    
    if (self.saleDesc == NO) {
//        [sender setImage:[UIImage imageNamed:@"selectDown"] forState:UIControlStateNormal];
    }else{
//        [sender setImage:[UIImage imageNamed:@"selectUp"] forState:UIControlStateNormal];
    }
    
    if (self.priceDesc == NO) {
        [self.priceBtn setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
    }else{
        [self.priceBtn setImage:[UIImage imageNamed:@"NoramlUp"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectSearchKey:)]) {
        if (self.saleDesc == YES) {
            [self.delegate selectSearchKey:@"sale+desc"];
        }else{
            [self.delegate selectSearchKey:@"sale+asc"];
        }
    }
}

-(void)priceBtnTapAction:(UIButton *)sender{
    if (sender.selected == YES) {
        self.priceDesc = !self.priceDesc;
        
    }else{
        sender.selected = YES;
        self.latestBtn.selected = NO;
        self.saleBtn.selected = NO;
    }
    
    if (self.priceDesc == NO) {
        [sender setImage:[UIImage imageNamed:@"selectDown"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"selectUp"] forState:UIControlStateNormal];
    }
    
    if (self.saleDesc == NO) {
//        [self.saleBtn setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
    }else{
//        [self.saleBtn setImage:[UIImage imageNamed:@"NoramlUp"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectSearchKey:)]) {
        if (self.priceDesc == YES) {
            [self.delegate selectSearchKey:@"price+desc"];
        }else{
            [self.delegate selectSearchKey:@"price+asc"];
        }
    }
}

-(void)selectBtnTapAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selectBtnTapAction)]) {
        [self.delegate selectBtnTapAction];
    }
}

#pragma mark -- 创建控件
-(void)creatSubView{
    [self addSubview:self.latestBtn];
    [self addSubview:self.saleBtn];
    [self addSubview:self.priceBtn];
    [self addSubview:self.selectBtn];
    __weak typeof(self) weakSelf = self;
    [self.latestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(weakSelf);
        make.width.equalTo(@(btnWidth));
    }];
    [self.saleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.latestBtn.mas_right);
        make.width.equalTo(weakSelf.latestBtn);
    }];
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.saleBtn.mas_right);
        make.width.equalTo(weakSelf.latestBtn);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(weakSelf);
        make.width.equalTo(weakSelf.latestBtn);
    }];
}
-(UIButton *)latestBtn{
    if (!_latestBtn) {
        _latestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_latestBtn setTitle:@"最新" forState:UIControlStateNormal];
        [_latestBtn setTitleColor:RGB(97, 97, 97) forState:UIControlStateNormal];
        [_latestBtn setTitleColor:RGB(255, 0, 82) forState:UIControlStateSelected];
        _latestBtn.titleLabel.font = LGFont(13);
        _latestBtn.selected = YES;
        [_latestBtn addTarget:self action:@selector(latestBtnTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _latestBtn;
}

-(MBButton *)saleBtn{
    if (!_saleBtn) {
        _saleBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        [_saleBtn setTitle:@"销量" forState:UIControlStateNormal];
//        [_saleBtn setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
        [_saleBtn setTitleColor:RGB(97, 97, 97) forState:UIControlStateNormal];
        [_saleBtn setTitleColor:RGB(255, 0, 82) forState:UIControlStateSelected];
        _saleBtn.titleLabel.font = LGFont(13);
        _saleBtn.type = MBButtonTypeRightImageLeftTitle;
        [_saleBtn addTarget:self action:@selector(saleBtnTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saleBtn;
}

-(MBButton *)priceBtn{
    if (!_priceBtn) {
        _priceBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        [_priceBtn setImage:[UIImage imageNamed:@"NoramlDown"] forState:UIControlStateNormal];
        [_priceBtn setTitleColor:RGB(97, 97, 97) forState:UIControlStateNormal];
        [_priceBtn setTitleColor:RGB(255, 0, 82) forState:UIControlStateSelected];
        _priceBtn.titleLabel.font = LGFont(13);
        _priceBtn.type = MBButtonTypeRightImageLeftTitle;
        [_priceBtn addTarget:self action:@selector(priceBtnTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceBtn;
}

-(MBButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"selNormal"] forState:UIControlStateNormal];
        [_selectBtn setTitleColor:RGB(97, 97, 97) forState:UIControlStateNormal];
        [_selectBtn setTitleColor:RGB(255, 0, 82) forState:UIControlStateSelected];
        _selectBtn.titleLabel.font = LGFont(13);
        _selectBtn.type = MBButtonTypeRightImageLeftTitle;
        [_selectBtn addTarget:self action:@selector(selectBtnTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (UIView *)indicatorLine {
    
    if (!_indicatorLine) {
        
        _indicatorLine = [[UIView alloc]init];
        _indicatorLine.backgroundColor = RGB(255, 0, 82);
    }
    return _indicatorLine;
}


@end
