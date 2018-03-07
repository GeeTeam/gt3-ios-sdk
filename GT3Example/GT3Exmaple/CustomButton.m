//
//  CustomButton.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 08/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "CustomButton.h"
#import "TipsView.h"

//网站主部署的用于验证注册的接口 (api_1)
#define api_1 @"http://www.geetest.com/demo/gt/register-slide"
//网站主部署的二次验证的接口 (api_2)
#define api_2 @"http://www.geetest.com/demo/gt/validate-slide"

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
    }
    return _manager;
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
    self.indicatorView = [self createActivityIndicator];
    // 必须调用, 用于注册获取验证初始化数据
    [self.manager registerCaptcha:nil];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.originalTitle = self.titleLabel.text;
        self.titleFlag = YES;
        [self setTitle:@"" forState:UIControlStateNormal];
        self.titleFlag = NO;
        [self setUserInteractionEnabled:NO];
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.indicatorView];
        [self centerActivityIndicatorInButton];
        [self.indicatorView startAnimating];
    });
}

- (void)removeIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTitle:self.originalTitle forState:UIControlStateNormal];
        [self setUserInteractionEnabled:YES];
        [self.indicatorView removeFromSuperview];
    });
}

- (void)centerActivityIndicatorInButton {
    NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [self addConstraints:@[constraintX, constraintY]];
}

#pragma mark GT3CaptchaManagerDelegate

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
    [TipsView showTipOnKeyWindow:@"DEMO: 验证已被取消"];
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
        [TipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(captcha:didReceiveSecondaryCaptchaData:response:error:)]) {
        [_delegate captcha:manager didReceiveSecondaryCaptchaData:data response:response error:error];
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

/** 自定义处理API1返回的数据并将验证初始化数据解析给管理器
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

#pragma mark GT3CaptchaManagerViewDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager updateCaptchaStatus:(GT3CaptchaState)state error:(GT3Error *)error {
    
    switch (state) {
        case GT3CaptchaStateInactive:
        case GT3CaptchaStateActive:
        case GT3CaptchaStateComputing: {
            [self showIndicator];
            break;
        }
        case GT3CaptchaStateInitial:
        case GT3CaptchaStateFail:
        case GT3CaptchaStateError:
        case GT3CaptchaStateSuccess:
        case GT3CaptchaStateCancel: {
            [self removeIndicator];
            break;
        }
        case GT3CaptchaStateWaiting:
        case GT3CaptchaStateCollecting:
        default: {
            break;
        }
    }
}

@end
