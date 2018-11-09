//
//  LGShoppingCartGoodsTableCell.m
//  meyley
//
//  Created by Bovin on 2018/8/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGShoppingCartGoodsTableCell.h"
#import "LGShoppingCartModel.h"

@interface LGShoppingCartGoodsTableCell ()

@property (nonatomic, strong) UIButton *selectBtn;
//商品图片展示
@property (nonatomic, strong) UIImageView *goodsImageView;
//商品名称
@property (nonatomic, strong) UILabel *nameLabel;
//价格
@property (nonatomic, strong) UILabel *priceLabel;
//分割线
@property (nonatomic, strong) UIView *sepLine;
//减号
@property (nonatomic, strong) UIButton *reduceBtn;
//商品数量
@property (nonatomic, strong) UITextField *countTextField;
//加号
@property (nonatomic, strong) UIButton *plusBtn;

@end

@implementation LGShoppingCartGoodsTableCell

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
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.reduceBtn];
    [self.contentView addSubview:self.plusBtn];
    [self.contentView addSubview:self.countTextField];
    [self.contentView addSubview:self.sepLine];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left);
        make.width.height.mas_equalTo(viewPix(40));
    }];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.selectBtn.mas_right);
        make.width.height.mas_equalTo(viewPix(80));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top).offset(5);
        make.left.equalTo(self.goodsImageView.mas_right).offset(viewPix(12));
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(25));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.greaterThanOrEqualTo(self.nameLabel.mas_bottom).offset(viewPix(15));
        make.bottom.equalTo(self.goodsImageView.mas_bottom).offset(-viewPix(12));
    }];
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-viewPix(12));
        make.width.height.mas_equalTo(viewPix(25));
    }];
    [self.countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.plusBtn.mas_centerY);
        make.right.equalTo(self.plusBtn.mas_left);
        make.height.mas_equalTo(viewPix(25));
        make.width.mas_equalTo(viewPix(40));
    }];
    [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.plusBtn.mas_centerY);
        make.right.equalTo(self.countTextField.mas_left);
        make.width.height.mas_equalTo(viewPix(25));
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}
#pragma mark--setter------
- (void)setGoodsModel:(LGShoppingGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    NSString *imageUrl = goodsModel.goodsThumb;
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRefreshCached];

    self.nameLabel.text = goodsModel.goodsName.length?goodsModel.goodsName:@"";
    self.priceLabel.attributedText = [MBTools typeString:@"促销价:" typeStringColor:RGB(149, 149, 149) valueString:[NSString stringWithFormat:@"￥%0.2f",[goodsModel.promotePrice floatValue]] valueStringColor:RGB(255, 0, 82)];
    self.countTextField.text = goodsModel.goodsNumber;
    NSInteger currentCount = [goodsModel.goodsNumber integerValue];
    if (currentCount<=1) {
        self.reduceBtn.enabled = NO;
    }else {
        self.reduceBtn.enabled = YES;
    }
    self.selectBtn.selected = goodsModel.isSelected;
}
#pragma mark--action------
- (void)selectGoods:(UIButton *)selectBtn {
    selectBtn.selected =! selectBtn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCurrentGoodsWithIndexPath:)]) {
        [self.delegate selectCurrentGoodsWithIndexPath:self.goodsModel.indexPath];
    }
}
- (void)reduceGoodsCount:(UIButton *)reduceBtn {
    NSInteger newCount = [self.countTextField.text integerValue]-1;
    if (newCount<=1) {
        newCount = 1;
        self.reduceBtn.enabled = NO;
    }
    self.goodsModel.goodsNumber = [NSString stringWithFormat:@"%ld",newCount];
    self.countTextField.text = [NSString stringWithFormat:@"%ld",newCount];
    if (self.delegate && [self.delegate respondsToSelector:@selector(reduceGoodsCountFinishWithIndexPath:)]) {
        [self.delegate reduceGoodsCountFinishWithIndexPath:self.goodsModel.indexPath];
    }
}
- (void)addGoodsCount:(UIButton *)plusBtn {
    NSInteger newCount = [self.countTextField.text integerValue]+1;
    if (newCount>1) {
        self.reduceBtn.enabled = YES;
    }
    self.goodsModel.goodsNumber = [NSString stringWithFormat:@"%ld",newCount];
    self.countTextField.text = [NSString stringWithFormat:@"%ld",newCount];
    if (self.delegate && [self.delegate respondsToSelector:@selector(addGoodsCountFinishWithIndexPath:)]) {
        [self.delegate addGoodsCountFinishWithIndexPath:self.goodsModel.indexPath];
    }
}
- (void)valueDidChange:(UITextField *)textField {
    NSInteger newCount = [self.countTextField.text integerValue];
    if (newCount<=1) {
        self.reduceBtn.enabled = NO;
    }else {
        self.reduceBtn.enabled = YES;
    }
    if (newCount<1) {
        [TooltipView showMessage:@"商品数量不能小于1" offset:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.countTextField.text = self.goodsModel.goodsNumber;
        });
    }else {
        self.goodsModel.goodsNumber = [NSString stringWithFormat:@"%ld",newCount];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editGoodsCountWithTextField:atIndexPath:)]) {
        [self.delegate editGoodsCountWithTextField:textField atIndexPath:self.goodsModel.indexPath];
    }
}

#pragma mark--lazy-----
- (UIButton *)selectBtn {
    
    if (!_selectBtn) {
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"x2"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"x1"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (UIImageView *)goodsImageView {
    
    if (!_goodsImageView) {
        
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.image = [UIImage imageNamed:@""];
        _goodsImageView.layer.borderColor = [UIColor colorWithString:@"#DBDBDB"].CGColor;
        _goodsImageView.layer.borderWidth = 1.0;
    }
    return _goodsImageView;
}
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
- (UILabel *)priceLabel {
    
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = RGB(255, 0, 82);
        _priceLabel.font = [UIFont systemFontOfSize:12];
    }
    return _priceLabel;
}

- (UIButton *)reduceBtn {
    
    if (!_reduceBtn) {
        
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceBtn setImage:[UIImage imageNamed:@"minutes_enable"] forState:UIControlStateNormal];
        [_reduceBtn setImage:[UIImage imageNamed:@"minute_disable"] forState:UIControlStateDisabled];
        _reduceBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _reduceBtn.layer.borderWidth = 0.5;
        [_reduceBtn addTarget:self action:@selector(reduceGoodsCount:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}

- (UITextField *)countTextField {
    
    if (!_countTextField) {
        
        _countTextField = [[UITextField alloc]init];
        _countTextField.borderStyle = UITextBorderStyleNone;
        _countTextField.textAlignment = NSTextAlignmentCenter;
        _countTextField.font = [UIFont systemFontOfSize:12];
        _countTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _countTextField.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _countTextField.layer.borderWidth = 0.5;
        _countTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_countTextField addTarget:self action:@selector(valueDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _countTextField;
}
- (UIButton *)plusBtn {
    
    if (!_plusBtn) {
        
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusBtn setImage:[UIImage imageNamed:@"add_enable"] forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"add_disable"] forState:UIControlStateDisabled];
        _plusBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _plusBtn.layer.borderWidth = 0.5;
        [_plusBtn addTarget:self action:@selector(addGoodsCount:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}

- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#DBDBDB"];
    }
    return _sepLine;
}
@end
