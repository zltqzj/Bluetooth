//
//  config.h
//  Travel
//
//  Created by ZKR on 1/4/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
// 

#ifndef Travel_config_h
#define Travel_config_h

//#define NO_DEBUG_VIEW

#ifdef DEBUG  // 唐巧
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

//#import "UIDeviceHardware.h"
#pragma mark - 普通常量定义

#define EMPTY_STRING        @""

#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define MAX_POINT 10  //最多点的个数
#define MIN_DISTANCE 0.5

// 数值转为字符串
#define valueToString(_value) [@(_value) stringValue]

#define PI 3.14159265358979323846264338327950288

#define CANNOT_CONNECT_TO_INTERNET  ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) && ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)

// 是否已经登录
#define IS_LOGIN @"is_login"


#define WHAT_NEW @" "

#define viewOnSb(identifer)  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifer]

#define GetAppDelegate (AppDelegate*)([UIApplication sharedApplication].delegate)

#define PLAY_VOICE  1
#define CONNECTBLE 1
#define  PLAY_PER_MINS 300  // 每六十秒播放一次声音


#define PLAY_SOUND_BY_KILOMETER @"kilometer"
#define PLAY_SOUND_BY_TIME @"time"

//聚光灯
#define NEWS_GUIDE @"guide"
#define FEED_DETAIL_GUIDE @"FEED_DETAIL_GUIDE"
#define DEVICE_GUIDE @"DEVICE_GUIDE"

#pragma mark - 判断设备
// 屏幕高度
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

// IPHONE
#define IS_IPHONE [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone


// 判断是否为iphone 6
#define IS_IPHONE6() ([[UIScreen mainScreen] bounds].size.height == 667)
#define IS_IPHONE6_PLUS() ([[UIScreen mainScreen] bounds].size.height == 736)

#define ORINGIN_X(view) view.frame.origin.x
#define ORINGIN_Y(view) view.frame.origin.y

#define VIEW_WIDTH(view)  view.frame.size.width
#define VIEW_HEIGHT(view)  view.frame.size.height

//_avatarBtn.frame.size.height

// IPAD
#define IS_IPAD [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPad

// 判断是否为IPHONE5
# define IS_IPHONE5  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

// 判断设备版本
// 版本等于
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

// 版本高于
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

// 版本高于等于
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// 版本小于
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

// 版本小于等于
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 判断是否大于7
#define ISIOS7  [[[UIDevice currentDevice] systemVersion] floatValue]>=7

//判断是否大于8
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)



// 持久化存储用户ID 和邮箱
#define CURRENT_USER_ID [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
#define CURRENT_USER_EMAIL  [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"]
#define HEALTH_MODELVIEW_APPEAR [[NSUserDefaults standardUserDefaults] objectForKey:@"health_modelview_appear"]


//  获取当前的APP版本号
#define CURRENT_APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 当前设备的版本号
#define CURREN_DEVICE_VERSON [[UIDevice currentDevice] systemVersion]

// 当前设备的名字（谁的iphone）
#define CURREN_DEVICE_NAME [[UIDevice currentDevice] name]

// 当前设备的名字(iPhone 4S) [UIDeviceHardware platformString]    NSLog(@"%@",CURRENT_DEVICE_PLATFORM_NAME);
#define CURRENT_DEVICE_PLATFORM_NAME  [UIDeviceHardware platformString]
#define CHANGE_LANGUAGE @"CHANGE_LANGUAGE"

//多语言切换
#define AppLanguage @"appLanguage"
#define CustomLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj" ]] localizedStringForKey:(key) value:@"" table:nil]
#pragma mark - RGB 颜色
// RGB颜色
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ORANGE_COLOR RGB(245, 115, 11)

#define SPLIT_COLOT [UIColor colorWithRed:30/255.0 green:167/255.0 blue:224/255.0 alpha:1]

#define MAIN_COLOR  RGB(59, 197, 204)
#define TABBAR_COLOR RGB(18, 18, 18)

// 设置导航栏格式
//#define SETTING_NAVGATION_STYLE [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIColor whiteColor], UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,nil]];
#define SETTING_NAVGATION_STYLE [self.navigationController.navigationBar setBarTintColor:MAIN_COLOR]; [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Arial-Bold" size:0.0], NSFontAttributeName, nil]];

// 查看一段代码运行的时间
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])
//调用方式
//TICK
////do your work here
//TOCK


#pragma mark - URL CONFIG
#define GPS1_RESULT  @"http://123.57.248.43:9003/server.php?action=getList1"

#define GPS2_RESULT  @"http://123.57.248.43:9003/server.php?action=getList2"

#define GPS3_RESULT  @"http://123.57.248.43:9003/server.php?action=getList3"

#endif
