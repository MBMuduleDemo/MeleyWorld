//
//  LGMineMoneyTableCell.m
//  meyley
//
//  Created by Bovin on 2018/9/30.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMineMoneyTableCell.h"

@interface LGMineMoneyTableCell ()

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *rightArrow;
@property (nonatomic, strong) UIView *sepLine;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray *funcsArray;
//存放每种类型的值label
@property (nonatomic, strong) NSMutableArray<UILabel *> *numsViewArray;

@end

@implementation LGMineMoneyTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.funcsArray = @[@{@"unit":@"张",@"title":@"现金券"},@{@"unit":@"个",@"title":@"红包"},@{@"unit":@"分",@"title":@"积分"},@{@"unit":@"元",@"title":@"礼品卡"}];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self.contentView addSubview:self.topBarView];
    [self.topBarView addSubview:self.typeLabel];
    [self.topBarView addSubview:self.detailLabel];
    [self.topBarView addSubview:self.rightArrow];
    [self.contentView addSubview:self.sepLine];
    [self.contentView addSubview:self.containerView];
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(44);
    }];
   
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarView.mas_left).offset(12);
        make.top.equalTo(self.topBarView.mas_top).offset(10);
    }];
    [self.typeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeLabel.mas_centerY);
        make.right.equalTo(self.topBarView.mas_right).offset(-10);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeLabel.mas_centerY);
        make.right.equalTo(self.rightArrow.mas_left).offset(-10);
        make.left.greaterThanOrEqualTo(self.typeLabel.mas_right);
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(44);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(1);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.sepLine.mas_bottom);
    }];
}
#pragma mark--setter--
- (void)setUserMoney:(NSString *)userMoney {
    _userMoney = userMoney;
    self.typeLabel.attributedText = [MBTools typeString:@"现金余额:" typeStringColor:RGB(66, 62, 62) valueString:[NSString stringWithFormat:@"%@ 元",userMoney] valueStringColor:RGB(255, 0, 82)];
}
- (void)setNumbersArray:(NSArray *)numbersArray {
    numbersArray = numbersArray;
    if (!numbersArray.count) {
        return;
    }
    int i = 0;
    for (UILabel *label in self.numsViewArray) {
        NSDictionary *dic = self.funcsArray[i];
        NSString *numStr = [NSString stringWithFormat:@"%@ %@",numbersArray[i],dic[@"unit"]];
        label.text = numStr;
        i++;
    }
}
#pragma mark--action--
//充值与提现
- (void)chargeOrWithdraw {
    if (self.chargeOrWithdrawHandler) {
        self.chargeOrWithdrawHandler();
    }
}
//某一模块
- (void)clickFuncBtn:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    NSDictionary *dic = self.funcsArray[tag];
    if (self.oneModuleDetailHandler) {
        self.oneModuleDetailHandler(dic[@"title"]);
    }
}
#pragma mark--lazy----
- (UIView *)topBarView {
    
    if (!_topBarView) {
        
        _topBarView = [[UIView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chargeOrWithdraw)];
        [_topBarView addGestureRecognizer:tap];
    }
    return _topBarView;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:16];
        _typeLabel.textColor = RGB(66, 62, 62);
        _typeLabel.text = @"现金余额";
    }
    return _typeLabel;
}
- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.textColor = RGB(149, 149, 149);
        _detailLabel.text = @"充值与提现";
    }
    return _detailLabel;
}
- (UIImageView *)rightArrow {
    
    if (!_rightArrow) {
        
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"you"]];
    }
    return _rightArrow;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = ML_BG_MAIN_COLOR;
    }
    return _sepLine;
}
- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc]init];
        for (NSInteger i = 0; i<self.funcsArray.count; i++) {
            CGFloat width = Screen_W/self.funcsArray.count;
            NSDictionary *dic = self.funcsArray[i];
            UIView *funcBgView = [[UIView alloc]initWithFrame:CGRectMake(i*width, 0, width, 60)];
            funcBgView.tag = i;
            [_containerView addSubview:funcBgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFuncBtn:)];
            [funcBgView addGestureRecognizer:tap];
            
            UILabel *unitLabel = [[UILabel alloc]init];
            unitLabel.textColor = RGB(66, 62, 62);
            unitLabel.font = [UIFont boldSystemFontOfSize:15];
            unitLabel.textAlignment = NSTextAlignmentCenter;
            unitLabel.text = dic[@"unit"];
            [funcBgView addSubview:unitLabel];
            [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(funcBgView.mas_centerX);
                make.top.equalTo(funcBgView.mas_top).offset(10);
                make.height.mas_equalTo(20);
            }];
            
            
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.textColor = RGB(66, 62, 62);
            titleLabel.font = [UIFont systemFontOfSize:11];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = dic[@"title"];
            titleLabel.userInteractionEnabled = YES;
            [funcBgView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(funcBgView);
                make.top.equalTo(unitLabel.mas_bottom).offset(10);
            }];
            [self.numsViewArray addObject:unitLabel];
        }
    }
    return _containerView;
}
- (NSMutableArray *)numsViewArray {
    
    if (!_numsViewArray) {
        
        _numsViewArray = [NSMutableArray array];
    }
    return _numsViewArray;
}
@end
