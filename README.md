#GT3Captcha Project

##概述

极验验证3.0 iOS SDK提供给集成iOS原生客户端开发的开发者使用, SDK不依赖任何第三方库。

## 环境需求

条目||
----|------
开发目标|iOS7+
开发环境|Xcode 8.0
系统依赖|`Webkit.framework`, `JavascriptCore.framework`
sdk三方依赖|无

## 获取SDK

>SDK在文件根目录

### 使用`git`命令从Github获取

```
git clone https://github.com/GeeTeam/gt3-ios-objc.git
```

### 手动下载获取
使用从github下载`.zip`文件获取最新的sdk。

[Github: gt3-ios-objc]()

## 接口

集成前需要先了解极验验证3.0的[产品结构](http://docs.geetest.com/install/overview/#产品结构), 并且必须要先在您的后端搭建相应的**服务端SDK**，并配置从[极验后台]()获取的`<gt_captcha_id>`和`<geetest_key>`用来配置您集成了极验服务端sdk的后台。

其中iOS sdk主要提供以下接口:

1. 配置验证初始化
2. 启动验证
3. 获取验证结果
4. 处理错误的代理

## 