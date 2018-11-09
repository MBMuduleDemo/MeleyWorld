//
//  LGChargeWithdrawViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGChargeWithdrawViewController.h"

#import "LGBlanceShowView.h"
#import "LGBaseTypeChooseView.h"
#import "LGBaseInputView.h"

@interface LGChargeWithdrawViewController ()

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) LGBlanceShowView *blanceView;

//注意事项
@property (nonatomic, strong) UILabel *careTipsLabel;
//申请提现
@property (nonatomic, strong) UIButton *withdrawBtn;

//记录用户填写的信息
@property (nonatomic, copy) NSString *accountInfo;

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *withdrawMoney;

@end

@implementation LGChargeWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值与提现";
    
    //请求余额
    
    self.dataArray = @[@{},@{@"typeName":@"提现账户:",@"placeHolder":@"请输入正确账户"},@{@"typeName":@"真实姓名:",@"placeHolder":@"请输入真实姓名"},@{@"typeName":@"提现金额:",@"placeHolder":@"可提现金额"}];
    [self.view addSubview:self.blanceView];
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.careTipsLabel];
    [self.view addSubview:self.withdrawBtn];
    
    CGFloat space = viewPix(10);
    CGFloat width = Screen_W-viewPix(24);
    CGFloat height = 44;
    for (NSInteger i = 0; i<self.dataArray.count; i++) {
        if (0 == i) {
            LGBaseTypeChooseView *view = [[LGBaseTypeChooseView alloc]initWithFrame:CGRectMake(viewPix(12), space, width, height)];
            [self.bgScrollView addSubview:view];
        }else {
            NSDictionary *dic = self.dataArray[i];
            LGBaseInputView *inputView = [[LGBaseInputView alloc]initWithFrame:CGRectMake(viewPix(12), space+(space+height)*i, width, height)];
            inputView.tag = 666+i;
            inputView.typeName = dic[@"typeName"];
            inputView.placeHolder = dic[@"placeHolder"];
            __weak typeof(self)weakSelf = self;
            inputView.userInputInfoHandler = ^(NSString *text) {
                [weakSelf handlerUserEditingInfoWithFlag:666+i text:text];
            };
            if ([self.blanceMoney floatValue]<100) {
                inputView.textField.userInteractionEnabled = NO;
                self.withdrawBtn.enabled = NO;
            }else {
                inputView.textField.userInteractionEnabled = YES;
                self.withdrawBtn.enabled = YES;
            }
            [self.bgScrollView addSubview:inputView];
            inputView.textField.keyboardType = UIKeyboardTypeDefault;
            if (self.dataArray.count-1 == i) {
                inputView.textField.keyboardType = UIKeyboardTypeDecimalPad;
                self.careTipsLabel.frame = CGRectMake(viewPix(12), CGRectGetMaxY(inputView.frame)+60, width, 150);
            }
        }
    }
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.bgScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.blanceView.frame), Screen_W, Screen_H-viewPix(49)-topBarHeight-viewPix(65));
    
    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(viewPix(40));
        make.right.equalTo(self.view.mas_right).offset(-viewPix(40));
        make.bottom.equalTo(self.view.mas_bottom).offset(-viewPix(10));
        make.height.mas_equalTo(viewPix(45));
    }];
    self.bgScrollView.contentSize = CGSizeMake(Screen_W, CGRectGetMaxY(self.careTipsLabel.frame)+20);
}

- (void)handlerUserEditingInfoWithFlag:(NSInteger)flag text:(NSString *)text {
    switch (flag) {
        case 667:
            self.accountInfo = text;
            break;
        case 668:
            self.realName = text;
            break;
        case 669:
            self.withdrawMoney = text;
            break;
            
        default:
            break;
    }
}

#pragma mark--action---
//申请提现
- (void)withdrawUserBlance {
   
    NSLog(@"%@===%@===%@",self.accountInfo,self.realName,self.withdrawMoney);
    NSString *message = [NSString stringWithFormat:@""];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认提现" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continuAciont = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *chartAction = [UIAlertAction actionWithTitle:@"确认提现" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //确认提现
        [self makeSureWithdraw];
    }];
    [alertController addAction:continuAciont];
    [alertController addAction:chartAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)makeSureWithdraw {
    if (!self.accountInfo.length) {
        [MBProgressHUD showInView:self.view status:@"请输入正确的账号"];
        return;
    }
    if (!self.realName.length) {
        [MBProgressHUD showInView:self.view status:@"请输入真实姓名"];
        return;
    }
    if (!self.withdrawMoney.length) {
        [MBProgressHUD showInView:self.view status:@"请输入提现金额"];
        return;
    }
    NSString *userId = [NSString stringWithFormat:@"%@",[HXSUserAccount currentAccount].userID];
    NSDictionary *action = @{@"userId":userId,@"accountType":@"支付宝",@"accountId":self.realName,@"money":self.withdrawMoney};
    [RequestUtil withPOST:@"/api/userCashApply/cashApply.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
            
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark--lazy------
- (UIScrollView *)bgScrollView {
    
    if (!_bgScrollView) {
        
        _bgScrollView = [[UIScrollView alloc]init];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bgScrollView;
}

- (LGBlanceShowView *)blanceView {
    
    if (!_blanceView) {
        
        _blanceView = [[LGBlanceShowView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, viewPix(49))];
        _blanceView.userBlanceMoney = self.blanceMoney;
    }
    return _blanceView;
}
- (UILabel *)careTipsLabel {
    
    if (!_careTipsLabel) {
        
        _careTipsLabel = [[UILabel alloc]init];
        _careTipsLabel.font = [UIFont systemFontOfSize:12];
        _careTipsLabel.textColor = RGB(66, 62, 62);
        _careTipsLabel.text = @"注意:\n1.每次提现最少100元起。\n\n2.请输入会员本人正确的支付宝账号和姓名，我们将通过支付宝转账的方式支付给你，依你输入的账号为准，并承担相关责任。\n\n3.本月5日前申请的提现，当月16日起按提现时间申请从先到后排序支付，5日后申请的提现次月16日统一支付，遇法定节假日顺延至工作日再处理。";
        _careTipsLabel.numberOfLines = 0;
        [_careTipsLabel sizeToFit];
    }
    return _careTipsLabel;
}
- (UIButton *)withdrawBtn {
    
    if (!_withdrawBtn) {
        
        _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawBtn setTitle:@"申请提现" forState:UIControlStateNormal];
        [_withdrawBtn setBackgroundColor:RGB(255, 0, 82) forState:UIControlStateNormal];
        [_withdrawBtn setBackgroundColor:ML_DISABLE_COLOR forState:UIControlStateDisabled];
        [_withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_withdrawBtn addTarget:self action:@selector(withdrawUserBlance) forControlEvents:UIControlEventTouchUpInside];
        _withdrawBtn.layer.cornerRadius = 5;
        _withdrawBtn.layer.masksToBounds = YES;
    }
    return _withdrawBtn;
}
@end
