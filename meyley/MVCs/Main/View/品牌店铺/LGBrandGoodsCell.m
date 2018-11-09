//
//  LGBrandGoodsCell.m
//  meyley
//
//  Created by Bovin on 2018/8/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBrandGoodsCell.h"
@interface LGBrandGoodsCell()
@property (nonatomic , strong)UIView *baseView;
@property (nonatomic , strong)UIImageView *imageView;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *priceLabel;
@property (nonatomic , strong)UILabel *promotPriceLabel;
@property (nonatomic , strong)UIButton *activeBtn;
@property (nonatomic , strong)UIView *lineView;
@property (nonatomic , copy)NSString *activeStr;
@end
@implementation LGBrandGoodsCell

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
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",dataDic[@"shopPrice"]];
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:price attributes:attribtDic];
//    self.markPriceLabel.attributedText = attribtStr;
}

-(void)setActiveStr:(NSString *)activeStr{
    _activeStr = activeStr;
    CGSize size = [activeStr boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:LGFont(10)} context:nil].size;
    [self.activeBtn setTitle:activeStr forState:UIControlStateNormal];
    [self.activeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width+12*LGPercent));
    }];
    UIImage *image = [UIImage imageNamed:@"bj"];
    CGFloat width = image.size.width/2.0;
    CGFloat height = image.size.height/2.0;
    
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width) resizingMode:UIImageResizingModeStretch];
    [self.activeBtn setBackgroundImage:newImage forState:UIControlStateNormal];
}

#pragma mark---创建控件
-(void)creatSubView{
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.imageView];
    [self.baseView addSubview:self.lineView];
    [self.baseView addSubview:self.titleLabel];
    [self.baseView addSubview:self.priceLabel];
    [self.baseView addSubview:self.promotPriceLabel];
    [self.baseView addSubview:self.activeBtn];
    __weak typeof(self) weakSelf = self;
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(viewPix(10));
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.baseView).offset(viewPix(10));
        make.left.equalTo(weakSelf.baseView).offset(viewPix(12));
        make.right.equalTo(weakSelf.baseView).offset(-viewPix(12));
        make.height.equalTo(@(viewPix(140)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.baseView);
        make.top.equalTo(weakSelf.imageView.mas_bottom).offset(viewPix(10));
        make.height.equalTo(@(1.0));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(viewPix(10));
        make.left.equalTo(weakSelf.baseView).offset(viewPix(15));
        make.right.equalTo(weakSelf.baseView).offset(-viewPix(15));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(viewPix(8));
    }];
    
    [self.promotPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.priceLabel);
        make.left.equalTo(weakSelf.priceLabel.mas_right).offset(viewPix(20));
    }];
    
    [self.activeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceLabel).offset(viewPix(3));
        make.left.equalTo(weakSelf.priceLabel.mas_right).offset(viewPix(12));
        make.width.equalTo(@(0));
        make.height.equalTo(@(viewPix(14)));
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

-(UILabel *)promotPriceLabel{
    if (!_promotPriceLabel) {
        _promotPriceLabel = [UILabel lableWithFrame:CGRectZero text:@"" textColor:RGB(149, 149, 149) font:13 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _promotPriceLabel;
}

-(UIButton *)activeBtn{
    if (!_activeBtn) {
        _activeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_activeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_activeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _activeBtn.titleLabel.font = LGFont(10);
        _activeBtn.enabled = NO;
    }
    return _activeBtn;
}


@end
