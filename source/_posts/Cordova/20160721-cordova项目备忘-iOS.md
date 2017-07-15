---
title: cordova项目备忘-iOS
toc: true
date: 2016-07-21 18:42:23
tags: Cordova
categories: Cordova
comments: true
---

## iOS代码编写方式

>iOS开发与Android开发有所不同，由于苹果的限制，它不能像Android开发那样直接通过命令行命令实现真机调试。

>iOS版本的cordova项目编译步骤：添加iOS平台=》添加所需插件=》通过`cordova build ios`命令生成.xcodeproj文件=》双击打开该文件=》通过Xcode实现真机调试
<!-- more -->
![屏幕快照 2016-08-02 15.46.54.png](http://ww3.sinaimg.cn/large/72f96cbagw1f6fgatmsvnj215o0k0jx8.jpg)

## iOS返回历史页面
```js
if (typeof(navigator.app) !== "undefined") {
    navigator.app.cancelLoadUrl(); // 在 web 页面成功加载之前取消加载
    navigator.app.backHistory();
} else {
    window.history.back();
}
```
## 缩减标题栏，修复界面的高度。

将通过命令行生成的.xcodeproject文件直接打开运行时，会发现页面内容会显示到手机的通知栏。
只需要在Staging目录下Classes目录下的MainViewController.m 下重写方法如下：
```objc
-(void)viewWillAppear:(BOOL)animated
{
    if([[[UIDevice currentDevice]systemVersion ] floatValue]>=7)
    {
        CGRect viewBounds=[self.webView  bounds];
        viewBounds.origin.y=20;
        viewBounds.size.height=viewBounds.size.height-20;
        self.webView.frame=viewBounds;
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext; //解决上浮的问题
    }
    [super viewWillDisappear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if([[[UIDevice currentDevice]systemVersion ] floatValue]>=7)
    {
        CGRect viewBounds=[self.webView  bounds];
        viewBounds.origin.y=20;
        viewBounds.size.height=viewBounds.size.height+20;
        self.webView.frame=viewBounds;
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext; //解决相机的问题
    }
    [super viewWillDisappear:animated];
}
```
## 禁止上下滑动出现灰色背景

使用Cordova进行跨平台应用开发时，发现在iOS平台下，如果页面处于最顶端时，用户用手指往下拖动，会露出灰色空背景。同样页面在最底部的时候，继续向上拖动，下方也会露出空背景。

要禁止这个拖动效果，可在 config.xml 中进行如下设置：
```xml
<preference name="WebViewBounce" value="false" />
<preference name="DisallowOverscroll" value="true" />
```

## 设置iOS下默认语言为中文

比如在打开键盘输入时，调用相机插件时，调用相册时，都会出现英文现象。

![2016061710444967199.jpg](http://ww1.sinaimg.cn/large/006tKfTcgw1f6vrt0t7thj30nl0ac763.jpg)

使用 Xcode 打开工程，将在 plist 文件里面 Localization native development region 设置为 China 即可。

![屏幕快照 2016-08-16 18.38.00.png](http://ww1.sinaimg.cn/large/006tKfTcgw1f6vrw81nswj315k0hodo9.jpg)

## 在post请求时，可能出现submit()方法无效的情况，需要在config.xml中添加
<allow-navigation href="*" /> 

## 参考

* [如何创建、配置、开发第一个ios应用](http://www.hangge.com/blog/cache/detail_1145.html )

**转载请标注原文地址**                           

