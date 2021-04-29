
//#import "FlutterAlipayPlugin.h"
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <UMCommon/UMConfigure.h>
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>

#define APPKEY @"824c12a64440fbf70e767a3e"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟移动统计集成
//    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"5e82e0a00cafb27dda0003ce" channel:@"App Store"];
//    NSString * deviceId=[UMConfigure deviceIDForIntegration];
//    NSLog(@"集成测试：%@",deviceId);
    
    //极光推送
    //注册通知 通知回调代理
    JPUSHRegisterEntity * entity=[[JPUSHRegisterEntity alloc]init];
    if (@available(iOS 12.0, *)) {
        entity.types=JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //初始化SDK
    [JPUSHService setupWithOption:launchOptions appKey:APPKEY channel:@"App Store" apsForProduction:YES advertisingIdentifier:nil];
    
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"Notification"]){
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Notification"];
    }
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    NSLog(@"[NBYJY]=========>%@",url);
//    return NO;
//}
//
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [WXApi handleOpenURL:url delegate:[FluwxResponseHandler defaultManager]];
//}
// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//        NSLog(@"[NBYJY]openUrl=========>%@",url);
    //支付宝回调
//    if ([url.host isEqualToString:@"safepay"]) {
//    return [FlutterAlipayPlugin handleOpenURL:url];
//    }
//    return NO;
//}
//- (void)applicationWillResignActive:(UIApplication *)application {
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//
//}
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//
//}
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//}
//- (void)applicationWillTerminate:(UIApplication *)application {
//}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //sdk注册DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
//设置消息送达代理
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
  
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler();  // 系统要求执行这个方法
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    NSLog(@"receive notification authorization status:%lu, info:%@", (unsigned long)status, info);
}

#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
    NSString *title = nil;
    if (notification) {
        title = @"从通知界面直接进入应用";
    }else{
        title = @"从系统设置界面进入应用";
    }
    NSLog(@"%@", title);
}
#endif

//【iOS7以上系统，收到通知以及静默推送】
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

@end
