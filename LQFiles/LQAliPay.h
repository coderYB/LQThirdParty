//
//  LQAliPay.h
//  LQAliSDKDemo
//
//  Created by Artron_LQQ on 2017/11/21.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQAliPay : NSObject

+ (void)openUrl:(NSURL *)url
        success:(void(^)(NSDictionary *))success
         failed:(void(^)(void))failed;

+ (void)payOrder:(NSString *)order
       appScheme:(NSString *)scheme
         success:(void(^)(NSDictionary *))success
          failed:(void(^)(void))faile;
@end
