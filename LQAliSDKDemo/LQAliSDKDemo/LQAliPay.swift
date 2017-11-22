//
//  LQAliPay.swift
//  LQAliSDKDemo
//
//  Created by Artron_LQQ on 2017/11/21.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class LQAliPay: NSObject {

    /// 处理支付宝客户端返回的url（在app被杀模式下，通过这个方法获取支付结果）
    ///
    /// - Parameters:
    ///   - url: 支付宝客户端回传的url
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func open(url: URL, success: ((_ info: [String: String]) -> Void)? = nil, failed: (()->Void)? = nil) {
        
        if let host = url.host {
            if host == "safepay" {
               AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (info) in
                self.checkResult(info as? [String : Any], success: success, failed: failed)
                })
            }
        }
    }
    
    /// 发起支付
    ///
    /// - Parameters:
    ///   - order: app支付请求参数字符串，主要包含商户的订单信息，key=value形式，以&连接。 由后台返回
    ///   - scheme: 商户程序注册的URL protocol，供支付完成后回调商户程序使用。
    ///   - success: 成功回调
    ///   - failed: 失败回调
    class func pay(order: String, appScheme scheme: String, success: ((_ info: [String: String]) -> Void)? = nil, failed: (()->Void)? = nil) {
        
        AlipaySDK.defaultService().payOrder(order, fromScheme: scheme) { (info) in
            self.checkResult(info as? [String : Any], success: success, failed: failed)
        }
    }
    
    private class func checkResult(_ resultDic: [String: Any]?, success: ((_ info: [String: String]) -> Void)? = nil, failed: (()->Void)? = nil) {
        
        if let result = resultDic {
            if let statusStr = result["resultStatus"] as? String {
                if let status = Int(statusStr) {
                    
                    if status == 9000 {
                        // 支付成功
                        if let obj = result["result"] as? String {
                            
                            let dic = payResultToDic(obj)
                            
                            if let handle = success {
                                handle(dic)
                            }
                            return
                        }
                    }
                }
            }
        }
        
        if let handle = failed {
            handle()
        }
    }
    // 处理支付结果字符串: 看着像个字典, 但是转不成字典, 只能分割字符串后保存到字典内
    private class func payResultToDic(_ str: String) -> [String: String] {
        
        let str1 = str.replacingOccurrences(of: "\"", with: "")
        
        let str2 = str1.replacingOccurrences(of: "{", with: "")
        
        let str3 = str2.replacingOccurrences(of: "}", with: "")
        
        let arr = str3.components(separatedBy: ",")
        
        var dic: [String: String] = [:]
        
        for str5 in arr {
            let results = str5.components(separatedBy: ":")
            
            if results.count == 2 {
                let key = results[0]
                let value = results[1]
                dic[key] = value
            } else if results.count == 3 {
                let key = results[1]
                let value = results[2]
                dic[key] = value
            }
        }
        
        return dic
    }
}
