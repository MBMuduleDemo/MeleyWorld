//
//  HKBaseViewController.m
//  Housekeeper
//
//  Created by chsasaw on 2017/2/16.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "HKBaseViewController.h"

@interface HKBaseViewController ()

@end

@implementation HKBaseViewController

+ (instancetype)controllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:[self storyboardName] bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

+ (NSString *)storyboardName {
    NSAssert(NO, @"must be override by subclass");
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = ML_BG_MAIN_COLOR;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initNavigationBarStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBarStatus{
    self.navigationItem.backBarButtonItem = nil;
    
    if (nil == self.navigationItem.leftBarButtonItem) {
        UIImage *leftItemImage = [UIImage imageNamed:(self.navigationController.viewControllers.count == 1 ? @"nav-close" : @"nav-back")];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftItemImage
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(back)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
}

- (void)back {
    if(self.navigationController.viewControllers.count == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)canBeDismissed {
    return self.presentingViewController != nil || (self.navigationController.viewControllers.count == 1 && self.navigationController.presentingViewController == nil);
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
