//
//  LGGoodsDetailDesView.m
//  meyley
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailDesView.h"

@interface LGGoodsDetailDesView()
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UILabel *desLabel;
@property (nonatomic , strong)UIView *lineView;
@end
@implementation LGGoodsDetailDesView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}

-(void)setPackDesc:(NSString *)packDesc{
    _packDesc = packDesc;
    _desLabel.text = packDesc;
}


#pragma mark -- 懒加载
-(void)creatSubView{
    [self addSubview:self.lineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.desLabel];
    
    __weak typeof(self) weakSelf = self;
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf);
        make.height.equalTo(@(1.0));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(viewPix(15));
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_right).offset(viewPix(3));
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).offset(-viewPix(15));
    }];
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(247, 247, 247);
    }
    return _lineView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectZero text:@"说明：" textColor:[UIColor colorWithString:@"333333"] font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _titleLabel;
}

-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [UILabel lableWithFrame:CGRectZero text:@"" textColor:[UIColor colorWithString:@"666666"] font:12 textAlignment:NSTextAlignmentLeft lines:2];
    }
    return _desLabel;
}

@end
