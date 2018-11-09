//
//  AppDelegate.h
//  meyley
//
//  Created by chsasaw on 2017/2/18.
//  Copyright © 2017年 Meyley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLRootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MLRootViewController *rootViewController;

+ (instancetype)sharedDelegate;

@end

