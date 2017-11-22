//
//  LQWechatPay.m
//  CGYC
//
//  Created by Artron_LQQ on 2017/11/22.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "LQWechatPay.h"
//#import "WXApi.h"
#import "WXApi.h"

static NSString *kLQWechatPay_appID = @"";



@interface LQWechatPay () <WXApiDelegate>

@property (nonatomic, copy) LQWechatPayResuleHandle successHandle;
@property (nonatomic, copy) LQWechatPayResuleHandle failedHandle;
@end


@implementation LQWechatPay

+ (void)registApp {
    
    [[LQWechatPay shared] registApp];
}

+ (BOOL)openURL:(NSURL *)url {
    
    return [[LQWechatPay shared] openURL:url];
}

+ (void)payOrder:(NSDictionary *)dic
         success:(LQWechatPayResuleHandle)success
          failed:(LQWechatPayResuleHandle)failed {
    
    [[LQWechatPay shared] payOrder:dic success:success failed:failed];
}

+ (instancetype)shared {
    __block LQWechatPay *pay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pay = [[LQWechatPay alloc]init];
    });
    
    return pay;
}

- (void)registApp {
    
    [WXApi registerApp:kLQWechatPay_appID];
}

- (BOOL)openURL:(NSURL *)url {
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (void)payOrder:(NSDictionary *)dic success:(LQWechatPayResuleHandle)success failed:(LQWechatPayResuleHandle)failed {
    
    self.successHandle = success;
    self.failedHandle = failed;
    
    PayReq *req = [[PayReq alloc]init];
    
    req.partnerId = [dic objectForKey:@"partnerid"];
    req.prepayId = [dic objectForKey:@"prepayid"];
    req.package = [dic objectForKey:@"package"];
    req.nonceStr = [dic objectForKey:@"noncestr"];
    req.timeStamp = [[dic objectForKey:@"timestamp"] intValue];
    req.sign = [dic objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}

#pragma WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        
        switch (resp.errCode) {
            case WXSuccess:
                if (self.successHandle) {
                    self.successHandle();
                }
                break;
                
            default:
                if (self.failedHandle) {
                    self.failedHandle();
                }
                break;
        }
    }
}
















@end
