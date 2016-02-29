//
//  AppDelegate.m
//  LQQWeChatDemo
//
//  Created by Artron_LQQ on 16/2/29.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册APP,
    [WXApi registerApp:@"wxb4ba3c02aa476ea1"];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    // 跳转到URL scheme中配置的地址
    //NSLog(@"跳转到URL scheme中配置的地址-->%@",url);
    return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
}
//支付成功时调用，回到第三方应用中
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    LQQLog(@"****************url.host -- %@",url.host);
    if ([url.scheme isEqualToString:@"wx23a1f7f291ef4b3d"])
    {
        return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    return YES;
}

//微信回调,有支付结果的时候会回调这个方法
- (void)onResp:(BaseResp *)resp
{
    //    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    //    NSString *strTitle;
    //    if([resp isKindOfClass:[SendMessageToWXResp class]])
    //    {
    //        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    //    }
    
    //    支付结果回调
    if([resp isKindOfClass:[PayResp class]]){
        
        switch (resp.errCode) {
            case WXSuccess:{
                
                //支付返回结果，实际支付结果需要去自己的服务器端查询
                NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                break;
            }
            default:{
                NSNotification *notification = [NSNotification notificationWithName:@"ORDER_PAY_NOTIFICATION"object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
