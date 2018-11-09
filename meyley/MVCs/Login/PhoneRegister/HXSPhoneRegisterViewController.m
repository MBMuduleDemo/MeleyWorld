//
//  HXSPhoneRegisterViewController.m
//  store
//
//  Created by chsasaw on 15/4/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPhoneRegisterViewController.h"
#import "HXSPhoneLoginViewController.h"
#import "HXStoreLogin.h"
#import "MLCustomButton.h"
#import "WKWebViewController.h"
#import "MBProgressHUD.h"

#define PHONE_MAX_LENGTH         11
#define PASSWORD_MAX_LENGTH 60

@interface HXSPhoneRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet MLCustomButton *sighBtn;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *recommendTextField;
@property (nonatomic, weak) IBOutlet UIButton *agreeButton;

@end

@implementation HXSPhoneRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户注册";
    
    self.phoneTextField.delegate = self;
    self.phoneTextField.returnKeyType = UIReturnKeyNext;
    self.phoneTextField.tintColor = HXS_TEXT_COLOR;
    [self.phoneTextField addTarget:self action:@selector(checkPhoneAndPasswordInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
    self.passwordTextField.layer.masksToBounds = YES;
    self.passwordTextField.delegate = self;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.tintColor = HXS_TEXT_COLOR;
    [self.passwordTextField addTarget:self action:@selector(checkPhoneAndPasswordInfoValidation) forControlEvents:UIControlEventEditingChanged];
    
    self.recommendTextField.delegate = self;
    self.recommendTextField.tintColor = HXS_TEXT_COLOR;
    self.recommendTextField.returnKeyType = UIReturnKeyDone;
    
    self.sighBtn.enabled = NO;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginCompleted object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (void)checkPhoneAndPasswordInfoValidation
{
    _sighBtn.enabled = ((_phoneTextField.text.length == 11) && (_passwordTextField.text.length >= 6));
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.phoneTextField) {
        [self.phoneTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }else if(textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
        [self.recommendTextField becomeFirstResponder];
    }else if(textField == self.recommendTextField) {
        [self.recommendTextField resignFirstResponder];
    }
    
    return YES;
}

-(void)hidenKeyboard
{
    [self.view endEditing:YES];
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMutableStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMutableStr replaceCharactersInRange:range withString:string];
    
    if (textField == self.phoneTextField) {
        if (PHONE_MAX_LENGTH < [resultMutableStr length]) {
            return NO;
        }
    } else if (textField == self.passwordTextField) {
        if (PASSWORD_MAX_LENGTH < [resultMutableStr length]) {
            return NO;
        }
    } else {
        // Do nothing
    }
    
    return YES;
}


#pragma mark - Target Methods

- (IBAction)onSignInClicked:(id)sender
{
    if(!self.agreeButton.selected) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请点击同意注册协议！" afterDelay:1.5];
        
        return;
    }
    
    [self hidenKeyboard];

    [MBProgressHUD showInView:self.view];
    
    [[HXSUserAccount currentAccount] registerWithMobile:self.phoneTextField.text password:self.passwordTextField.text invitationcode:self.recommendTextField.text completeBlock:^(HXSErrorCode code, NSString *msg, HXSUserBasicInfo *info) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(code == kHXSNoError) {
            HXSPhoneLoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HXSPhoneLoginViewController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:msg afterDelay:2];
        }
    }];
}


#pragma mark - Selector Of Phone Text Field 

- (void)updatePhoneTextFieldStatusToEnable
{
    self.phoneTextField.enabled = YES;
}

- (IBAction)agreeProtocol:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)openPasswordClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.passwordTextField.secureTextEntry = !btn.selected;
}

- (IBAction)openProtocol:(id)sender {
    WKWebViewController *controller = [[WKWebViewController alloc] init];
    [controller loadUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
