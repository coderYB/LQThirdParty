//
//  LQAppleLogin.swift
//  LQAppleLogin
//
//  Created by 刘启强 on 2019/11/7.
//  Copyright © 2019 Q.ice. All rights reserved.
//

import UIKit
import AuthenticationServices

typealias LQAppleLoginCompleteHandler = (_ successed: Bool, _ user: String?, _ familyName: String?, _ givenName: String?, _ email: String?, _ password: String?, _ identityToken: Data?, _ authorizationCode: Data?, _ error: Error?, _ msg: String) -> Void

typealias LQAppleLoginObserverHandler = () -> Void

class LQAppleLogin: NSObject {
    
    static let shared: LQAppleLogin = LQAppleLogin()
    
    private var completeHandler: LQAppleLoginCompleteHandler?
    private var observerHandler: LQAppleLoginObserverHandler?

    func startAppleIDObserverWithCompleteHandler(_ handler: @escaping LQAppleLoginObserverHandler) {
        
        self.observerHandler = handler
        
        NotificationCenter.default.addObserver(self, selector: #selector(lq_signWithAppleIDStateChanged), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
    }
    
    @objc func lq_signWithAppleIDStateChanged(_ noti: NSNotification) {
        
        if noti.name == ASAuthorizationAppleIDProvider.credentialRevokedNotification {
            self.observerHandler?()
        }
    }
    
    class func checkAuthorizationStateWithUser(_ user: String?, completeHander handler: ((_ authorized: Bool, _ msg: String) -> Void)?) {
        
        guard let us = user else {
            handler?(false, "用户标识符错误")
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: us) { (state, error) in
            var msg = "未知"
            var authorized = false
            
            switch state {
                
            case .revoked:
                msg = "授权被撤销"
                authorized = false
            case .authorized:
                msg = "已授权"
                authorized = true
            case .notFound:
                msg = "未查到授权信息"
                authorized = false
            case .transferred:
                msg = "授权信息变动"
                authorized = false
            @unknown default:
                authorized = false
            }
            handler?(authorized, msg)
        }
    }
    
    func loginWithExistingAccount(_ handler: @escaping LQAppleLoginCompleteHandler) {
        self.completeHandler = handler
        
        let provider = ASAuthorizationAppleIDProvider()
        
        let req = provider.createRequest()
        
        let pswProvider = ASAuthorizationPasswordProvider()
        let pswReq = pswProvider.createRequest()
        
        let controller = ASAuthorizationController(authorizationRequests: [req, pswReq])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func loginWithCompleteHandler(_ handler: @escaping LQAppleLoginCompleteHandler) {
        self.completeHandler = handler
        
        let provider = ASAuthorizationAppleIDProvider()
        let req = provider.createRequest()
        req.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [req])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension LQAppleLogin: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        guard let nse = error as? ASAuthorizationError else {
            return
        }
        
        var msg = "未知"
        switch nse.code {
        case .canceled:
            msg = "用户取消"
        case .failed:
            msg = "授权请求失败"
        case .invalidResponse:
            msg = "授权请求无响应"
        case .notHandled:
            msg = "授权请求未处理"
        case .unknown:
            msg = "授权失败，原因未知"
        default:
            msg = "未知"
        }
        
        self.completeHandler?(false, nil, nil, nil,nil, nil, nil, nil, error, msg)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let user = credential.user
            let familyName = credential.fullName?.familyName
            let givenName = credential.fullName?.givenName
            let email = credential.email
            
            let identityToken = credential.identityToken
            let code = credential.authorizationCode
            
            self.completeHandler?(true, user, familyName, givenName, email, nil, identityToken, code, nil, "授权成功")
        } else if let credential = authorization.credential as? ASPasswordCredential {
            
            let user = credential.user
            let password = credential.password
            
            self.completeHandler?(true, user, nil, nil
                , nil, password, nil, nil, nil, "授权成功")
        }
    }
}

extension LQAppleLogin: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first ?? UIWindow()
    }
}
