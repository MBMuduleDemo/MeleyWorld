//
//  LGShoppingCartBottomBar.m
//  meyley
//
//  Created by Bovin on 2018/9/1.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGShoppingCartBottomBar.h"
#import "MLWaiterModel.h"

@interface LGShoppingCartBottomBar ()

@property (nonatomic, strong) UIView *priceContainerView;
//全选
@property (nonatomic, strong) MBButton *selectAllBtn;
@property (nonatomic, strong) UIView *selectSepLine;
//红包积分
@property (nonatomic, strong) UILabel *redEnvelopLabel;
@property (nonatomic, strong) UIView *priceSepLine;
//价格
@property (nonatomic, strong) UILabel *priceLabel;



@property (nonatomic, strong) UIView *actionContainerView;
//客服
@property (nonatomic, strong) UIButton *serviceBtn;
@property (nonatomic, strong) UIView *serviceSepLine;
@property (nonatomic, strong) UILabel *serviceLabel;
//结算
@property (nonatomic, strong) UIButton *buyBtn;
//编辑状态展示
@property (nonatomic, strong) UIButton *addCollectionBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation LGShoppingCartBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor colorWithHexString:@"#DBDBDB"].CGColor;
        self.layer.borderWidth = 0.5;
        [self setupSubviewsAndConstraints];
        self.state = LGCartStateDefault;
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self addSubview:self.priceContainerView];
    [self.priceContainerView addSubview:self.selectAllBtn];
    [self.priceContainerView addSubview:self.selectSepLine];
    [self.priceContainerView addSubview:self.redEnvelopLabel];
    [self.priceContainerView addSubview:self.priceSepLine];
    [self.priceContainerView addSubview:self.priceLabel];
    
    
    [self addSubview:self.actionContainerView];
    [self.actionContainerView addSubview:self.serviceBtn];
    [self.actionContainerView addSubview:self.serviceSepLine];
    [self.actionContainerView addSubview:self.serviceLabel];
    [self.actionContainerView addSubview:self.buyBtn];
    [self.actionContainerView addSubview:self.addCollectionBtn];
    [self.actionContainerView addSubview:self.deleteBtn];
    
    [self.priceContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceContainerView.mas_centerY);
        make.left.equalTo(self.priceContainerView.mas_left);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(32);
    }];
    [self.selectSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceContainerView.mas_centerY);
        make.left.equalTo(self.selectAllBtn.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    [self.redEnvelopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.priceContainerView);
        make.left.equalTo(self.selectSepLine.mas_right).offset(20);
    }];
    [self.priceSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceContainerView.mas_right).offset(-viewPix(130));
        make.centerY.equalTo(self.priceContainerView.mas_centerY);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.priceContainerView);
        make.right.equalTo(self.priceContainerView.mas_right).offset(-10);
        make.left.equalTo(self.priceSepLine.mas_right).offset(10);
    }];

    [self.actionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceContainerView.mas_bottom);
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(49);
    }];
    [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.actionContainerView);
        make.width.mas_equalTo(44);
    }];
    [self.serviceSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionContainerView.mas_centerY);
        make.left.equalTo(self.serviceBtn.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serviceSepLine.mas_right).offset(5);
        make.top.bottom.equalTo(self.actionContainerView);
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.actionContainerView);
        make.width.mas_equalTo(viewPix(130));
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.actionContainerView);
        make.width.mas_equalTo(viewPix(75));
    }];
    [self.addCollectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.actionContainerView);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-2);
        make.width.mas_equalTo(viewPix(75));
    }];
}
- (void)setState:(LGCartState)state {
    _state = state;
    switch (state) {
        case LGCartStateDefault:
            [self setupDefaultStateSubviews];
            break;
        case LGCartStateEditing:
            [self setupEditingStateSubviews];
            break;
            
        default:
            break;
    }
}
- (void)setupDefaultStateSubviews {
    self.addCollectionBtn.hidden = YES;
    self.deleteBtn.hidden = YES;
    self.buyBtn.hidden = NO;
}
- (void)setupEditingStateSubviews {
    self.addCollectionBtn.hidden = NO;
    self.deleteBtn.hidden = NO;
    self.buyBtn.hidden = YES;
}
- (void)setIsShouldSelect:(BOOL)isShouldSelect {
    _isShouldSelect = isShouldSelect;
    self.selectAllBtn.selected = isShouldSelect;
}
- (void)setTotalPrice:(NSString *)totalPrice {
    _totalPrice = totalPrice;
    self.priceLabel.text = [NSString stringWithFormat:@"合计:\n￥%@",totalPrice];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:self.priceLabel.text];
    NSRange range = [self.priceLabel.text rangeOfString:@"￥"];
    [string addAttributes:@{NSForegroundColorAttributeName:RGB(255, 0, 82)} range:NSMakeRange(range.location, self.priceLabel.text.length-range.location)];
    self.priceLabel.attributedText = string;
}
- (void)setGoodsCount:(NSInteger)goodsCount {
    _goodsCount = goodsCount;
    self.buyBtn.userInteractionEnabled = YES;
    if (goodsCount>0) {
        [self.buyBtn setTitle:[NSString stringWithFormat:@"去结算(%ld)",goodsCount] forState:UIControlStateNormal];
        [_buyBtn setBackgroundColor:RGB(255, 0, 82)];
    }else {
        [self.buyBtn setTitle:[NSString stringWithFormat:@"去结算"] forState:UIControlStateNormal];
        [_buyBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.buyBtn.userInteractionEnabled = NO;
    }
}
- (void)setWaiterModel:(MLWaiterModel *)waiterModel {
    _waiterModel = waiterModel;
    if (waiterModel) {
        [self.serviceBtn sd_setImageWithURL:[NSURL URLWithString:waiterModel.headPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"42"]];
        self.serviceLabel.text = waiterModel.waiterName;
    }
}
- (void)setDiscountPrice:(NSString *)discountPrice {
    _discountPrice = discountPrice;
    if (discountPrice.length>0) {
        self.redEnvelopLabel.text = [NSString stringWithFormat:@"优惠:-￥%@",discountPrice];
    }
}
#pragma mark---action---
//全选（购物车中所有的商品）
- (void)selectAllGoods:(UIButton *)selectBtn {
    selectBtn.selected =! selectBtn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAllShoppingCartGoodsWithIsSelect:)]) {
        [self.delegate selectAllShoppingCartGoodsWithIsSelect:selectBtn.selected];
    }
}
//客服中心
- (void)goToMyServiceCenter:(UIButton *)serviceBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactCustomerService)]) {
        [self.delegate contactCustomerService];
    }
}
//使用红包积分
- (void)addRedEnvelopOrIntergral {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsPrefrenceWithRedEnvelopOrIntegral)]) {
        [self.delegate goodsPrefrenceWithRedEnvelopOrIntegral];
    }
}
//提交订单
- (void)commitOrder:(UIButton *)buyBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitGoodsOrder)]) {
        [self.delegate commitGoodsOrder];
    }
}
//加入收藏
- (void)collectionAllSelectGoods {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionAllSelectGoods)]) {
        [self.delegate collectionAllSelectGoods];
    }
}
//删除
- (void)deleteSelectGoodsFromShoppingCart {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteAllSelectGoodsFromShoppingCart)]) {
        [self.delegate deleteAllSelectGoodsFromShoppingCart];
    }
}
#pragma mark--lazy-----
- (UIView *)priceContainerView {
    
    if (!_priceContainerView) {
        
        _priceContainerView = [[UIView alloc]init];
        _priceContainerView.backgroundColor = [UIColor whiteColor];
        _priceContainerView.layer.borderColor = ML_BG_MAIN_COLOR.CGColor;
        _priceContainerView.layer.borderWidth = 0.5;
    }
    return _priceContainerView;
}
- (UIButton *)selectAllBtn {
    
    if (!_selectAllBtn) {
        
        _selectAllBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        [_selectAllBtn setImage:[UIImage imageNamed:@"x2"] forState:UIControlStateNormal];
        [_selectAllBtn setImage:[UIImage imageNamed:@"x1"] forState:UIControlStateSelected];
        _selectAllBtn.textAlignment = MBButtonTypeTopImageBottomTitle;
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_selectAllBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [_selectAllBtn addTarget:self action:@selector(selectAllGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAllBtn;
}
- (UIView *)selectSepLine {
    
    if (!_selectSepLine) {
        
        _selectSepLine = [[UIView alloc]init];
        _selectSepLine.backgroundColor = [UIColor colorWithString:@"#DBDBDB"];
    }
    return _selectSepLine;
}
- (UILabel *)redEnvelopLabel {
    
    if (!_redEnvelopLabel) {
        
        _redEnvelopLabel = [[UILabel alloc]init];
        _redEnvelopLabel.textColor = RGB(66, 62, 62);
        _redEnvelopLabel.font = [UIFont systemFontOfSize:12];
        _redEnvelopLabel.text = @"优惠:红包/券/积分";
        _redEnvelopLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addRedEnvelopOrIntergral)];
        [_redEnvelopLabel addGestureRecognizer:tap];
    }
    return _redEnvelopLabel;
}
- (UIView *)priceSepLine {
    
    if (!_priceSepLine) {
        
        _priceSepLine = [[UIView alloc]init];
        _priceSepLine.backgroundColor = [UIColor colorWithString:@"#DBDBDB"];
    }
    return _priceSepLine;
}
- (UILabel *)priceLabel {
    
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.text = @"合计:\n￥0.00";
        _priceLabel.numberOfLines = 2;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_priceLabel.text];
        NSRange range = [_priceLabel.text rangeOfString:@"￥"];
        [string addAttributes:@{NSForegroundColorAttributeName:RGB(255, 0, 82)} range:NSMakeRange(range.location, _priceLabel.text.length-range.location)];
        _priceLabel.attributedText = string;
        [_priceLabel sizeToFit];
    }
    return _priceLabel;
}
- (UIView *)actionContainerView {
    
    if (!_actionContainerView) {
        
        _actionContainerView = [[UIView alloc]init];
        _actionContainerView.backgroundColor = ML_BG_MAIN_COLOR;
        _actionContainerView.layer.borderColor = ML_BG_MAIN_COLOR.CGColor;
        _actionContainerView.layer.borderWidth = 0.5;
    }
    return _actionContainerView;
}
- (UIButton *)serviceBtn {
    
    if (!_serviceBtn) {
        
        _serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_serviceBtn setBackgroundColor:[UIColor clearColor]];
        [_serviceBtn setImage:[UIImage imageNamed:@"42"] forState:UIControlStateNormal];
        [_serviceBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_serviceBtn addTarget:self action:@selector(goToMyServiceCenter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceBtn;
}
- (UIView *)serviceSepLine {
    
    if (!_serviceSepLine) {
        
        _serviceSepLine = [[UIView alloc]init];
        _serviceSepLine.backgroundColor = [UIColor colorWithString:@"#DBDBDB"];
    }
    return _serviceSepLine;
}
- (UILabel *)serviceLabel {
    
    if (!_serviceLabel) {
        
        _serviceLabel = [[UILabel alloc]init];
        _serviceLabel.font = [UIFont systemFontOfSize:14];
        _serviceLabel.text = @"查看客服";
        _serviceLabel.textColor = RGB(66, 62, 62);
    }
    return _serviceLabel;
}
- (UIButton *)buyBtn {
    
    if (!_buyBtn) {
        
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyBtn.backgroundColor = [UIColor lightGrayColor];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buyBtn addTarget:self action:@selector(commitOrder:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.userInteractionEnabled = NO;
    }
    return _buyBtn;
}
- (UIButton *)addCollectionBtn {
    
    if (!_addCollectionBtn) {
        
        _addCollectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addCollectionBtn setTitle:@"移入收藏" forState:UIControlStateNormal];
        [_addCollectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addCollectionBtn setBackgroundColor:[UIColor lightGrayColor]];
        _addCollectionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addCollectionBtn addTarget:self action:@selector(collectionAllSelectGoods) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCollectionBtn;
}
- (UIButton *)deleteBtn {
    
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundColor:RGB(255, 0, 82)];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deleteBtn addTarget:self action:@selector(deleteSelectGoodsFromShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
@end
