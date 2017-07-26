//
//  AsyncButton.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 25/05/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "AsyncButton.h"
#import "TipsView.h"

//网站主部署的用于验证注册的接口 (api_1)
#define api_1 @"https://www.geetest.com/demo/gt/register-fullpage"
//网站主部署的二次验证的接口 (api_2)
#define api_2 @"http://www.geetest.com/demo/gt/validate-test"

@interface AsyncButton () <GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) GT3CaptchaManager *manager;

@property (nonatomic, strong) NSString *originalTitle;

@property (nonatomic, assign) BOOL titleFlag;

@end

@implementation AsyncButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    if (!self.titleFlag) {
        self.originalTitle = title;
    }
}

- (GT3CaptchaManager *)manager {
    if (!_manager) {
        _manager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_2 timeout:5.0];
        _manager.delegate = self;
        _manager.viewDelegate = self;
        
        //        [_manager enableDebugMode:YES];
        [_manager useVisualViewWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        //        _manager.maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _manager;
}

- (void)dealloc {
    [self.manager stopGTCaptcha];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self requestBusinessData];
        
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self requestBusinessData];
        
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startCaptcha)];
        //        [self addGestureRecognizer:tap];
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)requestBusinessData {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[[NSURLSessionConfiguration alloc] init]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"www.geetest.com"]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // receive 
            [self setUserInteractionEnabled:NO];
            [self.manager registerCaptcha:^{
                [self removeIndicator];
                [self setUserInteractionEnabled:YES];
            }];
        }
        else {
            NSLog(@"error:\n%@", error.localizedDescription);
        }
    }];
    
    [task resume];
}

- (UIActivityIndicatorView *)createActivityIndicator {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setHidesWhenStopped:YES];
    [_indicatorView stopAnimating];
    
    return indicatorView;
}

- (void)startCaptcha {
    if (_delegate && [_delegate respondsToSelector:@selector(captchaButtonShouldBeginTapAction:)]) {
        if (![_delegate captchaButtonShouldBeginTapAction:self]) {
            return;
        }
    }
    [self.manager startGTCaptchaWithAnimated:YES];
}

- (void)stopCaptcha {
    [self.manager stopGTCaptcha];
}

- (void)showIndicator {
    self.originalTitle = self.titleLabel.text;
    self.titleFlag = YES;
    [self setTitle:@"" forState:UIControlStateNormal];
    self.titleFlag = NO;
    [self setUserInteractionEnabled:NO];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.indicatorView];
    [self centerActivityIndicatorInButton];
    [self.indicatorView startAnimating];
}

- (void)removeIndicator {
    [self setTitle:self.originalTitle forState:UIControlStateNormal];
    [self setUserInteractionEnabled:YES];
    [self.indicatorView removeFromSuperview];
}

- (void)centerActivityIndicatorInButton {
    NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [self addConstraints:@[constraintX, constraintY]];
}

#pragma mark GT3CaptchaManagerDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    [TipsView showTipOnKeyWindow:[NSString stringWithFormat:@"验证发生错误\n%@", error.localizedDescription]];
    NSLog(@"\nerror: %@,\nmetadata: %@,\nmethod hint: %@", error.localizedDescription, [[NSString alloc] initWithData:error.metaData encoding:NSUTF8StringEncoding], error.gtDescription);
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    [TipsView showTipOnKeyWindow:@"验证已被取消"];
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
        
    }
    else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        NSLog(@"validate error: %ld, %@", (long)error.code, error.localizedDescription);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(captcha:didReceiveSecondaryCaptchaData:response:error:)]) {
        [_delegate captcha:manager didReceiveSecondaryCaptchaData:data response:response error:error];
    }
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendSecondaryCaptchaRequest:(void (^)(NSMutableURLRequest *))requestHandler {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:api_2] cachePolicy:0 timeoutInterval:5.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    requestHandler(request);
}

- (NSDictionary *)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error {
    if (!error) {
        NSLog(@"didReceiveDataFromAPI1:\n%@", dictionary);
    }
    else {
        NSLog(@"error: %@", error.localizedDescription);
    }
    
    return nil;
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(void (^)(NSURLRequest *))requestHandler {
//    NSString *rand = [NSString stringWithFormat:@"%d", arc4random() % 10000];
//    [manager configureSuperProperty:@{@"rand": rand}];
    NSURL *newURL = [NSURL URLWithString:api_1];
    NSURLRequest *request = [NSURLRequest requestWithURL:newURL cachePolicy:0 timeoutInterval:5.0];
    requestHandler(request);
}

#pragma mark GT3CaptchaManagerViewDelegate

- (void)gtCaptchaWillShowGTView:(GT3CaptchaManager *)manager {
    NSLog(@"GTView Will Show.");
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager updateCaptchaStatus:(GT3CaptchaState)state tip:(NSString *)tip color:(UIColor *)color {
    
    switch (state) {
        case GT3CaptchaStateComputing: {
            [self showIndicator];
            break;
        }
        case GT3CaptchaStateWaiting:
        case GT3CaptchaStateCollecting:
        case GT3CaptchaStateFail:
        case GT3CaptchaStateError:
        case GT3CaptchaStateSuccess: {
            [self removeIndicator];
            break;
        }
        case GT3CaptchaStateInactive:
        case GT3CaptchaStateActive:
        case GT3CaptchaStateInitial:
        default: {
            break;
        }
    }
}

@end
