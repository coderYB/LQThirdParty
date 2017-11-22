//
//  LQShareSDK.h
//  LQShareSDK
//
//  Created by Artron_LQQ on 2017/11/17.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LQShareBlock)(void);
typedef enum : NSUInteger {
    LQLoginTypeQQ,
    LQLoginTypeWechat,
    LQLoginTypeSinaWeibo,
} LQLoginType;

typedef enum : NSUInteger {
    LQShareSessionWechatSession,
    LQShareSessionWecharTimeline,
    LQShareSessionWechatFavorite,
    LQShareSessionSina,
    LQShareSessionQQ,
    LQShareSessionQzone,
} LQShareSession;

@interface LQShareSDK : NSObject

+ (void)registApp;
+ (BOOL)isWechatInstall;
+ (void)logout;
+ (void) login:(LQLoginType)type
       success:(void(^)(NSString * uid, NSString * name, NSString * icon, NSString * sex))success
        failed:(void(^)(NSError* error))failed;
+ (void)shareMusic:(NSString *)url
        thumbImage:(id)image
             title:(NSString *)title
             descr:(NSString *)descr
         toSession:(LQShareSession)session
           success:(void(^)(void))success
            failed:(void(^)(void))failed;
+ (void)shareVideo:(NSString *)url
        thumbImage:(id)image
             title:(NSString *)title
             descr:(NSString *)descr
         toSession:(LQShareSession)session
           success:(void(^)(void))success
            failed:(void(^)(void))failed;
+ (void)shareWeb:(NSString *)url
      thumbImage:(id)image
           title:(NSString *)title
           descr:(NSString *)descr
       toSession:(LQShareSession)session
         success:(void(^)(void))success
          failed:(void(^)(void))failed;
+ (void)shareImage:(id)image
         toSession:(LQShareSession)session
           success:(void(^)(void))success
            failed:(void(^)(void))failed;
+ (void)shareText:(NSString *)text
        toSession:(LQShareSession)session
          success:(void(^)(void))success
           failed:(void(^)(void))failed;

@end
