//
//  AppDelegate+LGPush.h
//  meyley
//
//  Created by Bovin on 2018/10/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "AppDelegate.h"

#ifdef __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate (LGPush)

/** 注册通知*/
- (void)registerNotoficationWithApplication:(UIApplication *)application  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
