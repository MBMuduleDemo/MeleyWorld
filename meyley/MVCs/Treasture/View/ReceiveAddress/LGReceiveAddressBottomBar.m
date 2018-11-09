//
//  LGReceiveAddressBottomBar.m
//  meyley
//
//  Created by Bovin on 2018/9/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGReceiveAddressBottomBar.h"

@interface LGReceiveAddressBottomBar ()

@property (nonatomic, strong) UIButton *addAddressBtn;

@end

@implementation LGReceiveAddressBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:self.addAddressBtn];
        [self.addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(viewPix(40));
            make.right.equalTo(self.mas_right).offset(-viewPix(40));
            make.top.equalTo(self.mas_top).offset(viewPix(10));
            make.bottom.equalTo(self.mas_bottom).offset(-viewPix(10));
        }];
    }
    return self;
}
#pragma mark--action---
- (void)addNewReceivingAddress {
    if (self.addNewReceiveAddress) {
        self.addNewReceiveAddress();
    }
}
#pragma mark--lazy----
- (UIButton *)addAddressBtn {
    
    if (!_addAddressBtn) {
        
        _addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addAddressBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
        [_addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addAddressBtn setImage:[UIImage imageNamed:@"add_new_address"] forState:UIControlStateNormal];
        [_addAddressBtn setImage:[UIImage imageNamed:@"add_new_address"] forState:UIControlStateHighlighted];
        [_addAddressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        _addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_addAddressBtn setBackgroundColor:RGB(255, 0, 82)];
        _addAddressBtn.layer.cornerRadius = 5;
        _addAddressBtn.layer.masksToBounds = YES;
        [_addAddressBtn addTarget:self action:@selector(addNewReceivingAddress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressBtn;
}
@end
