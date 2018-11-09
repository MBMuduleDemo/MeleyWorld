//
//  LGTopIndicatorBar.m
//  meyley
//
//  Created by Bovin on 2018/10/23.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGTopIndicatorBar.h"

@interface LGTopIndicatorBar ()

@property (nonatomic, strong) UILabel *topBar;

@end

@implementation LGTopIndicatorBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ML_DISABLE_COLOR;
        [self addSubview:self.topBar];
        [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.left.equalTo(self.mas_left).offset(viewPix(10));
        }];
        self.currentType = @"";
    }
    return self;
}

#pragma mark--setter---
- (void)setCurrentType:(NSString *)currentType {
    _currentType = currentType;
    NSRange range;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.topBar.text];
    if (!currentType || !currentType.length) {
        range = [self.topBar.text rangeOfString:@"查看协议/提交申请"];
    }else {
        range = [self.topBar.text rangeOfString:currentType];
    }
    [str addAttribute:NSForegroundColorAttributeName value:RGB(66, 62, 62) range:range];
    self.topBar.attributedText = str;
}
#pragma mark--lazy------
- (UILabel *)topBar {
    
    if (!_topBar) {
        
        _topBar = [[UILabel alloc]init];
        _topBar.backgroundColor = [UIColor clearColor];
        _topBar.text = @"加盟流程:查看协议/提交申请>平台审核>支付费用>加盟成功";
        _topBar.font = [UIFont systemFontOfSize:11];
        _topBar.textColor = RGB(149, 149, 149);
    }
    return _topBar;
}
@end
