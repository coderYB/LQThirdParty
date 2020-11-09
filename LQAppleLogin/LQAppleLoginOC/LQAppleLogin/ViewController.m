//
//  ViewController.m
//  LQAppleLogin
//
//  Created by 刘启强 on 2019/10/10.
//  Copyright © 2019 Q.ice. All rights reserved.
//

#import "ViewController.h"
//#import <AuthenticationServices/AuthenticationServices.h>
#import "LQAppleLogin.h"
#import <AuthenticationServices/ASAuthorizationAppleIDButton.h>
@interface ViewController ()

@end

@implementation ViewController
- (void) performExistingAccount {
    
    
}
- (void) checkLoginState {
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton buttonWithType:(ASAuthorizationAppleIDButtonTypeSignIn) style:(ASAuthorizationAppleIDButtonStyleBlack)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    button.frame = CGRectMake(60, 60, 60, 60);
    [self.view addSubview:button];
    
    [LQAppleLogin checkAuthorizationStateWithUser:@"userid" completeHandler:^(BOOL authorized, NSString * _Nonnull msg) {
        NSLog(@"%d--%@", authorized, msg);
    }];
}

- (void) buttonAction:(ASAuthorizationAppleIDButton *)button {
    NSLog(@"ddddd");
    [[LQAppleLogin shared] loginWithCompleteHandler:^(BOOL successed, NSString * _Nullable user, NSString * _Nullable familyName, NSString * _Nullable givenName, NSString * _Nullable email, NSString * _Nullable password, NSData * _Nullable identityToken, NSData * _Nullable authorizationCode, NSError * _Nullable error, NSString * _Nonnull msg) {
        
        NSLog(@"%@--%@--%@", user, familyName, email);
    }];
//    [self performExistingAccount];
    
}

- (void) firstAuthorization {
    
}



@end
