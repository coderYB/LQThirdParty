//
//  LQUnionPay.h
//  LQUnionPayDemo
//
//  Created by LiuQiqiang on 2018/11/28.
//  Copyright © 2018 LiuQiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LQUnionPayResultUnknow,
    LQUnionPayResultSuccess,
    LQUnionPayResultCancel,
    LQUnionPayResultFailure,
} LQUnionPayResult;

typedef void(^LQUnionPayResultHandler)(LQUnionPayResult result, NSDictionary *info);
NS_ASSUME_NONNULL_BEGIN

@interface LQUnionPay : NSObject

+ (BOOL) isUnionAppInstall ;
+ (void) handleOpenURL:(NSURL *)url ;


/**
 发起支付

 @param tn 后台生成的支付流水号
 @param vc 弹出支付控件的控制器
 */
+ (void) startPayWithTN:(NSString *)tn onViewController:(UIViewController *) vc resultHandler: (LQUnionPayResultHandler) handler ;
@end

NS_ASSUME_NONNULL_END
