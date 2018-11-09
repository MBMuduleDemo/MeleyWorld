//
//  LGChildCategoryReusableView.m
//  meyley
//
//  Created by Bovin on 2018/8/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGChildCategoryReusableView.h"

@interface LGChildCategoryReusableView ()

@property (nonatomic, strong) UIView *redDot;

@property (nonatomic, strong) UILabel *childCategoryTitleLabel;
@end

@implementation LGChildCategoryReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipToSecondCategory:)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = ML_BG_MAIN_COLOR;
        [self addSubview:self.redDot];
        [self addSubview:self.childCategoryTitleLabel];
        [self.childCategoryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(viewPix(28));
            make.left.equalTo(self.redDot.mas_right).offset(viewPix(7));
            make.bottom.equalTo(self.mas_bottom).offset(-viewPix(13));
            make.right.equalTo(self.mas_right).offset(-viewPix(14));
        }];
        [self.redDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(viewPix(11));
            make.centerY.equalTo(self.childCategoryTitleLabel.mas_centerY);
            make.width.height.mas_equalTo(4);
        }];
    }
    return self;
}

-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    self.childCategoryTitleLabel.text = titleText;
}
#pragma mark--action----
- (void)skipToSecondCategory:(UITapGestureRecognizer *)tap {
    if (self.secondCategoryHeaderAction) {
        self.secondCategoryHeaderAction();
    }
}
#pragma mark---lazy---
- (UILabel *)childCategoryTitleLabel {
    
    if (!_childCategoryTitleLabel) {
        
        _childCategoryTitleLabel = [[UILabel alloc]init];
        _childCategoryTitleLabel.textAlignment = NSTextAlignmentLeft;
        _childCategoryTitleLabel.textColor = [UIColor colorWithHexString:@"#8d8d8d"];
        _childCategoryTitleLabel.font = LGFont(14);
    }
    return _childCategoryTitleLabel;
}
- (UIView *)redDot {
    
    if (!_redDot) {
        
        _redDot = [[UIView alloc]init];
        _redDot.backgroundColor = RGB(255, 0, 82);
    }
    return _redDot;
}
@end
