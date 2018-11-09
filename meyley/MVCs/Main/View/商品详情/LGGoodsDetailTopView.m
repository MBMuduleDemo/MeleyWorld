//
//  LGGoodsDetailTopView.m
//  meyley
//
//  Created by Bovin on 2018/8/28.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailTopView.h"
#import "SDCycleScrollView.h"
@interface LGGoodsDetailTopView()<SDCycleScrollViewDelegate>

@property (nonatomic , strong)SDCycleScrollView *bannerView;
//标题
@property (nonatomic , strong)UILabel *titleLabel;
//标题
@property (nonatomic , strong)UILabel *desLabel;

@property (nonatomic , strong)UIView *lineView;

@end

@implementation LGGoodsDetailTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bannerView];
        [self addSubview:self.titleLabel];
        [self.bannerView addSubview:self.desLabel];
        [self addSubview:self.lineView];
        __weak typeof(self)weakSelf = self;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(statusBarHeight);
            make.left.equalTo(weakSelf).offset(viewPix(50));
            make.right.equalTo(weakSelf).offset(-viewPix(50));
            make.height.equalTo(@(viewPix(50)));
        }];
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bannerView).offset(viewPix(50));
            make.right.equalTo(weakSelf.bannerView).offset(-viewPix(50)); make.top.equalTo(weakSelf.bannerView).offset(viewPix(15));
        }];
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"goodsName"]];
    self.desLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"goodsBrief"]];
}

-(void)setImageArry:(NSArray *)imageArry{
    _imageArry = imageArry;
    NSMutableArray *tempArry = [NSMutableArray array];
    for (NSInteger i=0; i<imageArry.count; i++) {
        NSDictionary *dic = imageArry[i];
        NSString *imageUrl = dic[@"thumbUrl"];
        imageUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [tempArry addObject:imageUrl];
    }
    self.bannerView.imageURLStringsGroup = tempArry;
}

-(SDCycleScrollView * )bannerView{
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, statusBarHeight+ viewPix(40), Screen_W, viewPix(320)) delegate:self placeholderImage:nil];
        _bannerView.autoScrollTimeInterval = 3.5;
        _bannerView.autoScroll  = NO;
        _bannerView.infiniteLoop = NO;
        _bannerView.showPageControl = YES;
        _bannerView.backgroundColor = [UIColor whiteColor];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _bannerView.pageControlDotSize = CGSizeMake(viewPix(5), viewPix(5));
        _bannerView.pageControlBottomOffset = viewPix(5);
        _bannerView.currentPageDotImage = [UIImage imageNamed:@"d1"];
        _bannerView.pageDotImage = [UIImage imageNamed:@"d2"];
    }
    return _bannerView ;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(33, 33, 33) font:18 textAlignment:NSTextAlignmentCenter lines:2];
    }
    return _titleLabel;
}
-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [UILabel lableWithFrame:CGRectZero text:nil textColor:RGB(181, 181, 181) font:15 textAlignment:NSTextAlignmentCenter lines:3];
    }
    return _desLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, statusBarHeight+viewPix(360)-1, Screen_W, 1.0)];
        _lineView.backgroundColor = RGB(247, 247, 247);
    }
    return _lineView;
}

@end
