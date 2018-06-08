---
title: react-native集成至原有ios项目
toc: true
comments: true
date: 2018-06-04 22:12:52
categories:
tags:
photos:
---

### 一、准备工作

##### 1. React Native 开发基础环境
这个可以直接参考我之前写的，环境搭建相关的文章。如果已经按上篇文章操作过，或者说已经在Mac平台已经成功运行过React Native应用，那可以直接忽略这一步。

* 安装Node.js

方式一：安装 nvm（安装向导在这里）。然后运行命令行如下：

```bash
nvm install node && nvm alias default node
```

这将会默认安装最新版本的Node.js并且设置好命令行的环境变量，这样你可以输入node命令来启动Node.js环境。nvm使你可以可以同时安装多个版本的Node.js，并且在这些版本之间轻松切换。

方式二：

先安装Homebrew，再利用Homebrew安装Node.js，运行命令行如下：

```bash
# 安装Home-brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 安装Node.js
brew install node
```

* 安装React Native的命令行工具（react-native-cli）

```bash
npm install -g react-native-cli
```

##### 2. 安装CocoaPods

如果之前已经安装并使用过CocoaPods，请忽略这一步（相信只要是iOS开发，一定大多数都接触过了哈）。
若没有安装，则运行命令如下：

```bash
gem install cocoapods
# 权限不够则运行下面一句
sudo gem install cocoapods
```

### 二、 集成React Native





### 坑

1. 运行时发生以下错误:`library not found for -lDoubleConversion`

![](https://ws1.sinaimg.cn/large/006tKfTcgy1fs3jx9sortj31ae0iygve.jpg)

![](https://ws1.sinaimg.cn/large/006tKfTcgy1fs3jx9sortj31ae0iygve.jpg)

现在会报这个错误，但是我这边文件已经引入了，而且文件是存在的

解决方法： 

1.  rm -rf Pods.
2.  rm Podfile.lock.
3.  pod install
4.  react-native link
5.  不要忘了需要先关闭Xcode 在执行`pod install`，然后再打开`.xcworkspace`


2. 运行时产生以下错误:`Could not connect to development server.`
Failed to load bundle(http://localhost:8081/index.bundle?platform=ios&dev=true) with error: (Could not connect tp development server)

![](https://ws1.sinaimg.cn/large/006tNc79gy1fs2ecea0e7j30k30zqwmy.jpg)

解决:

把代码中的localhost改为IP地址（127.0.0.1）



**转载请标注原文地址**

