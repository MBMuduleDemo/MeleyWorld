//
//  LGActiveGoodsCell.m
//  meyley
//
//  Created by mac on 2018/8/6.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGActiveGoodsCell.h"
@interface LGActiveGoodsCell()
@property (nonatomic , strong)UIView *baseView;
@property (nonatomic , strong)UIImageView *imageView;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *priceLabel;
@property (nonatomic , strong)UIView *lineView;
@end

@implementation LGActiveGoodsCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(245, 245, 245);
        [self creatSubView];
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSString *imageUrl = dataDic[@"goodsThumb"];
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"goodsThumb"]]]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"goodsName"]];
    NSString *price = [NSString stringWithFormat:@"活动价：¥%@",dataDic[@"activityPrice"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:price];
    [attStr addAttribute:NSFontAttributeName value:LGFont(12) range:[price rangeOfString:@"活动价："]];
    self.priceLabel.attributedText = attStr;
}

#pragma mark---创建控件
-(void)creatSubView{
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.imageView];
    [self.baseView addSubview:self.lineView];
    [self.baseView addSubview:self.titleLabel];
    [self.baseView addSubview:self.priceLabel];
    __weak typeof(self) weakSelf = self;
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(viewPix(10));
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.baseView).offset(viewPix(10));
        make.right.equalTo(weakSelf.baseView).offset(-viewPix(10));
        make.height.equalTo(@(viewPix(158)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.baseView);
        make.top.equalTo(weakSelf.imageView.mas_bottom).offset(viewPix(10));
        make.height.equalTo(@(1.0));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(viewPix(12));
        make.left.equalTo(weakSelf.baseView).offset(viewPix(15));
        make.right.equalTo(weakSelf.baseView).offset(-viewPix(15));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(viewPix(10));
    }];
}

-(UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc]init];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(234, 234, 234);
    }
    return _lineView;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.cornerRidus = 10.0;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(66, 62, 62) font:14 textAlignment:NSTextAlignmentLeft lines:2];
    }
    return _titleLabel;
}

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lableWithFrame:CGRectZero text:@"活动价：" textColor:RGB(255, 0, 82) font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _priceLabel;
}


@end
