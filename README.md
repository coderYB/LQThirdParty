# LQThirdParty
# 介绍
关于第三方登录/分享, 其API相对比较简单, 稍微麻烦一点的是SDK的集成及相关的配置, 下面相关的文章中主要是参考相关平台的集成文档梳理的过程, 按照相关的步骤进行集成设置, 一般不会有问题.

还有就是需要准的资料: 第三方平台的开发者账号, 以及相关的AppKey(AppID)和AppSecret;

总共包含五个demo:
- LQThirdShare : 微信/QQ新浪微博原生SDK封装的登录/分享/支付
- LQShareSDK : 针对ShareSDK相关API的封装, 第三方登录及分享
- LQUmengSDK : 针对友盟相关API的封装, 第三方登录及分享
- LQAliSDKDemo : 支付宝支付的相关API封装, 可以直接使用
- LQQWeChatDemo : 微信支付的demo
- LQAppleLogin：Sign In with Apple

以上demo中使用的所有封装文件, 全部在LQFiles放了一份, 可以直接从这里找到自己需要的文件放到已经配置好的工程里. 有的文件中包含了Swift与Objective-C两种语言的封装, 请根据自身需要, 分开单独使用;

### 实现功能
- 登录: 原生微信/QQ/新浪微博登录, 以及友盟/ShareSDK第三方登录;
- 分享: 原生微信/QQ/新浪微博分享, 以及友盟/ShareSDK第三方分享;
- 支付: 微信支付/支付宝支付
- 苹果账号登录

##### 相关文章
- [[Swift]原生第三方接入: 微信篇--集成/登录/分享/支付](http://www.jianshu.com/p/1b744a97e63d)
- [[Swift]原生第三方接入: QQ篇--集成/登录/分享](http://www.jianshu.com/p/c8db82d27b11)
- [[Swift]原生第三方接入: 新浪微博篇--集成/登录/分享](http://www.jianshu.com/p/5a468f60c111)
- [[Mob]集成ShareSDK -- 第三方登录/分享](http://www.jianshu.com/p/f460c3d73b7e)
- [[Umeng] 友盟集成 - 第三方登录/分享](http://www.jianshu.com/p/9e0c35933e99)
- [[AliPay]支付宝支付接入](http://www.jianshu.com/p/5d59c80ef916)
- [[iOS]微信支付接入详解](http://www.jianshu.com/p/a92082b26fd9)
- [[UnionPay]银联支付](https://www.jianshu.com/p/51f93eff3231)
- [[iOS 13\] Sign in with Apple 苹果登录](https://www.jianshu.com/p/e393b631d3b4)

##### 具体的介绍及使用请参考相关的md文件:
- [ShareSDK.md](https://github.com/LQi2009/LQThirdParty/blob/master/ShareSDK.md)
- [原生第三方.md](https://github.com/LQi2009/LQThirdParty/blob/master/原生第三方.md)
- [友盟.md](https://github.com/LQi2009/LQThirdParty/blob/master/友盟.md)
- [alipay.md](https://github.com/LQi2009/LQThirdParty/blob/master/alipay.md)
- [wechatPay.md](https://github.com/LQi2009/LQThirdParty/blob/master/wechatPay.md)
- [LQAppleLogin.md](https://github.com/LQi2009/LQThirdParty/blob/master/LQAppleLogin.md)

# 欢迎Star & Fork

|        |                                          |
| :----: | :--------------------------------------: |
| Github |  [LQi2009](https://github.com/LQi2009)   |
| CSDN博客 | [流火绯瞳](http://blog.csdn.net/lqq200912408) |
|  新浪微博  | [杯水_沧海](http://www.weibo.com/u/2425045492/home) |
|   QQ   |                302934443                 |


