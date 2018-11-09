//
//  LGBrandCollectionCell.m
//  meyley
//
//  Created by Bovin on 2018/8/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBrandCollectionCell.h"

@interface LGBrandCollectionCell ()

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *englishNameLabel;

@property (nonatomic, strong) UILabel *chineseNameLabel;

@property (nonatomic, strong) UILabel *brandCountryLabel;

@end

@implementation LGBrandCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviewsAndConstraits];
    }
    return self;
}


-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"brandLogo"]]];
    self.englishNameLabel.text = dataDic[@"englishName"];
    self.chineseNameLabel.text = dataDic[@"chineseName"];
    self.brandCountryLabel.text = dataDic[@"countryName"];
    NSString *country = dataDic[@"countryName"];
    CGSize size = [country boundingRectWithSize:CGSizeMake(MAXFLOAT, viewPix(13)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    [self.brandCountryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width+viewPix(10)));
    }];
    
}


- (void)setupSubviewsAndConstraits {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.iconImageView];
    [self.baseView addSubview:self.englishNameLabel];
    [self.baseView addSubview:self.chineseNameLabel];
    [self.baseView addSubview:self.brandCountryLabel];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(viewPix(10));
        make.width.height.equalTo(@(viewPix(50)));
    }];
    [self.englishNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(viewPix(68));
    }];
    [self.chineseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.englishNameLabel.mas_bottom).offset(viewPix(3));
    }];
    [self.brandCountryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.baseView);
        make.width.equalTo(@(viewPix(30)));
        make.height.equalTo(@(viewPix(13)));
        
    }];
}
#pragma mark--lazy------
-(UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc]init];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.layer.borderColor = RGB(234, 234, 234).CGColor;
        _baseView.layer.borderWidth = 1.0;
        _baseView.cornerRidus = 2.0;
    }
    return _baseView;
}

- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"good_list_holder"];
    }
    return _iconImageView;
}

- (UILabel *)englishNameLabel {
    
    if (!_englishNameLabel) {
        
        _englishNameLabel = [[UILabel alloc]init];
        _englishNameLabel.textAlignment = NSTextAlignmentLeft;
        _englishNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _englishNameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _englishNameLabel;
}
- (UILabel *)chineseNameLabel {
    
    if (!_chineseNameLabel) {
        
        _chineseNameLabel = [[UILabel alloc]init];
        _chineseNameLabel.textAlignment = NSTextAlignmentLeft;
        _chineseNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _chineseNameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _chineseNameLabel;
}
- (UILabel *)brandCountryLabel {
    
    if (!_brandCountryLabel) {
        
        _brandCountryLabel = [[UILabel alloc]init];
        _brandCountryLabel.textAlignment = NSTextAlignmentCenter;
        _brandCountryLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _brandCountryLabel.font = [UIFont systemFontOfSize:10];
        _brandCountryLabel.backgroundColor = RGB(153, 153, 153);
    }
    return _brandCountryLabel;
}
@end
