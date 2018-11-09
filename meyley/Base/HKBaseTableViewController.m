//
//  HKBaseTableViewController.m
//  Housekeeper
//
//  Created by chsasaw on 2017/2/16.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "HKBaseTableViewController.h"

@interface HKBaseTableViewController ()

@end

@implementation HKBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initNavigationBarStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBarStatus
{
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.backBarButtonItem = nil;
    
    if (nil == self.navigationItem.leftBarButtonItem) {
        UIImage *leftItemImage = [UIImage imageNamed:(self.navigationController.viewControllers.count == 1 ? @"ic_close" : @"ic_back")];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftItemImage
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(back)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
    }
}

- (void)back {
    if(self.navigationController.viewControllers.count == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
