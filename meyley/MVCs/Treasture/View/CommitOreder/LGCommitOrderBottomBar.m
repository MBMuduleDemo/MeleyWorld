//
//  LGCommitOrderBottomBar.m
//  meyley
//
//  Created by Bovin on 2018/9/11.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGCommitOrderBottomBar.h"

@interface LGCommitOrderBottomBar ()

//实际支付费用
@property (nonatomic, strong) UILabel *totalCostLabel;
//提交订单
@property (nonatomic, strong) UIButton *commitOrderBtn;
@property (nonatomic, strong) UIView *sepLine;

@end

@implementation LGCommitOrderBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.sepLine];
        [self addSubview:self.commitOrderBtn];
        [self addSubview:self.totalCostLabel];
        [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        [self.commitOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.mas_equalTo(viewPix(130));
        }];
        [self.totalCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(viewPix(12));
            make.right.equalTo(self.commitOrderBtn.mas_left);
        }];
    }
    return self;
}
#pragma mark--setter---
- (void)setTotalCost:(NSString *)totalCost {
    _totalCost = totalCost;
    self.totalCostLabel.attributedText = [MBTools typeString:@"实付款:" typeStringColor:RGB(149, 149, 149) typeStringFont:[UIFont systemFontOfSize:12] valueString:[NSString stringWithFormat:@"￥%@",totalCost] valueStringColor:RGB(255, 0, 82) valueStringFont:[UIFont systemFontOfSize:14]];
}
#pragma mark--action----
- (void)commitOrder:(UIButton *)sender {
    if (self.CommitOrderBlock) {
        self.CommitOrderBlock();
    }
}
#pragma mark--lazy------
- (UILabel *)totalCostLabel {
    
    if (!_totalCostLabel) {
        
        _totalCostLabel = [[UILabel alloc]init];
        _totalCostLabel.textAlignment = NSTextAlignmentLeft;
        _totalCostLabel.textColor = RGB(149, 149, 149);
        _totalCostLabel.font = [UIFont systemFontOfSize:12];
        _totalCostLabel.text = @"合计：￥500";
    }
    return _totalCostLabel;
}
- (UIButton *)commitOrderBtn {
    
    if (!_commitOrderBtn) {
        
        _commitOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitOrderBtn setBackgroundColor:RGB(255, 0, 82)];
        [_commitOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_commitOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commitOrderBtn addTarget:self action:@selector(commitOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitOrderBtn;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#DBDBDB"];
    }
    return _sepLine;
}
@end
