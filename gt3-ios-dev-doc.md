[toc]

# GT3Captcha-iOS API Document

**GT3Captcha.framework** 主要包括`GT3CaptchaButton `, `GT3CaptchaManager`, `GT3Error`, `GT3Utils` 四个公有文件。

## GT3CaptchaButton

极验提供的验证按钮, 继承于`UIControl`

### Property

#### captchaManager

验证管理器

**Declaration**

```
@property (nonatomic, readonly, strong) GT3CaptchaManager *captchaManager;
```

**See also**

[`GT3CaptchaManager`](#GT3CaptchaManager)

#### delegate

验证按钮代理

**Declaration**

```
@property (nonatomic, weak) id<GT3CaptchaButtonDelegate> delegate;
```

#### captchaState

验证状态

**Declaration**

```
@property (nonatomic, readonly, assign) GT3CaptchaState captchaState;
```

#### captchaEdgeInsets

定义容器视图边距

**Declaration**

```
@property (nonatomic, assign) UIEdgeInsets captchaEdgeInsets;
```

#### tipsDict

定义各种验证状态下按钮上的提示文案

**Discussion**

字典请使用以下键名, 与`GT3CaptchaState`一一对应

```
'inactive', 'active', 'initial', 'waiting', 'collecting', 'computing', 'success', 'fail', 'error'.
```

**Declaration**

```
@property (nonatomic, strong) NSDictionary<NSString *, NSAttributedString *> *tipsDict;
```

**Seealso**

`GT3CaptchaState`

#### indicatorColor

定义验证状态指示器的颜色

**Declaration**

```
@property (nonatomic, strong) UIColor *indicatorColor;
```

#### logoImage

验证按钮上的logo图片

**Declaration**

```
@property (nonatomic, strong) UIImage *logoImage;
```

### Method

#### initWithFrame:captchaManager:

初始化并返回一个新的规定了尺寸的`GT3CaptchaButton`实例对象

**Declaration**

```
- (instancetype)initWithFrame:(CGRect)frame captchaManager:(GT3CaptchaManager *)captchaManager;
```

**Parameters**

Param		|Description		|
----------|---------------	|
frame 		|按钮的尺寸			|
captchaManager|验证管理器的实例|

**Return Value**

一个新的规定了尺寸的`GT3CaptchaButton`实例对象

#### startCaptcha

开始验证

**Declaration**

```
- (void)startCaptcha;
```

**Discussion**

根据验证状态, 在`GTCaptchaManager`内部调用实例方法`startGTCaptchaWithAnimated:`, `requestGTCaptcha`, `showGTViewIfRegiested`。

#### stopCaptcha

终止验证

**Declaration**

```
- (void)startCaptcha;
```

#### updateTitleLabel:

立即更新当前的验证提示标题

**Declaration**

```
- (void)updateTitleLabel:(NSAttributedString *)title;
```

**Parameters**

Param		|Description		|
----------|---------------	|
title 		|提示标题			|

### Protocol

#### GT3CaptchaButtonDelegate

##### captchaButtonShouldBeginCaptcha:

控制是否执行验证事件

**Declaration**

```
- (BOOL)captchaButtonShouldBeginCaptcha:(GT3CaptchaButton *)button;
```

**Discussion**

默认返回`YES`, 只有当返回`NO`时不执行验证事件 

**Parameters**

Param		|Description		|
----------|---------------	|
button 	|验证按钮			|

##### captchaButton:didChangeState:

验证状态改变的通知回调

**Declaration**

```
- (void)captchaButton:(GT3CaptchaButton *)button didChangeState:(GT3CaptchaState)state;
```

**Parameters**

Param		|Description		|
----------|---------------	|
button 	|验证按钮			|
state		|当前的按钮状态		|

## GT3CaptchaManager

### Property

#### delegate

验证管理的代理方法

**Declaration**

```
@property (nonatomic, weak) id<GT3CaptchaManagerDelegate> delegate;
```

#### viewDelegate

验证视图代理

**Declaration**

```
@property (nonatomic, weak) id<GT3CaptchaManagerViewDelegate> viewDelegate;
```

#### captchaState

验证状态

**Declaration**

```
@property (nonatomic, readonly) GT3CaptchaState captchaState;
```

#### isShowing

图形验证的展示状态

**Declaration**

```
@property (nonatomic, readonly) BOOL isShowing;
```

#### API_1

获取启动验证参数的接口

**Declaration**

```
@property (nonatomic, readonly) NSURL *API_1;
```

#### API_2

进行二次验证的接口

**Declaration**

```
@property (nonatomic, readonly) NSURL *API_2;
```

#### gt\_captcha\_id

本次验证会话的验证ID

**Declaration**

```
@property (nonatomic, readonly, strong) NSString *gt_captcha_id;
```

#### gt_challenge

本次验证的会话的流水号

**Declaration**

```
@property (nonatomic, readonly, strong) NSString *gt_challenge;
```

#### gt\_success\_code

当前验证的服务状态

**Declaration**

```
@property (nonatomic, readonly, strong) NSNumber *gt_success_code;
```

**Discussion**

1正常/0宕机
	
#### backgroundColor

当前验证的服务状态

**Declaration**

```
@property (nonatomic, strong) UIColor *backgroundColor;
```

### Method

#### sdkVersion

SDK版本号

**Declaration**

```
+ (NSString *)sdkVersion;
```

#### sharedGTManager

验证单例

**Declaration**

```
+ (instancetype)sharedGTManager;
```

#### initWithAPI1:API2:timeout:

验证初始化方法

**Declaration**

```
- (instancetype)initWithAPI1:(NSString *)api_1
                        API2:(NSString *)api_2
                     timeout:(NSTimeInterval)timeout NS_DESIGNATED_INITIALIZER;
```

**Parameters**

Param		|Description		|
----------|---------------	|
api_1		|获取验证参数的接口	|
api_2		|进行二次验证的接口	|
timeout	|超时时长			|

**Return Value**

一个新的GT3CaptchaManager实例	

**Discussion**

`NS_DESIGNATED_INITIALIZER`, 请不要使用`init`

#### cancelRequest

取消异步请求

**Declaration**

```
- (void)cancelRequest;
```

**Discussion**

当希望取消正在执行的**NSURLSessionDataTask**时，调用此方法

#### configureGTest:challenge:success:withAPI2:

自定义配置验证方法

**Declaration**

```
- (void)configureGTest:(NSString *)gt_public_key
             challenge:(NSString *)gt_challenge
               success:(NSNumber *)gt_success_code
              withAPI2:(NSString *)api_2;
```

**Parameters**

Param				|Description		|
----------------	|---------------	|
gt\_public\_key	|自定义时需要实现的动画block,仅在type配置为GTIndicatorCustomType时才执行|
gt_challenge		|状态指示器的类型	|
gt\_success\_code|网站主服务器监测geetest服务的可用状态, 0/1 不可用/可用
api_2				|用于二次验证的接口.网站主根据极验服务端sdk来部署

**Discussion**

同一个challenge只能使用在同一次验证会话中

#### configureAnimatedAcitvityIndicator:withIndicatorType:

配置状态指示器

**Declaration**

```
- (void)configureAnimatedAcitvityIndicator:(GT3IndicatorAnimationViewBlock)animationBlock
                         withIndicatorType:(GT3ActivityIndicatorType)type;
```

**Parameters**

Param	|Description		|
------	|---------------	|
api_1	|自定义时需要实现的动画block,仅在type配置为GTIndicatorCustomType时才执行|
api_2	|状态指示器的类型	|	

#### startGTCaptchaWithAnimated:

开始验证

**Declaration**

```
- (void)startGTCaptchaWithAnimated:(BOOL)animated;
```

**Parameters**

Param		|Description				|
----------|----------------------	|
animated	|控制验证视图弹出动画的启动	|

**Discussion**

获取姿态, 提交分析后, 如有必要在keyWindow上创建极验验证的GTView验证视图

>极验验证GTWebView通过JS与SDK通信

#### stopGTCaptcha

终止验证

**Declaration**

```
- (void)stopGTCaptcha;
```

#### closeGTViewIfIsOpen

若验证显示则关闭验证界面

**Declaration**

```
- (void)closeGTViewIfIsOpen;
```

#### getCookieValue:

获取cookie value

**Declaration**

```
- (NSString *)getCookieValue:(NSString *)cookieName;
```

**Parameters**

Param		|Description		|
----------|---------------	|
cookieName|cookie的键名		|

**Discussion**

获取姿态, 提交分析后, 如有必要在keyWindow上创建极验验证的GTView验证视图

**Return Value**

返回cookie value

#### useGTViewWithTitle:

验证标题

**Discussion**
 
默认不开启. 字符长度不能超过28, 一个中文字符为两个2字符长度.

**Declaration**

```
- (void)useGTViewWithTitle:(NSString *)title;
```

**Parameters**

Param		|Description		|
----------|---------------	|
title 		|验证标题字符串		|


#### useGTViewWithTitle:

配置背景模糊

**Declaration**

```
- (void)useVisualViewWithEffect:(UIBlurEffect *)blurEffect;
```

**Parameters**

Param		|Description		|
----------|---------------	|
blurEffect|模糊效果			|

**Discussion**

iOS8以上生效

#### useGTViewWithHeightConstraintType:

验证视图高度约束

**Declaration**

```
- (void)useGTViewWithHeightConstraintType:(GT3ViewHeightConstraintType)type;
```

**Parameters**

Param		|Description		|
----------|---------------	|
type 		|高度约束类型		|

**Discussion**

iOS9以下默认GTViewHeightConstraintDefault, iOS9以上自动适配验证高度, 不受此方法约束

#### useLanguage:

切换验证语言

**Declaration**

```
- (void)disableSecurityAuthentication:(BOOL)disable;
```

**Parameters**

Param		|Description		|
----------|---------------	|
Type	 	|语言类型			|

**Discussion**

默认开启HTTPS

#### disableSecurityAuthentication:

控制使用HTTPS协议请求验证

**Declaration**

```
- (void)disableSecurityAuthentication:(BOOL)disable;
```

**Parameters**

Param		|Description		|
----------|---------------	|
disable 	|是否禁止https支持	|

**Discussion**

默认开启HTTPS

#### disableBackgroundUserInteraction:

控制验证背景交互事件

**Declaration**

```
- (void)disableBackgroundUserInteraction:(BOOL)disable;
```

**Parameters**

Param		|Description			|
----------|------------------	|
disable 	|控制背景的点击交互事件	|

**Discussion**

默认不禁止

#### enableDebugMode:

Debug Mode

**Declaration**

```
- (void)enableDebugMode:(BOOL)enable;
```

**Parameters**

Param		|Description	|
----------|------------	|
disable 	|控制debug模式	|

**Discussion**

默认不开启

### Protocol

#### GT3CaptchaManagerDelegate

##### required

1. gtCaptcha:errorHandler:
	
	内部错误处理
	
	**Declaration**
	
	```
	- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error;
	```
	
	**Parameters**

	Param		|Description	|
	----------|------------	|
	manager 	|验证管理器		|
	error	 	|错误对象		|
	
2. 	gtCaptcha:didReceiveSecondaryCaptchaData:response:error:decisionHandler:

	通知已经收到二次验证结果, 并请在此处理最终验证结果
	
	**Declaration**
	
	```
	- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy captchaPolicy))decisionHandler;
	```
	
	**Parameters**

	Param		|Description		|
	----------|---------------	|
	manager 	|验证管理器			|
	data 		|二次验证返回的数据	|
	response 	|二次验证的响应		|
	error	 	|错误对象			|
	decisionHandler|更新验证结果的视图|

##### optional

1. gtCaptcha:willSendRequestAPI1:

	将要向**API1**发送请求的时候调用此方法, 通过此方法可以修改将要发送的请求
	
	**Declaration**
	
	```
	- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(void (^)(NSURLRequest * request))requestHandler;
	```
	
	**Parameters**

	Param			|Description		|
	-------------	|---------------	|
	manager 		|验证管理器			|
	requestHandler|修改请求的执行block|
	
	**Discussion**
	
	调用此方法的时候必须调用`requestHandler`, 否则导致内存泄露
	
2. gtCaptcha:didReceiveDataFromAPI1:withError:

	将要向**API1**发送请求的时候调用此方法, 通过此方法可以修改将要发送的请求
	
	**Declaration**
	
	```
	- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error;
	```
	
	**Parameters**

	Param			|Description		|
	-------------	|---------------	|
	manager 		|验证管理器			|
	dictionary 	|包含极验的验证数据	|
	error		 	|返回的错误			|
	
	**Discussion**
	
	参数**dictionary**内数据样例:
	
	```
	{
 	"challenge" : "12ae1159ffdfcbbc306897e8d9bf6d06",
 	"gt" : "ad872a4e1a51888967bdb7cb45589605",
 	"success" : 1
 	}
	```
	
3. gtCaptcha:didReceiveCaptchaCode:result:message:

	通知接收到返回的验证交互结果
	
	**Declaration**
	
	```
	- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message;
	```
	
	**Parameters**

	Param			|Description		|
	-------------	|---------------	|
	manager 		|验证管理器			|
	code		 	|验证交互结果		|
	result		 	|二次验证数据		|
	message	 	|附带消息			|
	
	**Discussion**
	
	此方法仅仅是前端返回的初步结果, 并非验证最终结果。

4. gtCaptcha:willSendSecondaryCaptchaRequest:

	通知接收到返回的验证交互结果
	
	**Declaration**
	
	```
	- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendSecondaryCaptchaRequest:(void (^)(NSMutableURLRequest * request))requestHandler;
	```
	
	**Parameters**

	Param			|Description		|
	-------------	|---------------	|
	manager 		|验证管理器			|
	requestHandler|修改二次验证请求的block|
	
	**Discussion**
	
	请不要修改<b>requestHandler</b>执行所在的线程或队列, 否则可能导请求修改失败. 二次验证的请求方式应为**POST**, 头部信息应为:
 	
	```
	{"Content-Type":@"application/x-www-form-urlencoded;charset=UTF-8"}
	```
	
5. gtCaptchaUserDidCloseGTView:

	用户主动关闭了验证码界面
	
	**Declaration**
	
	```
	- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager;
	```
	
	**Parameters**

	Param			|Description		|
	-------------	|---------------	|
	manager 		|验证管理器			|
	
#### GT3CaptchaManagerViewDelegate

##### required

1. gtCaptcha:notifyCaptchaMode:

	通知验证模式
	
	**Declaration**
	
	```
	- (void)gtCaptcha:(GT3CaptchaManager *)manager notifyCaptchaMode:(GT3CaptchaMode)mode;
	```
	
	**Parameters**

	Param			|Description		|
	-------------	|---------------	|
	manager 		|验证管理器			|
	mode	 		|验证模式			|
	
2. gtCaptcha:updateCaptchaStatus:

	更新验证状态
	
	**Declaration**
	
	```
	- (void)gtCaptcha:(GT3CaptchaManager *)manager updateCaptchaStatus:(GT3CaptchaState)state;
	```
	
	**Parameters**

	Param			|Description		|
	-------------	|---------------	|
	manager 		|验证管理器			|
	state	 		|验证状态			|
	
3. gtCaptcha:updateCaptchaViewWithFactor:to:timeInterval:

	更新验证视图
	
	**Declaration**
	
	```
	- (void)gtCaptcha:(GT3CaptchaManager *)manager updateCaptchaViewWithFactor:(CGFloat)fromValue to:(CGFloat)toValue timeInterval:(NSTimeInterval)timeInterval;
	```
	
	**Parameters**

	Param			|Description		|
	-------------	|---------------	|
	manager 		|验证管理器			|
	fromValue		|起始值				|
	toValue 		|终止值				|
	timeInterval 	|时间间隔			|

## GT3Error

极验封装的错误对象, 用于方便构造和返回特别信息

### GT3ErrorType

极验定义的错误类型
 
**Declaration**
 
```
typedef NS_ENUM(NSUInteger, GT3ErrorType) {
    /** 用户中断验证导致 */
    GT3ErrorTypeUser,
    /** 服务端返回错误 */
    GT3ErrorTypeServer,
    /** 内部网络抛出错误类型 */
    GT3ErrorTypeNetWorking,
    /** 内部浏览器抛出的错误类型 */
    GT3ErrorTypeWebView,
    /** 从前端库抛出的错误类型 */
    GT3ErrorTypeJavaScript,
    /** 内部解码错误类型 */
    GT3ErrorTypeDecode,
    /** 未知错误类型 */
    GT3ErrorTypeUnknown
};
```
### GT3Error Code

#### 验证被封禁 `-10`

预判断时被封禁, 不会再进行图形验证

#### 尝试过多 `-20`

用户尝试过多, 限制为5次

#### 配置问题 `-30`

接口传入的参数不正确或为空

#### 配置问题 `-40`

接口传入的参数不正确或为空

#### 服务器异常响应 `-50`

极验服务器gettype返回运行错误

#### 服务器异常响应 `-51`

极验服务器get返回运行错误

#### 服务器异常响应 `-52`

极验服务器ajax返回运行错误

#### 接口调用错误 `-70`

极验3.0 sdk 接口调用错误, 未配置参数或设置代理方法

#### 缺失资源文件 `-71`

缺失`GT3Captcha.bundle`

#### 接口调用错误 `-80`

未设置代理方法

>其他的部分基本遵从**NSURLErrorDomain**

#### 取消网络请求 `-999`

用户关闭了验证

```objc
NSURLErrorCancelled -999
```

#### 验证超时 `-1001`

与开发人员配置的超时时间和用户的网络情况的有关, 在低速网络可以对这块做测试

```objc
NSURLErrorTimedOut -1001
```

#### 无法找到主机 `-1003`

网络异常, 检查网络

```objc
NSURLErrorCannotFindHost -1003
```

#### 无法连接到极验服务器 `-1004`

网络异常, 无法连接到极验服务器

```objc
NSURLErrorCannotConnectToHost -1004
```

#### 未连接到互联网 `-1009`

无法检测到网络连接

```objc
NSURLErrorNotConnectedToInternet -1009
```

#### 服务器响应500 `-1011`

等价于"500 Server Error"

```objc
NSURLErrorBadServerResponse -1011
```

#### 无资源访问权限 `-1102`

传入的参数错误, 被极验服务器拒绝访问, 通常为id(gt)和challenge不正确或者不匹配导致

```objc
NSURLErrorNoPermissionsToReadFile -1102
```

#### JSON解析出错 `3840`

在使用默认的failback里使用了json转字典, 检查网站主服务器返回的验证数据格式是否正确(也可能在failback接口下, 增加了额外的键值导致)

如果使用套嵌的json格式, 请使用`@"data"`,`@"gtcap"`作为极验参数字典的键名

```objc
3840
```

### Property

#### metaData

发生错误时接收到的元数据, 没有数据则为nil

**Declaration**

```
@property (nonatomic, readonly, strong) NSData * _Nullable metaData;
```

#### gtDescription

极验的额外错误信息

**Declaration**

```
@property (nonatomic, readonly, strong) NSString * gtDescription;
```

#### originalError

原始的error

**Declaration**

```
@property (nonatomic, readonly, strong) NSError * _Nullable originalError;
```

### Method

#### errorWithDomainType:code:userInfo:withGTDesciption:

通过提供的详细的参数初始化GT3Error

**Declaration**

```
+ (instancetype)errorWithDomainType:(GT3ErrorType)type code:(NSInteger)code userInfo:(nullable NSDictionary *)dict withGTDesciption:(NSString *)description;
```

**Parameters**

Param		|Description		|
----------|---------------	|
type 		|极验定义的错误类型	|
code 		|错误码				|
dict 		|错误的`userInfo`	|
description|错误的额外描述字段|

#### 

基于提供的NSError封装成GT3Error

**Declaration**

```
+ (instancetype)errorWithDomainType:(GT3ErrorType)type originalError:(NSError *)originalError withGTDesciption:(NSString *)description;
```

**Parameters**

Param		|Description		|
----------|---------------	|
type 		|极验定义的错误类型	|
error 		|原始的`NSError`实例对象|
description|错误的额外描述字段|

## GT3Utils

极验验证工具类

### GT3CaptchaState

极验验证状态的枚举量
 
**Declaration**
 
```
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
```
 
### GT3CaptchaMode

验证模式枚举量
 
**Declaration**
 
```
typedef NS_ENUM(NSInteger, GT3CaptchaMode) {
    /** 验证默认模式*/
    GT3CaptchaModeDefault,
    /** 验证宕机模式*/
    GT3CaptchaModeFailback
};
```

### GT3SecondaryCaptchaPolicy

视图上结果的更新策略
 
**Declaration**
 
```
typedef NS_ENUM(NSInteger, GT3SecondaryCaptchaPolicy) {
    /** 二次验证通过 */
    GT3SecondaryCaptchaPolicyAllow,
    /** 二次验证拒绝 */
    GT3SecondaryCaptchaPolicyForbidden
};
```

### GT3ViewHeightConstraintType

高度约束类型
 
**Declaration**
 
```
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
```

### GT3LanguageType

语言选项
 
**Declaration**
 
```
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
```

### GT3ActivityIndicatorType

活动指示器类型
 
**Declaration**
 
```
typedef NS_ENUM(NSInteger, GT3ActivityIndicatorType) {
    /** System Indicator Type */
    GT3IndicatorTypeSystem = 0,
    /** Geetest Defualt Indicator Type */
    GT3IndicatorTypeDefault,
    /** Custom Indicator Type */
    GT3IndicatorTypeCustom,
};
```

### GT3SecondaryCaptchaBlock

返回的验证结果回调

**Declaration**
 
```
typedef NSURLRequest * (^GT3SecondaryCaptchaBlock)(NSString *code, NSDictionary *result, NSString *message);
```

**Parameters**

Param			|Description		|
-------------	|---------------	|
code 			|验证结果			|
result			|二次验证的数据		|
message 		|其他消息			|

### GT3CallCloseBlock

关闭验证回调

**Declaration**
 
```
typedef void(^GT3CallCloseBlock)(void);
```

### GT3IndicatorAnimationViewBlock

自定义状态指示器的动画实现block

**Declaration**
 
```
typedef void(^GT3IndicatorAnimationViewBlock)(CALayer *layer, CGSize size, UIColor *color);
```

**Parameters**

Param			|Description				|
-------------	|----------------------	|
layer 			|状态指示器视图的layer		|
size			|layer的大小,默认 {64, 64}|
color	 		|layer的颜色,默认 蓝色 [UIColor colorWithRed:0.3 green:0.6 blue:0.9 alpha:1]|

