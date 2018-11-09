//
//  LGBaseTypeChooseView.m
//  meyley
//
//  Created by Bovin on 2018/10/17.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGBaseTypeChooseView.h"

@interface LGBaseTypeChooseView ()

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation LGBaseTypeChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor colorWithString:@"#DBDBDB"].CGColor;
        self.layer.borderWidth = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeWithdrawType:)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.typeLabel];
        [self addSubview:self.detailLabel];
        [self addSubview:self.rightArrow];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(viewPix(10));
        }];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-viewPix(10));
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(12);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self.rightArrow.mas_left).offset(-viewPix(10));
            make.left.equalTo(self.typeLabel.mas_right);
        }];
    }
    return self;
}
#pragma mark--action---
- (void)changeWithdrawType:(UITapGestureRecognizer *)tap {
    
}
#pragma mark--lazy----
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.textColor = RGB(66, 62, 62);
        _typeLabel.text = @"提现至:";
        [_typeLabel sizeToFit];
    }
    return _typeLabel;
}
- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.textColor = RGB(66, 62, 62);
        _detailLabel.text = @"支付宝";
    }
    return _detailLabel;
}
- (UIImageView *)rightArrow {
    
    if (!_rightArrow) {
        
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"you"]];
    }
    return _rightArrow;
}
@end
