//
//  LGGoodsDetailWebViewController.m
//  meyley
//
//  Created by mac on 2018/11/7.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "LGGoodsDetailWebViewController.h"

@interface LGGoodsDetailWebViewController ()
/**   */
@property (nonatomic , strong)UIWebView *webView;
@end

@implementation LGGoodsDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-topBarHeight)];
    self.webView.backgroundColor = [UIColor clearColor] ;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
