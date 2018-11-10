---
title: ReactNative之环境搭建
toc: true
comments: true
date: 2018-05-31 11:51:08
categories: ReactNative
tags: ReactNative
photos:
---

<!--more-->

### 环境配置

按照官网[https://reactnative.cn/docs/0.51/getting-started.html](https://reactnative.cn/docs/0.51/getting-started.html)的教程一步一步来，不过还是遇坑无数，这里记录一下遇到的坑。

##### Android + Mac 环境

1. 安装完SDK后，再安装android studio，出现如下错误

    ![](https://ws1.sinaimg.cn/large/006tNc79gy1fruoitlzesj30ym0hiaco.jpg)

    `Unable to access Android SDK add-on list`

    第一次安装Android studio时候弹出unable to access android sdk add-on list

    原因：是你电脑没有SDK而且你下载的android studio又是不带SDK的；

    解决方法：在自己安装的目录下找到：bin\idea.properties打开这个文件末尾添加一行disable.android.first.run=true就行了，如果打不开这个文件，可以下载安装EditPlus工具或者sublime_text工具，用工具打开修改即可；如果这都嫌麻烦的话，那就用txt打开再简单不过了。但是并没有从根本上解决这个问题。

2. 进入android studio后，安装项无法选择，android SDK 无法下载。

    ![](https://ws1.sinaimg.cn/large/006tNc79gy1fruoirrs0tj31a80lk41x.jpg)

    原因：开启了 shadowsocks ，系统访问外部的SDK 资源，但还是未下载成功。

    解决办法： 在打开 android Studio时，先关闭 shadowsocks，等待进入sdk 下载页面时，再开启shadowsocks

3. ios报错

```
Found Xcode project testProject.xcodeproj
xcrun: error: unable to find utility "instruments", not a developer tool or in PATH

解决办法：

Xcode > Preferences > Locations
And assigning the Command Line Tools
```

4. ios报错
```
error: Build input file cannot be found: '/Users/rod/dev/react/testing/awesome/node_modules/react-native/third-party/double-conversion-1.1.6/src/strtod.cc'

▸ Compiling fast-dtoa.cc
error: Build input file cannot be found: '/Users/rod/dev/react/testing/awesome/node_modules/react-native/third-party/double-conversion-1.1.6/src/fast-dtoa.cc'

▸ Compiling fixed-dtoa.cc
error: Build input file cannot be found: '/Users/rod/dev/react/testing/awesome/node_modules/react-native/third-party/double-conversion-1.1.6/src/fixed-dtoa.cc'

▸ Compiling double-conversion.cc
error: Build input file cannot be found: '/Users/rod/dev/react/testing/awesome/node_modules/react-native/third-party/double-conversion-1.1.6/src/double-conversion.cc'

▸ Compiling diy-fp.cc
error: Build input file cannot be found: '/Users/rod/dev/react/testing/awesome/node_modules/react-native/third-party/double-conversion-1.1.6/src/diy-fp.cc'

▸ Compiling cached-powers.cc
error: Build input file cannot be found: '/Users/rod/dev/react/testing/awesome/node_modules/react-native/third-party/double-conversion-1.1.6/src/cached-powers.cc'

▸ Compiling bignum.cc
error: Build input file cannot be found: '/Users/rod/dev/react/testing/awesome/node_modules/react-native/third-party/double-conversion-1.1.6/src/bignum.cc'
```

解决办法，在项目目录下执行下面命令：

```shell
cd node_modules/react-native/scripts && ./ios-install-third-party.sh && cd ../../../
cd node_modules/react-native/third-party/glog-0.3.5/ && ../../scripts/ios-configure-glog.sh
```

### 安装pod

```shell

sudo gem update --system

sudo gem install -n /usr/local/bin cocoapods

pod setup

然后进入项目所在的ios目录，pod install

```


### 安装fastlane

1、首先要安装正确的 Ruby 版本。在终端窗口中用下列命令来确认:

```shell
ruby -v
```

2、然后检查 Xcode 命令行工具是否安装。在终端窗口中输入命令：

```shell
xcode-select --install
```

3、以上依赖配置好之后就可以通过 rubygem 进行安装了

```shell
sudo gem install fastlane # 提示没有权限

sudo gem install -n /usr/local/bin fastlane
```

可能会出现权限问题的报错，需要开一下组件的gitlab项目权限。（ssh有时候会出现，访问不了的问题，断网再连，或者等等看）


### 帐号登录

ios开发者帐号需要添加，然后在xcode登录，再在项目目录项运行 `fastlane match`


### 安装测试

```bash
react-native init AwesomeProject
cd AwesomeProject
react-native run-ios
# react-native run-android
```

>提示：
1. 如果run-ios无法正常运行，请使用Xcode运行来查看具体错误（run-ios的报错没有任何具体信息）。
2. 你可以使用--version参数（注意是两个杠，版本号必须精确到两个小数点）创建指定版本的项目。例如react-native init MyApp --version 0.44.3

运行APP：

* 在Nuclide中打开AwesomeProject文件夹然后运行
* 双击ios/AwesomeProject.xcodeproj文件然后在Xcode中点击Run按钮。

修改项目，现在你已经成功运行了项目，我们可以开始尝试动手改一改了：

* 使用你喜欢的编辑器打开App.js并随便改上几行。
* 在iOS Emulator中按下⌘+R就可以刷新APP并看到你的最新修改！
* 在 Android 上可以双击R，可以刷新APP并看到你的最新修改

### 调试方法

在模拟器上按快捷键 Command-D ，会弹出下面图示

![](https://ws3.sinaimg.cn/large/006tKfTcgy1fo33qaqknaj30km14edgx.jpg)


### 问题记录

##### ReactNative iOS运行出错：No bundle URL present（整个页面红色）

此处，React Native iOS中，iOS模拟器运行又出现了：`No bundle URL present`

* 方法一

是由于：（shadowsocks的）网络代理设置为了全局代理（去翻墙）

>导致了之前可以正常连接到本地的packager的server，由于全局网络代理，从而需要绕道国外服务器，再去连接本地，所以无法正常访问了

解决办法是：取消全局网络代理，改为自动模式即可。

* 方法二

怀疑是因为环境被破坏了，重新安装依赖，启动环境

在iOS模拟器运行的情况下，在命令行内输入：

```bash
npm i
react-native run-ios
```


#####  ReactNative iOS打开WebView 出现 `Error Domain=NSURLErrorDomain Code=-1022`

原因是：iOS开发中依然使用http请求，而非https请求，或者https请求内带有http请求。

解决方案： 修改RN项目中的ios文件夹下的项目文件内的`Info.plist`文件，如图添加下面代码

![](https://ws2.sinaimg.cn/large/006tNc79gy1fo99gokjf9j30w40fa3z2.jpg)

```
<key>NSAllowsArbitraryLoads</key>
<true/>
```

或者是在Xcode中，直接修改Info.plist文件

![](https://ws2.sinaimg.cn/large/006tNc79gy1fo99jtjtixj31cg0o4gpm.jpg)

##### 连接android真机无法成功安装

通过 命令行输入： `adb devices`，验证设备是否已连接，adb安装如下：

    通过 Homebrew 安装
    brew cask install android-platform-tools
    测试是否正常安装
    adb devices

若没有出现如下情况，说明设备还是没有成功连接，进入设备开发者模式，打开USB调试

![](https://ws1.sinaimg.cn/large/006tNc79gy1fruuv5wkh3j30rs048gm5.jpg)


**转载请标注原文地址**

