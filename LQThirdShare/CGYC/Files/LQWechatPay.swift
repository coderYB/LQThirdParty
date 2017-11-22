//
//  LQWechatPay.swift
//  CGYC
//
//  Created by Artron_LQQ on 2017/11/21.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

private let kLQWechatPay_appID = ""

typealias LQWechatPayResuleHandle = () -> Void
class LQWechatPay: NSObject {
    
    static let shared: LQWechatPay = LQWechatPay()
    fileprivate var successHandle: LQWechatPayResuleHandle?
    fileprivate var failedHandle: LQWechatPayResuleHandle?
    private override init() { }
    
    static func registApp() {
        
        LQWechatPay.shared.registerApp()
    }
    
    @discardableResult
    static func openURL(_ url: URL) -> Bool {
        
        return LQWechatPay.shared.openURL(url)
    }
    
    static func pay(_ dic: [String: Any], success: LQWechatPayResuleHandle? = nil, failed: LQWechatPayResuleHandle? = nil) {
        
        LQWechatPay.shared.pay(dic, success: success, failed: failed)
    }
    
}

extension LQWechatPay: WXApiDelegate {
    
    fileprivate func registerApp() {
        
        WXApi.registerApp(kLQWechatPay_appID)
    }
    
    @discardableResult
    fileprivate func openURL(_ url: URL) -> Bool {
        
        if let host = url.host {
            if host == "pay" {
                
                return WXApi.handleOpen(url, delegate: self)
            }
        }
        
        return true
    }
    
    fileprivate func pay(_ dic: [String: Any], success: LQWechatPayResuleHandle?, failed: LQWechatPayResuleHandle?) {
        
        self.successHandle = success
        self.failedHandle = failed
        
        let req = PayReq.init()
        
        req.partnerId = dic["partnerid"]! as! String
        req.prepayId = dic["prepayid"]! as! String
        req.package = dic["package"]! as! String
        req.nonceStr = dic["noncestr"]! as! String
        req.timeStamp = dic["timestamp"]! as! UInt32
        req.sign = dic["sign"] as! String
        
        if WXApi.send(req) {
            print("吊起微信支付成功")
        }
    }
    
    func onResp(_ resp: BaseResp) {
        
        if resp is PayResp {
            
            if resp.errCode == WXSuccess.rawValue {
                if let handle = self.successHandle {
                    handle()
                }
            } else {
                if let handle = self.failedHandle {
                    handle()
                }
            }
        }
    }
}
