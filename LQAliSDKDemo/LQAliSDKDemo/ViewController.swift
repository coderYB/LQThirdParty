//
//  ViewController.swift
//  LQAliSDKDemo
//
//  Created by Artron_LQQ on 2017/11/21.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LQAliPay.pay(order: "order info string", appScheme: "app scheme", success: { (result) in
            // 支付成功
        }) {
            // 支付失败
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

