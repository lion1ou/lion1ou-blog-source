---
title: RN开发过程遇到的问题
toc: true
comments: true
categories: 技术博客
tags: Default
date: 2019-06-16 22:19:17
photos:
description:
---





### iOS相关问题


1. ios证书问题: 证书不匹配无法打测试包，命令行在ios目录下，执行 `fastlane match`
2. ios 依赖问题，导入三方库报错： 

```bash
CocoaPods was not able to update the `master` repo. If this is an unexpected issue and persists you can inspect it running `pod repo update --verbose`
```

尝试解决：
* 尝试1： 根据提示，跑一下
pod repo update --verbose
* 尝试2：如果还是出现原来问题，升级CocoaPods版本
sudo gem update cocoa pods
* 尝试3：如果升级还是出现原来的问题，那么重装CocoaPods .

首先查看本地装了关于cocoapods的哪些东西，在终端输入
gem list --local | grep cocoapods

接着全部卸掉
sudo gem uninstall cocoapods

再安装
sudo gem install cocoapods


* 尝试4：如果问题依旧，那么清除缓存，清除命令：

sudo rm -fr ~/Library/Caches/CocoaPods/
sudo rm -fr ~/.cocoapods/repos/master
pod setup

还不行的话就把当前 Pods 目录清空：

sudo rm -fr Pods/
sudo gem install -n /usr/local/bin cocoapods

pod setup
看看还有没有报错.

* 网络情况才是第一生产要素

* cocoapods相关知识: https://www.jianshu.com/p/e2806f9d9e6f


1. ViewPropTypes和PropTypes，View.propTypes

![](http://cdn.chuyunt.com/Fq-_aoaRaRx6t1S4IJn396Nsp0Bw)

Task orphaned for request <NSMutableURLRequest: 0x1c4202170>
[Unmount images while loading · Issue #12152 · facebook/react-native · GitHub](https://github.com/facebook/react-native/issues/12152)
图片还没完全加载完成的过程中，就触发其他操作，比如页面跳转，这时候又需要unmount 图片，就会出现这些黄色warning
同理，FlatList如果有很多图片要渲染，上下拉刷新时也会出现这些情况



https://github.com/amandakelake/blog/issues/52
