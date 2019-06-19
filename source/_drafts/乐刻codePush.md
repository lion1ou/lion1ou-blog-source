---
title: 乐刻codePush
toc: true
comments: true
categories: 技术博客
tags: Default
date: 2019-06-16 22:05:01
photos:
description:
---


[TOC]
# 摘要说明  
  react-native code push 是微软提供一个在RN平台上进行热更新的工具。由于微软云服务在国内访问速度慢(其实也还可以的)，并且出于功能可扩展性。采用基于开源项目[code push server](https://github.com/lisong/code-push-server)进行自建管理。  
  本文档对自建code push的使用流程进行介绍，从客户端配置安装--》客户端打bundle包--》web后面发布上线--》客户端验证效果整个流程进行说明。  

# 客户端配置安装  

Code Push的配置涉及到js、android、ios三端安装

## 要求
- [x] 在一个 React Native 项目下完成安装，所以务必保证已经[ 接入 React Native 项目](http://note.youdao.com/noteshare?id=168e310d0fac7692befe4686d0e4aedc)  

## 安装  

- 使用npm安装Code Push依赖包  

``` ruby
npm install --save react-native-code-push
```

- 链接到原生项目  

``` ruby
react-native link react-native-code-push
```

## 配置  

### js  

代码的配置有多种，这里介绍其中一种，更多种类配置可以查看[react native code push](https://github.com/Microsoft/react-native-code-push)。  
在根视图组件文件下：  

``` js
import CodePush from "react-native-code-push";
export default class App extends Component<Props> {

    componentDidMount() {
        CodePush.sync({
            //启动模式三种：ON_NEXT_RESUME、ON_NEXT_RESTART、IMMEDIATE
            installMode: CodePush.InstallMode.IMMEDIATE,
            // 苹果公司和中国区安卓的热更新，是不允许弹窗提示的，所以不能设置为true
            updateDialog: false
        });
    }

    render() {
        return (
            <View>
            </View>
        );
    }
}
```  

### android  

`MainApplication`文件里，`CodePush`实例有两个参数需要修改。  
- 第一个参数`deployment-key`是在web后面新建应用时生成的key值，区分android、ios
- 第四个参数`server-url`是`code push server`部署的域名

``` java
public class MainApplication extends Application implements ReactApplication {

  private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {

        @Override
        protected String getJSBundleFile() {
        return CodePush.getJSBundleFile();
        }
    
    @Override
    public boolean getUseDeveloperSupport() {
      return BuildConfig.DEBUG;
    }

    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
            new CodePush("A6dIIfwQCl2XHa3VzzFvTyvkrixW4ksvOXqog", getApplicationContext(), BuildConfig.DEBUG,"http://172.16.150.71:3001/")
      );
    }

    @Override
    protected String getJSMainModuleName() {
      return "index";
    }
  };

  @Override
  public ReactNativeHost getReactNativeHost() {
    return mReactNativeHost;
  }

  @Override
  public void onCreate() {
    super.onCreate();
    SoLoader.init(this, /* native exopackage */ false);
  }
}
```

### ios  
  todo
  
# 客户端打包  

客户端使用命令行的方式打包：
``` ruby
react-native bundle --platform android --entry-file index.js --bundle-output android/app/src/main/assets/android.bundle --dev false
```  
参数说明：  
- --entry-file ,ios或者android入口的js名称，比如index.ios.js

- --platform ,平台名称(ios或者android)

- --dev ,设置为false的时候将会对JavaScript代码进行优化处理。打包时需要置为false，否则打出的包体积会很大。

- --bundle-output, 生成的jsbundle文件的名称，比如./ios/bundle/index.ios.jsbundle

- --assets-dest 图片以及其他资源存放的目录,比如./ios/bundle

为了方便使用，也可以把打包命令写到npm script中:  
``` js
"scripts": {
    "start": "node node_modules/react-native/local-cli/cli.js start",
    "bundle-ios":"node node_modules/react-native/local-cli/cli.js bundle --entry-file index.ios.js  --platform ios --dev false --bundle-output ./ios/bundle/index.ios.jsbundle --assets-dest ./ios/bundle",
    "bundle-android":"node node_modules/react-native/local-cli/cli.js bundle --entry-file index.js  --platform android --dev false --bundle-output ./android/bundle/index.android.bundle --assets-dest ./android/bundle"
  },
```
```
tips：如果没有对应的路径，请先新建对应目录
```
然后运行命令打包  
> npm run bundle-android

最后，将生成的bundle包压缩成zip上传到web后台发布管理。  

# WEB后台发布管理  

目前web后台的操作不太完整，比如：应用管理、部署管理这两个模块还没有建立起来。这两块的操作，仍然需要使用命令行的方式管理。发布管理已经打通了发布、回滚、编辑、下线等基本操作。  

## 发布、编辑  
[发布地址](http://test-app-cms.leoao-inc.com/version/RNmanage/detail?appName=android-test)，发布参数作如下解释：  

- 描述：更新内容描述  
- 版本号：原生app版本号，注意不是RN版本号，也不是发布的版本号。版本号规则：见下表。
  
| 版本号通配规则 | 适用版本 |
| ------ | ------ |
| 1.2.3 | 只有app1.2.3这个版本可以更新 |
| * | 配置了CodePush的所有app版本 |
| 1.2.3 - 1.2.7 | 1.2.3（包含）到1.2.7（包含）中间的版本可以更新 |
| 1.2 | 相当于>=1.2.0 <1.3.0 |

- 是否上线：提交后，是否立即上线。  
- 是否强升：因为都是静默更新，意义不大。  
- 灰度百分比：app更新比例。  
- 上传文件：客户端打的离线包，要是zip压缩包。文件上限需要server端配置  

注意：  
1、编辑操作不能对已经上传的离线包文件操作。其他参数<font color="#DC143C">同发布</font>  


| 页面 | 操作 | 期望结果 |
| ------ | ------ | ------ |
| RN版本管理详情 | 输入更新描述 | 可以正常输入 |
|  | 输入版本号 | 能够检验版本号是否符合规则 |
|  | 选择是否上线 | 能够正常选择是、否 |
|  | 选择是否强升 | 能够正常选择是、否 |
|  | 选择是否强升 | 能够正常选择是、否 |
|  | 输入灰度百分比 | 能够检验输入规则（0-100） |
|  | 上传更新包文件 | 能够检验文件格式及判定大小限制 |
|  | 提交 | 输入项通过后可以成功提交并返回到上一级列表页面。客户端能够按着输入项呈现效果 |
|  | 取消 | 返回到上一级列表页面 |


## 回滚  
[发布列表](http://test-app-cms.leoao-inc.com/version/RNmanage?appName=android-test)，回滚参数：  

- 版本：回滚到哪个版本。注意：只能从最新版本开始回滚，回滚之后会产生一个新版本。


| 页面 | 操作 | 期望结果 |
| ------ | ------ | ------ |
| RN版本管理 | 选择应用名 | 可以选择已经创建的应用 |
|  | 点击回滚按钮 | 能够弹出选择框 |
|  | 选择回滚到的版本 | 能够正常选择历史版本 |
|  | 确定 | 能够正常回滚到选择的历史版本 |



## 上、下线  
从发布列表，选择某个已经提交的版本进行操作。  

| 页面 | 操作 | 期望结果 |
| ------ | ------ | ------ |
| RN版本管理 | 对一个已经提交的版本上下线 | 可以成功上下线 |


# 客户端验证  
`js`端配置的时候，可以配置更新策略，包括三种：`ON_NEXT_RESUME`、`ON_NEXT_RESTART`、`IMMEDIATE`。字面意思能大概理解，再说明下：  

`ON_NEXT_RESUME`：重启检查下载更新，再次可见时更新生效。  
`ON_NEXT_RESTART`：重启检查下载更新，再次重启时更新生效。  
`IMMEDIATE`：重启检查下载更新，更新生效。

# 注意事项  

- 1、app发布版本时，也要对应该版本发布一条code push更新作为基线版本。因为后续的更新要在这条基线发布的基础上作差异化下发。所以，每次app更新和React Native 更新都要有对应的tag。以留后续验证修复。  

- 2、因为React Native 是基于原生app平台的，与原生代码也难免有交互，所以，React Native 配合的原生app版本号也有相应的上下限。下面是一个记录版本的模板，这个记录应该通过数据库可以查的：

| app版本 | ReactNative版本 | CodePush更新Label |
| ------ | ------ | ------ |
| 1.0.0 | 1.0.0 | v1 |
|  | 1.0.1 | v2 |
| 1.0.1 | 1.0.2 | v3 |


# 常见问题  

- 1、启动RN页面没有更新，并且调试模式提示`Network request failed`  

这是因为原生端配置的server url有问题。需要检查，如果是局域网IP，请一定要加上`http://`头，如果有端口号也请加上。  

- 2、启动RN页面没有更新，并且调试模式提示`[CodePush] An update is available, but it is being ignored due to having been previously rolled back.`  

一种情况，是因为检查到了一条更新，但是这条更新不是最新版本。很可能是历史发布的时候写错了版本号。可以归结为版本号错乱了。可以查看获取到的这条更新的label版本，然后把这条发布的版本号修正，使app可以获取到最新版本。  
还有一种情况，是检测到的这一条发布因为一些错误，没有更新成功。再检查还是这一条发布，就会提示错误版本被忽略了。需要打新包发布  

- 3、启动RN页面没有更新，并且调试模式提示`Update is invalid - A JS bundle file named "index.android.bundle" could not be found within the downloaded contents. Please check that you are releasing your CodePush updates using the exact same JS bundle file name that was shipped with your app's binary.`  

这是因为打包的时候命名不正确。请按着错误提示信息中的命名来打包。  

- 4、启动RN页面更新成功了，但是还是原来的效果。  

可能是调试模式本身的热更新冲掉了Code Push的更新。  

- 5、The update contents failed the data integrity check.  

我今天用了多半天时间，解决了这个问题，原因是mac系统下，打包的目录中多了隐藏文件.DS_Store，导致hash校验失败，为什么第一次能成功呢，因为第一次下载不是diffUpdate，所以不做hash校验。
解决方法就是：每次打包前把./bundles目录整个删除或者把.DS_Store文件删除再打包就好了...
Android代码中CodePushUpdateManager.java中有这么一段代码，做hash校验的...
if (isDiffUpdate) {
CodePushUpdateUtils.verifyFolderHash(newUpdateFolderPath, newUpdateHash);
}