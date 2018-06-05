---
title: react-native集成至原有ios项目
toc: true
comments: true
date: 2018-06-04 22:12:52
categories:
tags:
photos:
---

一、准备工作
1. React Native 开发基础环境
这个可以直接参考我写的第二篇文章React Native 环境搭建和创建项目(Mac)。如果已经按上篇文章操作过，或者说已经在Mac平台已经成功运行过React Native应用，那肯定是已经有了开发基础环境，可以直接忽略这一步。

1) 安装Node.js
方式一：
安装 nvm（安装向导在这里）。然后运行命令行如下：

nvm install node && nvm alias default node
这将会默认安装最新版本的Node.js并且设置好命令行的环境变量，这样你可以输入node命令来启动Node.js环境。nvm使你可以可以同时安装多个版本的Node.js，并且在这些版本之间轻松切换。
方式二：
先安装Homebrew，再利用Homebrew安装Node.js，运行命令行如下：

//安装Home-brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
//安装Node.js
brew install node
2) 安装React Native的命令行工具（react-native-cli）

npm install -g react-native-cli
2. 安装CocoaPods
本文只写使用CocoaPods安装React Native的方式，比较支持使用，也比较简单直接。
若依旧不想使用CocoaPods，想直接集成的朋友可以参考下面两篇文章：
1)【iOS&Android】RN学习3——集成进现有原生项目

reactnative集成到原生ios项目 文中的手动集成react-native
如果之前已经安装并使用过CocoaPods，请忽略这一步（相信只要是iOS开发，一定大多数都接触过了哈）。
若没有安装，则运行命令如下：

gem install  cocoa pods
//权限不够则运行下面一句
sudo gem install cocoapods

作者：朱_源浩
链接：https://www.jianshu.com/p/3dc9d70a790f
來源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
<!--more-->



**转载请标注原文地址**

