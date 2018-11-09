//
//  LGOrderPayView.m
//  meyley
//
//  Created by Bovin on 2018/9/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGOrderPayView.h"


@interface LGOrderPayView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIView *showMoney;
@property (nonatomic, strong) UILabel *orderPriceLabel;
@property (nonatomic, strong) UIButton *useBlanceBtn;

@property (nonatomic, strong) UIView *blanceContainerView;
@property (nonatomic, strong) UILabel *allBlanceLabel;
@property (nonatomic, strong) UILabel *useBlanceLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;

//使用余额支付部分金额
@property (nonatomic, strong) UIView *blancePaySuccessView;
@property (nonatomic, strong) UILabel *surplusOrderPriceLabel;

@property (nonatomic, strong) UIView *payContainerView;
@property (nonatomic, strong) UIButton *endPayBtn;
@property (nonatomic, strong) UIButton *goHomeBtn;

@property (nonatomic, strong) UIView *orderPayFinishView;

@property (nonatomic, strong) NSArray *payArray;



@end

@implementation LGOrderPayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ML_BG_MAIN_COLOR;
        self.payArray = @[@{@"logo":@"weixin",@"payName":@"微信支付",@"payDesc":@"微信安全支付"},@{@"logo":@"zhifubao",@"payName":@"支付宝支付",@"payDesc":@"支付宝安全支付"}];
        
        [self addSubview:self.topBar];
        [self.topBar addSubview:self.nameLabel];
        [self.topBar addSubview:self.closeBtn];
        [self addSubview:self.showMoney];
        [self.showMoney addSubview:self.orderPriceLabel];
        [self.showMoney addSubview:self.useBlanceBtn];
        
        [self addSubview:self.blanceContainerView];
        [self.blanceContainerView addSubview:self.allBlanceLabel];
        [self.blanceContainerView addSubview:self.useBlanceLabel];
        [self.blanceContainerView addSubview:self.textField];
        [self.blanceContainerView addSubview:self.unitLabel];
        [self.blanceContainerView addSubview:self.sepLine];
        [self.blanceContainerView addSubview:self.cancelBtn];
        [self.blanceContainerView addSubview:self.sureBtn];
        
        [self addSubview:self.blancePaySuccessView];
        [self.blancePaySuccessView addSubview:self.surplusOrderPriceLabel];
        
        [self addSubview:self.payContainerView];
        [self addSubview:self.endPayBtn];
        [self addSubview:self.goHomeBtn];
        
        
        [self setupConstraints];
    }
    return self;
}
- (void)setupConstraints {
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBar.mas_left).offset(15);
        make.top.bottom.equalTo(self.topBar);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.topBar);
        make.width.mas_equalTo(44);
    }];
    [self.showMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topBar.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    [self.blanceContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showMoney.mas_bottom).offset(12);
        make.left.right.equalTo(self);
    }];
    [self.allBlanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blanceContainerView.mas_left).offset(15);
        make.top.equalTo(self.blanceContainerView.mas_top);
        make.height.mas_equalTo(44);
    }];
    [self.useBlanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blanceContainerView.mas_centerX);
        make.top.equalTo(self.blanceContainerView);
        make.bottom.equalTo(self.sepLine.mas_top);
        make.height.mas_equalTo(44);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useBlanceLabel.mas_right);
        make.centerY.equalTo(self.useBlanceLabel.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.mas_right);
        make.top.equalTo(self.blanceContainerView.mas_top);
        make.bottom.equalTo(self.sepLine.mas_top);
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.blanceContainerView);
        make.top.equalTo(self.allBlanceLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blanceContainerView.mas_left).offset(10);
        make.top.equalTo(self.sepLine.mas_bottom).offset(10);
        make.bottom.equalTo(self.blanceContainerView.mas_bottom).offset(-10);
        make.right.equalTo(self.sureBtn.mas_left).offset(-20);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.blanceContainerView.mas_right).offset(-10);
        make.top.equalTo(self.sepLine.mas_bottom).offset(10);
        make.bottom.equalTo(self.blanceContainerView.mas_bottom).offset(-10);
        make.width.equalTo(self.cancelBtn.mas_width);
    }];
    [self.orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showMoney.mas_left).offset(15);
        make.top.bottom.equalTo(self.showMoney);
    }];
    [self.useBlanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showMoney.mas_top).offset(6);
        make.right.equalTo(self.showMoney.mas_right).offset(-10);
        make.bottom.equalTo(self.showMoney.mas_bottom).offset(-6);
        make.width.mas_equalTo(viewPix(85));
    }];
    [self.blancePaySuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showMoney.mas_bottom).offset(12);
        make.left.right.equalTo(self);
    }];
    [self.surplusOrderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.blancePaySuccessView);
        make.left.equalTo(self.blancePaySuccessView).offset(15);
    }];
    [self.endPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(self.goHomeBtn.mas_left).offset(-20);
        make.height.mas_equalTo(45);
    }];
    [self.goHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(self.endPayBtn.mas_width);
        make.height.mas_equalTo(45);
    }];
    [self.payContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-65);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(120);
    }];

}
#pragma mark--setter------
- (void)setOrderPrice:(NSString *)orderPrice {
    _orderPrice = orderPrice;
    self.orderPriceLabel.attributedText = [MBTools typeString:@"订单金额:" typeStringColor:RGB(66, 62, 62) valueString:[NSString stringWithFormat:@"￥%@",orderPrice] valueStringColor:RGB(255, 0, 82)];
    [self addSubview:self.orderPayFinishView];
    [self.orderPayFinishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}
- (void)setUserMoney:(NSString *)userMoney {
    _userMoney = userMoney;
    self.allBlanceLabel.text = [NSString stringWithFormat:@"余额:￥%@元",userMoney];
    if (self.useBlanceMoney.length) { //使用过余额支付
        self.textField.text = [NSString stringWithFormat:@"-%@",self.useBlanceMoney];
    }
//    else { //未使用余额支付
//        if ([self.orderPrice floatValue]>[userMoney floatValue]) {
//            self.textField.text = userMoney;
//        }else {
//            self.textField.text = self.orderPrice;
//        }
//    }
}
- (void)setUseBlanceMoney:(NSString *)useBlanceMoney {
    _useBlanceMoney = useBlanceMoney;
    CGFloat surplus = [self.orderPrice floatValue]-[useBlanceMoney floatValue];
    self.surplusOrderPriceLabel.attributedText = [MBTools typeString:@"结余金额:" typeStringColor:RGB(66, 62, 62) valueString:[NSString stringWithFormat:@"￥%0.2f",surplus] valueStringColor:RGB(255, 0, 82)];
    [self.useBlanceBtn setTitle:[NSString stringWithFormat:@"-￥%@",useBlanceMoney] forState:UIControlStateNormal];
}
- (void)needUpdateBlanceViewFrameWithSuccess:(BOOL)success {
    if (success) {
        [self.blanceContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.blancePaySuccessView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(55);
        }];
    }
}
- (void)showPaySuccessView {
    [self bringSubviewToFront:self.orderPayFinishView];
    self.orderPayFinishView.hidden = NO;
}
#pragma mark--action----
- (void)closePayView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeOrderPayView)]) {
        [self.delegate closeOrderPayView];
    }
}
- (void)useBlabcePay:(UIButton *)useBlanceBtn {
    [self.blanceContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(110);
    }];
    [self.blancePaySuccessView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];

    if (self.delegate && [self.delegate respondsToSelector:@selector(userBlancePay)]) {
        [self.delegate userBlancePay];
    }
}
- (void)cancelBlancePay {
    [self.blanceContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    if (self.useBlanceMoney.length>0) {
        [self.useBlanceBtn setTitle:[NSString stringWithFormat:@"-￥%@",self.useBlanceMoney] forState:UIControlStateNormal];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelBlancePay)]) {
        [self.delegate cancelBlancePay];
    }
}
- (void)sureUseBlancePay {
    [self.blancePaySuccessView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureUseBlancePay)]) {
        [self.delegate sureUseBlancePay];
    }
}
- (void)choosePayType:(UITapGestureRecognizer *)tap {
    if (tap.view.tag == 0) {
        self.payType = LGPayTypeWechatPay;
    }else {
        self.payType = LGPayTypeAlipay;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseThirdPayWithType:)]) {
        [self.delegate chooseThirdPayWithType:self.payType];
    }
}
- (void)endPay {
    if (self.delegate && [self.delegate respondsToSelector:@selector(endPay)]) {
        [self.delegate endPay];
    }
}
- (void)goToHomeVC {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goToHomeVC)]) {
        [self.delegate goToHomeVC];
    }
}

- (void)seeOrderDetail {
    if (self.delegate && [self.delegate respondsToSelector:@selector(seeOrderDetail)]) {
        [self.delegate seeOrderDetail];
    }
}
- (void)backMainHome {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goToHomeVC)]) {
        [self.delegate goToHomeVC];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.useBlanceMoney.length) {
        textField.text = @"";
    }
}
- (void)valueChanged:(UITextField *)textField {
    if ([self.userMoney floatValue]>=[self.orderPrice floatValue]) {
        if ([textField.text floatValue]>[self.orderPrice floatValue]) {
            [TooltipView showMessage:[NSString stringWithFormat:@"最大只能输入%@",self.orderPrice] offset:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                textField.text = self.orderPrice;
            });
            return;
        }
    }else {
        if ([textField.text floatValue]>[self.userMoney floatValue]) {
            [TooltipView showMessage:@"不能超过余额" offset:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                textField.text = self.userMoney;
            });
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(useBlanceWithTextField:)]) {
        [self.delegate useBlanceWithTextField:textField];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
        return NO;
    }else if ([textField.text containsString:@"."]) {
        NSString *beforePoint = [[textField.text componentsSeparatedByString:@"."]firstObject];
        if (!beforePoint.length || [beforePoint isEqualToString:@""]) {
            textField.text = [NSString stringWithFormat:@"%d%@",0,textField.text];
        }
        NSString *afterPoint = [[textField.text componentsSeparatedByString:@"."]lastObject];
        if (afterPoint.length>=2) {
            textField.text = [textField.text substringToIndex:3];
            if ([afterPoint isEqualToString:@"00"]) {
                textField.text = [textField.text substringToIndex:2];
            }
        }
    }else {
        if ([textField.text containsString:@"0"] && [string isEqualToString:@"0"]) {
            return NO;
        }
    }
    return YES;
}
#pragma mark--懒加载----
- (UIView *)topBar {
    
    if (!_topBar) {
        
        _topBar = [[UIView alloc]init];
        _topBar.backgroundColor = ML_MAIN_COLOR;
    }
    return _topBar;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.text = @"订单付款";
    }
    return _nameLabel;
}

- (UIButton *)closeBtn {
    
    if (!_closeBtn) {
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"nav-close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closePayView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)showMoney {
    
    if (!_showMoney) {
        
        _showMoney = [[UIView alloc]init];
        _showMoney.backgroundColor = [UIColor whiteColor];
    }
    return _showMoney;
}

- (UILabel *)orderPriceLabel {
    
    if (!_orderPriceLabel) {
        
        _orderPriceLabel = [[UILabel alloc]init];
        _orderPriceLabel.textColor = RGB(149, 149, 149);
        _orderPriceLabel.font = [UIFont systemFontOfSize:13];
        _orderPriceLabel.text = @"订单金额:";
    }
    return _orderPriceLabel;
}

- (UIButton *)useBlanceBtn {
    
    if (!_useBlanceBtn) {
        
        _useBlanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useBlanceBtn setTitle:@"使用余额" forState:UIControlStateNormal];
        _useBlanceBtn.backgroundColor = RGB(255, 0, 82);
        [_useBlanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _useBlanceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_useBlanceBtn addTarget:self action:@selector(useBlabcePay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useBlanceBtn;
}

- (UIView *)blanceContainerView {
    
    if (!_blanceContainerView) {
        
        _blanceContainerView = [[UIView alloc]init];
        _blanceContainerView.backgroundColor = [UIColor whiteColor];
        _blanceContainerView.layer.masksToBounds = YES;
    }
    return _blanceContainerView;
}
- (UILabel *)allBlanceLabel {
    
    if (!_allBlanceLabel) {
        
        _allBlanceLabel = [[UILabel alloc]init];
        _allBlanceLabel.textColor = RGB(66, 62, 62);
        _allBlanceLabel.font = [UIFont systemFontOfSize:13];
        _allBlanceLabel.text = @"余额:1900.00";
    }
    return _allBlanceLabel;
}

- (UILabel *)useBlanceLabel {
    
    if (!_useBlanceLabel) {
        
        _useBlanceLabel = [[UILabel alloc]init];
        _useBlanceLabel.textColor = RGB(66, 62, 62);
        _useBlanceLabel.font = [UIFont systemFontOfSize:13];
        _useBlanceLabel.text = @"使用余额:";
    }
    return _useBlanceLabel;
}

- (UITextField *)textField {
    
    if (!_textField) {
        
        _textField = [[UITextField alloc]init];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.textColor = RGB(66, 62, 62);
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        [_textField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UILabel *)unitLabel {
    
    if (!_unitLabel) {
        
        _unitLabel = [[UILabel alloc]init];
        _unitLabel.textColor = RGB(66, 62, 62);
        _unitLabel.font = [UIFont systemFontOfSize:13];
        _unitLabel.text = @"元";
    }
    return _unitLabel;
}

- (UIView *)sepLine {
    
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithString:@"#DBDBDB"];
    }
    return _sepLine;
}
- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = RGB(149, 149, 149).CGColor;
        _cancelBtn.layer.borderWidth = 0.5;
        _cancelBtn.layer.cornerRadius = 3;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancelBlancePay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:RGB(255, 0, 82)];
        _sureBtn.layer.cornerRadius = 3;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureUseBlancePay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIView *)blancePaySuccessView {
    
    if (!_blancePaySuccessView) {
        
        _blancePaySuccessView = [[UIView alloc]init];
        _blancePaySuccessView.backgroundColor = [UIColor clearColor];
        _blancePaySuccessView.layer.masksToBounds = YES;
    }
    return _blancePaySuccessView;
}

- (UILabel *)surplusOrderPriceLabel {
    
    if (!_surplusOrderPriceLabel) {
        
        _surplusOrderPriceLabel = [[UILabel alloc]init];
        _surplusOrderPriceLabel.font = [UIFont systemFontOfSize:13];
        
    }
    return _surplusOrderPriceLabel;
}
- (UIView *)payContainerView {
    
    if (!_payContainerView) {
        
        _payContainerView = [[UIView alloc]init];
        _payContainerView.backgroundColor = [UIColor whiteColor];
        for (NSInteger i = 0; i<self.payArray.count; i++) {
            NSDictionary *dic = self.payArray[i];
            UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 60*i, Screen_W, 60)];
            containerView.tag = i;
            [_payContainerView addSubview:containerView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePayType:)];
            [containerView addGestureRecognizer:tap];
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"logo"]]];
            [containerView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(containerView.mas_left).offset(15);
                make.centerY.equalTo(containerView.mas_centerY);
                make.width.height.mas_equalTo(40);
            }];
            UILabel *payLabel = [[UILabel alloc]init];
            payLabel.font = [UIFont systemFontOfSize:13];
            payLabel.textColor = RGB(66, 62, 62);
            payLabel.text = dic[@"payName"];
            [containerView addSubview:payLabel];
            [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_right).offset(10);
                make.top.equalTo(imageView.mas_top);
            }];
            UILabel *desLabel = [[UILabel alloc]init];
            desLabel.font = [UIFont systemFontOfSize:12];
            desLabel.textColor = RGB(149, 149, 149);
            desLabel.text = dic[@"payDesc"];
            [containerView addSubview:desLabel];
            [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_right).offset(10);
                make.bottom.equalTo(imageView.mas_bottom);
            }];
            UIView *sepLine = [[UIView alloc]init];
            sepLine.backgroundColor = [UIColor colorWithString:@"#f5f5f5"];
            [containerView addSubview:sepLine];
            [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(containerView);
                make.height.mas_equalTo(0.5);
            }];
            UIImageView *rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"you"]];
            [containerView addSubview:rightArrow];
            [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(containerView.mas_centerY);
                make.right.equalTo(containerView.mas_right).offset(-10);
                make.width.mas_equalTo(6);
                make.height.mas_equalTo(11);
            }];
        }
    }
    return _payContainerView;
}
- (UIButton *)endPayBtn {
    
    if (!_endPayBtn) {
        
        _endPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endPayBtn setTitle:@"暂不付款" forState:UIControlStateNormal];
        [_endPayBtn setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        _endPayBtn.layer.borderColor = RGB(149, 149, 149).CGColor;
        _endPayBtn.layer.borderWidth = 0.5;
        _endPayBtn.layer.cornerRadius = 3;
        _endPayBtn.layer.masksToBounds = YES;
        _endPayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_endPayBtn addTarget:self action:@selector(endPay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endPayBtn;
}
- (UIButton *)goHomeBtn {
    
    if (!_goHomeBtn) {
        
        _goHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goHomeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        [_goHomeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_goHomeBtn setBackgroundColor:RGB(255, 0, 82)];
        _goHomeBtn.layer.cornerRadius = 3;
        _goHomeBtn.layer.masksToBounds = YES;
        _goHomeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_goHomeBtn addTarget:self action:@selector(goToHomeVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goHomeBtn;
}

- (UIView *)orderPayFinishView {
    
    if (!_orderPayFinishView) {

        _orderPayFinishView = [[UIView alloc]init];
        _orderPayFinishView.backgroundColor = [UIColor whiteColor];
        _orderPayFinishView.layer.masksToBounds = YES;
        _orderPayFinishView.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"paySuccess"];
        [_orderPayFinishView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_orderPayFinishView.mas_left).offset(15);
            make.top.equalTo(_orderPayFinishView.mas_top).offset(20);
            make.width.height.mas_equalTo(40);
        }];
        UILabel *payLabel = [[UILabel alloc]init];
        payLabel.font = [UIFont systemFontOfSize:13];
        payLabel.textColor = RGB(66, 62, 62);
        payLabel.text = @"支付方式:余额支付";
        [_orderPayFinishView addSubview:payLabel];
        [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.top.equalTo(imageView.mas_top);
        }];
        UILabel *desLabel = [[UILabel alloc]init];
        desLabel.font = [UIFont systemFontOfSize:12];
        desLabel.attributedText = [MBTools typeString:@"付款金额:" typeStringColor:RGB(66, 62, 62) valueString:[NSString stringWithFormat:@"￥%@",self.orderPrice] valueStringColor:RGB(255, 0, 82)];
        [_orderPayFinishView addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.bottom.equalTo(imageView.mas_bottom);
        }];
        UIView *sepLine = [[UIView alloc]init];
        sepLine.backgroundColor = [UIColor colorWithString:@"#f5f5f5"];
        [_orderPayFinishView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_orderPayFinishView);
            make.top.equalTo(_orderPayFinishView.mas_top).offset(60);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *seeOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        [seeOrder setTitle:@"查看订单" forState:UIControlStateNormal];
        [seeOrder setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        seeOrder.layer.cornerRadius = 3;
        seeOrder.layer.masksToBounds = YES;
        seeOrder.layer.borderColor = RGB(149, 149, 149).CGColor;
        seeOrder.layer.borderWidth = 1;
        seeOrder.titleLabel.font = [UIFont systemFontOfSize:14];
        [seeOrder addTarget:self action:@selector(seeOrderDetail) forControlEvents:UIControlEventTouchUpInside];
        [_orderPayFinishView addSubview:seeOrder];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        [backBtn setTitleColor:RGB(66, 62, 62) forState:UIControlStateNormal];
        backBtn.layer.cornerRadius = 3;
        backBtn.layer.masksToBounds = YES;
        backBtn.layer.borderColor = RGB(149, 149, 149).CGColor;
        backBtn.layer.borderWidth = 1;
        backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [backBtn addTarget:self action:@selector(backMainHome) forControlEvents:UIControlEventTouchUpInside];
        [_orderPayFinishView addSubview:backBtn];
        
        [seeOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_orderPayFinishView.mas_bottom).offset(-20);
            make.left.equalTo(_orderPayFinishView.mas_left).offset(10);
            make.right.equalTo(backBtn.mas_left).offset(-20);
            make.height.mas_equalTo(45);
        }];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_orderPayFinishView.mas_bottom).offset(-20);
            make.right.equalTo(_orderPayFinishView.mas_right).offset(-10);
            make.width.equalTo(seeOrder.mas_width);
            make.height.mas_equalTo(45);
        }];
    }
    return _orderPayFinishView;
}
@end
