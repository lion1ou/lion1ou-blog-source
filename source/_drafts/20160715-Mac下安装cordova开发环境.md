---
title: mac下安装cordova开发环境  
date: 2016-07-15 12:49:02
tags: Cordova
toc: true  
categories: Cordova
comments: true
---

## 一、安装ios开发环境
### 1.安装xcode

### 2.安装node js

>   * control + space 打开spotlight,输入“终端”，就打开了终端，类似win下的cmd
>   * 输入 node -v , 回车;
>   * 输入 npm -v , 回车;
>   * 若无错，则显示版本号
<!-- more -->
### 3.安装cordova

```shell
sudo npm install -g cordova   
```

> 如果没有sudo则会报错，原因：由于 root 用户在 OS X 中具有特殊权限，因此对于特定的管理或故障诊断任务可能非常有用，但不适合日常使用。如果使用不慎，root 用户作出的更改可能只有通过重装 OS X 才能修复。考虑使用其他方式（如 sudo 命令）来代替启用 root 用户。

### 4.安装依赖

```shell
sudo npm install -g ios-deploy - -unsafe-perm=t    //代表真机运行环境  
sudo npm install -g ios-sim                       //代表模拟器运行环境  
```

需要输入appleId密码

### 5.ios真机调试

详见[@这里](http://www.skyfox.org/ios-xcode7-debug-device.html)

## 二、安装android开发环境

  * 下载jdk：[@这里](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
  * 下载Android Studio ，[@这里](http://www.android-studio.org/)
  * 安装后，选择标准版，然后会自行下载Android-SDK，platfroms
  * 下载完以后选择SDK Manager

![](http://7xvowi.com1.z0.glb.clouddn.com/blog/sdk-manager.png)

 * 选择需要下载的SDK文件

![](http://7xvowi.com1.z0.glb.clouddn.com/blog/downloadAndroidSdk.png)

 ＊ 显示隐藏文件：

>在终端（Terminal）输入如下命令，即可显示隐藏文件和文件夹

```shell
defaults write com.apple.finder AppleShowAllFiles -boolean true ; killall Finder//显示  
defaults write com.apple.finder AppleShowAllFiles -boolean false ; killall Finder//隐藏
```

 * 在本地目录（home directory／就是你的用户目录下）中创建文件.bash_profile
 * 在文件中写入以下内容：（可能每个人都有差异，请勾选显示“资源库”选项，自行对比）

```shell
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_91.jdk/Contents/Home;  
export ANDROID_HOME=/Users/mac/Library/Android/sdk;  
export ANDROID_HOME_TOOLS=/Users/mac/Library/Android/sdk/platform-tools;  
export PATH=${PATH}:${JAVA_HOME}:${ANDROID_HOME}:${ANDROID_HOME_TOOLS};
export PATH=$PATH:/Users/mac/Library/Android/sdk/platform-tools;   
```

 * 执行如下命令：
```shell
source .bash_profile
```

 * 验证：检查是否生效,可以看下 adb 当前版本

```shell
adb -version
```

出现以下内容，说明环境变量设置完成。

![](http://ww1.sinaimg.cn/large/65e4f1e6gw1f8rincw520j209504bq3e.jpg)

 * 执行Cordova命令行，`cordova run android`

![](http://7xvowi.com1.z0.glb.clouddn.com/blog/firstRunCordova.png)
即可真机调试程序，还是出现无法安装问题，拔出手机连接线，重新连接。（首次执行cordova命令需要较长时间，下载相关依赖文件）

## 出现问题

若出现如下问题：
```bash
cordova build android
ANDROID_HOME=/Users/jkinfo/Library/Android/sdk
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_91.jdk/Contents/Home
Error: Could not find gradle wrapper within Android SDK. Might need to update your Android SDK.
Looked here: /Users/jkinfo/Library/Android/sdk/tools/templates/gradle/wrapper
```

解决办法：

去[安卓开发平台](https://developer.android.com/studio/index.html#downloads)下载Android tools [tools_r25.2.3-macosx.zip](https://dl.google.com/android/repository/tools_r25.2.3-macosx.zip) 替换现tools文件的内容

* 下载上述文件，解压
* 将解压出来的文件，与`/Users/jkinfo/Library/Android/sdk/tools`目录下的文件替换
* 然后就可以正常的运行cordova命令了。



                          

