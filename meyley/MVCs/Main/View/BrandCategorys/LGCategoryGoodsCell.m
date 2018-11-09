//
//  LGCategoryGoodsCell.m
//  meyley
//
//  Created by Bovin on 2018/8/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGCategoryGoodsCell.h"
@interface LGCategoryGoodsCell()
@property (nonatomic , strong)UIImageView  *goodImageView;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *nowPriceLabel;
@property (nonatomic , strong)UILabel *markPriceLabel;
@property (nonatomic , strong)UIButton  *activeBtn;
@property (nonatomic , strong)UIView  *lineView;

@end
@implementation LGCategoryGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubView];
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSString *imageUrl = dataDic[@"goodsThumb"];
    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
    
    self.titleLabel.text = dataDic[@"goodsName"];
    NSArray *activeArry = dataDic[@"activityLabel"];
    NSString *price = [NSString stringWithFormat:@"¥%@",dataDic[@"shopPrice"]];
    if (activeArry.count>0) {
        self.activeBtn.hidden = NO;
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
        price = [NSString stringWithFormat:@"¥%@",activeArry[0][@"actPrice"]];
        
    }else{
        self.activeBtn.hidden = YES;
    }
    
    NSMutableAttributedString *attPrice = [[NSMutableAttributedString alloc]initWithString:price];
    NSRange range = [price rangeOfString:@"¥"];
    [attPrice addAttribute:NSFontAttributeName value:LGFont(13) range:range];
    self.nowPriceLabel.attributedText = attPrice;
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",dataDic[@"marketPrice"]] attributes:attribtDic];
    self.markPriceLabel.attributedText = attribtStr;
    
    
}

#pragma mark---懒加载
-(void)creatSubView{
    [self addSubview:self.goodImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.nowPriceLabel];
    [self addSubview:self.markPriceLabel];
    [self addSubview:self.activeBtn];
    [self addSubview:self.lineView];
    __weak typeof(self) weakSelf = self;
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(viewPix(20));
        make.top.equalTo(weakSelf).offset(viewPix(15));
        make.bottom.equalTo(weakSelf).offset(-viewPix(15));
        make.width.equalTo(@(viewPix(80)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.goodImageView).offset(viewPix(7));
        make.left.equalTo(weakSelf.goodImageView.mas_right).offset(viewPix(20));
        make.right.equalTo(weakSelf).offset(-viewPix(20));
    }];
    
    [self.nowPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.goodImageView).offset(-viewPix(5));
    }];
    
    [self.markPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.nowPriceLabel);
        make.left.equalTo(weakSelf.nowPriceLabel.mas_right).offset(viewPix(12));
    }];
    [self.activeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.markPriceLabel);
        make.left.equalTo(weakSelf.markPriceLabel.mas_right).offset(viewPix(6));
        make.height.equalTo(@(viewPix(14)));
        make.width.equalTo(@(0.0));
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
        _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodImageView.clipsToBounds = YES;
    }
    return _goodImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(51, 51, 51) font:18 textAlignment:NSTextAlignmentLeft lines:2];
    }
    return _titleLabel;
}



-(UILabel *)nowPriceLabel{
    if (!_nowPriceLabel) {
        _nowPriceLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(255, 0, 102) font:16 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _nowPriceLabel;
}

-(UILabel *)markPriceLabel{
    if (!_markPriceLabel) {
        _markPriceLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(153, 153, 153) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _markPriceLabel;
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

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(234, 234, 234);
    }
    return _lineView;
}


@end
