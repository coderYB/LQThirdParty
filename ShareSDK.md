
# LQShareSDK
# 介绍
使用Swift及OC语言封装集成的ShareSDK第三方登录及分享

demo包含三个文件:
- LQShareSDK.swift -- Swift语言封装的相关API
- LQShareSDK.h及LQShareSDK.m -- OC语言实现的相同功能封装



以上文件可请根据需求选择使用.

相关的文章地址:
- [[Mob]集成ShareSDK -- 第三方登录/分享](http://www.jianshu.com/p/f460c3d73b7e)

# 使用
使用的时候需要自行配置相关的AppID及AppSecret;

所有API的调用均是以类方法的形式:
#### 注册APP

```Swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LQShareSDK.registApp()
        return true
    }
```
    
#### 登录

```Swift
    var type: LQLoginType?
    if indexPath.row == 0 {
        type = LQLoginType.wechat
    } else if indexPath.row == 1 {
         type = LQLoginType.qq
    } else if indexPath.row == 2 {
         type = LQLoginType.sinaWeibo
    }
            
    if let ty = type {
                
         LQShareSDK.login(ty, success: { (uid, name, icon, sex) in
             self.alert(uid, name: name, sex: sex)
        }, failed: { (error) in
            self.alertFailed("登录失败--\(error.localizedDescription)")
        })
    }
            
```

#### 分享

```Swift
// 分享文本
LQShareSDK.shareText("关关雎鸠，在河之洲。窈窕淑女，君子好逑。", to: .wechatSession, success: {
                print("成功")
                self.alertFailed("分享成功")
            }, failed: {
                print("失败")
                self.alertFailed("分享失败")
            })
            

// 分享图片
LQShareSDK.shareImage("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510824926407&di=73ce61c358f9947833d03e13aa9712dc&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F255%2FHP4C7KBZQ0YP.jpg", to: .wechatSession, success: {
                print("成功")
                self.alertFailed("分享成功")
            }, failed: {
                print("失败")
                self.alertFailed("分享失败")
            })

// 分享网页
LQShareSDK.shareWeb("http://www.jianshu.com/u/2846c3d3a974", thumbImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510824926407&di=73ce61c358f9947833d03e13aa9712dc&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F255%2FHP4C7KBZQ0YP.jpg", title: "欢迎关注简书: 流火绯瞳", descr: "一个开发者", to: .wechatSession, success: {
                print("成功")
                self.alertFailed("分享成功")
            }, failed: {
                print("失败")
                self.alertFailed("分享失败")
            })
            
// 分享视频
LQShareSDK.shareVideo("http://www.artup.com/mp4/cggcwx.mp4", thumbImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510824926407&di=73ce61c358f9947833d03e13aa9712dc&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F255%2FHP4C7KBZQ0YP.jpg", title: "流火绯瞳", descr: "一个开发者", to: .wechatSession, success: {
                print("成功")
                self.alertFailed("分享成功")
            }, failed: {
                print("失败")
                self.alertFailed("分享失败")
            })
            
//分享音乐
LQShareSDK.shareMusic("http://sp.9sky.com/convert/song/music/1014827/20171108153027116.mp3", thumbImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510824926407&di=73ce61c358f9947833d03e13aa9712dc&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F255%2FHP4C7KBZQ0YP.jpg", title: "好了就暂时这样吧", descr: "歌手: 金品研", to: .wechatSession, success: {
                print("分享成功")
                self.alertFailed("分享成功")
            }, failed: {
                print("分享失败")
                self.alertFailed("分享失败")
            })   
```

详细内容可下载demo查看.







