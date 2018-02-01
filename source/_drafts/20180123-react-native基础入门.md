---
title: react-native 基础入门
toc: true
comments: true
date: 2018-01-23 15:01:21
categories:
tags:
photos:
---

<!--more-->

### 环境搭建

### 安装测试

提示：你可以使用--version参数（注意是两个杠）创建指定版本的项目。例如react-native init MyApp --version 0.44.3。注意版本号必须精确到两个小数点。

```bash
react-native init AwesomeProject
cd AwesomeProject
react-native run-ios
```

>提示：如果run-ios无法正常运行，请使用Xcode运行来查看具体错误（run-ios的报错没有任何具体信息）。

运行：

* 在Nuclide中打开AwesomeProject文件夹然后运行
* 双击ios/AwesomeProject.xcodeproj文件然后在Xcode中点击Run按钮。

修改项目，现在你已经成功运行了项目，我们可以开始尝试动手改一改了：

* 使用你喜欢的编辑器打开App.js并随便改上几行。
* 在iOS Emulator中按下⌘+R就可以刷新APP并看到你的最新修改！
* 在 Android 上可以双击R，可以刷新APP并看到你的最新修改

### 问题记录

##### ReactNative iOS运行出错：No bundle URL present（整个页面红色）

此处，React Native iOS中，iOS模拟器运行又出现了：`No bundle URL present`

是由于：（shadowsocks的）网络代理设置为了全局代理（去翻墙）

>导致了之前可以正常连接到本地的packager的server，由于全局网络代理，从而需要绕道国外服务器，再去连接本地，所以无法正常访问了

解决办法是：取消全局网络代理，改为自动模式即可。

**转载请标注原文地址**

