//
//  LGPhoneLoginViewController.m
//  meyley
//
//  Created by Bovin on 2018/10/12.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGPhoneLoginViewController.h"
#import "WKWebViewController.h"
#import "MBProgressHUD.h"
#import "HXSRegisterVerifyButton.h"

@interface LGPhoneLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *LoginBGView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTF;

@property (weak, nonatomic) IBOutlet UIView *inviteBGView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *protocolView;

@property (weak, nonatomic) IBOutlet HXSRegisterVerifyButton *verifyBtn;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *passWordLogin;

@end

@implementation LGPhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == LGInterfaceTypeLogin) {
        self.navigationItem.title = @"手机登录";
        self.protocolView.hidden = NO;
        self.passWordLogin.hidden = NO;
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }else {
        self.navigationItem.title = @"修改手机号";
        self.protocolView.hidden = YES;
        self.passWordLogin.hidden = YES;
        [self.loginBtn setTitle:@"确认" forState:UIControlStateNormal];
    }
    
    self.inviteBGView.hidden = YES;
    self.loginBtn.enabled = NO;
    
    self.phoneNumTF.delegate = self;
    self.phoneNumTF.returnKeyType = UIReturnKeyNext;
    self.phoneNumTF.tintColor = HXS_TEXT_COLOR;
    [self.phoneNumTF addTarget:self action:@selector(checkPhoneAndPasswordInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
    self.verificationCodeTF.layer.masksToBounds = YES;
    self.verificationCodeTF.delegate = self;
    self.verificationCodeTF.returnKeyType = UIReturnKeyNext;
    self.verificationCodeTF.tintColor = HXS_TEXT_COLOR;
    [self.verificationCodeTF addTarget:self action:@selector(checkPhoneAndPasswordInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMutableStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMutableStr replaceCharactersInRange:range withString:string];
    
    if (textField == self.phoneNumTF) {
        if (11 < [resultMutableStr length]) {
            return NO;
        }
    } else if (textField == self.verificationCodeTF) {
        if (4 < [resultMutableStr length]) {
            return NO;
        }
    } else {
        // Do nothing
    }
    
    return YES;
}


- (void)checkPhoneAndPasswordInfoValidation
{
    if (self.phoneNumTF.text.length == 11) {
        if ([MBTools checkMobileIsTrue:self.phoneNumTF.text]) { //判断手机号是否注册
            [self checkPhoneNumberIsRegistered];
        }else { //输入的手机号码不正确
            [MBProgressHUD showInViewWithoutIndicator:self.view status:@"您输入的手机号码不正确" afterDelay:2];
            return;
        }
    }
    self.loginBtn.enabled = ((self.phoneNumTF.text.length == 11) && (self.verificationCodeTF.text.length >= 4));
}

//判断手机号是否已经注册
- (void)checkPhoneNumberIsRegistered {
    NSString *action = [NSString stringWithFormat:@"mobile=%@",self.phoneNumTF.text];
    [MBProgressHUD showInView:self.view];
    [RequestUtil withGET:@"/api/user/verify/mobile.action" parameters:action success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"0"]) { //手机号已注册
            if (self.type == LGInterfaceTypeLogin) {
                self.inviteBGView.hidden = YES;
            }
        }else if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) { //手机号未注册
            if (self.type == LGInterfaceTypeLogin) {
                self.inviteBGView.hidden = NO;
            }
        }else {
            [TooltipView showMessage:responseObject[@"msg"] offset:0];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (IBAction)getVerifyCode:(HXSRegisterVerifyButton *)sender {
    if (sender.isCounting) {
        return;
    }
    if (self.phoneNumTF.text.length > 0)
    {
        NSDictionary *dic = @{@"mobile":self.phoneNumTF.text};
        [RequestUtil withPOST:@"/api/sms/send.action" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
                [sender countingSeconds:60];
            }else {
                [TooltipView showMessage:responseObject[@"msg"] offset:0];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    if(!self.agreeBtn.selected) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请点击同意注册协议！" afterDelay:1.5];
        
        return;
    }
    [MBProgressHUD showInView:self.view];
    [[HXSUserAccount currentAccount] registerWithMobile:self.phoneNumTF.text password:self.verificationCodeTF.text invitationcode:self.inviteCodeTF.text completeBlock:^(HXSErrorCode code, NSString *msg, HXSUserBasicInfo *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(code == kHXSNoError) {
            
        }else {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:msg afterDelay:2];
        }
    }];
    
}
//收不到短信验证码
- (IBAction)cannotReceiveVeriCode:(UIButton *)sender {
    [MBProgressHUD showInViewWithoutIndicator:self.view status:@"联系你的专属客服或致电/加微信13575770625" afterDelay:1.5];
}
//密码登录
- (IBAction)accountPasswordLogin:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)agreeProtocol:(UIButton *)sender {
    sender.selected =! sender.selected;
}
- (IBAction)optenUserProtocol:(UIButton *)sender {
    WKWebViewController *controller = [[WKWebViewController alloc] init];
    [controller loadUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
