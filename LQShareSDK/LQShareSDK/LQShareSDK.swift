//
//  LQShareSDK.swift
//  LQUmengDemo
//
//  Created by Artron_LQQ on 2017/11/16.
//  Copyright © 2017年 Artup. All rights reserved.
//

// ShareSDK AppID
let kShareSDK_AppID = ""
let kShareSDK_Secret = ""

// QQ
let kShareSDK_QQAppID = ""
let kShareSDK_QQAppKey = ""
// Wechat
let kShareSDK_WechatAppID = ""
let kShareSDK_WechatAppSecret = ""
// SinaWeibo
let kShareSDK_SinaWeiboAppKey = ""
let kShareSDK_SinaWeiboAppSecret = ""
let kShareSDK_SinaWeibOredirectUri = ""

import UIKit

enum LQLoginType {
    case qq, wechat, sinaWeibo
}

enum LQShareSession {
    case wechatSession, wechatTimeline, wechatFavorite, sina, qq, qzone
}

class LQShareSDK {

    class func registApp() {
        ShareSDK.registerActivePlatforms([SSDKPlatformType.typeQQ.rawValue, SSDKPlatformType.typeWechat.rawValue, SSDKPlatformType.typeSinaWeibo.rawValue], onImport: { (platform) in
            switch platform {
            case SSDKPlatformType.typeQQ:
                ShareSDKConnector.connectQQ(QQApiInterface.self, tencentOAuthClass: TencentOAuth.self)
            case SSDKPlatformType.typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.self)
            case SSDKPlatformType.typeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.self)
            default:
                break
            }
        }) { (platform, appInfo) in
            
            switch platform {
            case SSDKPlatformType.typeQQ:
                appInfo?.ssdkSetupQQ(byAppId: kShareSDK_QQAppID, appKey: kShareSDK_QQAppKey, authType: SSDKAuthTypeBoth)
            case SSDKPlatformType.typeWechat:
                appInfo?.ssdkSetupWeChat(byAppId: kShareSDK_WechatAppID, appSecret: kShareSDK_WechatAppSecret)
            case SSDKPlatformType.typeSinaWeibo:
                appInfo?.ssdkSetupSinaWeibo(byAppKey: kShareSDK_SinaWeiboAppKey, appSecret: kShareSDK_SinaWeiboAppSecret, redirectUri: kShareSDK_SinaWeibOredirectUri, authType: SSDKAuthTypeBoth)
            default:
                break
            }
        }
    }
    
    class func isWechatInstall() -> Bool {
        
        if WXApi.isWXAppSupport() && WXApi.isWXAppInstalled() {
            
            return true
        }
        return false
    }
    
    class func logout() {
        
        let isQQAuth = ShareSDK.hasAuthorized(SSDKPlatformType.typeQQ)
        let isWechatAuth = ShareSDK.hasAuthorized(SSDKPlatformType.typeWechat)
        let isSinaAuth = ShareSDK.hasAuthorized(SSDKPlatformType.typeSinaWeibo)
        
        if isQQAuth {
            ShareSDK.cancelAuthorize(SSDKPlatformType.typeQQ)
        }
        
        if isSinaAuth {
            ShareSDK.cancelAuthorize(SSDKPlatformType.typeSinaWeibo)
        }
        
        if isWechatAuth {
            ShareSDK.cancelAuthorize(SSDKPlatformType.typeWechat)
        }
    }
    
    class func login(_ type: LQLoginType, success handle: @escaping ((_ uid: String, _ name: String, _ url: String, _ sex: String) -> Void), failed: ((_ error: Error) -> Void)?) {
        
        var shareType: SSDKPlatformType?
        switch type {
        case .qq:
            shareType = SSDKPlatformType.typeQQ
        case .wechat:
            shareType = SSDKPlatformType.typeWechat
        case .sinaWeibo:
            shareType = SSDKPlatformType.typeSinaWeibo
        }
       
        if let login = shareType {
            
            ShareSDK.cancelAuthorize(login)
            ShareSDK.getUserInfo(login) { (state, user, error) in
                
                if state == SSDKResponseState.success {
                    
                    var uid = ""
                    if let ui = user?.uid {
                        uid = ui
                    }
                    
                    var nickName = ""
                    if let name = user?.nickname {
                        nickName = name
                    }
                    
                    var icon = ""
                    if let ic = user?.icon {
                        icon = ic
                    }
                    
                    var gender = ""
                    if let gen = user?.gender {
                        if gen == 0 {
                            gender = "男"
                        } else if gen == 1 {
                            gender = "女"
                        }else{
                            gender = "未知"
                        }
                    }
                    handle(uid, nickName, icon, gender)
                } else  {
                    if let handle = failed {
                        handle(error!)
                    }
                }
            }
        }
    }
}

//MARK: - 分享
extension LQShareSDK {
    
    /// 分享音乐
    ///
    /// - Parameters:
    ///   - url: 音乐地址
    ///   - thumbImage: 音乐缩略图
    ///   - title: 音乐名称
    ///   - descr: 音乐描述
    ///   - session: 分享到的平台
    ///   - success: 分享成功回调
    ///   - failed: 分享失败回调
    class func shareMusic(_ url: String, thumbImage: Any? = nil, title: String? = nil, descr: String? = nil, to session: LQShareSession, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: descr, images: thumbImage, url: URL.init(string: url), title: title, type: SSDKContentType.audio)
        
        ShareSDK.share(SSDKPlatformType.subTypeWechatSession, parameters: shareParams) { (state, info, entity, error) in
            
            if state == SSDKResponseState.success {
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
    ///   - url: 视频url地址
    ///   - thumbImage: 视频缩略图
    ///   - title: 视频标题
    ///   - descr: 视频描述
    ///   - session: 分享到的平台
    ///   - success: 分享成功回调
    ///   - failed: 分享失败回调
    class func shareVideo(_ url: String, thumbImage: Any? = nil, title: String? = nil, descr: String? = nil, to session: LQShareSession, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: descr, images: thumbImage, url: URL.init(string: url), title: title, type: SSDKContentType.video)
        
        ShareSDK.share(shareSession(session), parameters: shareParams) { (state, info, entity, error) in
            
            if state == SSDKResponseState.success {
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
    ///   - url: 网页地址
    ///   - thumbImage: 网页缩略图
    ///   - title: 网页标题
    ///   - descr: 网页描述
    ///   - session: 分享到的平台
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func shareWeb(_ url: String, thumbImage: Any? = nil, title: String? = nil, descr: String? = nil, to session: LQShareSession, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: descr, images: thumbImage, url: URL.init(string: url), title: title, type: SSDKContentType.webPage)
        
        ShareSDK.share(shareSession(session), parameters: shareParams) { (state, info, entity, error) in
            
            if state == SSDKResponseState.success {
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
    ///   - image: 图片内容, 可以为Data, UIImage, String, 或一组图片, 当为一组图片时, 只分享第一张
    ///   - session: 分享到的平台
    ///   - success: 成功的回调
    ///   - failed: 失败的回调
    class func shareImage(_ image: Any, to session: LQShareSession, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: nil, images: image, url: nil, title: nil, type: SSDKContentType.image)
        
        ShareSDK.share(shareSession(session), parameters: shareParams) { (state, info, entity, error) in
            
            if state == SSDKResponseState.success {
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
    ///   - success: 成功的回调
    ///   - failed: 失败的回调
    class func shareText(_ text: String, to session: LQShareSession, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: text, images: nil, url: nil, title: nil, type: SSDKContentType.text)
        
        ShareSDK.share(shareSession(session), parameters: shareParams) { (state, info, entity, error) in
            
            if state == SSDKResponseState.success {
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
    
    private class func shareSession(_ type: LQShareSession) -> SSDKPlatformType {
        switch type {
        case .qq:
            return SSDKPlatformType.subTypeQQFriend
        case .qzone:
            return SSDKPlatformType.subTypeQZone
        case .wechatSession:
            return SSDKPlatformType.subTypeWechatSession
        case .wechatTimeline:
            return SSDKPlatformType.subTypeWechatTimeline
        case .wechatFavorite:
            return SSDKPlatformType.subTypeWechatFav
        case .sina:
            return SSDKPlatformType.typeSinaWeibo
        }
    }
    
    class func shareUI() {
        
        let shareParams: NSMutableDictionary = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: "分享内容", images: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510826207776&di=5308bfb4c02cefc1210cad3eb963993b&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fd788d43f8794a4c273cb6b0804f41bd5ad6e392c.jpg", url: URL.init(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510826207776&di=5308bfb4c02cefc1210cad3eb963993b&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fd788d43f8794a4c273cb6b0804f41bd5ad6e392c.jpg"), title: "分享标题", type: SSDKContentType.audio)
        
        //1.要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        // 2. 菜单项, 需要分享到的平台, 如果传nil, 则会显示所有已集成的平台 SSDKPlatformType
        // 3. 分享的内容
        ShareSDK.showShareActionSheet(nil, items: nil, shareParams: shareParams) { (state, type, info, entity, error, end) in
            
            if state == SSDKResponseState.success {
                print("分享成功")
            } else {
                print("分享失败")
            }
        }
    }
}
