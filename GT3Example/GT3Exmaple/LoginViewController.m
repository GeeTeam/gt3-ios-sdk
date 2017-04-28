//
//  ViewController.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 17/02/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "LoginViewController.h"
#import <GT3Captcha/GT3Captcha.h>
#import <WebKit/WebKit.h>

#import "CustomButton.h"
#import "TextField.h"
#import "TipsLabel.h"

#import "NSAttributedString+AttributedString.h"

//网站主部署的用于验证登录的接口 (api_1)
#define api_1 @"https://www.geetest.com/demo/gt/register-test"
//网站主部署的二次验证的接口 (api_2)
#define api_2 @"http://101.200.132.124:9977/gt/validate-test"

@interface LoginViewController () <GT3CaptchaManagerDelegate, CaptchaButtonDelegate>

@property (nonatomic, strong) TextField *emailTextField;
@property (nonatomic, strong) TextField *passwordTextField;
@property (nonatomic, strong) GT3CaptchaButton *captchaButton;


@end

@implementation LoginViewController

- (GT3CaptchaButton *)captchaButton {
    if (!_captchaButton) {
        //创建验证管理器实例
        GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_2 timeout:5.0];
        captchaManager.delegate = self;
        
        //debug mode
//        [captchaManager enableDebugMode:YES];
        //创建验证视图的实例
        _captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(0, 0, 260, 40) captchaManager:captchaManager];
    }
    return _captchaButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)createCustomButton {
    
    CustomButton *yourButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    [yourButton setTitle:@"  发送" forState:UIControlStateNormal];
    yourButton.center = self.view.center;
    yourButton.backgroundColor = [UIColor colorWithRed:237.0/255 green:107.0/255 blue:98.0/255 alpha:1.0];
    yourButton.layer.cornerRadius = 2.0;
    
    [self.view addSubview:yourButton];
}

- (void)_setup {
    [self setupTitle];
    [self setupEmailTextField];
    [self setupPasswordTextField];
    if (self.flag) {
        [self createDefaultButton];
    }
    [self setupLoginButton];
}

- (void)setupTitle {
    UILabel *label = [[UILabel alloc] init];
    
    NSAttributedString *attrString = [NSAttributedString generate:@"登录" fontSize:36.0 color:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]];
    
    label.attributedText = attrString;
    [label sizeToFit];
    
    label.center = CGPointMake(self.view.center.x, self.view.center.y - 132);
    
    [self.view addSubview:label];
}

- (void)setupEmailTextField {
    self.emailTextField = [[TextField alloc] initWithFrame:CGRectMake(0, 0, 260, 40) placeholder:@"邮箱" keyboardType:UIKeyboardTypeEmailAddress lengthLimit:44];
    self.emailTextField.center = CGPointMake(self.view.center.x, self.view.center.y - 22);
    self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.view addSubview:self.emailTextField];
}

- (void)setupPasswordTextField {
    self.passwordTextField = [[TextField alloc] initWithFrame:CGRectMake(0, 0, 260, 40) placeholder:@"密码" keyboardType:UIKeyboardTypeASCIICapable lengthLimit:24];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.center = CGPointMake(self.view.center.x, self.view.center.y + 22);
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.view addSubview:self.passwordTextField];
}

- (void)createDefaultButton {
    
    //添加验证按钮到父视图上
    self.captchaButton.center = CGPointMake(self.view.center.x, self.view.center.y + 74);
    //推荐直接开启验证
    [self.captchaButton startCaptcha];
    [self.view addSubview:self.captchaButton];
}

- (void)setupLoginButton {
    if (self.flag) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
        button.backgroundColor = [UIColor colorWithRed:0.3 green:0.63 blue:1.0 alpha:1.0];
        [button setClipsToBounds:YES];
        
        NSAttributedString *attrString = [NSAttributedString generate:@"登录" fontSize:16.0 color:[UIColor whiteColor]];
        
        button.layer.cornerRadius = 2.0;
        button.titleLabel.attributedText = attrString;
        [button setTitle:@"登录" forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.center = CGPointMake(self.view.center.x, self.view.center.y + 126);
        
        [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    else {
        CustomButton *button = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
        button.delegate = self;
        button.backgroundColor = [UIColor colorWithRed:0.3 green:0.63 blue:1.0 alpha:1.0];
        [button setClipsToBounds:YES];
        
        NSAttributedString *attrString = [NSAttributedString generate:@"登录" fontSize:16.0 color:[UIColor whiteColor]];
        
        button.layer.cornerRadius = 2.0;
        button.titleLabel.attributedText = attrString;
        [button setTitle:@"登录" forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.center = CGPointMake(self.view.center.x, self.view.center.y + 74);
        
        [self.view addSubview:button];
    }
}

- (void)login {
    
}

#pragma MARK - CaptchaButtonDelegate

- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button {
    if (self.emailTextField.text.length >= 8 && self.passwordTextField.text.length >= 8) {
        return YES;
    }
    else {
        [TipsLabel showTipOnKeyWindow:@"请输入正确的邮箱或密码"];
    }
    return NO;
}

- (void)captcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error {
    //演示中全部默认为成功, 不对返回做判断
    [TipsLabel showTipOnKeyWindow:@"登录成功"];
}

#pragma MARK - GT3CaptchaManagerDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    NSLog(@"\nerror: %@,\nmetadata: %@,\nmethod hint: %@", error.localizedDescription, [[NSString alloc] initWithData:error.metaData encoding:NSUTF8StringEncoding], error.gtDescription);
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    NSLog(@"User Did Close GTView.");
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    if (!error) {
        //处理你的验证结果
        NSLog(@"\ndata: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //成功请调用decisionHandler(GT3SecondaryCaptchaPolicyAllow)
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        //失败请调用decisionHandler(GT3SecondaryCaptchaPolicyForbidden)
        //decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        
        if (!self.flag) {
            [TipsLabel showTipOnKeyWindow:@"登入成功"];
        }
    }
    else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        NSLog(@"validate error: %ld, %@", (long)error.code, error.localizedDescription);
    }
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error {
    if (!error) {
        NSLog(@"\n%@", dictionary);
    }
    else {
        NSLog(@"error: %@", error.localizedDescription);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
