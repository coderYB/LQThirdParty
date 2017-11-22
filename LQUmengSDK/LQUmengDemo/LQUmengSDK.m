//
//  LQUmengSDK.m
//  LQUmengDemo
//
//  Created by Artron_LQQ on 2017/11/18.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "LQUmengSDK.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

// Umeng AppKey
static NSString*  kLQUmengSDK_UMengAppKey = @"";

// QQ
static NSString* kLQUmengSDK_QQAppID = @"";
static NSString* kLQUmengSDK_QQAppKey = @"";
// Wechat
static NSString* kLQUmengSDK_WechatAppID = @"";
static NSString* kLQUmengSDK_WechatAppSecret = @"";
// SinaWeibo
static NSString* kLQUmengSDK_SinaWeiboAppKey = @"";
static NSString* kLQUmengSDK_SinaWeiboAppSecret = @"";
static NSString* kLQUmengSDK_SinaWeibOredirectUri = @"";

@implementation LQUmengSDK

+ (void)registApp {
    // 打开日志调试模式, 集成验证成功后可移除
    [[UMSocialManager defaultManager] openLog:YES];
    // 设置友盟AppKey
    [[UMSocialManager defaultManager] setUmSocialAppkey:kLQUmengSDK_UMengAppKey];
    // 关闭https验证
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    //注册微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kLQUmengSDK_WechatAppID appSecret:kLQUmengSDK_WechatAppSecret redirectURL:nil];
    // 注册QQ
    [[UMSocialManager defaultManager] setPlaform:(UMSocialPlatformType_QQ) appKey:kLQUmengSDK_QQAppID appSecret:nil redirectURL:nil];
    //注册新浪微博
    [[UMSocialManager defaultManager] setPlaform:(UMSocialPlatformType_Sina) appKey:kLQUmengSDK_SinaWeiboAppKey appSecret:kLQUmengSDK_SinaWeiboAppSecret redirectURL:kLQUmengSDK_SinaWeibOredirectUri];
}

+ (BOOL)handle:(NSURL *)url source:(NSString *)source annotation:(id)annotation {
    
    return [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:source annotation:annotation];
}

+ (BOOL)handle:(NSURL *)url option:(NSDictionary *)options {
    
    return [[UMSocialManager defaultManager] handleOpenURL:url options:options];
}

+ (BOOL)handle:(NSURL *)url {
    
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

+ (BOOL)isWechatInstall {
    return [[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)];
}

+ (void)login:(LQLoginType)type
onViewController:(UIViewController *)vc
      success:(void(^)(NSString * uid, NSString * name, NSString * icon, NSString * sex))success
       failed:(void(^)(NSError* error))failed {
    
    UMSocialPlatformType loginType;
    
    switch (type) {
        case LQLoginTypeQQ:
            loginType = UMSocialPlatformType_QQ;
            break;
        case LQLoginTypeWechat:
            loginType = UMSocialPlatformType_WechatSession;
            break;
        case LQLoginTypeSinaWeibo:
            loginType = UMSocialPlatformType_Sina;
            break;
            
        default:
            break;
    }
    
    if (loginType) {
        [[UMSocialManager defaultManager] cancelAuthWithPlatform:loginType completion:^(id result, NSError *error) {
            
        }];
        
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:loginType currentViewController:vc completion:^(id result, NSError *error) {
            
            if (result) {
                UMSocialUserInfoResponse *res = result;
                if (success) {
                    success(res.uid, res.name, res.iconurl, res.unionGender);
                }
            } else {
                if (failed) {
                    failed(error);
                }
            }
        }];
    }
}

+ (void)shareMusic:(NSString *)url
             title:(NSString *)title
        thumbImage:(id)image
             descr:(NSString *)descr
         toSession:(LQShareSession)session
  onViewController:(UIViewController *)vc
           success:(void(^)(void))success
            failed:(void(^)(void))failed {
    
    UMShareMusicObject *obj = [[UMShareMusicObject alloc]init];
    obj.thumbImage = image;
    obj.title = title;
    obj.descr = descr;
    obj.musicUrl = url;
    
    UMSocialMessageObject *message = [UMSocialMessageObject messageObjectWithMediaObject:obj];
    [[UMSocialManager defaultManager] shareToPlatform:[self shareSession:session] messageObject:message currentViewController:vc completion:^(id result, NSError *error) {
        if (result) {
            if (success) {
                success();
            }
        } else {
            if (failed) {
                failed();
            }
        }
    }];
}
+ (void)shareVideo:(NSString *)url
             title:(NSString *)title
        thumbImage:(id)image
             descr:(NSString *)descr
         toSession:(LQShareSession)session
  onViewController:(UIViewController *)vc
           success:(void(^)(void))success
            failed:(void(^)(void))failed {
    
    UMShareVideoObject *obj = [[UMShareVideoObject alloc]init];
    obj.thumbImage = image;
    obj.title = title;
    obj.descr = descr;
    obj.videoUrl = url;
    
    UMSocialMessageObject *message = [UMSocialMessageObject messageObjectWithMediaObject:obj];
    [[UMSocialManager defaultManager] shareToPlatform:[self shareSession:session] messageObject:message currentViewController:vc completion:^(id result, NSError *error) {
        if (result) {
            if (success) {
                success();
            }
        } else {
            if (failed) {
                failed();
            }
        }
    }];
}
+ (void)shareTest:(NSString *)text
        toSession:(LQShareSession)session
 onViewController:(UIViewController *)vc
          success:(void(^)(void))success
           failed:(void(^)(void))failed {
    
    UMSocialMessageObject *message = [[UMSocialMessageObject alloc]init];
    
    message.text = text;
    
    [[UMSocialManager defaultManager] shareToPlatform:[self shareSession:session] messageObject:message currentViewController:vc completion:^(id result, NSError *error) {
        if (result) {
            if (success) {
                success();
            }
        } else {
            if (failed) {
                failed();
            }
        }
    }];
}

+ (void)shareImage:(id)image
        thumbImage:(id)thumbImage
         toSession:(LQShareSession)session
  onViewController:(UIViewController *)vc
           success:(void(^)(void))success
            failed:(void(^)(void))failed {
    
    UMShareImageObject *obj = [[UMShareImageObject alloc]init];
    obj.thumbImage = thumbImage;
    obj.shareImage = image;
    
    UMSocialMessageObject *message = [UMSocialMessageObject messageObjectWithMediaObject:obj];
    [[UMSocialManager defaultManager] shareToPlatform:[self shareSession:session] messageObject:message currentViewController:vc completion:^(id result, NSError *error) {
        if (result) {
            if (success) {
                success();
            }
        } else {
            if (failed) {
                failed();
            }
        }
    }];
}

+ (void)shareWeb:(NSString *)url
           title:(NSString *)title
      thumbImage:(id)image
           descr:(NSString *)descr
       toSession:(LQShareSession)session
onViewController:(UIViewController *)vc
         success:(void(^)(void))success
          failed:(void(^)(void))failed {
    
    UMShareWebpageObject *obj = [[UMShareWebpageObject alloc]init];
    obj.thumbImage = image;
    obj.title = title;
    obj.descr = descr;
    obj.webpageUrl = url;
    
    UMSocialMessageObject *message = [UMSocialMessageObject messageObjectWithMediaObject:obj];
    [[UMSocialManager defaultManager] shareToPlatform:[self shareSession:session] messageObject:message currentViewController:vc completion:^(id result, NSError *error) {
        if (result) {
            if (success) {
                success();
            }
        } else {
            if (failed) {
                failed();
            }
        }
    }];
}

+ (UMSocialPlatformType)shareSession:(LQShareSession)session {
    
    UMSocialPlatformType type;
    switch (session) {
        case LQShareSessionWechatSession:
            type = UMSocialPlatformType_WechatSession;
            break;
        case LQShareSessionWechatTimeline:
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case LQShareSessionWechatFavorite:
            type = UMSocialPlatformType_WechatFavorite;
            break;
        case LQShareSessionQQ:
            type = UMSocialPlatformType_QQ;
            break;
        case LQShareSessionSina:
            type = UMSocialPlatformType_Sina;
            break;
        case LQShareSessionQZone:
            type = UMSocialPlatformType_Qzone;
            break;
        default:
            break;
    }
    
    return type;
}
@end
