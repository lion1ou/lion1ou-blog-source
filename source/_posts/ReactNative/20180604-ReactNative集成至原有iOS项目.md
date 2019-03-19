---
title: ReactNative集成至原有iOS项目
toc: true
comments: true
date: 2018-06-04 22:12:52
categories: ReactNative
tags: ReactNative
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

##### 创建一个iOS原生项目

>使用Xcode创建一个空的项目

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fs87not03vj31900wg0xd.jpg)

##### 项目支持Pod

创建podfile文件，我们在有xcodeproj文件的同级目录下执行下面命令，这时我们的项目文件中就多了一个Podfile文件

```
pod init
```

执行pod install命令来安装pod，同样，这个命令也是在有xcodeproj同级目录下，安装完成后，我们的项目多了一个

```
pod install
```

![](https://ws2.sinaimg.cn/large/006tKfTcgy1fs891z9rclj30gd0aoabi.jpg)

执行下面命令打开文件夹，打开.xcworkspace 文件

```
open .
```

注：当我们使用pod来作为库管理工具，后面我们打开项目运行，就需要打开上图所示的.xcworkspace文件

![](https://ws3.sinaimg.cn/large/006tKfTcgy1fs89c9je3rj30go0c3gmi.jpg)

##### 整理文件夹结构

>这里对文件夹做结构调整是为了后期更好的将Android原始项目也使用RN Hybrid，使iOS和Android共享一份React Native框架，共享同一份JS文件，调整的后的文件夹结构如下

![](https://ws3.sinaimg.cn/large/006tKfTcgy1fs8di2bg05j30ba05mt90.jpg)

##### 添加RN依赖文件

主要需要以下几步：

* 创建package.json文件（用于react-native相关依赖信息）
* 创建index.js文件
* 创建bundle文件夹（这个文件夹是我们后面接入codepush热更新时使用的）

###### 安装React Native

安装React Native这个也很简单，我们也是简单的执行下面的命令即可，注意：执行npm 系列的命令，我们都需要在项目根目录（有package.json文件的目录）下执行

```
$ npm install
```

###### package.json文件内容如下:

```
{
  "name": "testRN",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "start": "node node_modules/react-native/local-cli/cli.js start"
  },
  "dependencies": {
    "react": "16.0.0",
    "react-native": "0.50.3",
    "react-native-router-flux": "^4.0.0-beta.24",
    "react-native-simple-store": "^1.3.0",
    "react-native-storage": "^0.2.2",
    "react-native-vector-icons": "^4.3.0"
  },
  "devDependencies": {
    "babel-jest": "22.4.1",
    "babel-preset-react-native": "4.0.0",
    "jest": "22.4.2",
    "react-test-renderer": "16.0.0"
  },
  "jest": {
    "preset": "react-native"
  }
}
```

注意：因为我们项目中使用到了react-native-vector-icons 这个iconFont组件需要依赖原生，所以我们执行完 npm install 之后，我们还需要 再执行一个 react-native link react-native-vector-icons 命令来安装原生依赖

```
$ react-native link react-native-vector-icons
```

当我们执行完npm install 命令之后，我们再打开项目目录，发现多了一个 node_modules 文件夹，这个文件夹就是我们安装的React Native所有的依赖库
修改Podfile文件，原生安装React Native依赖库

后面我们都是使用Pod来管理原生的依赖库，安装React Native依赖库，我们只需要将下面的Podfile文件中的内容添加进去，执行 pod install 安装即可

###### Podfile文件

```
# Uncomment the next line to define a global platform for your project
  platform :ios, '9.0'
# Uncomment the next line if you're using Swift or would like to use dynamic frameworks
# use_frameworks!

target 'RNTest1' do
  
    # Pods for RNTest1
    #***********************************************************************#
   
    # 'node_modules'目录一般位于根目录中
    # 但是如果你的结构不同，那你就要根据实际路径修改下面的`:path`
    pod 'React', :path => '../node_modules/react-native', :subspecs => [
    'Core',
    'RCTText',
    'RCTImage',
    'RCTActionSheet',
    'RCTGeolocation',
    'RCTNetwork',
    'RCTSettings',
    'RCTVibration',
    'BatchedBridge',
    'RCTWebSocket',
    'ART',
    'RCTAnimation',
    'RCTBlob',
    'RCTCameraRoll',
    'RCTPushNotification',
    'RCTLinkingIOS',
    'DevSupport'
    # 在这里继续添加你所需要的模块
    ]

    # 如果你的RN版本 >= 0.42.0，请加入下面这行
    pod "yoga", :path => "../node_modules/react-native/ReactCommon/yoga"
    
    #***********************************************************************#

    pod 'RNVectorIcons', :path => '../node_modules/react-native-vector-icons'

end
```

注意： `#*************************#` 中间的内容是我们需要添加的RN依赖库，后面我们所有pod 相关的命令，我们都需要iOS根目录（有Podfile文件的目录）下执行

执行安装命令

```
$ pod install
```

![](https://ws1.sinaimg.cn/large/006tKfTcgy1fs8ecskqgpj30g30bvjt4.jpg)

###### 在iOS原生页面添加RN页面和入口

>实现由原生页面跳转到RN页面

在项目中新建一个RN页面，

用于承接react-native, 代码如下：

```
#import "RNViewController.h"
#import <React/RCTRootView.h>

@interface RNViewController ()

@end

@implementation RNViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * strUrl = @"http://127.0.0.1:8081/index.bundle?platform=ios&dev=true";
    NSURL * jsCodeLocation = [NSURL URLWithString:strUrl];
    
    RCTRootView * rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                         moduleName:@"testRN"
                                                  initialProperties:nil
                                                      launchOptions:nil];
    self.view = rootView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
```

在默认页面上添加跳转入口，代码如下：

```

#import "ViewController.h"
#import "RNViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIButton *btn;

@end

@implementation ViewController

-(UILabel *)label{
    // 添加标题
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 40)];
        _label.backgroundColor = [UIColor greenColor];
        _label.font = [UIFont systemFontOfSize:20];
    }
    return _label;
}

-(UIButton *)btn{
    // 添加跳转按钮
    if (_btn == nil) {
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 400, 200, 40)];
        [_btn setTitle:@"跳转RN" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

-(void)btnClick{
    // 按钮动作
    RNViewController *rnVC = [[RNViewController alloc]init];
    [self presentViewController:rnVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.label];
    [self.view addSubview:self.btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
```


##### 引入RN入口文件 index.js

```js
import React, { Component } from 'react'
import {
  Platform,
  StyleSheet,
  Text,
  View,
  AppRegistry
} from 'react-native';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit App.js
        </Text>
        <Text style={styles.instructions}>
          {instructions}
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('testRN', () => App)

```
到这里所有的配置，都完成了

### 三、启动项目

* 在项目最外层路径下，执行 `npm start`，开启node服务
* 在Xcode上启动项目
* 成功运行

![](http://oat0k0zot.qnssl.com/2018/06/13/Fi-2bPGtCXeO03AWd47NKS_gYld0138.png)


### 更新react-native版本

* 修改package.json中，react-native和React版本为当前最高版本，
* 在当前目录下，执行`npm install`
* 关闭Xcode
* cd 到ios目录，执行pod install，会报错（按照底下错误提示修改podfile文件配置）
* 再次执行pod install
* 再打开 .xcworkspace 文件
* 运行


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

3. 新建RN页面时，出现错误 'React/RCTRootView.h' file not found

![](https://ws3.sinaimg.cn/large/006tKfTcgy1fs8ey0vq3sj30mv0afdhh.jpg)

解决方法： 

    1.  rm -rf Pods.
    2.  rm Podfile.lock.
    3.  pod install
    4.  react-native link
    5.  不要忘了需要先关闭Xcode 在执行`pod install`，然后再打开`.xcworkspace`

4. 在编译时出现 `Undefined symbols for architecture x86_64`

![](http://oat0k0zot.qnssl.com/2018/06/13/FgFiv8PTgtHfGVf2CBXMU7UOajtu247.png)

原因：缺少引用依赖

在podfile中添加 `BatchedBridge` 引用依赖


5. 在pod install 过程中出现

```
[!] CocoaPods could not find compatible versions for pod "React/BatchedBridge":
In Podfile:
React/BatchedBridge (from ../node_modules/react-native/)
```

原因：当前版本的react-native不支持BatchedBridge这个组件了

解决：在podfile中去除`BatchedBridge`引用，修改为`CxxBridge`



**转载请标注原文地址**

