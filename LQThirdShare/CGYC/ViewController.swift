//
//  ViewController.swift
//  CGYC
//
//  Created by Artron_LQQ on 2017/5/23.
//  Copyright © 2017年 Artup. All rights reserved.
//
/* 简书博客: http://www.jianshu.com/u/2846c3d3a974
 Github: https://github.com/LQQZYY
 
 demo地址:
 https://github.com/LQQZYY/LDThirdShare-Swift
 博文讲解:
 http://www.jianshu.com/p/1b744a97e63d
 http://www.jianshu.com/p/c8db82d27b11
 http://www.jianshu.com/p/5a468f60c111
 */

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var dataSource: [String] = ["QQ登录", "微信登录", "新浪微博登录", "分享文本到QQ", "分享文本到微信", "分享文本到新浪", "分享图片到QQ", "分享图片到微信", "分享图片到新浪", "分享音乐到微信", "分享视频到微信", "分享web到微信", "分享web到新浪微博", "分享多张图片到QQ收藏", "分享Web到QQ", "音乐到QQ", "分享视频到QQ", "微信支付"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var frame = self.view.bounds
        frame.origin.y += 20
        frame.size.height -= 20
        
        let table = UITableView(frame: frame, style: .plain)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.testSingle(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        
        cell?.textLabel?.text = dataSource[indexPath.row] + "----row: \(indexPath.row)"
        return cell!
    }
    
    func alert(_ message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func testSingle(_ index: Int) {
        let text = self.dataSource[index]
        
        switch index {
        case 0:
            LDTencentShare.login({ (info) in
                self.alert("\(text) success: \(info)")
            }, failsure: { (error) in
                self.alert("\(text) failed: \(error)")
            })
        case 1:
            LDWechatShare.login({ (info) in
                self.alert("\(text) success: \(info)")
            }, failsure: { (error) in
                self.alert("\(text) failed: \(error)")
            })
        case 2:
            LDSinaShare.login(userInfo: ["custom": "这是自定义的字段"], success: { (info) in
                self.alert("\(text) success: \(info)")
            }, failsure: { (error) in
                self.alert("\(text) failed: \(error)")
            })
        case 3:
            LDTencentShare.shareText("这是分享到QQ的一段话", flag: .QQ, shareResultHandle: { (success, description) in
                
                self.alert("\(text) success: \(success)--\(description)")
            })
        case 4:
            LDWechatShare.shareText("这是分享到微信的一段话", to: .Session, resuleHandle: { (success, description) in
                self.alert("\(text) success: \(success)--\(description)")
            })
        case 5:
            LDSinaShare.shareText("这是分享到新浪微博的一段话", userInfo: ["custom": "这是自定义的字段信息"], shareResultHandle: { (success, info) in
                self.alert("\(text) success: \(success)--\(String(describing: info))")
            })
        case 6:
            // 测试异步
            let queue = DispatchQueue(label: "label")
            queue.async {
                
                let data = UIImageJPEGRepresentation(UIImage.init(named: "1.jpg")!, 0.6)
                
                LDTencentShare.shareImage(data!, thumbData: nil, title: "分享图片的标题", description: nil, flag: .QQ, shareResultHandle: { (success, description) in
                    self.alert("\(text) success: \(success)--\(description)")
                    
                    print("\(Thread.current) 结束")
                })
            }
            
            
            print("\(Thread.current) 开始")
            
        case 7:
            
            let data = UIImageJPEGRepresentation(UIImage.init(named: "1.jpg")!, 0.6)
            LDWechatShare.shareImage(data!, thumbImage: UIImage.init(named: "微信"), title: "分享微信", description: nil, to: .Favorite, resuleHandle: { (success, description) in
                self.alert("\(text) success: \(success)---\(description)")
            })
        case 8:
            let data = UIImageJPEGRepresentation(UIImage.init(named: "1.jpg")!, 0.6)
            LDSinaShare.shareImage(data!, text: nil, userInfo: nil, shareResultHandle: { (success, info) in
                self.alert("\(text) success: \(success)--\(String(describing: info))")
            })
        case 9:
            LDWechatShare.shareMusic("javascript:;", dataUrl: nil, title: "伪音乐", description: nil, thumbImg: UIImage.init(named: "微信"), to: .Session, resuleHandle: { (success, description) in
                self.alert("\(text) success: \(success)--\(description)")
            })
        case 10:
            LDWechatShare.shareVideo("http://www2.artup.com/mp4/cggcwx.mp4", lowBandUrl: "http://www2.artup.com/mp4/cggcwx.mp4", title: "搞笑", description: "描述", thumbImg: UIImage.init(named: "微信"), to: .Session, resuleHandle: { (success, description) in
                self.alert("\(text) success: \(success)--\(description)")
            })
        case 11:
            LDWechatShare.shareURL("http://www.jianshu.com/u/2846c3d3a974", title: "流火绯瞳的简书", description: "一个coder, 不是美女", thumbImg: nil, to: .Session, resuleHandle: { (success, description) in
                self.alert("\(text) success: \(success)--\(description)")
            })
        case 12:
            let data = UIImagePNGRepresentation(UIImage.init(named: "微信")!)
            
            LDSinaShare.shareWeb("http://www.jianshu.com/u/2846c3d3a974", objectID: "124", title: "标题", text: "流火绯瞳的简书", description: "一个coder, 不是美女", scheme: "http://www.baidu.com", thumbImgData: data, userInfo: nil, shareResultHandle: { (success, info) in
                self.alert("\(text) success: \(success)--\(String(describing: info))")
            })
        case 13:
            let data = UIImageJPEGRepresentation(UIImage.init(named: "1.jpg")!, 0.6)
            let data1 = UIImageJPEGRepresentation(UIImage.init(named: "10633861_160536558132_2.jpg")!, 0.6)
            
            let data2 = UIImagePNGRepresentation(UIImage.init(named: "微信")!)
            LDTencentShare.shareImages([data!, data1!], preImage: data2, title: "多图", description: "分享了多张图片", shareResultHandle: { (success, description) in
                self.alert("\(text) success: \(success)--\(description)")
            })
        case 14:
            
            LDTencentShare.shareNews(URL.init(string: "http://www.jianshu.com/u/2846c3d3a974")!, preUrl: URL.init(string: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=928861582,28679776&fm=26&gp=0.jpg")!, title: "流火绯瞳", description: "一个coder", flag: .QQ, shareResultHandle: { (success, description) in
                self.alert("\(text) success: \(success)--\(description)")
            })
        case 15:
            LDTencentShare.shareMusic(URL.init(string: "http://www2.artup.com/mp4/cggcwx.mp4")!, title: "伪音乐", description: "并不是真的", preImgUrl: URL.init(string: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=928861582,28679776&fm=26&gp=0.jpg")!, flag: .QQ, shareResultHandle: { (success, description) in
                self.alert("\(text) success: \(success)--\(description)")
            })
        case 16:
            LDTencentShare.shareVideo(URL.init(string: "http://www2.artup.com/mp4/cggcwx.mp4")!, preImgUrl: URL.init(string: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=928861582,28679776&fm=26&gp=0.jpg")!, title: "分享的视频", description: "一个描素", flag: .QQ, shareResultHandle: { (success, description) in
                self.alert("\(text) success: \(success)--\(description)")
            })
            
        case 17:
            let dic = ["partnerid": "", "prepayid": "", "package": "", "noncestr": "", "timestamp": "", "sign": ""]
            
            LDWechatShare.pay(to: "payID", dic, resultHandle: { (result, payID) in
                
                if result == .Success {
                    // 支付成功, 这里的支付结果需要和自己的服务器核实
                    self.alert("\(text) success\(payID)")
                }
            })
        default:
            print("error\(index) : 未添加分享")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

