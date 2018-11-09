//
//  LGExpressTypeView.m
//  meyley
//
//  Created by Bovin on 2018/9/14.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGExpressTypeView.h"
#import "LGExpressTypeModel.h"
@interface LGExpressTypeView ()

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UIView *expressContainerView;

@property (nonatomic, strong) UILabel *selectLabel;

@end

@implementation LGExpressTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self addSubview:self.indicatorView];
    [self addSubview:self.typeLabel];
    [self addSubview:self.sepLine];
    [self addSubview:self.expressContainerView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.typeLabel.mas_centerY);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(5);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self.indicatorView.mas_right).offset(23);
        make.height.mas_equalTo(44);
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    [self.expressContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sepLine.mas_bottom).offset(14);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-9);
    }];
}
- (void)setExpressArray:(NSMutableArray *)expressArray {
    _expressArray = expressArray;
    [self setupExpressTypeView];
}
- (void)setupExpressTypeView {
    for (NSInteger i = 0; i<self.expressArray.count; i++) {
        LGExpressTypeModel *model = self.expressArray[i];
        CGFloat space = 9;
        CGFloat height = 44;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,(space+height)*i, Screen_W-30, height)];
        label.textColor = RGB(66, 62, 62);
        label.font = [UIFont systemFontOfSize:15];
        label.layer.borderColor = [UIColor colorWithString:@"#DBDBDB"].CGColor;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
        label.userInteractionEnabled = YES;
        label.tag = 1000+i;
        label.text = model.shippingName;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:label.text];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.firstLineHeadIndent = 16;
        [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, label.text.length)];
        label.attributedText = string;
        [self.expressContainerView addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseExpressType:)];
        [label addGestureRecognizer:tap];
        if ([model.shippingStatus intValue] == 0) {
            if (!self.selectLabel) {
                [self chooseExpressType:tap];
            }
        }else {
            label.userInteractionEnabled = NO;
            label.textColor = [UIColor colorWithString:@"#999999"];
        }
    }
}
#pragma mark---acation----------
- (void)chooseExpressType:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    if (self.selectLabel != label) {
        self.selectLabel.layer.borderColor = [UIColor colorWithString:@"#DBDBDB"].CGColor;
        self.selectLabel.textColor = RGB(66, 62, 62);
        label.layer.borderColor = RGB(255, 0, 82).CGColor;
        label.textColor = RGB(255, 0, 82);
    }
    self.selectLabel = label;
    LGExpressTypeModel *model = self.expressArray[label.tag-1000];
    if (self.expressTypeChooseBlock) {
        self.expressTypeChooseBlock(model);
    }
}
#pragma mark--lazy-----
- (UIView *)indicatorView {
    
    if (!_indicatorView) {
        
        _indicatorView = [[UIView alloc]init];
        _indicatorView.backgroundColor = RGB(255, 0, 82);
    }
    return _indicatorView;
}
- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.text = @"配送方式";
        _typeLabel.textColor = RGB(66, 62, 62);
    }
    return _typeLabel;
}
- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithString:@"#DBDBDB"];
    }
    return _sepLine;
}
- (UIView *)expressContainerView {
    
    if (!_expressContainerView) {
        
        _expressContainerView = [[UIView alloc]init];
        _expressContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _expressContainerView;
}
@end
