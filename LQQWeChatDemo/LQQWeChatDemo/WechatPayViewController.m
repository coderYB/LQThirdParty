//
//  WechatPayViewController.m
//  LQQWeChatDemo
//
//  Created by Artron_LQQ on 16/2/29.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "WechatPayViewController.h"
#import "HYBNetworking.h"
#import "WXApi.h"

@interface WechatPayViewController ()

@end

@implementation WechatPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.center = self.view.center;
    payButton.bounds = CGRectMake(0, 0, 200, 200);
    [payButton setImage:[UIImage imageNamed:@"wechatPay_icon@2x"] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    
    // 判断 用户是否安装微信
    //如果判断结果一直为NO,可能appid无效,这里的是无效的
//    if([WXApi isWXAppInstalled])
    
    {
        // 监听一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"ORDER_PAY_NOTIFICATION" object:nil];
    }

}

-(void)payClick {
    [self easyPay];
}


/**
 *  @author LQQ, 16-02-29 17:02:47
 *
 *  http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php为测试数据,一般可以从这儿拿到的数据都可以让服务器端去完成,客户端只需获取到然后配置到PayReq,即可吊起微信;
 */
-(void)easyPay {
    [HYBNetworking getWithUrl:@"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php" params:nil success:^(id response) {
        NSLog(@"%@",response);
        
        //配置调起微信支付所需要的参数
        
        PayReq *req  = [[PayReq alloc] init];
        
        req.partnerId = [response objectForKey:@"partnerid"];
        req.prepayId = [response objectForKey:@"prepayid"];
        req.package = [response objectForKey:@"package"];
        req.nonceStr = [response objectForKey:@"noncestr"];
        req.timeStamp = [[response objectForKey:@"timestamp"]intValue];
        req.sign = [response objectForKey:@"sign"];
        
        //调起微信支付
        if ([WXApi sendReq:req]) {
            NSLog(@"吊起成功");
        }

        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 收到支付成功的消息后作相应的处理
- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"]) {
        NSLog(@"支付成功");
    } else {
        NSLog(@"支付失败");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
