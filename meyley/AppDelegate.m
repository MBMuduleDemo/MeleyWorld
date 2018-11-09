//
//  AppDelegate.m
//  meyley
//
//  Created by chsasaw on 2017/2/18.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "HXAppDeviceHelper.h"
#import "IQKeyboardManager.h"
#import "AppDelegate+LGPay.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (MLRootViewController *) rootViewController{
    UIViewController * controller;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0") && ([UIApplication sharedApplication].windows.count > 0)) {
        controller = [UIApplication sharedApplication].windows[0].rootViewController;
    }
    else {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    if([controller isKindOfClass:[MLRootViewController class]]) {
        return (MLRootViewController *)controller;
    }else if([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)controller;
        for(UIViewController * root in nav.viewControllers) {
            if([root isKindOfClass:[MLRootViewController class]]) {
                return (MLRootViewController *)root;
            }
        }
    }
    
    return nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    
    [self setupCache];
    
    [self setupInitialStatusOfBusiness];
    
    [self initCustomUniversal];
    
    [self initCustomControlPhone];
    
    [HXSUserAccount currentAccount];
    
    
    NSLog(@"product service URL %@ = debug  service url %@== service type %ld",[[ApplicationSettings instance]currentHttpsServiceURL],[[ApplicationSettings instance]currentServiceURL],(long)[[ApplicationSettings instance]currentEnvironmentType]);
    
    //第三方支付
    [self thirdPayApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupCache{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:200 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [HXSDirectoryManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[HXSDirectoryManager getDocumentsDirectory]]];
    [HXSDirectoryManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[HXSDirectoryManager getLibraryDirectory]]];
}

- (void)setupInitialStatusOfBusiness {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - Initial Methods

- (void)initCustomUniversal{

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:ML_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setBarTintColor:ML_MAIN_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeZero;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                                         NSShadowAttributeName:shadow};
    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setTintColor:[UIColor whiteColor]];
}

- (void)initCustomControlPhone{
    // UITabBar
    [UITabBar appearance].backgroundColor = [UIColor whiteColor];
    [UITabBar appearance].backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [UITabBar appearance].shadowImage = [UIImage imageWithColor:ML_TEXT_LIGHT_COLOR];
    [UITabBar appearance].selectionIndicatorImage = [UIImage imageWithColor:[UIColor clearColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    [UITabBar appearance].tintColor = ML_ACCENT_COLOR;
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: ML_ACCENT_COLOR,
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                                        NSShadowAttributeName:shadow}
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: ML_TEXT_MAIN_COLOR,
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                                        NSShadowAttributeName:shadow}
                                             forState:UIControlStateNormal];
}

@end
