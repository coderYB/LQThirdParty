//
//  ViewController.swift
//  LQAppleLogin
//
//  Created by 刘启强 on 2019/11/7.
//  Copyright © 2019 Q.ice. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    var login = LQAppleLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.frame = CGRect(x: 60, y: 60, width: 130, height: 60)
        self.view.addSubview(button)
        
        // Do any additional setup after loading the view.
    }


    @objc func buttonAction() {
        
        login.loginWithCompleteHandler { (success, user, familyName, givenName, email, password, identityToken, authorizationCode, error, msg) in
            print(msg)
        }
    }
}

