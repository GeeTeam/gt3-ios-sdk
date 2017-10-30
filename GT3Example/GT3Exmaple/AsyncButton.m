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
#define api_1 @"http://www.geetest.com/demo/gt/register-fullpage"
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
    if (_manager) {
        [_manager stopGTCaptcha];
    }
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
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startCaptcha)];
//        [self addGestureRecognizer:tap];
        [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)_init {
    [self.manager registerCaptcha:nil];
}

- (void)startCaptcha {
    if (_delegate && [_delegate respondsToSelector:@selector(captchaButtonShouldBeginTapAction:)]) {
        if (![_delegate captchaButtonShouldBeginTapAction:self]) {
            return;
        }
    }
    /**
     *  TO-DO 从接口解析是否开启极验3.0, 并解析和配置验证参数
     *  不要重复调用, 在交互上需要处理用户的短时间内多次点击的问题
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[[NSURLSessionConfiguration alloc] init]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:api_1]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&error];
            
            if (!error && dict) {
                NSString *geetest_id = [dict objectForKey:@"gt"];
                NSString *geetest_challenge = [dict objectForKey:@"challenge"];
                NSNumber *geetest_success = [dict objectForKey:@"success"];
                // 不要重复调用
                [self.manager configureGTest:geetest_id challenge:geetest_challenge success:geetest_success withAPI2:api_2];
                [self.manager startGTCaptchaWithAnimated:YES];
            }
        }
        else {
            NSLog(@"error:\n%@", error.localizedDescription);
        }
    }];
    
    [task resume];
}

- (void)stopCaptcha {
    [self.manager stopGTCaptcha];
}

#pragma mark GT3CaptchaManagerDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    
}

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
    
    [TipsView showTipOnKeyWindow:[NSString stringWithFormat:@"验证发生错误\n%@", error.localizedDescription]];
    NSLog(@"\nerror: %@,\nmetadata: %@,\nmethod hint: %@", error.localizedDescription, [[NSString alloc] initWithData:error.metaData encoding:NSUTF8StringEncoding], error.gtDescription);
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    [TipsView showTipOnKeyWindow:@"验证已被取消"];
    NSLog(@"User Did Close GTView.");
}

- (BOOL)shouldUseDefaultRegisterAPI:(GT3CaptchaManager *)manager {
    return NO;
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
    
    /**
     *  TO-DO 处理result数据, 进行二次验证
     */
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

- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSString *newURL = [NSString stringWithFormat:@"%@?t=%.0f", originalRequest.URL.absoluteString, [[[NSDate alloc] init]timeIntervalSince1970]];
    mRequest.URL = [NSURL URLWithString:newURL];
    
    replacedHandler(mRequest);
}

#pragma mark GT3CaptchaManagerViewDelegate

- (void)gtCaptchaWillShowGTView:(GT3CaptchaManager *)manager {
    NSLog(@"GTView Will Show.");
}

@end
