
//#import "FlutterAlipayPlugin.h"
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <UMCommon/UMConfigure.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟移动统计集成
//    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"5e82e0a00cafb27dda0003ce" channel:@"App Store"];
//    NSString * deviceId=[UMConfigure deviceIDForIntegration];
//    NSLog(@"集成测试：%@",deviceId);
    
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
@end
