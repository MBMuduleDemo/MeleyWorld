//
//  LGSelectCollectionCell.m
//  meyley
//
//  Created by Bovin on 2018/8/19.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGSelectCollectionCell.h"

@interface LGSelectCollectionCell()



@end

@implementation LGSelectCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.baseBtn];
        __weak typeof(self) weakSelf = self;
        [self.baseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(weakSelf);
        }];
    }
    return self;
}

-(void)setModel:(LGSelectItemModel *)model{
    _model = model;
    if ([model.status isEqualToString:@"N"]) {
        self.baseBtn.selected = NO;
    }else{
        self.baseBtn.selected = YES;
    }
    [self.baseBtn setTitle:model.title forState:UIControlStateNormal];
}

-(UIButton *)baseBtn{
    if (!_baseBtn) {
        _baseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_baseBtn setBackgroundImage:[UIImage imageNamed:@"selNormalBG"] forState:UIControlStateNormal];
        [_baseBtn setBackgroundImage:[UIImage imageNamed:@"selSelectBG"] forState:UIControlStateSelected];
        [_baseBtn setTitleColor:RGB(77, 77, 77) forState:UIControlStateNormal];
        [_baseBtn setTitleColor:[UIColor colorWithString:@"ff0052"] forState:UIControlStateSelected];
        _baseBtn.titleLabel.font = LGFont(12);
        _baseBtn.userInteractionEnabled = NO;
    }
    return _baseBtn;
}

@end
