//
//  LQUnionPay.m
//  LQUnionPayDemo
//
//  Created by LiuQiqiang on 2018/11/28.
//  Copyright © 2018 LiuQiqiang. All rights reserved.
//

#import "LQUnionPay.h"
#import "UPPaymentControl.h"

LQUnionPayResultHandler __resultHandler ;
@implementation LQUnionPay

+ (BOOL) isUnionAppInstall {
    
    return [[UPPaymentControl defaultControl] isPaymentAppInstalled];
}

+ (void) handleOpenURL:(NSURL *)url {
    
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        LQUnionPayResult rs = LQUnionPayResultUnknow;
        if([code isEqualToString:@"success"]) {
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
            rs = LQUnionPayResultSuccess;
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            rs = LQUnionPayResultFailure;
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            rs = LQUnionPayResultCancel ;
        }
        
        if (__resultHandler) {
            __resultHandler(rs, data);
        }
    }];
}

+ (void) startPayWithTN:(NSString *)tn onViewController:(UIViewController *) vc resultHandler: (LQUnionPayResultHandler) handler {
    
    __resultHandler = handler;
    
    [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"LQUnionPayDemo" mode:@"00" viewController:vc];
    
    // 该方法的参数 mode 有两个可取值: 00 正式环境; 01 测试环境; 根据需要设置
}
@end
