//
//  ViewController.m
//  GT3Exmaple
//
//  Created by NikoXu on 21/03/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <GT3Captcha/GT3Captcha.h>

//网站主部署的用于验证注册的接口 (api_1)
#define api_1 @"https://www.geetest.com/demo/gt/register-test"
//网站主部署的二次验证的接口 (api_2)
#define api_2 @"https://www.geetest.com/demo/gt/validate-test"

@interface ViewController () <GT3CaptchaManagerDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loopNavi];
    [self createCaptcha];
}

- (void)loopNavi {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(pushVC)];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:buttonItem];
}

- (void)pushVC {
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createCaptcha {
    //创建验证管理器实例
    GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_2 timeout:5.0];
    captchaManager.delegate = self;
    
//    [captchaManager enableDebugMode:YES];
    
    //创建验证视图的实例, 并添加到父视图上
    GT3CaptchaButton *captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44) captchaManager:captchaManager];
    captchaButton.center = self.view.center;
    //推荐直接开启验证
    [captchaButton startCaptcha];
    [self.view addSubview:captchaButton];
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    NSLog(@"User Did Close GTView");
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    NSLog(@"\nerror: %@,\nmetadata: %@,\nmethod hint: %@", error.localizedDescription, [[NSString alloc] initWithData:error.metaData encoding:NSUTF8StringEncoding], error.gtDescription);
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    if (!error) {
        //处理你的验证结果
        NSLog(@"\nsession ID: %@,\ndata: %@", [manager getCookieValue:@"msid"], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //成功请调用decisionHandler(GT3SecondaryCaptchaPolicyAllow)
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        //失败请调用decisionHandler(GT3SecondaryCaptchaPolicyForbidden)
        //decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
    }
    else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        NSLog(@"validate error: %ld, %@", (long)error.code, error.localizedDescription);
    }
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error {
    if (!error) {
        NSLog(@"didReceiveDataFromAPI1:\n%@", dictionary);
    }
    else {
        NSLog(@"didReceiveDataFromAPI1 error: %@", error.localizedDescription);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
