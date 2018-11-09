//
//  LGGoodsDetailTitleView.m
//  meyley
//
//  Created by Bovin on 2018/8/28.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailTitleView.h"


@interface LGGoodsDetailTitleView()

//活动文字
@property (nonatomic , strong)UIButton *activityBtn;
//活动价 -- 销售价
@property (nonatomic , strong)UILabel *priceLabel;
//店铺价
@property (nonatomic , strong)UILabel *shopPriceLabel;
//专柜价
@property (nonatomic , strong)UILabel *markPriceLabel;
//二维码
@property (nonatomic , strong)UIView *scanView;
@property (nonatomic , strong)UILabel *scanLabel;
@property (nonatomic , strong)UIImageView *scanImageView;

@property (nonatomic , assign)BOOL open;

@end

@implementation LGGoodsDetailTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.open = NO;
        [self creatSubView];
    }
    return self;
}

-(void)setScanUrl:(NSString *)scanUrl{
    _scanUrl = scanUrl;
    
    UIImage *image = [self creatScanImageWithURL:scanUrl];
    self.scanImageView.image = image;
//    NSString *imageUrl = scanUrl;
//    imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [self.scanImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
//   NSString *urlStr =@"http://www.meyley.com/production/detail/"+response.getResult().getGoodsId()+"?inviteCode="+getInviteCode();
}

-(void)setActiveStr:(NSString *)activeStr{
    _activeStr = activeStr;
    CGSize size = [activeStr boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:LGFont(10)} context:nil].size;
    [self.activityBtn setTitle:activeStr forState:UIControlStateNormal];
    [self.activityBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width+12*LGPercent));
    }];
    UIImage *image = [UIImage imageNamed:@"bj"];
    CGFloat width = image.size.width/2.0;
    CGFloat height = image.size.height/2.0;
    
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width) resizingMode:UIImageResizingModeStretch];
    [self.activityBtn setBackgroundImage:newImage forState:UIControlStateNormal];
}

-(void)setPriceStr:(NSString *)priceStr{
    _priceStr = priceStr;
    if (priceStr.length>0 && ![priceStr containsString:@"null"]) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",priceStr];
    }else{
        self.priceLabel.text = @"";
    }
    
}

-(void)setMarkPriceStr:(NSString *)markPriceStr{
    _markPriceStr = markPriceStr;
     NSString *price = [NSString stringWithFormat:@"¥%@",markPriceStr];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:price attributes:attribtDic];
    self.markPriceLabel.attributedText = attribtStr;
}

-(void)setShopPrice:(NSString *)shopPrice{
    _shopPrice = shopPrice;
    if (self.priceLabel.text.length>0) {
//        self.shopPriceLabel.textColor = RGB(149, 149, 149);
//        self.shopPriceLabel.font = LGFont(12);
    }else{
        //RGB(255, 0, 82) font:17
//        self.shopPriceLabel.textColor = RGB(255, 0, 82);
//        self.shopPriceLabel.font = LGFont(17);
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",shopPrice];
    }
    
    NSString *price = [NSString stringWithFormat:@"¥%@ /",shopPrice];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:price];
    NSRange range = [price rangeOfString:@"/"];
    [attstr addAttributes:@{NSFontAttributeName:LGFont(12),NSForegroundColorAttributeName:RGB(149, 149, 149)} range:range];
    self.shopPriceLabel.attributedText = attstr;
}

-(void)showBigScanImageView{
    if (self.open == NO) {
        [self.scanView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(viewPix(90)));
            make.height.equalTo(@(viewPix(95)));
        }];
        self.scanLabel.text = @"扫描二维码查看/购买";
    }else{
        [self.scanView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(viewPix(55)));
            make.height.equalTo(@(viewPix(60)));
        }];
        self.scanLabel.text = @"dia击放大";
    }
    self.open = !self.open;
}


-(UIImage *)creatScanImageWithURL:(NSString *)urlStr{
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:viewPix(100)];
    return image;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)creatSubView{
    [self addSubview:self.activityBtn];
    [self addSubview:self.priceLabel];
    [self addSubview:self.shopPriceLabel];
    [self addSubview:self.markPriceLabel];
    [self addSubview:self.scanView];
    [self.scanView addSubview:self.scanLabel];
    [self.scanView addSubview:self.scanImageView];
    __weak typeof(self) weakSelf = self;
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(viewPix(15));
        make.top.equalTo(weakSelf).offset(viewPix(20));
    }];
    
    [self.activityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceLabel).offset(viewPix(3));
        make.left.equalTo(weakSelf.priceLabel.mas_right).offset(viewPix(12));
        make.width.equalTo(@(0));
        make.height.equalTo(@(viewPix(14)));
    }];
    
    [self.shopPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.priceLabel);
        make.top.equalTo(weakSelf.priceLabel.mas_bottom).offset(viewPix(12));
    }];
    
    [self.markPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.shopPriceLabel);
        make.left.equalTo(weakSelf.shopPriceLabel.mas_right).offset(viewPix(5));
    }];
    
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).offset(-viewPix(15));
        make.width.equalTo(@(viewPix(55)));
        make.height.equalTo(@(viewPix(60)));
    }];
    
    [self.scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.scanView);
        make.top.equalTo(weakSelf.scanView).offset(viewPix(3));
        make.width.height.equalTo(self.scanView.mas_width).offset(-viewPix(18));
    }];
    
    [self.scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scanView).offset(viewPix(3));
        make.right.equalTo(weakSelf.scanView).offset(-viewPix(3));
        make.top.equalTo(weakSelf.scanImageView.mas_bottom).offset(viewPix(5));
    }];
}

//促销价：promotePrice 、 商品本店售价：shopPrice  专柜价：marketPrice
-(UIButton *)activityBtn{
    if (!_activityBtn) {
        _activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_activityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_activityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _activityBtn.titleLabel.font = LGFont(10);
        _activityBtn.enabled = NO;
    }
    return _activityBtn;
}

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(255, 0, 82) font:17 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _priceLabel;
}

-(UILabel *)shopPriceLabel{
    if (!_shopPriceLabel) {
        _shopPriceLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(149, 149, 149) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _shopPriceLabel;
}

-(UILabel *)markPriceLabel{
    if (!_markPriceLabel) {
        _markPriceLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(149, 149, 149) font:12 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _markPriceLabel;
}

-(UIView *)scanView{
    if (!_scanView) {
        _scanView = [[UIView alloc]init];
        _scanView.userInteractionEnabled = YES;
        _scanView.layer.borderColor = [UIColor colorWithString:@"666666"].CGColor;
        _scanView.layer.borderWidth = 0.5;
        [_scanView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigScanImageView)]];
    }
    return _scanView;
}

-(UILabel *)scanLabel{
    if (!_scanLabel) {
        _scanLabel = [UILabel lableWithFrame:CGRectZero text:@"点击放大" textColor:[UIColor colorWithString:@"bababa"] font:9 textAlignment:NSTextAlignmentCenter lines:1];
    }
    return _scanLabel;
}

-(UIImageView *)scanImageView{
    if (!_scanImageView) {
        _scanImageView = [[UIImageView alloc]init];
        _scanImageView.userInteractionEnabled = YES;
    }
    return _scanImageView;
}



@end
