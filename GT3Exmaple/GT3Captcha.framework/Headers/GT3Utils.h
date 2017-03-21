//
//  GTUtils.h
//  GTFramework
//
//  Created by LYJ on 15/5/18.
//  Copyright (c) 2015年 gt. All rights reserved.
//

#ifndef GTFramework_GTUtils_h
#define GTFramework_GTUtils_h

#import <UIKit/UIKit.h>


/**
 极验验证状态的枚举量
 */
typedef NS_ENUM(NSInteger, GT3CaptchaState) {
    /** 验证未激活 */
    GT3CaptchaStateInactive,
    /** 验证激活 */
    GT3CaptchaStateActive,
    /** 验证初始化中 */
    GT3CaptchaStateInitial,
    /** 验证检测数据中 */
    GT3CaptchaStateCollecting,
    /** 验证等待提交中 */
    GT3CaptchaStateWaiting,
    /** 验证结果判定中*/
    GT3CaptchaStateComputing,
    /** 验证通过*/
    GT3CaptchaStateSuccess,
    /** 验证失败*/
    GT3CaptchaStateFail,
    /** 验证发生错误*/
    GT3CaptchaStateError
};

typedef NS_ENUM(NSInteger, GT3CaptchaMode) {
    /** 验证默认模式*/
    GT3CaptchaModeDefault,
    /** 验证宕机模式*/
    GT3CaptchaModeFailback
};

typedef NS_ENUM(NSInteger, GT3SecondaryCaptchaPolicy) {
    /** 二次验证通过 */
    GT3SecondaryCaptchaPolicyAllow,
    /** 二次验证拒绝 */
    GT3SecondaryCaptchaPolicyForbidden
};

/**
 *  展示方式
 */
typedef NS_ENUM(NSInteger, GT3PresentType) {
    /** Popup on the center of screen. <b>Default</b>. */
    GT3PopupCenterType = 0,
    /**
     * @abstract Popup on the bottom of screen. <b>Portrait ONLY</b>.
     *
     * @discussion Close <b>geetest</b> if opened when detect the device orientated. You should open <b>geetest</b> again manually because of the <b>Challenge</b> can't be used twice in the same session.
     */
    GT3PopupBottomType
};

/**
 *  高度约束类型
 */
typedef NS_ENUM(NSInteger, GT3ViewHeightConstraintType) {
    /** Default Type */
    GT3ViewHeightConstraintDefault,
    /** Small View With Logo*/
    GT3ViewHeightConstraintSmallViewWithLogo,
    /** Small View With No Logo */
    GT3ViewHeightConstraintSmallViewWithNoLogo,
    /** Large View With Logo */
    GT3ViewHeightConstraintLargeViewWithLogo,
    /** Large View With No Logo */
    GT3ViewHeightConstraintLargeViewWithNoLogo
};

/**
 *  语言选项
 */
typedef NS_ENUM(NSInteger, GT3LanguageType) {
    /** Simplified Chinese */
    GT3LANGTYPE_ZH_CN = 0,
    /** Traditional Chinese */
    GT3LANGTYPE_ZH_TW,
    /** Traditional Chinese */
    GT3LANGTYPE_ZH_HK,
    /** Korean */
    GT3LANGTYPE_KO_KR,
    /** Japenese */
    GT3LANGTYPE_JA_JP,
    /** English */
    GT3LANGTYPE_EN_US,
    /** System language*/
    GT3LANGTYPE_AUTO
};

/**
 *  活动指示器类型
 */
typedef NS_ENUM(NSInteger, GT3ActivityIndicatorType) {
    /** System Indicator Type */
    GT3IndicatorTypeSystem = 0,
    /** Geetest Defualt Indicator Type */
    GT3IndicatorTypeDefault,
    /** Custom Indicator Type */
    GT3IndicatorTypeCustom,
};

/**
 *  默认验证处理block
 *
 *  @param gt_captcha_id   用于验证的captcha_id
 *  @param gt_challenge    验证的流水号
 *  @param gt_success_code 网站主侦测到极验服务器的状态
 */
typedef void(^GT3DefaultCaptchaHandlerBlock)(NSString *gt_captcha_id, NSString *gt_challenge, NSNumber *gt_success_code);

/**
 *  验证完成回调
 *
 *  @param code    验证结果 1 成功/ 其他 失败
 *  @param result  返回二次验证所需数据
 {
 "geetest_challenge": "5a8c21e206f5f7ba4fa630acf269d0ec4z",
 "geetest_validate": "f0f541006215ac784859e29ec23d5b97",
 "geetest_seccode": "f0f541006215ac784859e29ec23d5b97|jordan"
 }
 *  @param message 验证结果信息 （sucess/fail）
 */
typedef NSURLRequest * (^GT3SecondaryCaptchaBlock)(NSString *code, NSDictionary *result, NSString *message);

/**
 *  关闭验证回调
 */
typedef void(^GT3CallCloseBlock)(void);

/**
 *  自定义状态指示器的动画实现block
 *
 *  @param layer 状态指示器视图的layer
 *  @param size  layer的大小,默认 {64, 64}
 *  @param color layer的颜色,默认 蓝色 [UIColor colorWithRed:0.3 green:0.6 blue:0.9 alpha:1]
 */
typedef void(^GT3IndicatorAnimationViewBlock)(CALayer *layer, CGSize size, UIColor *color);

#endif
