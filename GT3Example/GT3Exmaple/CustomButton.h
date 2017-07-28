//
//  CustomButton.h
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 08/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GT3Captcha;

@protocol CaptchaButtonDelegate;

/**
 demo场景: 仅自定按钮与验证事件绑定
 */
@interface CustomButton : UIButton

@property (nonatomic, weak) id<CaptchaButtonDelegate> delegate;

- (void)startCaptcha;
- (void)stopCaptcha;

@end

@protocol CaptchaButtonDelegate <NSObject>

@optional
- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button;
- (void)captcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error;
- (void)captcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error;

@end
