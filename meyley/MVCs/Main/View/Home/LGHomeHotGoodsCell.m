//
//  LGHomeHotGoodsCell.m
//  meyley
//
//  Created by mac on 2018/8/1.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGHomeHotGoodsCell.h"

@interface LGHomeHotGoodsCell()

@property (nonatomic , strong)UIImageView *goodImageView;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *nowPriceLabel;
@property (nonatomic , strong)UILabel *normalPriceLabel;
@property (nonatomic , strong)UIButton *activeBtn;
@property (nonatomic , strong)UIView *brandView;
@property (nonatomic , strong)UIImageView *brandImageView;
@property (nonatomic , strong)UILabel *brandLabel;
@property (nonatomic , strong)UILabel *brandCountLabel;
@property (nonatomic , strong)UIImageView *tipImageView;

@end

@implementation LGHomeHotGoodsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)]];
        [self creatSubView];
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSString *imageUrl = dataDic[@"goodsThumb"];
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
//    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"goodsThumb"]]]];
    self.titleLabel.text = dataDic[@"goodsName"];
    NSArray *activeArry = dataDic[@"activityLabel"];
    if (activeArry.count>0) {
        self.activeBtn.hidden = NO;
        self.nowPriceLabel.text = [NSString stringWithFormat:@"¥%@",activeArry[0][@"actPrice"]];
        NSString *active = [NSString stringWithFormat:@"%@",activeArry[0][@"activity"]];
        CGSize size = [active boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:LGFont(10)} context:nil].size;
        [self.activeBtn setTitle:active forState:UIControlStateNormal];
        [self.activeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width+12*LGPercent));
        }];
        UIImage *image = [UIImage imageNamed:@"bj"];
        CGFloat width = image.size.width/2.0;
        CGFloat height = image.size.height/2.0;
        
        UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width) resizingMode:UIImageResizingModeStretch];
        [self.activeBtn setBackgroundImage:newImage forState:UIControlStateNormal];
        
    }else{
        self.activeBtn.hidden = YES;
        self.nowPriceLabel.text = [NSString stringWithFormat:@"¥%@",dataDic[@"shopPrice"]];
    }
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",dataDic[@"marketPrice"]] attributes:attribtDic];
    self.normalPriceLabel.attributedText = attribtStr;
 
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"brandLogo"]]];
    self.brandLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"brandName"]];
    self.brandCountLabel.text = [NSString stringWithFormat:@"共%@件商品",dataDic[@"goodsNumOfBrand"]];
    /*
     {
     activityLabel =     (
     {
     actPrice = "898.0";
     activity = "\U4eca\U65e5\U7279\U60e0";
     productId = 978;
     }
     );
     brandId = 126;
     brandLogo = "http://www.meyley.com/upload/logo/2017091310132566511.jpg";
     brandName = "\U540e";
     goodsId = 3216;
     goodsName = "\U4e16 | WHOO\U540e \U6d25\U7387\U4eab\U7ea2\U51dd\U6c34\U4e73\U971c7\U4ef6\U5957\U793c\U76d2\U88c5   323ml";
     goodsNumOfBrand = 43;
     goodsNumber = 200;
     goodsSn = MW3727;
     goodsThumb = "http://106.75.134.13:8080/upload/brand/bd126-Whoo/3216G3.jpg";
     marketPrice = 1800;
     shopPrice = 950;
     siteUrl = "http://www.whoo.com.cn/";
     sortOrder = 50;
     }
     
     */
}



-(void)tapGestureAction:(UITapGestureRecognizer *)sender{
    CGPoint point =  [sender locationInView:self];
    if (CGRectContainsPoint(self.brandView.frame, point)) {
        if ([self.delegate respondsToSelector:@selector(selectHotBrand:)]) {
            [self.delegate selectHotBrand:self.dataDic];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(selectHotGoods:)]) {
            [self.delegate selectHotGoods:self.dataDic];
        }
    }
}


#pragma mark---创建控件
-(void)creatSubView{
    [self addSubview:self.goodImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.nowPriceLabel];
    [self addSubview:self.normalPriceLabel];
    [self addSubview:self.activeBtn];
    [self addSubview:self.brandView];
    [self addSubview:self.lineView];
    [self.brandView addSubview:self.brandImageView];
    [self.brandView addSubview:self.brandLabel];
    [self.brandView addSubview:self.brandCountLabel];
    [self.brandView addSubview:self.tipImageView];
    __weak typeof(self) weakSelf = self;
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(viewPix(15));
        make.left.equalTo(weakSelf).offset(viewPix(20));
        make.width.height.equalTo(@(viewPix(92)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.goodImageView).offset(viewPix(13));
        make.left.equalTo(weakSelf.goodImageView.mas_right).offset(viewPix(20));
        make.right.equalTo(weakSelf).offset(-viewPix(20));
    }];
    
    [self.nowPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.goodImageView).offset(-viewPix(5));
    }];
    
    [self.normalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nowPriceLabel.mas_right).offset(viewPix(15));
        make.bottom.equalTo(weakSelf.nowPriceLabel);
    }];
    
    [self.activeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.normalPriceLabel.mas_right).offset(viewPix(5));
        make.centerY.equalTo(weakSelf.nowPriceLabel);
        make.height.equalTo(@(viewPix(14)));
        make.width.equalTo(@(0.0));
    }];
    
    [self.brandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.goodImageView.mas_bottom).offset(viewPix(12));
        make.left.equalTo(weakSelf).offset(viewPix(20));
        make.right.equalTo(weakSelf).offset(-viewPix(20));
        make.height.equalTo(@(viewPix(40)));
    }];
    
    [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.brandView).offset(viewPix(10));
        make.centerY.equalTo(weakSelf.brandView);
        make.width.height.equalTo(@(viewPix(26)));
    }];
    
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.brandImageView.mas_right).offset(viewPix(10));
        make.centerY.equalTo(weakSelf.brandView);
    }];
    
    [self.brandCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.brandView);
        make.right.equalTo(weakSelf.tipImageView.mas_left).offset(-viewPix(5));
    }];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.brandView);
        make.right.equalTo(weakSelf.brandView).offset(-viewPix(15));
        make.width.equalTo(@(viewPix(6)));
        make.height.equalTo(@(viewPix(10)));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(viewPix(20));
        make.right.equalTo(weakSelf).offset(-viewPix(20));
        make.height.equalTo(@(1.0));
    }];
    
}
-(UIImageView *)goodImageView{
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc]init];
        _goodImageView.contentMode = UIViewContentModeScaleAspectFit;
        _goodImageView.clipsToBounds = YES;
    }
    return _goodImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(34, 34, 34) font:18 textAlignment:NSTextAlignmentLeft lines:2];
    }
    return _titleLabel;
}

-(UILabel *)nowPriceLabel{
    if (!_nowPriceLabel) {
        _nowPriceLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(255, 0, 102) font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _nowPriceLabel;
}

-(UILabel *)normalPriceLabel{
    if (!_normalPriceLabel) {
        _normalPriceLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(102, 102, 102) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _normalPriceLabel;
}

-(UIButton *)activeBtn{
    if (!_activeBtn) {
        _activeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_activeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_activeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _activeBtn.titleLabel.font = LGFont(10);
    }
    return _activeBtn;
}

-(UIView *)brandView{
    if (!_brandView) {
        _brandView = [[UIView alloc]init];
        _brandView.backgroundColor = RGB(245, 245, 245);
        _brandView.cornerRidus = viewPix(20);
    }
    return _brandView;
}

-(UIImageView *)brandImageView{
    if (!_brandImageView) {
        _brandImageView = [[UIImageView alloc]init];
        _brandImageView.cornerRidus = viewPix(13);
        _brandImageView.clipsToBounds = YES;
        _brandImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _brandImageView;
}

-(UILabel *)brandLabel{
    if (!_brandLabel) {
        _brandLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(0, 0, 0) font:13 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _brandLabel;
}

-(UILabel *)brandCountLabel{
    if (!_brandCountLabel) {
        _brandCountLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(93, 92, 90) font:12 textAlignment:NSTextAlignmentRight lines:1];
    }
    return _brandCountLabel;
}

-(UIImageView *)tipImageView{
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"you"]];
    }
    return _tipImageView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(234, 234, 234);
    }
    return _lineView;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
