//
//  WKWebViewController.m
//  meyley
//
//  Created by chsasaw on 2017/2/19.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "HXSUserAccount.h"
#import "HXSUserInfo.h"
#import "HXSUserBasicInfo.h"

@interface WKWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKUserContentController *contentController;
@property (nonatomic, copy) NSURL *URL;

@end

@implementation WKWebViewController

- (WKWebView *)webView {
    if(_webView == nil) {
        NSString *userInfoString = [[HXSUserAccount currentAccount].userInfo.basicInfo toJSONString];
        NSString *jsString = [NSString stringWithFormat:@"\
                              window.JsProxy = { \
                              login:login \
                              };\
                              function login() { \
                              return '%@'; \
                              };", userInfoString];
        //javascript 注入
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:jsString
                                                                injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                             forMainFrameOnly:YES];
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addUserScript:noneSelectScript];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        self.contentController = userContentController;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        [self.view addSubview:_webView];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo:) name:kLoginCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo:) name:kLogoutCompleted object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshUserInfo:(NSNotification *)noti {
    [_webView removeFromSuperview];
    self.webView = nil;
    self.URL = nil;
}

- (void)loadUrl:(NSURL *)URL {
    if([URL.absoluteString isEqualToString:self.URL.absoluteString] && _webView) {
        return;
    }
    
    self.URL = URL;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

- (void)loadHTMLString:(NSString *)htmlString withTitle:(NSString *)title {
    [self.webView loadHTMLString:htmlString baseURL:nil];
    self.navigationItem.title = title;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    self.navigationItem.title = webView.title;
    
    [_webView evaluateJavaScript:@"window.JsProxy.login();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"%@", data);
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    if(webView != _webView) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
