//
//  ViewController.swift
//  LQUmengDemo
//
//  Created by Artron_LQQ on 2017/11/15.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataSource = ["微信登录", "QQ登录", "新浪微博登录", "友盟分享面板", "分享文本到微信会话", "分享图片到微信会话", "分享网页到微信会话", "分享视频到微信会话", "分享音乐到微信会话"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < 3 {
            var type: LQLoginType?
            if indexPath.row == 0 {
                type = LQLoginType.wechat
            } else if indexPath.row == 1 {
                type = LQLoginType.qq
            } else if indexPath.row == 2 {
                type = LQLoginType.sinaWeibo
            }
            
            if let ty = type {
                
                LQUmengSDK.login(ty, success: { (uid, name, url, sex) in
                    self.alert(uid, name: name, sex: sex)
                }, failed: {error in
                    self.alertFailed(error.localizedDescription)
                })
            }
        } else if indexPath.row == 3 {
            LQUmengSDK.shareUmengUI()
        } else if indexPath.row == 4 {
            LQUmengSDK.shareText("关关雎鸠，在河之洲。窈窕淑女，君子好逑。", to: .wechatSession)
        } else if indexPath.row == 5 {
            LQUmengSDK.shareImage("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510826207776&di=5308bfb4c02cefc1210cad3eb963993b&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fd788d43f8794a4c273cb6b0804f41bd5ad6e392c.jpg", thumbImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510824926407&di=73ce61c358f9947833d03e13aa9712dc&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F255%2FHP4C7KBZQ0YP.jpg", to: .wechatSession, success: {
                
            }, failed:{})
        } else if indexPath.row == 6 {
            LQUmengSDK.shareWeb("http://www.jianshu.com/u/2846c3d3a974", title: "欢迎关注简书: 流火绯瞳", thumbUrl: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510824926407&di=73ce61c358f9947833d03e13aa9712dc&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F255%2FHP4C7KBZQ0YP.jpg", descr: "一个开发者", to: .wechatSession)
        } else if indexPath.row == 7 {
            LQUmengSDK.shareVideo("http://sp.9sky.com/convert/song/mv/37/20170829122323956.mp4", title: "盛夏", descr: "黄删删", thumbImage: "http://sp.9sky.com/disc/cover/37/20170817102848685.jpg", to: .wechatSession)
        } else if indexPath.row == 8 {
            LQUmengSDK.shareMusic("http://sp.9sky.com/convert/song/music/1014827/20171108153027116.mp3", title: "好了就暂时这样吧", descr: "歌手: 金品研", thumbImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510824926407&di=73ce61c358f9947833d03e13aa9712dc&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F255%2FHP4C7KBZQ0YP.jpg", to: .wechatSession)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    func alertFailed(_ text: String) {
        
        let alert = UIAlertController(title: nil, message: "登录失败", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(_ uid: String, name: String, sex: String) {
        
        let alert = UIAlertController(title: nil, message: "\(name) \(sex)士您好!\n您的uid为\(uid)", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

