---
title: ReactNative之CocoaPods基础知识
toc: true
comments: true
date: 2018-10-17 00:15:31
categories: 前端技术
tags: ReactNative
photos:
---

在使用react-native的时候，安装ios依赖时经常就会使用到cocoapods，这里我们介绍一下cocoaPods。

<!--more-->

### 什么是CocoaPods

CocoaPods是OS X和iOS下的一个第三类库管理工具，通过CocoaPods工具我们可以为项目添加被称为“Pods”的依赖库（这些类库必须是CocoaPods本身所支持的），并且可以轻松管理其版本。

### CocoaPods的好处

1、在引入第三方库时它可以自动为我们完成各种各样的配置，包括配置编译阶段、连接器选项、甚至是ARC环境下的-fno-objc-arc配置等。
2、使用CocoaPods可以很方便地查找新的第三方库，这些类库是比较“标准的”，而不是网上随便找到的，这样可以让我们找到真正好用的类库。

### cocoapods的安装

#### 1. gem简介

Gem是一个管理Ruby库和程序的标准包，它通过Ruby Gem（如 http://rubygems.org/ ）源来查找、安装、升级和卸载软件包，非常的便捷。

> 常用命令

* 查看gem版本 gem --version
* 更新 gem update --system
* 查看数据源 gem source
* 安装软件包 gem install 软件包名称
* 卸载安装包 gem uninstall


#### 2. 使用gem 安装cocoapods

```bash
sudo gem install cocoapods
```

### 使用cocoapods集成第三方

#### 1.检索第三方框架

pod search 框架关键字

内部原理：从本地缓存的"第三方框架描述信息" 生成的检索文件中检索到 相关框架的信息

常见错误：unable to find....

删除cocoapods索引文件


#### 2.安装第三方框架

创建 Podfile 文件, 到自己工程内(一级目录)

Podfile 文件作用：其实就是使用ruby语法编写的 "框架依赖描述文件"; 就是告诉cocoapods需要下载集成哪些框架

创建命令: pod init


#### 3.安装框架

安装命令 pod install

原理：直接就是根据 Podfile 文件从本地索引库中找到框架信息, 然后下载集成
找不到目标框架

更新本地框架信息源信息: pod install --no-repo-update  (快速)

生成的重要文件 Podfile.lock

作用: 记录着上一次下载的框架最新版本


* pod install 和 pod update 区别

pod install: 如果Podfile.lock文件存在, 直接从此文件中读取框架信息下载安装, 如果不存在, 依然会读取Podfile文件内的框架信息,下载好之后, 再根据下载好的框架信息, 生成Podfile.lock文件
pod update 不管Podfile.lock是否存在, 都会读取Pod file文件的的框架信息去下载。主要区别在于, Podfile文件内的框架信息, 版本描述没有指定具体版本




