//
//  GTCaptchaManager.h
//  GTCaptcha
//
//  Created by NikoXu on 8/22/16.
//  Copyright © 2016 Geetest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GT3Utils.h"
#import "GT3Error.h"

@protocol GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate;

@interface GT3CaptchaManager : NSObject

/** 验证管理代理 */
@property (nonatomic, weak) id<GT3CaptchaManagerDelegate> delegate;
/** 验证视图代理 */
@property (nonatomic, weak) id<GT3CaptchaManagerViewDelegate> viewDelegate;

/** 验证状态 */
@property (nonatomic, readonly) GT3CaptchaState captchaState;
/** 图形验证的展示状态 */
@property (nonatomic, readonly) BOOL isShowing;
/** 获取启动验证参数的接口 */
@property (nonatomic, readonly) NSURL *API_1;
/** 进行二次验证的接口 */
@property (nonatomic, readonly) NSURL *API_2;
/** 验证的ID */
@property (nonatomic, readonly, strong) NSString *gt_captcha_id;
/** 验证的会话标识 */
@property (nonatomic, readonly, strong) NSString *gt_challenge;
/** 验证的服务状态, 1正常/0宕机 */
@property (nonatomic, readonly, strong) NSNumber *gt_success_code;

/** 背景验证 */
@property (nonatomic, strong) UIColor *backgroundColor;

#pragma mark 基本方法

/** 验证单例 */
+ (instancetype)sharedGTManager;

/**
 *  验证初始化方法
 *
 *  @param api_1    获取验证参数的接口
 *  @param api_2    进行二次验证的接口
 *  @param timeout  超时时长
 *  @return GT3CaptchaManager 实例
 */
- (instancetype)initWithAPI1:(NSString *)api_1
                        API2:(NSString *)api_2
                     timeout:(NSTimeInterval)timeout NS_DESIGNATED_INITIALIZER;

/**
 *  @abstract 取消异步请求
 *
 *  @discussion
 *  当希望取消正在执行的<b>NSURLSessionDataTask</b>时，调用此方法
 *
 *  ❗️<b>内部请求基于NSURLSeesion</b>
 */
- (void)cancelRequest;

/**
 *  @abstract 自定义配置验证方法
 *
 *  @discussion
 *  当网站主使用自己的failback逻辑的时候使用此方法开启验证
 *  使用此方法之前，网站主必须在服务端通过心跳检测geetest服务可用后通知客户端, 
 *  同时单个challenge只能使用在同一次验证会话中
 *
 *  @param gt_public_key    在官网申请的captcha_id
 *  @param gt_challenge     根据极验服务器sdk生成的challenge
 *  @param gt_success_code  网站主服务器监测geetest服务的可用状态 0/1 不可用/可用
 *  @param api_2            用于二次验证的接口.网站主根据极验服务端sdk来部署.
 *
 */
- (void)configureGTest:(NSString *)gt_public_key
             challenge:(NSString *)gt_challenge
               success:(NSNumber *)gt_success_code
              withAPI2:(NSString *)api_2;

/**
 *  @abstract 配置状态指示器
 *
 *  @discussion
 *  为了能方便的调试动画,真机调试模拟低速网络 Settings->Developer
 *  ->Status->Enable->Edge(E网,2.5G😂)
 *
 *  @param animationBlock 自定义时需要实现的动画block,仅在type配置为GTIndicatorCustomType时才执行
 *  @param type           状态指示器的类型
 */
- (void)configureAnimatedAcitvityIndicator:(GT3IndicatorAnimationViewBlock)animationBlock
                         withIndicatorType:(GT3ActivityIndicatorType)type;

/**
 *  ❗️<b>必要方法</b>❗️
 *  @abstract 开始验证
 *
 *  @discussion
 *  获取姿态, 提交分析后, 如有必要在`[[UIApplication sharedApplication].delegate window]`上显示极验验证的GTView验证视图
 *  极验验证GTWebView通过JS与SDK通信
 *
 */
- (void)startGTCaptchaWithAnimated:(BOOL)animated;

/**
 *  请求验证预判定
 */
- (void)requestGTCaptcha;

/**
 *  如果已经获得注册数据, 直接加载展示图形验证
 */
- (void)showGTViewIfRegiested;

/**
 *  终止验证
 */
- (void)stopGTCaptcha;

/**
 *  若验证显示则关闭验证界面
 */
- (void)closeGTViewIfIsOpen;

/**
 *  获取cookie value
 *
 *  @param cookieName cookie的键名
 *  @return 对应的cookie的值
 */
- (NSString *)getCookieValue:(NSString *)cookieName;

#pragma mark 其他配置的方法

/**
 *  @abstract 验证标题
 *
 *  @discussion
 *  默认不开启. 字符长度不能超过28, 一个中文字符为两个2字符长度.
 *
 *  @param title 验证标题字符串
 */
- (void)useGTViewWithTitle:(NSString *)title;

/**
 *  @abstract 配置背景模糊
 *
 *  @discussion
 *  iOS8以上生效
 *
 *  @param blurEffect 模糊特效
 */
- (void)useVisualViewWithEffect:(UIBlurEffect *)blurEffect;

/**
 *  @abstract 验证高度约束
 *
 *  @discussion
 *  iOS8以下默认GTViewHeightConstraintDefault, iOS9以上自动适配验证高度,
 *  不受此方法约束
 *
 *  @param type 高度约束类型
 */
- (void)useGTViewWithHeightConstraintType:(GT3ViewHeightConstraintType)type;

/**
 *  @abstract 切换验证语言
 *
 *  @discussion
 *  默认中文
 *
 *  @param Type 语言类型
 */
- (void)useLanguage:(GT3LanguageType)Type;

/**
 *  @abstract 完全使用HTTPS协议请求验证
 *
 *  @discussion
 *  默认开启HTTPS
 *
 *  @param disable 是否禁止https支持
 */
- (void)disableSecurityAuthentication:(BOOL)disable;

/**
 *  @abstract 验证背景交互事件的开关
 *
 *  @discussion 默认关闭
 *
 *  @param disable YES忽略交互事件/NO接受交互事件
 */
- (void)disableBackgroundUserInteraction:(BOOL)disable;

/**
 *  @abstract Debug Mode
 *
 *  @discussion
 *  开启debugMode,在开启验证之前调用此方法
 *  默认不开启
 *
 *  @param enable YES开启,NO关闭
 */
- (void)enableDebugMode:(BOOL)enable;

@end

#pragma mark - 验证代理方法

@protocol GT3CaptchaManagerDelegate <NSObject>

@required
/**
 *  验证错误处理
 *
 *  @discussion 抛出内部错误, 比如GTWebView等错误
 *
 *  @param manager  验证管理器
 *  @param error    错误源
 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error;

/**
 *  @abstract 通知已经收到二次验证结果, 在此处理最终验证结果
 *
 *  @discussion
 *  二次验证的错误只在这里返回, `decisionHandler`需要处理
 *
 *  @param manager          验证管理器
 *  @param data             二次验证返回的数据
 *  @param response         二次验证的响应
 *  @param error            错误源
 *  @param decisionHandler  更新验证结果的视图
 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy captchaPolicy))decisionHandler;

@optional
/**
 *  @abstract 将要向<b>API1</b>发送请求的时候调用此方法, 通过此方法可以修改将要发送的请求
 *
 *  @discussion 调用此方法的时候必须执行<b>requestHandler</b>, 否则导致内存泄露
 *
 *  @param manager        验证管理器
 *  @param requestHandler 修改请求的执行block
 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(void (^)(NSURLRequest * request))requestHandler;

/**
 *  @abstract 当接收到从<b>API1</b>的数据, 通知返回字典, 包括<b>gt_public_key</b>,
 *  <b>gt_challenge</b>, <b>gt_success_code</b>
 *
 *  @discussion
 *  只有仅当使用<b>configureGTest:API2:withTimeout:cookieName:</b>时,
 *  才会调用此方法. 如果是一层套嵌字典, 请在服务端设置对应<b>key</b>为<b>"gtcap"</b>, manager内
 *  部会自动解析出数据.
 *
 *  @param manager      验证管理器
 *  @param dictionary   包含极验的验证数据
 *  @param error        返回的错误
 *
 *  返回验证数据示例
 <pre>
 {
 "challenge" : "12ae1159ffdfcbbc306897e8d9bf6d06",
 "gt" : "ad872a4e1a51888967bdb7cb45589605",
 "success" : 1
 }
 </pre>
 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error;

/**
 *  @abstract 通知接收到返回的验证交互结果
 *
 *  @discussion 此方法仅仅是前端返回的初步结果, 并非验证最终结果。
 *
 *  @param manager 验证管理器
 *  @param code    验证交互结果, 0失败/1成功
 *  @param result  二次验证数据
 *  @param message 附带消息
 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message;

/**
 *  @abstract 通知即将进行二次验证, 再次修改发送至<b>API2</b>的验证
 *
 *  @discussion
 *  请不要修改<b>requestHandler</b>执行所在的线程或队列, 否则可能导
 *  请求修改失败. 二次验证的请求方式应为<b>POST</b>, 头部信息应为:
 *  <pre>{"Content-Type":@"application/x-www-form-urlencoded;charset=UTF-8"}</pre>
 *
 *  @param manager        验证管理器
 *  @param requestHandler 修改二次验证请求的block
 */
- (void)gtCpatcha:(GT3CaptchaManager *)manager willSendSecondaryCaptchaRequest:(void (^)(NSMutableURLRequest * request))requestHandler;

/**
 *  @abstract 用户主动关闭了验证码界面
 *
 *  @param manager 验证管理器
 */
- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager;

@end

@protocol GT3CaptchaManagerViewDelegate <NSObject>

@required

/**
 *  通知验证模式
 *
 *  @param manager 验证管理器
 *  @param mode    验证模式
 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager notifyCaptchaMode:(GT3CaptchaMode)mode;

/**
 *  更新验证状态
 *
 *  @param manager 验证管理器
 *  @param state   验证状态
 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager updateCaptchaStatus:(GT3CaptchaState)state;

/**
 *  更新验证视图
 *
 *  @param manager         验证管理器
 *  @param fromValue       起始值
 *  @param toValue         终止值
 *  @param timeInterval    时间间隔
 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager updateCaptchaViewWithFactor:(CGFloat)fromValue to:(CGFloat)toValue timeInterval:(NSTimeInterval)timeInterval;

@end
