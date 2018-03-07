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
#import "TipsView.h"

#import "NSAttributedString+AttributedString.h"

//网站主部署的用于验证登录的接口 (api_1)
#define api_1 @"http://www.geetest.com/demo/gt/register-slide"
//网站主部署的二次验证的接口 (api_2)
#define api_2 @"http://www.geetest.com/demo/gt/validate-slide"

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
        captchaManager.maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
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
    self.emailTextField.text = @"123@abc.com";
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
    self.captchaButton.center = CGPointMake(self.view.center.x, self.view.center.y + 76);
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
        button.center = CGPointMake(self.view.center.x, self.view.center.y + 130);
        
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
        [TipsView showTipOnKeyWindow:@"DEMO: 请输入正确的邮箱或密码"];
    }
    return NO;
}

- (void)captcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error {
    //演示中全部默认为成功, 不对返回做判断
    [TipsView showTipOnKeyWindow:@"DEMO: 登录成功"];
}

#pragma MARK - GT3CaptchaManagerDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    if (error.code == -999) {
        // 请求被意外中断, 一般由用户进行取消操作导致, 可忽略错误
    }
    else if (error.code == -10) {
        // 预判断时被封禁, 不会再进行图形验证
    }
    else if (error.code == -20) {
        // 尝试过多
    }
    else {
        // 网络问题或解析失败, 更多错误码参考开发文档
    }
    [TipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
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
            [TipsView showTipOnKeyWindow:@"DEMO: 登入成功"];
        }
    }
    else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        [TipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
    }
}

/** 修改API2的请求
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendSecondaryCaptchaRequest:(NSURLRequest *)originalRequest withReplacedRequest:(void (^)(NSMutableURLRequest *))replacedRequest {
    
}
 */

/** 不使用默认的二次验证接口
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
    
    __block NSMutableString *postResult = [[NSMutableString alloc] init];
    [result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [postResult appendFormat:@"%@=%@&",key,obj];
    }];
    
    NSDictionary *headerFields = @{@"Content-Type":@"application/x-www-form-urlencoded;charset=UTF-8"};
    NSMutableURLRequest *secondaryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:api_2] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    secondaryRequest.HTTPMethod = @"POST";
    secondaryRequest.allHTTPHeaderFields = headerFields;
    secondaryRequest.HTTPBody = [postResult dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:secondaryRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [manager closeGTViewIfIsOpen];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
            if (!err) {
                NSString *status = [dict objectForKey:@"status"];
                if ([status isEqualToString:@"success"]) {
                    NSLog(@"通过业务流程");
                }
                else {
                    NSLog(@"无法通过业务流程");
                }
            }
        }
    }];
    
    [task resume];
}

- (BOOL)shouldUseDefaultSecondaryValidate:(GT3CaptchaManager *)manager {
    return NO;
}
  */

/** 处理API1返回的数据并将验证初始化数据解析给管理器
- (NSDictionary *)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error {
    
}
 */

/** 修改API1的请求 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSString *newURL = [NSString stringWithFormat:@"%@?t=%.0f", originalRequest.URL.absoluteString, [[[NSDate alloc] init]timeIntervalSince1970]];
    mRequest.URL = [NSURL URLWithString:newURL];
    
    replacedHandler(mRequest);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
