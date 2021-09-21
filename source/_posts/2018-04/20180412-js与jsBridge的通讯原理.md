---
title: js与jsBridge的通讯原理
toc: true
comments: true
categories: 技术博客
tags: Default
date: 2018-04-12 11:17:48
photos:
description:
---

第一次接触到混合开发应该是在一年前，当时在做 ionic 和 Cordova(PhoneGap)项目的时候，这些框架在 web 基础上包了一层 Native，然后通过 Bridge 技术使得 js 可以调用视频、位置、音频等功能。目前手上负责的项目则是一个与自家 APP 交互的混合开发项目，于是在课余时间就查了查相关的实现方案和原理。本文就是介绍这层 Bridge 的交互原理，主要描述了 js 与 ios 及 android 底层的通讯原理及 JSBridge 的封装技术及调试方法。

<!-- more -->

## 主要用途

JSBridge 简单来讲，主要是 给 JavaScript 提供调用 Native 功能的接口，让混合开发中的前端部分可以方便地使用定位、摄像头、系统相册等 Native 功能。

但是 JSBridge 的用途肯定不只调用 Native 功能这么简单。实际上，JSBridge 就像其名称中的 `Bridge` 的意义一样，是 Native 和非 Native 之间的桥梁，它的核心是 构建 `Native` 和`非 Native` 间消息通信的通道，而且是 双向通信的通道。

![](http://cdn.chuyunt.com/uPic/006tNc79gy1fq9wv29dbfj30j604n74i.jpg)

所谓 双向通信的通道:

JS 向 Native 发送消息 : 调用相关功能、通知 Native 当前 JS 的相关状态等。
Native 向 JS 发送消息 : 回溯调用结果、消息推送、通知 JS 当前 Native 的状态等。

## 实现原理

主要分为两个部分，分别是 `JavaScript 调用 Native` 和 `Native 调用 JavaScript`

#### JavaScript 调用 Native

主要有两种实现方案，一种是 `拦截 URL SCHEME` ，另一种是 `注入API让js直接调用`

##### 拦截 URL SCHEME

- 什么是 URL SCHEME

由于苹果的 app 都是在沙盒中，相互是不能访问数据的。但是苹果还是给出了一个可以在 app 之间跳转的方法：URL Scheme。URL SCHEME：URL SCHEME 是一种类似于 url 的链接，是为了方便 iosapp 直接互相跳转设计的，形式和普通的 url 近似，主要区别是 protocol 和 host 一般是自定义的，例如: lefit://leoao/xxxx?xx=123，protocol 是 lefit，host 则是 leoao

- 实现流程
  在 UIWebView 内发起的所有网络请求，都可以通过 delegate 函数在 Native 层得到通知。这样，我们就可以在 UIWebView 内发起一个自定义的网络请求，拦截 URL SCHEME 的主要流程是：Web 端通过某种方式（例如 iframe.src）发送 URL Scheme 请求，之后 Native 拦截到请求并根据 URL SCHEME（包括所带的参数）进行相关操作。

在实际过程中，这种方式有一定的 缺陷：

- 使用 iframe.src 发送 URL SCHEME 会有 url 长度的隐患。
- 创建请求，需要一定的耗时，比注入 API 的方式调用同样的功能，耗时会较长。

> 但是之前为什么很多方案使用这种方式呢？因为它 支持 iOS6。而现在的大环境下，iOS6 占比很小，基本上可以忽略，所以并不推荐为了 iOS6 使用这种 并不优雅 的方式。

**注 1**：有些方案为了规避 url 长度隐患的缺陷，在 iOS 上采用了使用 Ajax 发送同域请求的方式，并将参数放到 head 或 body 里。这样，虽然规避了 url 长度的隐患，但是 WKWebView 并不支持这样的方式。

**注 2**：为什么选择 iframe.src 不选择 locaiton.href ？因为通过 location.href 有个问题，就是如果我们连续多次修改 window.location.href 的值，在 Native 层只能接收到最后一次请求，前面的请求都会被忽略掉。

##### 注入 API 让 js 直接调用

注入 API 方式的主要原理是，通过 WebView 提供的接口，向 JavaScript 的 Context（window）中注入对象或者方法，让 JavaScript 调用时，直接执行相应的 Native 代码逻辑，达到 JavaScript 调用 Native 的目的。

###### iOS

对于 iOS 的 UIWebView，实例如下：

```Objective-C
JSContext *context = [uiWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

context[@"postBridgeMessage"] = ^(NSArray<NSArray *> *calls) {
    // Native 逻辑
};
```

前端调用方式：

```js
window.postBridgeMessage(message);
```

对于 iOS 的 WKWebView 可以用以下方式：

```Objective-C
@interface WKWebVIewVC ()<WKScriptMessageHandler>

@implementation WKWebVIewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    WKUserContentController *userCC = configuration.userContentController;
    // 注入对象，前端调用其方法时，Native 可以捕获到
    [userCC addScriptMessageHandler:self name:@"nativeBridge"];

    WKWebView wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];

    // TODO 显示 WebView
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"nativeBridge"]) {
        NSLog(@"前端传递的数据 %@: ",message.body);
        // Native 逻辑
    }
}
```

前端调用方式：

```java
window.webkit.messageHandlers.nativeBridge.postMessage(message);
```

###### Android

对于 Android 可以采用下面的方式：

```java
public class JavaScriptInterfaceDemoActivity extends Activity {
	private WebView Wv;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Wv = (WebView)findViewById(R.id.webView);
        final JavaScriptInterface myJavaScriptInterface = new JavaScriptInterface(this);

        Wv.getSettings().setJavaScriptEnabled(true);
        Wv.addJavascriptInterface(myJavaScriptInterface, "nativeBridge");

        // TODO 显示 WebView

    }

    public class JavaScriptInterface {
         Context mContext;

         JavaScriptInterface(Context c) {
             mContext = c;
         }

         public void postMessage(String webMessage){
             // Native 逻辑
         }
     }
}
```

前端调用方式：

```js
window.nativeBridge.postMessage(message);
```

在 4.2 之前，Android 注入 JavaScript 对象的接口是 `addJavascriptInterface`，但是这个接口有漏洞，可以被不法分子利用，危害用户的安全，因此在 4.2 中引入新的接口 `@JavascriptInterface`（上面代码中使用的）来替代这个接口，解决安全问题。所以 Android 注入对对象的方式是 有兼容性问题的。

javascript 执行以下四种行为会被 webview 监听到，箭头后面是对应触发的 Java 方法。由于 prompt 相对来说使用的很少，所以 4.2 之前很多方案都采用拦截 prompt 的方式来实现。

    1、window.alert => onJSAlert
    2、window.confirm => onJSConfirm
    3、window.prompt => onJsPrompt
    4、window.location => shouldOverrideUrlLoading

#### Native 调用 JavaScript

Native 调用 JavaScript，其实就是`执行拼接 JavaScript 字符串`，从外部调用 JavaScript 中的方法，因此 JavaScript 的方法必须在全局的 window 上。（闭包里的方法，JavaScript 自己都调用不了，更不用想让 Native 去调用了）

###### iOS

对于 iOS 的 UIWebView，示例如下：

```Objective-C
result = [uiWebview stringByEvaluatingJavaScriptFromString:javaScriptString];
```

对于 iOS 的 WKWebView，示例如下：

```Objective-C
[wkWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
```

###### Android

对于 Android，在 Kitkat（4.4）之前并没有提供 iOS 类似的调用方式，只能用 loadUrl 一段 JavaScript 代码，来实现：

```Java
webView.loadUrl("javascript:" + javaScriptString);
```

而 Kitkat 之后的版本，也可以用 evaluateJavascript 方法实现：

```Java
webView.evaluateJavascript(javaScriptString, new ValueCallback<String>() {
    @Override
    public void onReceiveValue(String value) {
    }
});
```

**注**：使用 loadUrl 的方式，并不能获取 JavaScript 执行后的结果。

参考链接：

1. [移动混合开发中的 JSBridge](https://blog.ymfe.org/%E6%B7%B7%E5%90%88%E5%BC%80%E5%8F%91%E4%B8%AD%E7%9A%84JSBridge/)
2. [H5 与 Native 交互之 JSBridge 技术](https://segmentfault.com/a/1190000010356403)
