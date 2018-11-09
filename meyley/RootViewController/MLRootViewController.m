//
//  MLRootViewController.m
//  meyley
//
//  Created by chsasaw on 2017/2/19.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "MLRootViewController.h"
#import "SDImageCache.h"
#import "HXSUserAccount.h"
#import "HXStoreLogin.h"
#import "HKBaseNavigationController.h"
#import "HXSLoginViewController.h"
#import "HXSBaseViewController.h"

@interface MLRootViewController ()<UITabBarControllerDelegate>

@end

@implementation MLRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.selectedViewController beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.selectedViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.selectedViewController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.selectedViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    // Do nothing
}


#pragma mark - Override Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.selectedViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger controllerIdx = [self.viewControllers indexOfObject:viewController];
    
    if (controllerIdx == 1 || controllerIdx == 3 || controllerIdx == 4) {
        WS(weakSelf);
        if (![HXSUserAccount currentAccount].isLogin) {
            [HXSLoginViewController showLoginController:self loginCompletion:^{
                [weakSelf setSelectedIndex:controllerIdx];
            }];
            return NO;
        }
    }
    
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.selectedIndex == [tabBar.items indexOfObject:item]) {
        HKBaseNavigationController * nav = (HKBaseNavigationController *)self.selectedViewController;
        HKBaseViewController * viewController = (HKBaseViewController *)nav.viewControllers[0];
        if([viewController respondsToSelector:@selector(tokenRefreshed)]) {
            [viewController performSelector:@selector(tokenRefreshed)];
        }
    }
}

#pragma mark - public method

- (BOOL)checkIsLoggedin{
    if([HXSUserAccount currentAccount].isLogin) {
        return YES;
    }else {
        BEGIN_MAIN_THREAD
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
        }];
        END_MAIN_THREAD
        
        return NO;
    }
}

@end
