//
//  LQUmengPush.swift
//  LQUmengNew
//
//  Created by LiuQiqiang on 2018/7/1.
//  Copyright © 2018年 LiuQiqiang. All rights reserved.
//

import UIKit
import NotificationCenter

class LQUmengPush: NSObject {

    
    
    func action() {
        
//        let action1 = u()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerForRemoteNotifications(_ options: [String: Any]? = nil) {
        
        let entity = UMessageRegisterEntity.init()
        //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue)|Int(UMessageAuthorizationOptions.sound.rawValue)|Int(UMessageAuthorizationOptions.alert.rawValue)
        
        UNUserNotificationCenter.current().delegate = self
        
        UMessage.registerForRemoteNotifications(launchOptions: options, entity: entity) { (success, error) in
            
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        UMessage.setAutoAlert(false)
        if Int(UIDevice.current.systemVersion)! < 10 {
            UMessage.didReceiveRemoteNotification(userInfo)
        }
        
        completionHandler(.newData)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
    }
    
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
    }
}


























