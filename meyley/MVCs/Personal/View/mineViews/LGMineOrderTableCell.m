//
//  LGMineOrderTableCell.m
//  meyley
//
//  Created by Bovin on 2018/9/30.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGMineOrderTableCell.h"
#import "DFCornerNumView.h"


@interface LGMineOrderTableCell ()


@property (nonatomic, strong) UIView *topBarView;

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *rightArrow;

@property (nonatomic, strong) UIView *sepLine;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray *funcsArray;
@property (nonatomic, strong) NSMutableArray *cornerViewsArray;

@end

@implementation LGMineOrderTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.funcsArray = @[@{@"icon":@"wait_pay",@"title":@"待付款"},@{@"icon":@"wait_receive",@"title":@"待收货"},@{@"icon":@"wait_comment",@"title":@"待评价"},@{@"icon":@"returning_icon",@"title":@"退货/售后"}];
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
        make.top.equalTo(self.topBarView.mas_top).offset(11);
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
- (void)setUnreadNumberArray:(NSArray *)unreadNumberArray {
    _unreadNumberArray = unreadNumberArray;
    if (!unreadNumberArray.count) {
        return;
    }
    int i = 0;
    for (DFCornerNumView *view in self.cornerViewsArray) {
        NSString *numStr = [NSString stringWithFormat:@"%@",unreadNumberArray[i]];
        if ([numStr isEqualToString:@"0"]) {
            
            view.shouldNumHidden = YES;
        }else{
            view.shouldNumHidden = NO;
            view.unreadNumStr = numStr;
        }
        i++;
    }
}
#pragma mark--action--
//进入我的订单
- (void)allOrderState {
    if (self.OrderCenterHandler) {
        self.OrderCenterHandler();
    }
}
//具体状态订单
- (void)clickFuncBtn:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    NSDictionary *dic = self.funcsArray[tag];
    if (self.OrderStateDetailHandler) {
        self.OrderStateDetailHandler(dic[@"title"]);
    }
}
#pragma mark--lazy----
- (UIView *)topBarView {
    
    if (!_topBarView) {
        
        _topBarView = [[UIView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allOrderState)];
        [_topBarView addGestureRecognizer:tap];
    }
    return _topBarView;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:16];
        _typeLabel.textColor = RGB(66, 62, 62);
        _typeLabel.text = @"我的订单";
    }
    return _typeLabel;
}
- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.textColor = RGB(149, 149, 149);
        _detailLabel.text = @"查看全部订单";
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
            
            DFCornerNumView *cornerNumView = [DFCornerNumView instanceCornerNumView];
            cornerNumView.userInteractionEnabled = NO;
            cornerNumView.shouldNumHidden = YES;
            cornerNumView.imgName = dic[@"icon"];
            [funcBgView addSubview:cornerNumView];
            [cornerNumView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(funcBgView.mas_centerX);
                make.top.equalTo(funcBgView.mas_top).offset(10);
                make.width.height.mas_equalTo(20);
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
                make.top.equalTo(cornerNumView.mas_bottom).offset(10);
            }];
            [self.cornerViewsArray addObject:cornerNumView];
        }
    }
    return _containerView;
}
- (NSMutableArray *)cornerViewsArray {
    
    if (!_cornerViewsArray) {
        
        _cornerViewsArray = [NSMutableArray array];
    }
    return _cornerViewsArray;
}
@end
