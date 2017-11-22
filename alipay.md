
# LQAliPay
# 介绍
使用Swift及OC语言封装集成的支付宝支付

demo包含三个文件:
- LQAliPay.swift -- Swift语言封装的相关API
- LQAliPay.h及LQAliPay.m -- OC语言实现的相同功能封装


以上文件可请根据需求选择使用.

相关的文章地址:
- [[AliPay]支付宝支付接入](http://www.jianshu.com/p/5d59c80ef916)

# 使用
使用的时候需要自行配置相关的AppID及AppSecret;

所有API的调用均是以类方法的形式:
#### 回调设置

iOS 9以上版本可在下面的方法里设置:
```Swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        LQAliPay.open(url: url, success: { (result) in
            //处理支付成功结果
        }) {
            // 支付失败或支付异常, 这里的支付失败不一定是失败, 具体结果可在后台验证
        }
        return true
    }
```

如果需要兼容iOS 9以下版本, 可在下面的方法内处理:
```Swift
func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        LQAliPay.open(url: url, success: { (result) in
            //处理支付成功结果
        }) {
            // 支付失败或支付异常, 这里的支付失败不一定是失败, 具体结果可在后台验证
        }
        return true
    }
```
    
#### 支付

```Swift
  LQAliPay.pay(order: "order info string", appScheme: "app scheme", success: { (result) in
            // 支付成功
        }) {
            // 支付失败
        }      
```

详细内容可下载demo查看.







