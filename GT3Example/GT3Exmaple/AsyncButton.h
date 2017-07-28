//
//  AsyncButton.h
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 25/05/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GT3Captcha;

@protocol CaptchaButtonDelegate;

/**
 demo场景: 远程开关验证, 自定义api1和api2的处理, 并与自定义按钮事件绑定, 使用此文件请充分测试业务场景下的极端环境
 */
@interface AsyncButton : UIButton

@property (nonatomic, weak) id<CaptchaButtonDelegate> delegate;

- (void)startCaptcha;
- (void)stopCaptcha;

@end

@protocol CaptchaButtonDelegate <NSObject>

@optional
- (BOOL)captchaButtonShouldBeginTapAction:(AsyncButton *)button;
- (void)captcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error;
- (void)captcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error;


@end
