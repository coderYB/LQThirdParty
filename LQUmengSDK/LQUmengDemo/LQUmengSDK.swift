//
//  LQUmengSDK.swift
//  LQUmengDemo
//
//  Created by Artron_LQQ on 2017/11/16.
//  Copyright © 2017年 Artup. All rights reserved.
//
// Umeng AppKey
let kLQUmengSDK_UMengAppKey = ""

// QQ
let kLQUmengSDK_QQAppID = ""
let kLQUmengSDK_QQAppKey = ""
// Wechat
let kLQUmengSDK_WechatAppID = ""
let kLQUmengSDK_WechatAppSecret = ""
// SinaWeibo
let kLQUmengSDK_SinaWeiboAppKey = ""
let kLQUmengSDK_SinaWeiboAppSecret = ""
let kLQUmengSDK_SinaWeibOredirectUri = ""

import UIKit

enum LQLoginType {
    case qq, wechat, sinaWeibo
}

enum LQShareSession {
    case wechatSession, wechatTimeline, wechatFavorite, sina, qq, qzone
}

class LQUmengSDK: NSObject {

    class func registApp() {
        // 打开调试模式日志
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = kLQUmengSDK_UMengAppKey
        //        UMSocialManager.default().umSocialAppSecret = ""
        
        // 关闭强制验证https, 即可分享http链接图片
UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = false
    
       //注册微信
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: kLQUmengSDK_WechatAppID, appSecret: kLQUmengSDK_WechatAppSecret, redirectURL: "")
        
        //注册QQ
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: kLQUmengSDK_QQAppID, appSecret: nil, redirectURL: "")
        
        // 注册新浪微博
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: kLQUmengSDK_SinaWeiboAppKey, appSecret: kLQUmengSDK_SinaWeiboAppSecret, redirectURL: kLQUmengSDK_SinaWeibOredirectUri)
    }
    
    @discardableResult
    class func handle(_ url: URL, source: String? = nil, annotation: Any? = nil, options: [String: Any]? = nil) -> Bool {
        
        if let opt = options {
            return UMSocialManager.default().handleOpen(url, options: opt)
        } else if let ant = annotation {
            return UMSocialManager.default().handleOpen(url,sourceApplication: source, annotation: ant)
        } else {
            return UMSocialManager.default().handleOpen(url)
        }
    }
    
//    @discardableResult
//    class func handle(_ url: URL, source: String?, annotation: Any) -> Bool {
//        
//        return UMSocialManager.default().handleOpen(url,sourceApplication: source, annotation: annotation)
//    }
//    
//    // ios 9 +
//    @discardableResult
//    func handle(_ url: URL, options: [String: Any]) -> Bool {
//        return UMSocialManager.default().handleOpen(url, options: options)
//    }
//    
//    @discardableResult
//    class func handle(_ url: URL) -> Bool {
//        return UMSocialManager.default().handleOpen(url)
//    }
    
    class func isWechatInstall() -> Bool {
        
        return UMSocialManager.default().isInstall(UMSocialPlatformType.wechatSession)
    }
    
    /// 登录
    ///
    /// - Parameters:
    ///   - type: 登录类型
    ///   - viewController: 当前控制器
    ///   - handle: 成功回调
    ///   - failed: 失败回调
    class func login(_ type: LQLoginType, onViewController viewController: UIViewController? = nil, success handle: @escaping ((_ uid: String, _ name: String, _ url: String, _ sex: String) -> Void), failed: ((_ error: Error) -> Void)?) {
        
        var loginType: UMSocialPlatformType? = nil
        
        if type == .qq {
            loginType = UMSocialPlatformType.QQ
        } else if type == .wechat {
            loginType = UMSocialPlatformType.wechatSession
        } else if type == .sinaWeibo {
            loginType = UMSocialPlatformType.sina
        }
        
        if let login = loginType {
            // 取消上次授权
            UMSocialManager.default().cancelAuth(with: login) { (result, error) in }
            
            UMSocialManager.default().getUserInfo(with: login, currentViewController: viewController) { (result, error) in
                
                if let resp = result as? UMSocialUserInfoResponse {
                    
                    var uid = ""
                    if resp.uid != nil {
                        uid = resp.uid!
                    }
                    
                    var name = ""
                    if resp.name != nil {
                        name = resp.name!
                    }
                    
                    var icon = ""
                    if resp.iconurl != nil {
                        icon = resp.iconurl
                    }
                    
                    var gender = ""
                    if resp.unionGender != nil {
                        gender = resp.unionGender!
                    }
                    
                    handle(uid, name, icon, gender)
                } else {
                    if let hd = failed {
                        hd(error!)
                    }
                }
            }
        }
    }
}

//MARK: - 分享
extension LQUmengSDK {
    
    /// 分享音乐
    ///
    /// - Parameters:
    ///   - url: 音乐url
    ///   - title: 音乐标题
    ///   - thumbImage: 音乐缩略图
    ///   - descr: 音乐描述
    ///   - session: 分享到的平台
    ///   - vc: 当前控制器
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func shareMusic(_ url: String, title: String?, descr: String?, thumbImage: Any?, to session: LQShareSession, onViewController vc: UIViewController? = nil, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let obj = UMShareMusicObject()
        
        obj.title = title
        obj.descr = descr
        obj.thumbImage = thumbImage
        obj.musicUrl = url
        
        let message = UMSocialMessageObject(mediaObject: obj)
        UMSocialManager.default().share(to: UMSocialPlatformType.wechatSession, messageObject: message, currentViewController: vc) { (info, error) in
            if info != nil {
                if let handle = success {
                    handle()
                }
            } else {
                if let handle = failed {
                    handle()
                }
            }
        }
    }
    
    /// 分享视频
    ///
    /// - Parameters:
    ///   - url: 视频地址
    ///   - title: 视频标题
    ///   - thumbImage: 视频缩略图
    ///   - descr: 视频描述
    ///   - session: 分享到的平台
    ///   - vc: 当前控制器
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func shareVideo(_ url: String, title: String?, descr: String?, thumbImage: Any?, to session: LQShareSession, onViewController vc: UIViewController? = nil, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let obj = UMShareVideoObject()
        
        obj.title = title
        obj.descr = descr
        // 视频缩略图
        obj.thumbImage = thumbImage
        // 视频网页url
        obj.videoUrl = url
        
        let message = UMSocialMessageObject(mediaObject: obj)
        UMSocialManager.default().share(to: UMSocialPlatformType.wechatSession, messageObject: message, currentViewController: vc) { (info, error) in
            if info != nil {
                if let handle = success {
                    handle()
                }
            } else {
                if let handle = failed {
                    handle()
                }
            }
        }
    }
    
    /// 分享文本
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - session: 分享到的平台
    ///   - vc: 当前控制器
    ///   - success: 成回调
    ///   - failed: 失败回调
    class func shareText(_ text: String, to session: LQShareSession, onViewController vc: UIViewController? = nil, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let message = UMSocialMessageObject()
        message.text = text
        
        UMSocialManager.default().share(to: shareSession(session), messageObject: message, currentViewController: vc) { (info, error) in
            if info != nil {
                if let handle = success {
                    handle()
                }
            } else {
                if let handle = failed {
                    handle()
                }
            }
        }
    }
    
    /// 分享图片
    ///
    /// - Parameters:
    ///   - image: 图片内容, 可以是UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象, 如果是一组图片, 分享第一张
    ///   - thumbImage: 缩略图
    ///   - session: 分享到的平台
    ///   - vc: 当前控制器
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func shareImage(_ image: Any, thumbImage: Any? = nil, to session: LQShareSession, onViewController vc: UIViewController? = nil, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let obj = UMShareImageObject()
        
        obj.shareImage = image
        obj.thumbImage = thumbImage
        
        let message = UMSocialMessageObject(mediaObject: obj)
        
        UMSocialManager.default().share(to: shareSession(session), messageObject: message, currentViewController: vc) { (info, error) in
            
            if info != nil {
                if let handle = success {
                    handle()
                }
            } else {
                if let handle = failed {
                    handle()
                }
            }
        }
    }
    
    /// 分享网页
    ///
    /// - Parameters:
    ///   - webUrl: 网页地址
    ///   - title: 网页标题
    ///   - thumbUrl: 网页缩略图
    ///   - descr: 网页描述
    ///   - session: 分享到的平台
    ///   - vc: 当前控制器
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func shareWeb(_ webUrl: String, title: String, thumbUrl: Any, descr: String, to session: LQShareSession, onViewController vc: UIViewController? = nil, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let obj = UMShareWebpageObject()
        obj.thumbImage = thumbUrl
        obj.title = title
        obj.descr = descr
        obj.webpageUrl = webUrl
        
        let message = UMSocialMessageObject(mediaObject: obj)
        
        UMSocialManager.default().share(to: shareSession(session), messageObject: message, currentViewController: vc) { (info, error) in
            if info != nil {
                if let handle = success {
                    handle()
                }
            } else {
                if let handle = failed {
                    handle()
                }
            }
        }
    }
    
    class func shareUmengUI() {
        
        UMSocialUIManager.showShareMenuViewInWindow { (type, info) in
            
        }
    }
    
    private class func shareSession(_ session: LQShareSession) -> UMSocialPlatformType {
        switch session {
        case .wechatSession:
            return UMSocialPlatformType.wechatSession
        case .wechatTimeline:
            return UMSocialPlatformType.wechatTimeLine
        case .wechatFavorite:
            return UMSocialPlatformType.wechatFavorite
        case .qq:
            return UMSocialPlatformType.QQ
        case .qzone:
            return UMSocialPlatformType.qzone
        case .sina:
            return UMSocialPlatformType.sina
        }
    }
}
