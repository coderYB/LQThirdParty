//
//  ViewController.m
//  LQUnionPayDemo
//
//  Created by LiuQiqiang on 2018/11/28.
//  Copyright © 2018 LiuQiqiang. All rights reserved.
//

#import "ViewController.h"
#import "LQUnionPay.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(40, 100, 100, 40);
    [button addTarget:self action:@selector(testAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    NSLog(@"%d", [LQUnionPay isUnionAppInstall]);
}

- (void) testAction {
    [LQUnionPay startPayWithTN:@"" onViewController:self resultHandler:^(LQUnionPayResult result, NSDictionary *info) {
        
        NSLog(@"%lu --- %@", (unsigned long)result, info);
    }];
}
@end
