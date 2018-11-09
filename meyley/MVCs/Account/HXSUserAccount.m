//
//  HXSUserAccount.m
//  store
//
//  Created by chsasaw on 14/10/26.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSUserAccount.h"

#import "HXSRegisterRequest.h"
#import "HXSDeviceUpdateRequest.h"
#import "HXSLogoutRequest.h"
#import "HXSLoginRequest.h"
#import "HXSAccountManager.h"
#import "HXSUpdateTokenRequest.h"
#import "AFNetworking.h"
#import "HXMacrosDefault.h"
#import "HXSCustomAlertView.h"
#import "HXAppDeviceHelper.h"
#import "HXMacrosUtils.h"
#import "HXSUserInfo.h"
#import "HXSDirectoryManager.h"
#import "ApplicationSettings.h"

@interface HXSUserAccount()

@property (nonatomic, strong) HXSCustomAlertView *alert;
@property (nonatomic, strong) HXSRegisterRequest *registerRequest;
@property (nonatomic, strong) HXSLoginRequest * loginRequest;
@property (nonatomic, strong) HXSLogoutRequest *logoutRequest;

@property (nonatomic, assign) BOOL tokenUpdating;

@end

@implementation HXSUserAccount

static HXSUserAccount * _currentAccount = nil;

+ (HXSUserAccount *) currentAccount
{
    @synchronized (self)
    {
        if (_currentAccount == nil)
        {
            _currentAccount = [[HXSUserAccount alloc] init];
            [_currentAccount loadUserInfo];
        }
    }
    return _currentAccount;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        NSNumber * userid = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kHXSUserID];
        NSString * token = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kHXSToken];
        if (userid != nil && [userid isKindOfClass:[NSNumber class]])
        {
            _userID = userid;
        }
        
        _strToken = token;
        
        self.tokenUpdating = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setStrToken:(NSString *)strToken {
    _strToken = strToken;
    
    [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:kHXSToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserID:(NSNumber *)userID {
    if([userID isKindOfClass:[NSNumber class]]) {
        _userID = userID;
    }else {
        _userID = nil;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kHXSUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateToken {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if(status == AFNetworkReachabilityStatusUnknown) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        __weak HXSUserAccount *weakSelf = self;
        // 检测网络连接的单例,网络变化时的回调方法
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if([HXSUserAccount currentAccount].strToken || weakSelf.alert)
                return;
            if(status == AFNetworkReachabilityStatusNotReachable) {
                weakSelf.alert = [[HXSCustomAlertView alloc] initWithTitle:@"警告"
                                                               message:@"无法连接网络，请检查网络设置！"
                                                       leftButtonTitle:@"确定"
                                                     rightButtonTitles:nil];
                [weakSelf.alert show];
            }else if(status == AFNetworkReachabilityStatusReachableViaWWAN) {
                weakSelf.alert = [[HXSCustomAlertView alloc] initWithTitle:@"警告"
                                                               message:@"您正在使用移动数据，将产生通信费用，是否继续？"
                                                       leftButtonTitle:@"取消"
                                                     rightButtonTitles:@"继续"];
                weakSelf.alert.rightBtnBlock = ^{
                    [weakSelf _updateToken];
                };
                [weakSelf.alert show];
            }else {
                [weakSelf _updateToken];
            }
        }];
    }else {
        if(self.alert)
            return;
        if(status == AFNetworkReachabilityStatusNotReachable) {
            self.alert = [[HXSCustomAlertView alloc] initWithTitle:@"警告"
                                                           message:@"无法连接网络，请检查网络设置！"
                                                   leftButtonTitle:@"确定"
                                                 rightButtonTitles:nil];
            [self.alert show];
        }else if(status == AFNetworkReachabilityStatusReachableViaWWAN) {
            __weak HXSUserAccount *weakSelf = self;
            self.alert = [[HXSCustomAlertView alloc] initWithTitle:@"警告"
                                                           message:@"您正在使用移动数据，将产生通信费用，是否继续？"
                                                   leftButtonTitle:@"取消"
                                                 rightButtonTitles:@"继续"];
            self.alert.rightBtnBlock = ^{
                [weakSelf _updateToken];
            };
            [self.alert show];
        }else {
            [self _updateToken];
        }
    }
}

- (void)_updateToken {
    if(self.tokenUpdating) {
        return;
    }
    
    self.tokenUpdating = YES;
    __weak typeof(self) weakSelf = self;
    
    [[HXSUpdateTokenRequest currentRequest] startUpdateTokenWithDeviceId:[HXAppDeviceHelper uniqueDeviceIdentifier] siteId:@(0) userId:self.userID complete:^(HXSErrorCode errorcode, NSString *msg, NSString *token) {
        weakSelf.tokenUpdating = NO;
        if(errorcode == kHXSNoError && token != nil) {
            weakSelf.strToken = token;
            
            //更新购物车，通知界面更新
            BEGIN_MAIN_THREAD
            [[NSNotificationCenter defaultCenter] postNotificationName:kTokenRefreshed object:nil];
            END_MAIN_THREAD
        }else {
            BEGIN_MAIN_THREAD
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"错误"
                                                                              message:msg
                                                                      leftButtonTitle:@"确定"
                                                                    rightButtonTitles:nil];
            
            [alertView show];
            
            END_MAIN_THREAD
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.tokenUpdating = NO;
    });;
}

- (void) loadUserInfo
{
    
    if ([self isLogin]) {
        [HXSDirectoryManager createDirectoryAtPath:[self homeDirectory]];
        
        self.userInfo = [[HXSUserInfo alloc] init];
    }
}

- (void)registerWithMobile:(NSString *)mobile password:(NSString *)password invitationcode:(NSString *)invitationcode completeBlock:(void (^)(HXSErrorCode, NSString *, HXSUserBasicInfo *))block{
    self.registerRequest = [[HXSRegisterRequest alloc] init];
    [self.registerRequest registerWithMobile:mobile password:password invitationcode:invitationcode completeBlock:^(HXSErrorCode errorcode, NSString *msg, NSNumber *userID, HXSUserBasicInfo *info) {
        
        if (errorcode == kHXSNoError){
            [HXSAccountManager sharedManager].accountType = kHXSUnknownAccount;
            
            self.userID = userID;
            
            [self loadUserInfo];
        
            self.userInfo.basicInfo = info;
        
            [self.userInfo updateUserInfo];
        
            block(errorcode, msg, info);
        
            BEGIN_MAIN_THREAD
            NSDictionary *postLoginInfo = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:errorcode], @"code",@"注册成功",@"msg", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleted object:nil userInfo:postLoginInfo];
        
            [[HXSDeviceUpdateRequest currentRequest] startUpdate];
            END_MAIN_THREAD
        }else{
            self.userInfo = nil;
        
            block(errorcode, msg, info);

            BEGIN_MAIN_THREAD
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleted object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg",[NSNumber numberWithInt:errorcode], @"code", nil]];
            END_MAIN_THREAD
        }
    }];
}

- (void) login:(NSString *)mobile password:(NSString *)password
{
    self.loginRequest = [[HXSLoginRequest alloc] init];
    [self.loginRequest loginWith:mobile password:password completeBlock:^(HXSErrorCode errorcode, NSString *msg, NSNumber *userID, HXSUserBasicInfo *basicInfo) {
        if (errorcode == kHXSNoError)
        {
            [HXSAccountManager sharedManager].accountType = kHXSUnknownAccount;
            
            self.userID = userID;
            
            [self loadUserInfo];
        
        self.userInfo.basicInfo = basicInfo;
        
            BEGIN_MAIN_THREAD
            NSDictionary *postLoginInfo = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:errorcode], @"code",@"登录成功",@"msg", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleted object:nil userInfo:postLoginInfo];
        
            [[HXSDeviceUpdateRequest currentRequest] startUpdate];
            END_MAIN_THREAD
        }
        else
        {
            self.userInfo = nil;
            
            BEGIN_MAIN_THREAD
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleted object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg",[NSNumber numberWithInt:errorcode], @"code", nil]];
            END_MAIN_THREAD
        }
    }];
}

- (void) loginWithThirdAccount:(NSString *)userID token:(NSString *)token
{
    self.loginRequest = [[HXSLoginRequest alloc] init];
    [self.loginRequest loginWithThirdAccount:userID accountToken:token accountType:[HXSAccountManager sharedManager].accountType completeBlock:^(HXSErrorCode errorcode, NSString *msg, NSNumber *userID, HXSUserBasicInfo *basicInfo) {
        if (errorcode == kHXSNoError)
        {
            self.userID = userID;
            
            [self loadUserInfo];
        
            self.userInfo.basicInfo = basicInfo;

            BEGIN_MAIN_THREAD
            NSDictionary *postLoginInfo = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:errorcode], @"code",@"登录成功",@"msg", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleted object:nil userInfo:postLoginInfo];
        
            [[HXSDeviceUpdateRequest currentRequest] startUpdate];
            END_MAIN_THREAD
        }
        else
        {
            self.userInfo = nil;
            
            BEGIN_MAIN_THREAD
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleted object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg",[NSNumber numberWithInt:errorcode], @"code", nil]];
            END_MAIN_THREAD
        }
    }];
}

- (BOOL) isLogin
{
    if (self.userID && self.userID.integerValue > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void) logout
{
    if ([self isLogin])
    {
        self.logoutRequest = [[HXSLogoutRequest alloc] init];
        [self.logoutRequest startRequest:self.userID token:self.strToken];
        
        if (self.userInfo != nil)
        {
            [self.userInfo logout];
        }
        
        self.userID = nil;
        self.userInfo = nil;
        
        [[HXSAccountManager sharedManager] clearAccounts];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutCompleted object:nil];
    }
}

- (NSString *) homeDirectory
{
    NSString * strPath = [HXSDirectoryManager getCachesDirectory];
    strPath = [strPath stringByAppendingPathComponent:self.userID.stringValue];
    if (![[NSFileManager defaultManager] fileExistsAtPath:strPath isDirectory:nil])
    {
        [HXSDirectoryManager createDirectoryAtPath:strPath];
    }
    
    return strPath;
}

@end
