//
//  MLCommentListViewController.m
//  meyley
//
//  Created by chsasaw on 2017/4/4.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLCommentListViewController.h"

@interface MLCommentListViewController ()

@end

@implementation MLCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTheNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTheNavigationBar
{
    self.navigationItem.title = @"评论记录";
}

@end
