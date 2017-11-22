//
//  LQWechatPay.h
//  CGYC
//
//  Created by Artron_LQQ on 2017/11/22.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LQWechatPayResuleHandle)();
@interface LQWechatPay : NSObject

+ (void)registApp;

+ (BOOL)openURL:(NSURL *)url ;

+ (void)payOrder:(NSDictionary *)dic
         success:(LQWechatPayResuleHandle)success
          failed:(LQWechatPayResuleHandle)failed;
@end
