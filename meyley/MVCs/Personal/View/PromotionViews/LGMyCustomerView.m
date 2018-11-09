//
//  LGMyCustomerView.m
//  meyley
//
//  Created by Bovin on 2018/10/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMyCustomerView.h"
#import "LGPromotionHomeModel.h"

@interface LGMyCustomerView ()

//
@property (nonatomic, strong) UIView *containerView;
//分割条
@property (nonatomic, strong) UIView *sepBar;
//存放改变没想值view
@property (nonatomic, strong) NSMutableArray *viewsArray;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LGMyCustomerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.viewsArray = [NSMutableArray arrayWithCapacity:0];
        self.dataArray = @[@{@"typeName":@"已成交订单",@"value":@""},@{@"typeName":@"推荐会员",@"value":@""},@{@"typeName":@"服务会员",@"value":@""}];
        
        [self addSubview:self.containerView];
        [self addSubview:self.sepBar];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(viewPix(72));
        }];
        [self.sepBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.containerView.mas_bottom);
        }];

    }
    return self;
}
#pragma mark--setter-----
- (void)setModel:(LGPromotionHomeModel *)model {
    _model = model;
    int count = 0;
    for (UILabel *label in self.viewsArray) {
        if (count == 0) {
            label.text = model.allOrderNum;
        }else if (count == 1) {
            label.text = model.myInviteUserCount;
        }else {
            label.text = model.myUserCount;
        }
        count++;
    }
}

#pragma mark--action---
- (void)checkDetailInfo:(UITapGestureRecognizer *)tap {
    NSInteger index= tap.view.tag-600;
    if (self.myCustomDetailInfo) {
        self.myCustomDetailInfo(index);
    }
}

#pragma mark--lazy----
- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc]init];
        CGFloat width = Screen_W/self.dataArray.count;
        for (NSInteger i = 0; i<self.dataArray.count; i++) {
            NSDictionary *dic = self.dataArray[i];
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(width*i, 0, width, viewPix(72))];
            bgView.tag = 600+i;
            [_containerView addSubview:bgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkDetailInfo:)];
            [bgView addGestureRecognizer:tap];
            UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewPix(12), width, viewPix(25))];
            valueLabel.text = dic[@"value"];
            valueLabel.textColor = RGB(66, 62, 62);
            valueLabel.textAlignment = NSTextAlignmentCenter;
            valueLabel.font = [UIFont systemFontOfSize:14];
            valueLabel.userInteractionEnabled = YES;
            [bgView addSubview:valueLabel];
    
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(valueLabel.frame), width, viewPix(35))];
            titleLabel.textColor = RGB(66, 62, 62);
            titleLabel.text = dic[@"typeName"];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.userInteractionEnabled = YES;
            [bgView addSubview:titleLabel];
            [self.viewsArray addObject:valueLabel];
        }
    }
    return _containerView;
}
- (UIView *)sepBar {
    
    if (!_sepBar) {
        
        _sepBar = [[UIView alloc]init];
        _sepBar.backgroundColor = ML_BG_MAIN_COLOR;
    }
    return _sepBar;
}
@end
