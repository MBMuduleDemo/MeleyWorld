//
//  LGMyPerformanceView.m
//  meyley
//
//  Created by Bovin on 2018/10/18.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMyPerformanceView.h"
#import "LGPromotionHomeModel.h"

@interface LGMyPerformanceView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *topBarContainer;
//筛选时间
@property (nonatomic, strong) UITextField *textField;
//佣金记录
@property (nonatomic, strong) MBButton *recodeBtn;
//分割线
@property (nonatomic, strong) UIView *sepLine;

//
@property (nonatomic, strong) UIView *containerView;
//分割条
@property (nonatomic, strong) UIView *sepBar;
//存放改变没想值view
@property (nonatomic, strong) NSMutableArray<UILabel *> *viewsArray;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LGMyPerformanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = @[@{@"typeName":@"服务佣金/元",@"value":@""},@{@"typeName":@"奖励积分",@"value":@""},@{@"typeName":@"未结算订单",@"value":@""}];
        [self addSubview:self.topBarContainer];
        [self.topBarContainer addSubview:self.textField];
        [self.topBarContainer addSubview:self.recodeBtn];
        [self addSubview:self.sepLine];
        [self addSubview:self.containerView];
        [self addSubview:self.sepBar];
        [self.topBarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(viewPix(44));
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topBarContainer.mas_centerY);
            make.left.equalTo(self.topBarContainer.mas_left).offset(viewPix(15));
            make.height.mas_equalTo(viewPix(24));
        }];
        [self.recodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topBarContainer.mas_centerY);
            make.right.equalTo(self.topBarContainer.mas_right).offset(-viewPix(15));
        }];
        [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.topBarContainer.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sepLine.mas_bottom);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.sepBar.mas_top);
        }];
        [self.sepBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(viewPix(10));
        }];
    }
    return self;
}
#pragma mark--setter---
- (void)setModel:(LGPromotionHomeModel *)model {
    _model = model;
    int count = 0;
    for (UILabel *label in self.viewsArray) {
        if (count == 0) {
            label.text = model.totalMoney.length?model.totalMoney:@"0";
        }else if (count == 1) {
            label.text = model.totalPoint.length?model.totalPoint:@"0";
        }else {
            label.text = model.unsettledOrderNum;
        }
        count++;
    }
}
#pragma mark--action---
- (void)checkDetailInfo:(UITapGestureRecognizer *)tap {
    if (self.checkMyCommissionRecode) {
        self.checkMyCommissionRecode();
    }
}
//查看佣金记录
- (void)seeMyCommission {
    if (self.checkMyCommissionRecode) {
        self.checkMyCommissionRecode();
    }
}

#pragma mark--lazy----
- (UIView *)topBarContainer {
    
    if (!_topBarContainer) {
        
        _topBarContainer = [[UIView alloc]init];
    }
    return _topBarContainer;
}
- (UITextField *)textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = RGB(66, 62, 62);
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.tintColor = RGB(255, 0, 82);
        _textField.delegate = self;
        _textField.text = @"最近30天";
        _textField.borderStyle = UITextBorderStyleBezel;
    }
    return _textField;
}
- (MBButton *)recodeBtn {
    
    if (!_recodeBtn) {
        
        _recodeBtn = [MBButton buttonWithType:UIButtonTypeCustom];
        [_recodeBtn setTitle:@"佣金记录" forState:UIControlStateNormal];
        [_recodeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _recodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_recodeBtn setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        [_recodeBtn addTarget:self action:@selector(seeMyCommission) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recodeBtn;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = ML_BORDER_COLOR;
    }
    return _sepLine;
}
- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc]init];
        CGFloat space = 20;
        CGFloat width = (Screen_W-80)/self.dataArray.count;
        for (NSInteger i = 0; i<self.dataArray.count; i++) {
            NSDictionary *dic = self.dataArray[i];
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(space+(width+space)*i, 0, width, viewPix(90))];
            bgView.tag = 500+i;
            [_containerView addSubview:bgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkDetailInfo:)];
            [bgView addGestureRecognizer:tap];
            UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewPix(12), width, viewPix(44))];
            valueLabel.backgroundColor = ML_BG_MAIN_COLOR;
            valueLabel.textColor = RGB(66, 62, 62);
            valueLabel.text = dic[@"value"];
            valueLabel.textAlignment = NSTextAlignmentCenter;
            valueLabel.font = [UIFont systemFontOfSize:13];
            [bgView addSubview:valueLabel];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(valueLabel.frame), width, viewPix(35))];
            titleLabel.textColor = RGB(66, 62, 62);
            titleLabel.text = dic[@"typeName"];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:14];
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
- (NSMutableArray *)viewsArray {
    
    if (!_viewsArray) {
        
        _viewsArray = [NSMutableArray array];
    }
    return _viewsArray;
}
@end
