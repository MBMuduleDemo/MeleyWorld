//
//  LGOrderDetailCostTableCell.m
//  meyley
//
//  Created by Bovin on 2018/10/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderDetailCostTableCell.h"
#import "LGOrderDetailModel.h"

@interface LGOrderDetailCostTableCell ()

@property (nonatomic, strong) UILabel *goodsCostLabel;
@property (nonatomic, strong) UILabel *goodsCostValueLabel;
@property (nonatomic, strong) UILabel *shippFeeLabel;
@property (nonatomic, strong) UILabel *shippFeeValueLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *discountValueLabel;

@property (nonatomic, strong) UILabel *discountDescLabel;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UILabel *orderCreatTimeLabel;
@property (nonatomic, strong) UILabel *orderPriceLabel;

@end

@implementation LGOrderDetailCostTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self.contentView addSubview:self.goodsCostLabel];
    [self.contentView addSubview:self.goodsCostValueLabel];
    [self.contentView addSubview:self.shippFeeLabel];
    [self.contentView addSubview:self.shippFeeValueLabel];
    [self.contentView addSubview:self.discountLabel];
    [self.contentView addSubview:self.discountValueLabel];
    [self.contentView addSubview:self.discountDescLabel];
    [self.contentView addSubview:self.sepLine];
    [self.contentView addSubview:self.orderCreatTimeLabel];
    [self.contentView addSubview:self.orderPriceLabel];
    [self.goodsCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
        make.top.equalTo(self.contentView.mas_top).offset(viewPix(8));
    }];
    [self.goodsCostValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(12));
        make.centerY.equalTo(self.goodsCostLabel.mas_centerY);
    }];
    [self.shippFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
        make.top.equalTo(self.goodsCostLabel.mas_bottom).offset(viewPix(8));
    }];
    [self.shippFeeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsCostValueLabel.mas_right);
        make.centerY.equalTo(self.shippFeeLabel.mas_centerY);
    }];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
        make.top.equalTo(self.shippFeeLabel.mas_bottom).offset(viewPix(8));
    }];
    [self.discountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shippFeeValueLabel.mas_right);
        make.centerY.equalTo(self.discountLabel.mas_centerY);
    }];
    [self.discountDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
        make.right.equalTo(self.discountValueLabel.mas_right);
        make.top.equalTo(self.discountLabel.mas_bottom).offset(viewPix(8));
        make.height.mas_equalTo(viewPix(30));
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.discountDescLabel.mas_bottom).offset(viewPix(8));
        make.height.mas_equalTo(1);
    }];
    [self.orderCreatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
        make.top.equalTo(self.sepLine.mas_bottom).offset(viewPix(5));
    }];
    [self.orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(12));
        make.centerY.equalTo(self.orderCreatTimeLabel.mas_centerY);
    }];
    
}

#pragma mark--setter---
- (void)setDetailModel:(LGOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.goodsCostValueLabel.text = [NSString stringWithFormat:@"￥%@",detailModel.goodsAmount];
    self.shippFeeValueLabel.text = [NSString stringWithFormat:@"+￥%@",detailModel.shippingFee];
    self.discountValueLabel.text = [NSString stringWithFormat:@"-￥%@",@"0"];
    self.discountDescLabel.text = [NSString stringWithFormat:@"优惠 0 折扣 0 红包 0"];
    self.orderCreatTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",[MBTools transFormDateStringFormTimeInterval:detailModel.addTime]];
    self.orderPriceLabel.attributedText = [MBTools typeString:@"实付款:" typeStringColor:RGB(66, 62, 62) valueString:[NSString stringWithFormat:@"￥%@",detailModel.orderAmount] valueStringColor:RGB(255, 0, 82)];
    
}

#pragma mark--lazy-------
- (UILabel *)goodsCostLabel {
    
    if (!_goodsCostLabel) {
        
        _goodsCostLabel = [[UILabel alloc]init];
        _goodsCostLabel.textColor = RGB(66, 62, 62);
        _goodsCostLabel.text = @"商品金额";
        _goodsCostLabel.font = [UIFont systemFontOfSize:15];
        _goodsCostLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsCostLabel;
}
- (UILabel *)goodsCostValueLabel {
    
    if (!_goodsCostValueLabel) {
        
        _goodsCostValueLabel = [[UILabel alloc]init];
        _goodsCostValueLabel.textColor = RGB(255, 0, 82);
        _goodsCostValueLabel.font = [UIFont systemFontOfSize:13];
        _goodsCostValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _goodsCostValueLabel;
}
- (UILabel *)shippFeeLabel {
    
    if (!_shippFeeLabel) {
        
        _shippFeeLabel = [[UILabel alloc]init];
        _shippFeeLabel.textColor = RGB(66, 62, 62);
        _shippFeeLabel.text = @"运费";
        _shippFeeLabel.font = [UIFont systemFontOfSize:15];
        _shippFeeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _shippFeeLabel;
}
- (UILabel *)shippFeeValueLabel {
    
    if (!_shippFeeValueLabel) {
        
        _shippFeeValueLabel = [[UILabel alloc]init];
        _shippFeeValueLabel.textColor = RGB(255, 0, 82);
        _shippFeeValueLabel.font = [UIFont systemFontOfSize:13];
        _shippFeeValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _shippFeeValueLabel;
}
- (UILabel *)discountLabel {
    
    if (!_discountLabel) {
        
        _discountLabel = [[UILabel alloc]init];
        _discountLabel.textColor = RGB(66, 62, 62);
        _discountLabel.text = @"优惠金额";
        _discountLabel.font = [UIFont systemFontOfSize:15];
        _discountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _discountLabel;
}
- (UILabel *)discountValueLabel {
    
    if (!_discountValueLabel) {
        
        _discountValueLabel = [[UILabel alloc]init];
        _discountValueLabel.textColor = RGB(255, 0, 82);
        _discountValueLabel.font = [UIFont systemFontOfSize:13];
        _discountValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _discountValueLabel;
}
- (UILabel *)discountDescLabel {
    
    if (!_discountDescLabel) {
        
        _discountDescLabel = [[UILabel alloc]init];
        _discountDescLabel.textColor = RGB(66, 62, 62);
        _discountDescLabel.font = [UIFont systemFontOfSize:11];
        _discountDescLabel.textAlignment = NSTextAlignmentRight;
        _discountDescLabel.layer.borderWidth = 1;
        _discountDescLabel.layer.borderColor = ML_BG_MAIN_COLOR.CGColor;
    }
    return _discountDescLabel;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = ML_BG_MAIN_COLOR;
    }
    return _sepLine;
}
- (UILabel *)orderCreatTimeLabel {
    
    if (!_orderCreatTimeLabel) {
        
        _orderCreatTimeLabel = [[UILabel alloc]init];
        _orderCreatTimeLabel.textColor = RGB(149, 149, 149);
        _orderCreatTimeLabel.text = @"下单时间:";
        _orderCreatTimeLabel.font = [UIFont systemFontOfSize:13];
        _orderCreatTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderCreatTimeLabel;
}
- (UILabel *)orderPriceLabel {
    
    if (!_orderPriceLabel) {
        
        _orderPriceLabel = [[UILabel alloc]init];
        _orderPriceLabel.textColor = RGB(66, 62, 62);
        _orderPriceLabel.text = @"实付款:";
        _orderPriceLabel.font = [UIFont systemFontOfSize:15];
        _orderPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderPriceLabel;
}
@end
