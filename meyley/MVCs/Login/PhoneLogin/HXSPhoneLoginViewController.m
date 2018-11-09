//
//  HXSPhoneLoginViewController.m
//  store
//
//  Created by chsasaw on 15/4/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPhoneLoginViewController.h"
#import "MLUserInfoSetupViewController.h"
#import "HXSLoginViewController.h"
#import "HXSRegisterVerifyButton.h"
#import "HXStoreLogin.h"
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"

#define LENGTH_CELL_PHONE              11
#define VERIFIED_CODE_MAX_LENGTH       4
#define MESSAGE_CODE_WAITING_TIME 60

@interface HXSPhoneLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet HXSRegisterVerifyButton *verifyBtn;
@property (nonatomic, assign) IBOutlet UIButton *loginBtn;
@property (nonatomic, assign) IBOutlet UITextField *phoneTextField;
@property (nonatomic, assign) IBOutlet UITextField *verifyTextField;

@property (nonatomic, assign) BOOL hasRegisteredFlag;   // 0 didn't register,  1 has registered

@end

@implementation HXSPhoneLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initialNavigationStatus];
    
    [self initialTextFieldAndButtons];
    
    [self checkPhoneAndVerifyCodeInfoValidation];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    if([[HXSUserAccount currentAccount] isLogin]) {
        self.phoneTextField.text = [HXSUserAccount currentAccount].userInfo.basicInfo.mobile;
        self.phoneTextField.enabled = NO;
        
        self.verifyBtn.enabled = YES;
    }
    
    [self.verifyBtn setTitleColor:ML_ACCENT_COLOR forState:UIControlStateNormal];
    [self.verifyBtn setTitleColor:ML_ACCENT_COLOR forState:UIControlStateDisabled];
    
    [self.verifyBtn setBackgroundColor:[UIColor clearColor]];
    [self.verifyBtn setBackgroundImage:nil forState:UIControlStateDisabled];
    [self.verifyBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.verifyBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.phoneTextField.delegate  = nil;
    self.verifyTextField.delegate = nil;
}

#pragma mark - Initial Methods

- (void)initialNavigationStatus
{
    self.navigationItem.title = @"手机验证";
}

- (void)initialTextFieldAndButtons
{
    self.phoneTextField.layer.masksToBounds = YES;
    self.phoneTextField.delegate = self;
    self.phoneTextField.returnKeyType = UIReturnKeyNext;
    self.phoneTextField.tintColor = HXS_TEXT_COLOR;
    [self.phoneTextField addTarget:self action:@selector(checkPhoneAndVerifyCodeInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
    self.verifyTextField.layer.masksToBounds = YES;
    self.verifyTextField.delegate = self;
    self.verifyTextField.returnKeyType = UIReturnKeyDone;
    self.verifyTextField.tintColor = HXS_TEXT_COLOR;
    [self.verifyTextField addTarget:self action:@selector(checkPhoneAndVerifyCodeInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
    self.verifyBtn.enabled = NO;
}

- (void)checkPhoneAndVerifyCodeInfoValidation
{
    if (!_verifyBtn.isCounting) {
        _verifyBtn.enabled = (_phoneTextField.text.length == 11);
    }
    
    if ((LENGTH_CELL_PHONE == [self.phoneTextField.text length])
        && (VERIFIED_CODE_MAX_LENGTH == [self.verifyTextField.text length])) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}


#pragma mark - Target Methods

- (IBAction)onClickGetVerifyCode:(HXSRegisterVerifyButton *)button
{
    if (button.isCounting) {
        return;
    }
    
    [self.phoneTextField resignFirstResponder];
    
    if (self.phoneTextField.text.length > 0)
    {
        [self sendIdenfication:^{
            [button countingSeconds:MESSAGE_CODE_WAITING_TIME];
        }];
    }
}

- (IBAction)onLogInClicked:(id)sender
{
    [self hidenKeyboard];
    
    if(LENGTH_CELL_PHONE > [self.phoneTextField.text length]) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入11位手机号码" afterDelay:1.0];
        
        return;
    }else if(VERIFIED_CODE_MAX_LENGTH > [self.verifyTextField.text length]) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入4位验证码" afterDelay:1.0];
        
        return;
    } else {
        // Do nothing
    }
    
    [self sendVerificationCode];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        [self.phoneTextField resignFirstResponder];
        [self.verifyTextField becomeFirstResponder];
    } else if (textField == self.verifyTextField) {
        [self.verifyTextField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMStr replaceCharactersInRange:range withString:string];
    
    if (textField == self.phoneTextField) {
        if (LENGTH_CELL_PHONE < [resultMStr length]) {
            return NO;
        }
    } else if (textField == self.verifyTextField) {
        if (VERIFIED_CODE_MAX_LENGTH < [resultMStr length] ) {
            return NO;
        }
    }
    
    if (textField.isSecureTextEntry) {
        textField.text = resultMStr;
        
        return NO;
    }
    
    return YES;
}

- (void)hidenKeyboard
{
    [self.view endEditing:YES];

    [self.phoneTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
}


#pragma mark - Connect Service

- (void)sendIdenfication:(void (^)())success
{
    [MBProgressHUD showInView:self.view];
    [HXSPersonalInfoModel sendAuthCodeWithPhone:self.phoneTextField.text
                                     verifyType:HXSVerifyAppLogin
                                       complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           if (kHXSNoError != code) {
                                               [MBProgressHUD showInViewWithoutIndicator:self.view
                                                                                  status:message?message:@"获取验证码失败"
                                                                              afterDelay:2.0];

                                               return ;
                                           }
                                           
                                           success();
                                           
                                           if (DIC_HAS_NUMBER(authInfo, @"register_flag")) {
                                               self.hasRegisteredFlag = [[authInfo objectForKey:@"register_flag"] boolValue];
                                           }
                                       }];
}

- (void)sendVerificationCode
{
    [MBProgressHUD showInView:self.view];
    [HXSPersonalInfoModel verifAuthCodeWithPhone:self.phoneTextField.text
                                            code:self.verifyTextField.text
                                      verifyType:HXSVerifyAppLogin
                                        complete:^(HXSErrorCode code, NSString *message, NSDictionary *authInfo) {
                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                            if (kHXSNoError != code) {
                                                
                                                [MBProgressHUD showInViewWithoutIndicator:self.view
                                                                                   status:message
                                                                               afterDelay:1.0];
                                                
                                                return;
                                            }
                                            
                                            [self verifyComplete];
                                        }];
}

#pragma mark - Display Verify Done

- (void)verifyComplete
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (self.hasRegisteredFlag) {
        [MBProgressHUD showDrawInViewWithoutIndicator:self.view status:@"验证成功" afterDelay:1.0f];
    } else {
        [MBProgressHUD showDrawInViewWithoutIndicator:self.view status:@"验证成功" afterDelay:1.0];
    }
    
    // update user info in basic info class.
    [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BEGIN_MAIN_THREAD
        [self showUserInfoSetup:nil];
        END_MAIN_THREAD
    });
}

- (IBAction)showUserInfoSetup:(id)sender {
    MLUserInfoSetupViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MLUserInfoSetupViewController"];
    [self.navigationController setViewControllers:@[controller] animated:YES];
}

@end
