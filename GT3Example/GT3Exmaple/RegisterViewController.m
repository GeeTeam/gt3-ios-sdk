//
//  RegisterViewController.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "RegisterViewController.h"
#import <GT3Captcha/GT3Captcha.h>
#import <WebKit/WebKit.h>

#import "CustomButton.h"
#import "TextField.h"
#import "TipsLabel.h"

#import "NSAttributedString+AttributedString.h"

//网站主部署的用于验证注册的接口 (api_1)
#define api_1 @"https://www.geetest.com/demo/gt/register-test"
//网站主部署的二次验证的接口 (api_2)
#define api_2 @"http://101.200.132.124:9977/gt/validate-test"

@interface RegisterViewController () <GT3CaptchaManagerDelegate, CaptchaButtonDelegate>

@property (nonatomic, strong) TextField *phoneNumberTextField;
@property (nonatomic, strong) TextField *smsCodeTextField;

@property (nonatomic, strong) GT3CaptchaButton *captchaButton;

@end

@implementation RegisterViewController

- (GT3CaptchaButton *)captchaButton {
    if (!_captchaButton) {
        //创建验证管理器实例
        GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_2 timeout:5.0];
        captchaManager.delegate = self;
        captchaManager.maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        //debug mode
//        [captchaManager enableDebugMode:YES];
        //创建验证视图的实例
        _captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(0, 0, 260, 44) captchaManager:captchaManager];
    }
    return _captchaButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _init];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (self.flag) {
        [self.captchaButton stopCaptcha];
    }
    
    [super viewDidDisappear:animated];
}

- (void)_init {
    [self setupTitle];
    [self setupPhoneNumberTextField];
    [self setupSMSCodeTextField];
    [self setupSMSButton];
    if (self.flag) {
        [self createDefaultButton];
    }
    [self setupRegisterButton];
}

- (void)setupTitle {
    UILabel *label = [[UILabel alloc] init];
    
    NSAttributedString *attrString = [NSAttributedString generate:@"注册" fontSize:36.0 color:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]];
    
    label.attributedText = attrString;
    [label sizeToFit];
    
    label.center = CGPointMake(self.view.center.x, self.view.center.y - 132);
    
    [self.view addSubview:label];
}

- (void)setupPhoneNumberTextField {
    self.phoneNumberTextField = [[TextField alloc] initWithFrame:CGRectMake(0, 0, 260, 40) placeholder:@"手机号" keyboardType:UIKeyboardTypeNumbersAndPunctuation lengthLimit:44];
    self.phoneNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneNumberTextField.center = CGPointMake(self.view.center.x, self.view.center.y - 22);
    
    [self.view addSubview:self.phoneNumberTextField];
}

- (void)setupSMSCodeTextField {
    self.smsCodeTextField = [[TextField alloc] initWithFrame:CGRectMake(0, 0, 124, 40) placeholder:@"短信验证码" keyboardType:UIKeyboardTypeNumberPad lengthLimit:44];
    self.smsCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.smsCodeTextField.center = CGPointMake(self.view.center.x - 68, self.view.center.y + 22);
    
    [self.view addSubview:self.smsCodeTextField];
}

- (void)setupSMSButton {
    
    if (self.flag) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 124, 40)];
        button.backgroundColor = [UIColor colorWithRed:0.36 green:0.8 blue:0.44 alpha:1.0];
        [button setClipsToBounds:YES];
        
        NSAttributedString *attrString = [NSAttributedString generate:@"获取验证码" fontSize:16.0 color:[UIColor whiteColor]];
        
        button.layer.cornerRadius = 2.0;
        button.titleLabel.attributedText = attrString;
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.center = CGPointMake(self.view.center.x + 68, self.view.center.y + 22);
        
        [button addTarget:self action:@selector(captcha) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    else {
        CustomButton *button = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 124, 40)];
        button.delegate = self;
        button.backgroundColor = [UIColor colorWithRed:0.36 green:0.8 blue:0.44 alpha:1.0];
        [button setClipsToBounds:YES];
        
        NSAttributedString *attrString = [NSAttributedString generate:@"获取验证码" fontSize:16.0 color:[UIColor whiteColor]];
        
        button.layer.cornerRadius = 2.0;
        button.titleLabel.attributedText = attrString;
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.center = CGPointMake(self.view.center.x + 68, self.view.center.y + 22);
        
        [self.view addSubview:button];
    }
}

- (void)setupRegisterButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
    
    button.backgroundColor = [UIColor lightGrayColor];
    [button setClipsToBounds:YES];
    
    NSAttributedString *attrString = [NSAttributedString generate:@"登录" fontSize:16.0 color:[UIColor whiteColor]];
    
    button.layer.cornerRadius = 2.0;
    button.titleLabel.attributedText = attrString;
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    CGFloat bias = self.flag ? 0.0 : -56.0;
    button.center = CGPointMake(self.view.center.x, self.view.center.y + 130 + bias);
    
    [button addTarget:self action:@selector(userRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)captcha {
    
}

- (void)userRegister {
    
}

- (void)createDefaultButton {
    
    //添加验证按钮到父视图上
    self.captchaButton.center = CGPointMake(self.view.center.x, self.view.center.y + 76);
    //推荐直接开启验证
    [self.captchaButton startCaptcha];
    [self.view addSubview:self.captchaButton];
}

#pragma mark - CaptchaButtonDelegate

- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button {
    if (self.phoneNumberTextField.text.length == 11) {
        return YES;
    }
    else {
        [TipsLabel showTipOnKeyWindow:@"DEMO: 不合法的手机号"];
    }
    return NO;
}

- (void)captcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error {
    if ([self.phoneNumberTextField.text isEqualToString:@"12345678900"]) {
        [TipsLabel showTipOnKeyWindow:@"DEMO: 已存在的手机号"];
    }
    else {
        self.smsCodeTextField.text = @"88888888";
        [TipsLabel showTipOnKeyWindow:@"DEMO: 获取短信验证码:88888888" fontSize:12];
    }
}

#pragma mark - GT3CaptchaManagerDelegate

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
            [TipsLabel showTipOnKeyWindow:@"DEMO: 登入成功"];
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
