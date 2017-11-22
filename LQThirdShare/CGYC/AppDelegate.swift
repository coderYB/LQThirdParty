//
//  AppDelegate.swift
//  CGYC
//
//  Created by Artron_LQQ on 2017/5/23.
//  Copyright © 2017年 Artup. All rights reserved.
//
/* 简书博客: http://www.jianshu.com/u/2846c3d3a974
 Github: https://github.com/LQQZYY
 
 demo地址: https://github.com/LQQZYY/LDThirdShare-Swift
 博文讲解: http://www.jianshu.com/p/1b744a97e63d
         http://www.jianshu.com/p/c8db82d27b11
         http://www.jianshu.com/p/5a468f60c111
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LDWechatShare.registeApp("微信AppID", appSecret: "微信APPSecret")
        LDSinaShare.registeApp("新浪微博AppKey", appSecret: "新浪微博APPSecret", oredirectUri: "新浪微博授权回调URI", isDebug: true)// 是否开启Debug模式, 开启后会打印错误信息, 开发期建议开启
        LDTencentShare.registeApp("QQ的appid", appKey: "QQ的APPKey")
        
        return true
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        let urlKey: String = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        
        if urlKey == "com.tencent.xin"
        {
            // 微信 的回调
            return LDWechatShare.handle(url)
        } else if urlKey == "com.tencent.mqq"
        {
            
            // QQ 的回调
            return LDTencentShare.handle(url)
        } else if urlKey == "com.sina.weibo"
        {
            
            // 新浪微博 的回调
            return LDSinaShare.handle(url)
        }
        
        
        return true
    }
    // 新浪微博的H5网页登录回调需要实现这个方法
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // 这里的URL Schemes是配置在 info -> URL types中, 添加的新浪微博的URL schemes
        // 例如: 你的新浪微博的AppKey为: 123456789, 那么这个值就是: wb123456789
        if url.scheme == "URL Schemes" {
            // 新浪微博 的回调
            return LDSinaShare.handle(url)
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

