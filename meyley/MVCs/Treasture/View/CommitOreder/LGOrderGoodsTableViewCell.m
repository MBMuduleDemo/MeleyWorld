//
//  LGOrderGoodsTableViewCell.m
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderGoodsTableViewCell.h"
#import "LGShoppingCartModel.h"

#import "LGOrderListModel.h"

@interface LGOrderGoodsTableViewCell ()

//商品图片展示
@property (nonatomic, strong) UIImageView *goodsImageView;
//商品名称
@property (nonatomic, strong) UILabel *nameLabel;
//价格
@property (nonatomic, strong) UILabel *priceLabel;
//来源
@property (nonatomic, strong) UILabel *sourceLabel;
//商品规格描述
@property (nonatomic, strong) UILabel *skuDesLabel;

@end

@implementation LGOrderGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {

    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.sourceLabel];
    [self.contentView addSubview:self.skuDesLabel];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(viewPix(12));
        make.width.height.mas_equalTo(viewPix(80));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top);
        make.left.equalTo(self.goodsImageView.mas_right).offset(viewPix(15));
        make.right.lessThanOrEqualTo(self.priceLabel.mas_left).offset(-viewPix(40));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(15));
    }];
    [self.priceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(viewPix(12));
    }];
    [self.skuDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.greaterThanOrEqualTo(self.sourceLabel.mas_bottom).offset(viewPix(10));
        make.bottom.equalTo(self.goodsImageView.mas_bottom).offset(-viewPix(5));
    }];
}
#pragma mark--setter----
- (void)setModel:(LGShoppingGoodsModel *)model {
    _model = model;
    NSString *imageUrl = model.goodsThumb;
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRefreshCached];

    self.nameLabel.text = model.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",[model.goodsPrice floatValue]];
    self.sourceLabel.attributedText = [MBTools typeString:@"来源:" typeStringColor:RGB(149, 149, 149) valueString:@"" valueStringColor:RGB(66, 62, 62)];
    self.skuDesLabel.text = [NSString stringWithFormat:@"数量:%@  %@",model.goodsNumber,model.goodsAttrs];
}

- (void)setDetailModel:(LGOrderGoodsListModel *)detailModel {
    _detailModel = detailModel;
    NSString *imageUrl = detailModel.goodsThumb;
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
    
    self.nameLabel.text = detailModel.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",[detailModel.goodsPrice floatValue]];
    self.sourceLabel.attributedText = [MBTools typeString:@"来源:" typeStringColor:RGB(149, 149, 149) valueString:@"" valueStringColor:RGB(66, 62, 62)];
    self.skuDesLabel.text = [NSString stringWithFormat:@"数量:%@  %@",detailModel.goodsNumber,detailModel.goodsAttrs];
}
#pragma mark--lazy------
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
- (UILabel *)skuDesLabel {
    
    if (!_skuDesLabel) {
        
        _skuDesLabel = [[UILabel alloc]init];
        _skuDesLabel.textAlignment = NSTextAlignmentLeft;
        _skuDesLabel.textColor = RGB(149, 149, 149);
        _skuDesLabel.font = [UIFont systemFontOfSize:12];
    }
    return _skuDesLabel;
}
@end
