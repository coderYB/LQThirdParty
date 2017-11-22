//
//  LQShareSDK.m
//  LQShareSDK
//
//  Created by Artron_LQQ on 2017/11/17.
//  Copyright © 2017年 Artup. All rights reserved.
//
#import "LQShareSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"


// ShareSDK AppID
static NSString* kShareSDK_AppID = @"";
static NSString* kShareSDK_Secret = @"";

// QQ
static NSString* kShareSDK_QQAppID = @"";
static NSString* kShareSDK_QQAppKey = @"";
// Wechat
static NSString* kShareSDK_WechatAppID = @"";
static NSString* kShareSDK_WechatAppSecret = @"";
// SinaWeibo
static NSString* kShareSDK_SinaWeiboAppKey = @"";
static NSString* kShareSDK_SinaWeiboAppSecret = @"";
static NSString* kShareSDK_SinaWeibOredirectUri = @"";

@implementation LQShareSDK

+ (void)registApp {
    
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeQQ), @(SSDKPlatformTypeWechat), @(SSDKPlatformTypeSinaWeibo)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:kShareSDK_SinaWeiboAppKey
                                          appSecret:kShareSDK_SinaWeiboAppSecret
                                        redirectUri:kShareSDK_SinaWeibOredirectUri
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:kShareSDK_WechatAppID
                                      appSecret:kShareSDK_WechatAppSecret];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:kShareSDK_QQAppID
                                     appKey:kShareSDK_QQAppKey
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}

+ (BOOL)isWechatInstall {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        return YES;
    }
    return NO;
}

+ (void)logout {
    BOOL isQQAuth = [ShareSDK hasAuthorized:SSDKPlatformTypeQQ];
    BOOL isWechatAuth = [ShareSDK hasAuthorized:(SSDKPlatformTypeWechat)];
    BOOL isSinaAuth = [ShareSDK hasAuthorized:(SSDKPlatformTypeSinaWeibo)];
    if (isQQAuth) {
        [ShareSDK cancelAuthorize:(SSDKPlatformTypeQQ)];
    }
    
    if (isSinaAuth) {
        [ShareSDK cancelAuthorize:(SSDKPlatformTypeSinaWeibo)];
    }
    
    if (isWechatAuth) {
        [ShareSDK cancelAuthorize:(SSDKPlatformTypeWechat)];
    }
}

+ (void) login:(LQLoginType)type
       success:(void(^)(NSString * uid, NSString * name, NSString * icon, NSString * sex))success
        failed:(void(^)(NSError* error))failed {
    SSDKPlatformType shareType;
    switch (type) {
        case LQLoginTypeQQ:
            shareType = SSDKPlatformTypeQQ;
            break;
        case LQLoginTypeWechat:
            shareType = SSDKPlatformTypeWechat;
            break;
        case LQLoginTypeSinaWeibo:
            shareType = SSDKPlatformTypeSinaWeibo;
            break;
        default:
            break;
    }
    
    if (shareType) {
        [ShareSDK cancelAuthorize:shareType];
        [ShareSDK getUserInfo:shareType onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                if (success) {
                    NSString *sex = @"未知";
                    if (user.gender == 0) {
                        sex = @"男";
                    } else if (user.gender == 1) {
                        sex = @"女";
                    }
                    success(user.uid, user.nickname, user.icon, sex);
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
        thumbImage:(id)image
             title:(NSString *)title
             descr:(NSString *)descr
         toSession:(LQShareSession)session
           success:(void(^)(void))success
            failed:(void(^)(void))failed {
    
    NSMutableDictionary *shareParems = [NSMutableDictionary dictionary];
    [shareParems SSDKSetupShareParamsByText:descr images:image url:[NSURL URLWithString:url] title:title type:SSDKContentTypeAudio];
    [ShareSDK share:[self shareSession:session] parameters:shareParems onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
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
        thumbImage:(id)image
             title:(NSString *)title
             descr:(NSString *)descr
         toSession:(LQShareSession)session
           success:(void(^)(void))success
            failed:(void(^)(void))failed {
    
    NSMutableDictionary *shareParems = [NSMutableDictionary dictionary];
    [shareParems SSDKSetupShareParamsByText:descr images:image url:[NSURL URLWithString:url] title:title type:SSDKContentTypeVideo];
    [ShareSDK share:[self shareSession:session] parameters:shareParems onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
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
      thumbImage:(id)image
           title:(NSString *)title
           descr:(NSString *)descr
       toSession:(LQShareSession)session
         success:(void(^)(void))success
          failed:(void(^)(void))failed {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:descr images:image url:[NSURL URLWithString:url] title:title type:SSDKContentTypeWebPage];
    
    [ShareSDK share:[self shareSession:session] parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
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
         toSession:(LQShareSession)session
           success:(void(^)(void))success
            failed:(void(^)(void))failed {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil images:image url:nil title:nil type:SSDKContentTypeImage];
    
    [ShareSDK share:[self shareSession:session] parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
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

+ (void)shareText:(NSString *)text
        toSession:(LQShareSession)session
          success:(void(^)(void))success
           failed:(void(^)(void))failed {
    
    NSMutableDictionary *shareParams = [[NSMutableDictionary alloc]init];
    [shareParams SSDKSetupShareParamsByText:text images:nil url:nil title:nil type:SSDKContentTypeText];
    [ShareSDK share:[self shareSession:session] parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
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

+ (SSDKPlatformType) shareSession:(LQShareSession)type {
    SSDKPlatformType shareType;
    switch (type) {
        case LQShareSessionQQ:
            shareType = SSDKPlatformSubTypeQQFriend;
            break;
        case LQShareSessionQzone:
            shareType = SSDKPlatformSubTypeQZone;
            break;
        case LQShareSessionWechatSession:
            shareType = SSDKPlatformSubTypeWechatSession;
            break;
        case LQShareSessionWecharTimeline:
            shareType = SSDKPlatformSubTypeWechatTimeline;
            break;
        case LQShareSessionWechatFavorite:
            shareType = SSDKPlatformSubTypeWechatFav;
            break;
        case LQShareSessionSina:
            shareType = SSDKPlatformTypeSinaWeibo;
            break;
        default:
            break;
    }
    
    return shareType;
}




















@end
