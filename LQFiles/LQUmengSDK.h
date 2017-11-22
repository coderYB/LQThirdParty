//
//  LQUmengSDK.h
//  LQUmengDemo
//
//  Created by Artron_LQQ on 2017/11/18.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
typedef enum : NSUInteger {
    LQLoginTypeQQ,
    LQLoginTypeWechat,
    LQLoginTypeSinaWeibo,
} LQLoginType;

typedef enum : NSUInteger {
    LQShareSessionWechatSession,
    LQShareSessionWechatTimeline,
    LQShareSessionWechatFavorite,
    LQShareSessionSina,
    LQShareSessionQQ,
    LQShareSessionQZone,
} LQShareSession;

@interface LQUmengSDK : NSObject

/**
 注册app
 */
+ (void)registApp;

/**
 系统回调
 
 @param url url
 @param source source
 @param annotation annotation
 @return 返回值
 */
+ (BOOL)handle:(NSURL *)url
        source:(NSString *)source
    annotation:(id)annotation;
+ (BOOL)handle:(NSURL *)url
        option:(NSDictionary *)options;
+ (BOOL)handle:(NSURL *)url;

/**
 判断是否安装微信
 
 @return 返回结果
 */
+ (BOOL)isWechatInstall;

/**
 登录接口
 
 @param type 登录类型
 @param vc 当前控制器
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)login:(LQLoginType)type
onViewController:(UIViewController *)vc
      success:(void(^)(NSString * uid, NSString * name, NSString * icon, NSString * sex))success
       failed:(void(^)(NSError* error))failed;

+ (void)shareMusic:(NSString *)url
             title:(NSString *)title
        thumbImage:(id)image
             descr:(NSString *)descr
         toSession:(LQShareSession)session
  onViewController:(UIViewController *)vc
           success:(void(^)(void))success
            failed:(void(^)(void))failed;
+ (void)shareVideo:(NSString *)url
             title:(NSString *)title
        thumbImage:(id)image
             descr:(NSString *)descr
         toSession:(LQShareSession)session
  onViewController:(UIViewController *)vc
           success:(void(^)(void))success
            failed:(void(^)(void))failed;
+ (void)shareTest:(NSString *)text
        toSession:(LQShareSession)session
 onViewController:(UIViewController *)vc
          success:(void(^)(void))success
           failed:(void(^)(void))faile;
+ (void)shareImage:(id)image
        thumbImage:(id)thumbImage
         toSession:(LQShareSession)session
  onViewController:(UIViewController *)vc
           success:(void(^)(void))success
            failed:(void(^)(void))faile;
+ (void)shareWeb:(NSString *)url
           title:(NSString *)title
      thumbImage:(id)image
           descr:(NSString *)descr
       toSession:(LQShareSession)session
onViewController:(UIViewController *)vc
         success:(void(^)(void))success
          failed:(void(^)(void))failed;
@end
