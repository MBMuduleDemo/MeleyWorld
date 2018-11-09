//
//  HKBaseNavigationController.m
//  Housekeeper
//
//  Created by chsasaw on 2017/2/16.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "HKBaseNavigationController.h"

@interface HKBaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation HKBaseNavigationController

#pragma mark - Initial Methods

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate = self;
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    viewController.hidesBottomBarWhenPushed = YES;
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = (navigationController.viewControllers.count >= 2);
    }
    if (!([viewController isKindOfClass:NSClassFromString(@"LGBrandDetailViewController")] || [viewController isKindOfClass:NSClassFromString(@"LGGoodsDetailViewController")])) {
        [navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:ML_MAIN_COLOR]  forBarMetrics:UIBarMetricsDefault];
        [navigationController.navigationBar setBarTintColor:ML_MAIN_COLOR];
        navigationController.navigationBar.translucent = NO;
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if ([viewController isKindOfClass:NSClassFromString(@"MLMainViewController")]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] &&
        gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    }
    return YES;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
//    if ([self.topViewController isKindOfClass:NSClassFromString(@"MLMainViewController")]) {
//        return UIStatusBarStyleDefault;
//    }
//    return UIStatusBarStyleLightContent;
    return [self.topViewController preferredStatusBarStyle];
}

@end
