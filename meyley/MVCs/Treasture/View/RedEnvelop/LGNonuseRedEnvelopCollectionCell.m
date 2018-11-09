//
//  LGNonuseRedEnvelopCollectionCell.m
//  meyley
//
//  Created by Bovin on 2018/9/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGNonuseRedEnvelopCollectionCell.h"

@interface LGNonuseRedEnvelopCollectionCell ()

//不使用红包
@property (nonatomic, strong) UILabel *typeLabel;
//选中指示框
@property (nonatomic, strong) UIButton *indicatorBtn;

@end

@implementation LGNonuseRedEnvelopCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.indicatorBtn];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(viewPix(15));
            
        }];
        [self.indicatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(viewPix(44));
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.indicatorBtn.selected = selected;
}
#pragma mark--lazy------
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:15];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.text = @"不使用红包";
        _typeLabel.textColor = RGB(66, 62, 62);
    }
    return _typeLabel;
}
- (UIButton *)indicatorBtn {
    
    if (!_indicatorBtn) {
        
        _indicatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_indicatorBtn setImage:[UIImage imageNamed:@"x2"] forState:UIControlStateNormal];
        [_indicatorBtn setImage:[UIImage imageNamed:@"x1"] forState:UIControlStateSelected];
        _indicatorBtn.userInteractionEnabled = NO;
    }
    return _indicatorBtn;
}
@end
