//
//  RegisterViewController.h
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 demo场景: 注册场景
 */
@interface RegisterViewController : UIViewController

// 演示时用于区分是否使用`GT3CaptchaButton`实例, 实际开发集成中, 选择一种方式即可
@property (nonatomic, assign) BOOL flag;

@end
