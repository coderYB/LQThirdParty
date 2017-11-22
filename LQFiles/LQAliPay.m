//
//  LQAliPay.m
//  LQAliSDKDemo
//
//  Created by Artron_LQQ on 2017/11/21.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "LQAliPay.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation LQAliPay

+ (void)openUrl:(NSURL *)url
        success:(void(^)(NSDictionary *))success
         failed:(void(^)(void))failed {
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self checkResult:resultDic success:success failed:failed];
        }];
    }
}

+ (void)payOrder:(NSString *)order
       appScheme:(NSString *)scheme
         success:(void(^)(NSDictionary *))success
          failed:(void(^)(void))failed {
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        [self checkResult:resultDic success:success failed:failed];
    }];
}
+ (void)checkResult:(NSDictionary *)result success:(void(^)(NSDictionary *))success failed:(void(^)(void))failed {
    
    if (result) {
        NSString *statusStr = result[@"resultStatus"];
        NSInteger state = statusStr.integerValue;
        if (state == 9000) {
            //支付成功
            NSString *obj = result[@"result"];
            if (obj) {
                
                NSDictionary *dic = [self payResultToDic:obj];
                if (success) {
                    success(dic);
                }
                return;
            }
        }
    }
    
    if (failed) {
        failed();
    }
}
+ (NSDictionary *)payResultToDic:(NSString *)str {
    
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"{" withString:@""];
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    NSArray *array = [str3 componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (NSString * tmp in array) {
        NSArray *tmpArray = [tmp componentsSeparatedByString:@":"];
        if (tmpArray.count == 2) {
            NSString *key = tmpArray[0];
            NSString *value = tmpArray[1];
            
            [dic setObject:value forKey:key];
        } else if (tmpArray.count == 3) {
            NSString *key = tmpArray[1];
            NSString *value = tmpArray[2];
            
            [dic setObject:value forKey:key];
        }
    }
    return dic;
}






















@end
