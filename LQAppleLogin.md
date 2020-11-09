
# LQAppleLogin
# 介绍
使用Swift及OC语言封装的Sign in with Apple

包含两个demo:
- LQShareSDK.swift -- Swift语言封装的相关API
- LQShareSDK.h及LQShareSDK.m -- OC语言实现的相同功能封装

以上文件可请根据需求选择使用.

相关的文章地址:
- [[iOS 13\] Sign in with Apple 苹果登录](https://www.jianshu.com/p/e393b631d3b4)

# 使用
使用的时候可以使用提供的单例类，如果是自己创建的类，需要设置为全局变量

#### 创建默认登录按钮

```Swift
ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton buttonWithType:(ASAuthorizationAppleIDButtonTypeSignIn) style:(ASAuthorizationAppleIDButtonStyleBlack)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    button.frame = CGRectMake(60, 60, 60, 60);
    [self.view addSubview:button];
```

#### 发起登录请求

```Swift
   [[LQAppleLogin shared] loginWithCompleteHandler:^(BOOL successed, NSString * _Nullable user, NSString * _Nullable familyName, NSString * _Nullable givenName, NSString * _Nullable email, NSString * _Nullable password, NSData * _Nullable identityToken, NSData * _Nullable authorizationCode, NSError * _Nullable error, NSString * _Nonnull msg) {
        
        NSLog(@"%@--%@--%@", user, familyName, email);
    }];      
```

#### 检测当前用户状态

此处的userid为登录成功时返回的user字段，需要自己保存，一般是保存在钥匙串中

```Swift
[LQAppleLogin checkAuthorizationStateWithUser:@"userid" completeHandler:^(BOOL authorized, NSString * _Nonnull msg) {
        NSLog(@"%d--%@", authorized, msg);
    }];
```

详细内容可下载demo查看.





