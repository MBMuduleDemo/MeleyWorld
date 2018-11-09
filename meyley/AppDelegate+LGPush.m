//
//  AppDelegate+LGPush.m
//  meyley
//
//  Created by Bovin on 2018/10/16.
//  Copyright © 2018年 Meyley. All rights reserved.
//

#import "AppDelegate+LGPush.h"

#import "MiPushSDK.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (LGPush)

- (void)registerNotoficationWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MiPushSDK registerMiPush:self type:0 connect:YES];
    
    // 点击通知打开app处理逻辑
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){ //应用在点击推送时启动，获取推送消息并跳转
        
    }
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [MiPushSDK bindDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"远程通知注册失败: %@", error);
}
#pragma mark--UNUserNotificationCenterDelegate--
/** iOS 10.0 之后所有通知接收处理*/
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
//    NSLog(@"我即将收到通知消息 %@",notification.request.content);
//    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    //点击通知时调用处理
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationContent *content = response.notification.request.content; // 收到推送的消息内容
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"didReceive收到远程通知:{body:%@,\ntitle:%@,\nsubtitle:%@,\nbadge：%@,\nsound：%@,\nuserInfo：%@}",content.body,content.title,content.subtitle,content.badge,content.sound,userInfo);
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }else {
        if([response.actionIdentifier isEqualToString:@"action.sure"]) {
            
        }else {
            
        }
        NSLog(@"didReceive收到本地通知:{body:%@,\ntitle:%@,\nsubtitle:%@,\nbadge：%@,\nsound：%@,\nuserInfo：%@}",content.body,content.title,content.subtitle,content.badge,content.sound,userInfo);
        
        
    }
    
    completionHandler();
}
//ios 10以前接收到通知或者所有的静默通知处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
/** iOS 10.0 之前的本地通知接收处理*/
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) { //前台
        NSLog(@"ios10之前，前台收到本地通知 %@",notification);
    }else { //在后台或即将进入前台
        NSLog(@"ios10之前，进入前台处理本地通知 %@",notification);
    }
}

#pragma mark--MiPushSDKDelegate
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    
    if ([selector isEqualToString:@"registerMiPush:"]) {
        
    }else if ([selector isEqualToString:@"registerApp"]) {
        // 获取regId
        NSLog(@"regid = %@", data[@"regid"]);
    }else if ([selector isEqualToString:@"bindDeviceToken:"]) {
        [MiPushSDK setAlias:@"dailybuild_test_alias"];
        [MiPushSDK subscribe:@"dailybuild_test_topic"];
        [MiPushSDK setAccount:@"dailybuild_test_account"];
        // 获取regId
        NSLog(@"regid = %@", data[@"regid"]);
    }else if ([selector isEqualToString:@"unregisterMiPush"]) {

    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{

}

- (void)miPushReceiveNotification:(NSDictionary*)data
{
    // 1.当启动长连接时, 收到消息会回调此处
    // 2.[MiPushSDK handleReceiveRemoteNotification]
    //   当使用此方法后会把APNs消息导入到此
  
}

- (NSString*)getOperateType:(NSString*)selector
{
    NSString *ret = nil;
    if ([selector hasPrefix:@"registerMiPush:"] ) {
        ret = @"客户端注册设备";
    }else if ([selector isEqualToString:@"unregisterMiPush"]) {
        ret = @"客户端设备注销";
    }else if ([selector isEqualToString:@"registerApp"]) {
        ret = @"注册App";
    }else if ([selector isEqualToString:@"bindDeviceToken:"]) {
        ret = @"绑定 PushDeviceToken";
    }else if ([selector isEqualToString:@"setAlias:"]) {
        ret = @"客户端设置别名";
    }else if ([selector isEqualToString:@"unsetAlias:"]) {
        ret = @"客户端取消别名";
    }else if ([selector isEqualToString:@"subscribe:"]) {
        ret = @"客户端设置主题";
    }else if ([selector isEqualToString:@"unsubscribe:"]) {
        ret = @"客户端取消主题";
    }else if ([selector isEqualToString:@"setAccount:"]) {
        ret = @"客户端设置账号";
    }else if ([selector isEqualToString:@"unsetAccount:"]) {
        ret = @"客户端取消账号";
    }else if ([selector isEqualToString:@"openAppNotify:"]) {
        ret = @"统计客户端";
    }else if ([selector isEqualToString:@"getAllAliasAsync"]) {
        ret = @"获取Alias设置信息";
    }else if ([selector isEqualToString:@"getAllTopicAsync"]) {
        ret = @"获取Topic设置信息";
    }
    
    return ret;
}

@end
