//
//  HXSLoginViewController.m
//  store
//
//  Created by chsasaw on 14-10-16.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSLoginViewController.h"

#import "HXSSinaWeiboManager.h"
#import "HXSQQSdkManager.h"
#import "HXSWXApiManager.h"
#import "HXSAlipayManager.h"
#import "HXSPhoneRegisterViewController.h"
#import "HXStoreLogin.h"
#import "MLCustomButton.h"

#import "LGPhoneLoginViewController.h"


#define PASSWORD_MAX_LENGTH    16

@interface HXSLoginViewController ()<HXSThirdAccountDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField * nameField;
@property (nonatomic, weak) IBOutlet UITextField * passwordField;

@property (nonatomic, weak) IBOutlet MLCustomButton * loginBtn;

@property (nonatomic, weak) IBOutlet UIButton * weiboBtn;
@property (nonatomic, weak) IBOutlet UIButton * qqBtn;
@property (nonatomic, weak) IBOutlet UIButton * weixinBtn;
@property (nonatomic, weak) IBOutlet UIButton * alipayBtn;

@property (nonatomic, copy) LoginCompletion completion;
@property (nonatomic, copy) void (^loginCanceled)(void);

@end

@implementation HXSLoginViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {


}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.loginBtn.enabled = NO;
    
    self.navigationItem.title = @"密码登录";
    
    self.nameField.delegate = self;
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.nameField.tintColor = HXS_TEXT_COLOR;
    
    self.passwordField.delegate = self;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.tintColor = HXS_TEXT_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLoginStatus)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    if(![HXSQQSdkManager sharedManager].isQQInstalled) {
        self.qqBtn.hidden = YES;
    }
    
    if(![HXSWXApiManager sharedManager].isWechatInstalled) {
        self.weixinBtn.hidden = YES;
    }
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    self.passwordField.secureTextEntry = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginComplete:) name:kLoginCompleted object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginCompleted object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
}

-(void)hidenKeyboard
{
    [self.nameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Methods

- (IBAction)phoneLogin:(id)sender {
    
    LGPhoneLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LGPhoneLoginViewController"];
    loginVC.hidesBottomBarWhenPushed = YES;
    loginVC.type = LGInterfaceTypeLogin;
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (void)actionCompletion
{
    if(self.completion) {
        self.completion();
        self.completion = nil;
    }
}

+ (void)showLoginController:(UIViewController *)fromController loginCompletion: (LoginCompletion)completion
{
    [HXSLoginViewController showLoginController:fromController
                                loginCompletion:completion
                                  loginCanceled:nil];
}

+ (void)showLoginController:(UIViewController *)fromController
            loginCompletion: (LoginCompletion)completion
              loginCanceled:(void (^)(void))cancelCompletion
{
    if([HXSUserAccount currentAccount].isLogin) {
        completion();
        return;
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePathStr = [bundle pathForResource:@"HXStoreLogin" ofType:@"bundle"];
    if (0 < [bundlePathStr length]) {
        bundle = [NSBundle bundleWithPath:bundlePathStr];
    }
    
    HKBaseNavigationController * nav = [[UIStoryboard storyboardWithName:@"Login" bundle:bundle] instantiateViewControllerWithIdentifier:@"HXSLoginViewControllerNavigation"];
    HXSLoginViewController *loginVc = nav.viewControllers[0];
    loginVc.completion = completion;
    loginVc.loginCanceled = cancelCompletion;
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.modalPresentationCapturesStatusBarAppearance = YES;
    [fromController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - Override Methods

- (void)back
{
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 if (self.loginCanceled) {
                                     self.loginCanceled();
                                     
                                     self.loginCanceled = nil;
                                 }
                             }];
}


#pragma mark - Target Methods

- (IBAction)onLoginClicked:(id)sender
{
    [self hidenKeyboard];

    [MBProgressHUD showInView:self.view];
    [[HXSUserAccount currentAccount] login:self.nameField.text password:self.passwordField.text];
}

- (IBAction)openPasswordClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.passwordField.secureTextEntry = !btn.selected;
}

- (IBAction)qqLogin:(id)sender {
    [HXSQQSdkManager sharedManager].delegate = self;
    [[HXSQQSdkManager sharedManager] logIn];
}

- (IBAction)weiboLogin:(id)sender {
    [MBProgressHUD showInViewWithoutIndicator:self.view status:@"功能开发中，请稍后！" afterDelay:2];
    
    [HXSSinaWeiboManager sharedManager].delegate = self;
    [[HXSSinaWeiboManager sharedManager] logIn];
}

- (IBAction)alipayLogin:(id)sender
{
    [HXSAlipayManager sharedManager].loginDelegate = self;
    [[HXSAlipayManager sharedManager] login];
}

- (IBAction)weixinLogin:(id)sender {
    [HXSWXApiManager sharedManager].delegate = self;
    [[HXSWXApiManager sharedManager] logIn];
}

#pragma mark - HXSThirdAccountDelegate
- (void)thirdAccountDidLogin:(HXSAccountType)type
{
    [self clearDelegateWithType:type];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"绑定帐号中...";
    
    [[HXSUserAccount currentAccount] loginWithThirdAccount:[HXSAccountManager sharedManager].accountID token:[HXSAccountManager sharedManager].accountToken];
}

- (void)thirdAccountLoginCancelled:(HXSAccountType)type
{
    [self clearDelegateWithType:type];
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.label.text = @"用户取消";
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)thirdAccountLoginFailed:(HXSAccountType)type
{
    [self clearDelegateWithType:type];
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.label.text = @"登录失败";
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)thirdAccountDidLogout:(HXSAccountType)type {
    
}

#pragma mark Clear Delegate
- (void)clearDelegateWithType:(HXSAccountType)type
{
    [HXSAccountManager sharedManager].accountType = type;
    
    switch (type) {
        case kHXSWeixinAccount:
            [HXSWXApiManager sharedManager].delegate = nil;
            break;
            
        case kHXSSinaWeiboAccount:
            [HXSSinaWeiboManager sharedManager].delegate = nil;
            break;
            
        case kHXSQQAccount:
            [HXSQQSdkManager sharedManager].delegate = nil;
            break;
            
        case kHXSAlipayAccount:
            // Do nothing
            break;
            
        default:
            break;
    }
}

#pragma mark - HXSUserAccountDelegate
- (void)onLoginComplete:(NSNotification *)noti
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    NSDictionary * dic = [noti userInfo];
    if([HXSUserAccount currentAccount].isLogin) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = [dic objectForKey:@"msg"];
        [hud hideAnimated:YES afterDelay:1.0];
        
        if (self.completion) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self actionCompletion];
            }];
        }
        else {
            [self back];
        }
    }else {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = [dic objectForKey:@"msg"];
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.nameField) {
        [self.passwordField becomeFirstResponder];
        [self.nameField resignFirstResponder];
    }else if(textField == self.passwordField) {
        [self.passwordField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *resultMStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMStr replaceCharactersInRange:range withString:string];
    
    if (textField == self.passwordField) {
        if (PASSWORD_MAX_LENGTH < [resultMStr length]) {
            return NO;
        }
    }
    
    if (textField.isSecureTextEntry) {
        textField.text = resultMStr;
        
        [self updateLoginStatus];
        return NO;
    }
    
    return YES;
}


#pragma mark - Private Methods

- (void)updateLoginStatus
{
    if ((0 < [self.nameField.text length])
        && (0 < [self.passwordField.text length])) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}


@end
