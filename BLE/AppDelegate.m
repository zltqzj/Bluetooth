//
//  AppDelegate.m
//  BLE
//
//  Created by ZKR on 5/4/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setBarTintColor:MAIN_COLOR];
    [[UITabBar appearance] setTintColor:MAIN_COLOR];
    [[UITabBar appearance] setBackgroundColor:TABBAR_COLOR];
    // Override point for customization after application launch.
    
   
#pragma mark - 推送设置   // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |  UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |  UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
//    UILocalNotification *notification = [self  localNotificationWithPushDate:[NSDate dateWithTimeIntervalSinceNow:2]  RepeatInterval:0 title:@"123" body:@"333"];
//      [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    return YES;
}


/**
 *  创建本地推送
 *
 *  @param pushDate       推送触发时间
 *  @param repeatInterval 重复间隔
 *  @param title          显示标题
 *  @param body           显示内容
 *
 *  @return 本地推送
 */
- (UILocalNotification *)localNotificationWithPushDate:(NSDate *)pushDate RepeatInterval:(NSCalendarUnit)repeatInterval title:(NSString *)title body:(NSString *)body{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {//判断系统是否支持本地通知
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        notification.repeatInterval = repeatInterval;
        // 推送内容
        notification.alertBody = body;
        // 解锁按钮文字
        notification.alertAction = title;
        // 显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber += 1;
    }
    return notification;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    
    
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber  = 0;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber  = 0;
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
