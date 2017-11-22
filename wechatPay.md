
# LQWechatPay
# 介绍
单独封装集成的微信支付

demo包含三个文件:
- LQWechatPay.swift -- Swift语言封装的相关API
- LQWechatPay.h及LQWechatPay.m -- OC语言实现的相同功能封装

以上文件可请根据需求选择使用.

相关的文章地址:
- [[iOS]微信支付接入详解](http://www.jianshu.com/p/a92082b26fd9)

# 使用
使用的时候需要自行配置相关的AppID及AppSecret;

所有API的调用均是以类方法的形式:
#### 回调设置

iOS 9以上版本可在下面的方法里设置:
```Swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        LQWechatPay.openURL(url)
        return true
    }
```

如果需要兼容iOS 9以下版本, 可在下面的方法内处理:
```Swift
func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        LQWechatPay.openURL(url)
        return true
    }
```
    
#### 支付

微信支付吊起微信APP所需的参数, 主要是从后台获取, 在请求自己服务器获取到相关参数后, 按如下字典的key值设置, 直接将该字典传入封装的方法参数即可, 其中需要注意的是参数sign, 具体可参考文章: [[iOS]微信支付接入详解](http://www.jianshu.com/p/a92082b26fd9)

```Swift
let dic = ["partnerid": "", "prepayid": "", "package": "", "noncestr": "", "timestamp": "", "sign": ""]

LQWechatPay.pay(dic, success: {
    // 支付成功
 }, failed: {
    //支付失败
 })
```




