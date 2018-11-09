//
//  LGOrderStateTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/10/8.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderStateTableViewCell.h"
#import "LGOrderListModel.h"

@interface LGOrderStateTableViewCell ()

@property (nonatomic, strong) UIView *topBarContainer;
@property (nonatomic, strong) UIImageView *brandLogoImageView;
@property (nonatomic, strong) UILabel *brandNameLabel;
@property (nonatomic, strong) UILabel *orderNoLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIView *sepLine;

//商品图片展示
@property (nonatomic, strong) UIImageView *goodsImageView;
//商品名称
@property (nonatomic, strong) UILabel *nameLabel;
//订单状态时间
@property (nonatomic, strong) UILabel *timeLabel;
//商品价格
@property (nonatomic, strong) UILabel *priceLabel;
//商品来源
@property (nonatomic, strong) UILabel *sourceLabel;
//商品数量描述
@property (nonatomic, strong) UILabel *productDescLabel;

@property (nonatomic, strong) UIView *middleSepLine;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation LGOrderStateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    
    [self.contentView addSubview:self.topBarContainer];
    [self.topBarContainer addSubview:self.brandLogoImageView];
    [self.topBarContainer addSubview:self.brandNameLabel];
    [self.topBarContainer addSubview:self.orderNoLabel];
    [self.topBarContainer addSubview:self.stateLabel];
    [self.contentView addSubview:self.sepLine];
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.sourceLabel];
    [self.contentView addSubview:self.productDescLabel];
    [self.contentView addSubview:self.middleSepLine];
    
    [self.contentView addSubview:self.sureBtn];
    [self.contentView addSubview:self.cancelBtn];
    [self.topBarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(viewPix(44));
    }];
    [self.brandLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBarContainer.mas_centerY);
        make.left.equalTo(self.topBarContainer.mas_left).offset(viewPix(12));
        make.width.height.mas_equalTo(viewPix(22));
    }];
    [self.brandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBarContainer.mas_centerY);
        make.left.equalTo(self.brandLogoImageView.mas_right).offset(viewPix(5));
    }];
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBarContainer.mas_centerY);
        make.left.equalTo(self.brandNameLabel.mas_right).offset(viewPix(5));
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBarContainer.mas_centerY);
        make.right.equalTo(self.topBarContainer.mas_right).offset(-viewPix(10));
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.topBarContainer.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
        make.top.equalTo(self.sepLine.mas_bottom).offset(viewPix(5));
        make.width.height.mas_equalTo(viewPix(80));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(viewPix(10));
        make.top.equalTo(self.goodsImageView.mas_top);
        make.width.mas_equalTo(viewPix(100));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(10));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.centerY.equalTo(self.goodsImageView.mas_centerY);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
    }];
    [self.productDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(10));
        make.centerY.equalTo(self.priceLabel.mas_centerY);
    }];
    [self.middleSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(1);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(12));
        make.top.equalTo(self.middleSepLine.mas_bottom).offset(viewPix(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-viewPix(10));
        make.width.mas_equalTo(viewPix(75));
    }];
    
}

#pragma mark--setter---
- (void)setOrderModel:(LGOrderListModel *)orderModel {
    _orderModel = orderModel;
    self.orderNoLabel.attributedText = [MBTools typeString:@"订单号:" typeStringColor:RGB(149, 149, 149) valueString:orderModel.orderSn valueStringColor:RGB(66, 62, 62)];
    self.stateLabel.text = orderModel.orderStatusName;
    self.timeLabel.text = [MBTools transFormDateStringFormTimeInterval:orderModel.addTime];
    LGOrderGoodsListModel *goodModel = orderModel.goodsList[0];
    NSString *imageUrl = [NSString stringWithFormat:@"%@", goodModel.goodsThumb];
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.nameLabel.text = goodModel.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",goodModel.goodsPrice];
    self.productDescLabel.text = [NSString stringWithFormat:@"共计%ld件商品",orderModel.goodsList.count];
    NSInteger status = [orderModel.orderStatus integerValue];
    if (status == 0) {  //待付款
        [self.sureBtn setTitle:@"去付款" forState:UIControlStateNormal];
    }else if (status == 1) {//待发货
        [self.sureBtn setTitle:@"" forState:UIControlStateNormal];
    }else if (status == 2) {//待收货
        [self.sureBtn setTitle:@"去收货" forState:UIControlStateNormal];
    }else if (status == 3) {//待评价
        [self.sureBtn setTitle:@"去评价" forState:UIControlStateNormal];
    }else if (status == 4) {//售后
        [self.sureBtn setTitle:@"退货/售后" forState:UIControlStateNormal];
    }else {
        [self.sureBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    
}

- (void)setCellType:(LGOrderCellType)cellType {
    _cellType = cellType;
    //根据celltype区分展示
    switch (cellType) {
        case LGOrderCellTypeDefault:{
            self.cancelBtn.hidden = YES;
            self.sureBtn.hidden = YES;
        }
            break;
        case LGOrderCellTypeOneAction:{
            self.cancelBtn.hidden = YES;
            self.sureBtn.hidden = NO;
        }
            break;
        case LGOrderCellTypeTwoAction:{
            self.cancelBtn.hidden = NO;
            self.sureBtn.hidden = NO;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark--action--
- (void)sureActionClick:(UIButton *)sender {
    if (self.OrderSureActionHandler) {
        self.OrderSureActionHandler();
    }
}
- (void)cancelActionClick:(UIButton *)cancel {
    if (self.OrderCancelActionHandler) {
        self.OrderCancelActionHandler();
    }
}
#pragma mark--lazy-----
- (UIView *)topBarContainer {
    
    if (!_topBarContainer) {
        
        _topBarContainer = [[UIView alloc]init];
    }
    return _topBarContainer;
}

- (UIImageView *)brandLogoImageView {
    
    if (!_brandLogoImageView) {
        
        _brandLogoImageView = [[UIImageView alloc]init];
    }
    return _brandLogoImageView;
}

- (UILabel *)brandNameLabel {
    
    if (!_brandNameLabel) {
        
        _brandNameLabel = [[UILabel alloc]init];
        _brandNameLabel.font = [UIFont systemFontOfSize:14];
        _brandNameLabel.textColor = RGB(66, 62, 62);
    }
    return _brandNameLabel;
}
- (UILabel *)orderNoLabel {
    
    if (!_orderNoLabel) {
        
        _orderNoLabel = [[UILabel alloc]init];
        _orderNoLabel.textAlignment = NSTextAlignmentLeft;
        _orderNoLabel.textColor = RGB(149, 149, 149);
        _orderNoLabel.font = [UIFont systemFontOfSize:12];
        [_orderNoLabel sizeToFit];
    }
    return _orderNoLabel;
}
- (UILabel *)stateLabel {
    
    if (!_stateLabel) {
        
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.textColor = RGB(255, 0, 82);
        _stateLabel.font = [UIFont systemFontOfSize:13];
        [_stateLabel sizeToFit];
    }
    return _stateLabel;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#DBDBDB"];
    }
    return _sepLine;
}
- (UIImageView *)goodsImageView {
    
    if (!_goodsImageView) {
        
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.image = [UIImage imageNamed:@""];
        _goodsImageView.layer.borderColor = [UIColor colorWithString:@"#DBDBDB"].CGColor;
        _goodsImageView.layer.borderWidth = 1.0;
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goodsImageView;
}
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = RGB(66, 62, 62);
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = RGB(66, 62, 62);
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}
- (UILabel *)priceLabel {
    
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = RGB(255, 0, 82);
        _priceLabel.font = [UIFont systemFontOfSize:14];
    }
    return _priceLabel;
}
- (UILabel *)sourceLabel {
    
    if (!_sourceLabel) {
        
        _sourceLabel = [[UILabel alloc]init];
        _sourceLabel.textAlignment = NSTextAlignmentLeft;
        _sourceLabel.textColor = RGB(149, 149, 149);
        _sourceLabel.font = [UIFont systemFontOfSize:12];
    }
    return _sourceLabel;
}
- (UILabel *)productDescLabel {
    
    if (!_productDescLabel) {
        
        _productDescLabel = [[UILabel alloc]init];
        _productDescLabel.textAlignment = NSTextAlignmentRight;
        _productDescLabel.textColor = RGB(149, 149, 149);
        _productDescLabel.font = [UIFont systemFontOfSize:12];
    }
    return _productDescLabel;
}
- (UIView *)middleSepLine {
    
    if (!_middleSepLine) {
        
        _middleSepLine = [[UIView alloc]init];
        _middleSepLine.backgroundColor = ML_BG_MAIN_COLOR;
    }
    return _middleSepLine;
}
- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitleColor:RGB(255, 0, 82) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureBtn.layer.borderColor = [UIColor colorWithHexString:@"#DE7D82"].CGColor;
        _sureBtn.layer.borderWidth = 0.5;
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureActionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _cancelBtn.layer.borderWidth = 0.5;
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancelActionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end
