//
//  CustomButton.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 08/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "CustomButton.h"
#import "TipsLabel.h"

//网站主部署的用于验证注册的接口 (api_1)
#define api_1 @"https://www.geetest.com/demo/gt/register-test"
//网站主部署的二次验证的接口 (api_2)
#define api_2 @"http://101.200.132.124:9977/gt/validate-test"

@interface CustomButton () <GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) GT3CaptchaManager *manager;

@property (nonatomic, strong) NSString *originalTitle;

@property (nonatomic, assign) BOOL titleFlag;

@end

@implementation CustomButton

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
    [[self manager] stopGTCaptcha];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self _init];
        
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _init];
        
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)_init {
    [self setUserInteractionEnabled:NO];
    self.indicatorView = [self createActivityIndicator];
    [self showIndicator];
    // 必须调用, 用于注册获取验证初始化数据
    [self.manager registerCaptcha:^{
        [self removeIndicator];
        [self setUserInteractionEnabled:YES];
    }];
}

- (UIActivityIndicatorView *)createActivityIndicator {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView stopAnimating];
    
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
    [TipsLabel showTipOnKeyWindow:[NSString stringWithFormat:@"DEMO: 验证发生错误\n%@", error.localizedDescription]];
    NSLog(@"\nerror: %@,\nmetadata: %@,\nmethod hint: %@", error.localizedDescription, [[NSString alloc] initWithData:error.metaData encoding:NSUTF8StringEncoding], error.gtDescription);
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    [TipsLabel showTipOnKeyWindow:@"DEMO: 验证已被取消"];
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

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error {
    if (!error) {
        NSLog(@"\n%@", dictionary);
    }
    else {
        NSLog(@"error: %@", error.localizedDescription);
    }
}

#pragma mark GT3CaptchaManagerViewDelegate

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
