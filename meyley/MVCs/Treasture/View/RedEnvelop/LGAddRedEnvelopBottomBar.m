//
//  LGAddRedEnvelopBottomBar.m
//  meyley
//
//  Created by Bovin on 2018/9/15.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGAddRedEnvelopBottomBar.h"

@interface LGAddRedEnvelopBottomBar ()

@property (nonatomic, strong) UIButton *addRedEnvelopBtn;
@end

@implementation LGAddRedEnvelopBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:self.addRedEnvelopBtn];
        [self.addRedEnvelopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(viewPix(40));
            make.right.equalTo(self.mas_right).offset(-viewPix(40));
            make.top.equalTo(self.mas_top).offset(viewPix(10));
            make.bottom.equalTo(self.mas_bottom).offset(-viewPix(10));
        }];
    }
    return self;
}
#pragma mark--action----
//添加红包
- (void)addRedEnvelop {
    if (self.addNewRedEnvelops) {
        self.addNewRedEnvelops();
    }
}
#pragma mark--lazy----
- (UIButton *)addRedEnvelopBtn {
    
    if (!_addRedEnvelopBtn) {
        
        _addRedEnvelopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addRedEnvelopBtn setTitle:@"添加红包" forState:UIControlStateNormal];
        [_addRedEnvelopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addRedEnvelopBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_addRedEnvelopBtn setBackgroundColor:RGB(255, 0, 82)];
        _addRedEnvelopBtn.layer.cornerRadius = 5;
        _addRedEnvelopBtn.layer.masksToBounds = YES;
        [_addRedEnvelopBtn addTarget:self action:@selector(addRedEnvelop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addRedEnvelopBtn;
}
@end
