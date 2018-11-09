//
//  LGGoodsDetailParamView.m
//  meyley
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailParamView.h"
#import "LGGoodsCategoryModel.h"
#define  labelHeight     viewPix(20)
#define  color  RGB(66, 66, 66)
@interface LGGoodsDetailParamView()

@property (nonatomic , strong)UILabel *categoryTitle;
@property (nonatomic , strong)UIView *categoryView;
@property (nonatomic , strong)UILabel *packLabel;
@property (nonatomic , strong)UILabel *salesLabel;

@end

@implementation LGGoodsDetailParamView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}

-(void)setCategoryArry:(NSArray *)categoryArry{
    _categoryArry = categoryArry;
    if (self.categoryView.subviews.count>0) {
        for (UILabel *label in self.categoryView.subviews) {
            [label removeFromSuperview];
        }
    }
    
    for (NSInteger i=0; i<categoryArry.count; i++) {
        LGGoodsCategoryModel *model = categoryArry[i];
        NSString *tempStr = [NSString stringWithFormat:@"%@:",model.attrName];
        NSArray *tempArry = model.attrValues;
        for (NSDictionary *valueDic in tempArry) {
            tempStr = [NSString stringWithFormat:@"%@ %@",tempStr,valueDic[@"attrValue"]];
        }
        UILabel *label = [UILabel lableWithFrame:CGRectMake(viewPix(15), labelHeight*i, Screen_W-viewPix(45), labelHeight) text:tempStr textColor:color font:13 textAlignment:NSTextAlignmentLeft lines:1];
        [self.categoryView addSubview:label];
    }
    [self.categoryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(labelHeight*categoryArry.count));
    }];
}

-(void)setPackDes:(NSString *)packDes{
    _packDes = packDes;
    self.packLabel.text = [NSString stringWithFormat:@"包装说明：%@",packDes];
}

-(void)setSalesDes:(NSString *)salesDes{
    _salesDes = salesDes;
    self.salesLabel.text = [NSString stringWithFormat:@"售后说明：%@",salesDes];
}


#pragma mark -- 懒加载
-(void)creatSubView{
    [self addSubview:self.categoryTitle];
    [self addSubview:self.categoryView];
    [self addSubview:self.packLabel];
    [self addSubview:self.salesLabel];
    __weak typeof(self) weakSelf = self;
    [self.categoryTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf).offset(viewPix(15));
    }];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.categoryTitle);
        make.right.equalTo(weakSelf).offset(-viewPix(15));
        make.top.equalTo(weakSelf.categoryTitle.mas_bottom).offset(viewPix(5));
        make.height.equalTo(@(0));
    }];
    
    [self.packLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.categoryTitle);
        make.top.equalTo(weakSelf.categoryView.mas_bottom).offset(viewPix(5));
        make.right.equalTo(weakSelf).offset(-viewPix(15));
    }];
    
    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.packLabel);
        make.top.equalTo(weakSelf.packLabel.mas_bottom).offset(viewPix(5));
    }];
}

-(UILabel *)categoryTitle{
    if (!_categoryTitle) {
        _categoryTitle = [UILabel lableWithFrame:CGRectZero text:@"参数：" textColor:color font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _categoryTitle;
}

-(UIView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[UIView alloc]init];
    }
    return _categoryView;
}

-(UILabel *)packLabel{
    if (!_packLabel) {
        _packLabel = [UILabel lableWithFrame:CGRectZero text:@"包装说明：" textColor:color font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _packLabel;
}

-(UILabel *)salesLabel{
    if (!_salesLabel) {
        _salesLabel = [UILabel lableWithFrame:CGRectZero text:@"售后说明：" textColor:color font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _salesLabel;
}

@end
