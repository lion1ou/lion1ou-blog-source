---
title: ReactNative之入门全解
toc: true
comments: true
date: 2018-12-17 00:13:04
categories: 前端技术
tags: ReactNative
photos:
---

上手 RN 开发也有一段时间了，为了让团队其他同学也能快速上手，也算是对自己学习过程的一个记录。 这里整理了一下整个开发过程需要注意的点，因为是面向大前端所有同学，所以也包括了前端、android、ios 的相关知识。主要分成几个部分：环境搭建、基础知识（RN 基础、前端基础）、学习资源

<!--more-->

## 环境搭建和运行

### 基础环境

按照官网[https://reactnative.cn/docs/0.51/getting-started.html](https://reactnative.cn/docs/0.51/getting-started.html)的教程一步一步来，不过还是遇坑无数，这里记录一下遇到的坑。

1. [jDK 1.8 下载](https://cdn.leoao.com/jdk-8u131-macosx-x64.dmg)困难，这里放到我们自己服务器了。

2. 安装完 SDK 后，再安装 android studio，出现如下错误

   ![](http://cdn.chuyunt.com/uPic/006tNc79gy1fruoitlzesj30ym0hiaco.jpg)

   `Unable to access Android SDK add-on list`

   第一次安装 Android studio 时候弹出 unable to access android sdk add-on list

   原因：是你电脑没有 SDK 而且你下载的 android studio 又是不带 SDK 的；

   **解决方法：** 在自己安装的目录下找到：bin\idea.properties 打开这个文件末尾添加一行 disable.android.first.run=true 就行了，如果打不开这个文件，可以下载安装 EditPlus 工具或者 sublime_text 工具，用工具打开修改即可；如果这都嫌麻烦的话，那就用 txt 打开再简单不过了。但是并没有从根本上解决这个问题。

3. 进入 android studio 后，安装项无法选择，android SDK 无法下载。

   ![](http://cdn.chuyunt.com/uPic/006tNc79gy1fruoirrs0tj31a80lk41x.jpg)

   原因：开启了 shadowsocks ，系统访问外部的 SDK 资源，但还是未下载成功。

   **解决办法：** 在打开 android Studio 时，先关闭 shadowsocks，等待进入 sdk 下载页面时，再开启 shadowsocks

### 安装测试

```bash
react-native init AwesomeProject
cd AwesomeProject
react-native run-ios
# 或者 react-native run-android
```

> 提示：

1. 如果`run-ios`无法正常运行，请使用 Xcode 运行来查看具体错误（`run-ios`的报错没有任何具体信息），命令行执行`react-native start`，双击 ios/AwesomeProject.xcodeproj 文件，然后在 Xcode 中点击 Run 按钮。
2. 你可以使用`--version`参数（注意是两个杠，版本号必须精确到两个小数点）创建指定版本的项目。例如`react-native init MyApp --version 0.44.3`

### [运行调试](https://reactnative.cn/docs/0.51/debugging.html#content)

到这里你已经成功运行了项目，我们可以开始尝试动手改一改了：

- 使用你喜欢的编辑器打开 App.js 并随便改上几行。
- 在 iOS Emulator 中按下 ⌘+R 就可以刷新 APP 并看到你的最新修改！
- 在 Android 上可以双击 R，可以刷新 APP 并看到你的最新修改

#### 开启调试框

- 在 iOS 模拟器中运行，还可以按下 Command⌘ + D 快捷键，Android 模拟器对应的则是 Command⌘ + M（windows 上可能是 F1 或者 F2）
- 使用真机时，摇晃手机，会弹出调试框。（android 需要开启悬浮框权限，才会弹出调试框）

![](https://cdn.leoao.com/blog/RN调试界面.jpg?imageslim)

#### 刷新 JavaScript

- 在 iOS 模拟器中按下 Command⌘ + R ，Android 模拟器上对应的则是按两下 R。
- 选择开发菜单中的"Enable Live Reload"可以开启自动刷新。(增加了新的资源(比如给 iOS 的 Images.xcassets 或是 Andorid 的 res/drawable 文件夹添加了图片)
  更改了任何的原生代码)

#### 应用内报错

- 红屏或黄屏提示都只会在开发版本中显示，正式的离线包中是不会显示的。
- 可以通过在代码中执行`console.disableYellowBox = true;`，手动关闭警告
- 可以通过指定警告类型，来指定性关闭`console.ignoredYellowBox = ['Warning: ...'];`

#### 访问控制台日志

- 可以在终端上执行`react-native log-ios`，或者在 iOS 模拟器的菜单中选择 Debug → Open System Log...来查看。
- 可以在终端上执行`react-native log-android`，或者在 Android 模拟器或是真机上，都可以通过在终端命令行里运行`adb logcat *:S ReactNative:V ReactNativeJS:V`命令来查看。

#### Chrome 开发者工具

- 在开发者菜单中选择"Debug JS Remotely"选项，即可以开始在 Chrome 中调试 JavaScript 代码。点击这个选项的同时会自动打开调试页面 http://localhost:8081/debugger-ui.

### 问题记录

#### 1. ReactNative iOS 运行出错：No bundle URL present（整个页面红色）

此处，React Native iOS 中，iOS 模拟器运行又出现了：`No bundle URL present`

- 方法一，是由于：（shadowsocks 的）网络代理设置为了全局代理（去翻墙）

> 导致了之前可以正常连接到本地的 packager 的 server，由于全局网络代理，从而需要绕道国外服务器，再去连接本地，所以无法正常访问了

> 解决办法是：取消全局网络代理，改为自动模式即可。

- 方法二， 怀疑是因为环境被破坏了，重新安装依赖，启动环境。在 iOS 模拟器运行的情况下，在命令行内输入：

```bash
npm i
react-native run-ios
```

#### 2. ReactNative iOS 打开 WebView 出现 `Error Domain=NSURLErrorDomain Code=-1022`

原因是：iOS 开发中依然使用 http 请求，而非 https 请求，或者 https 请求内带有 http 请求。

解决方案： 修改 RN 项目中的 ios 文件夹下的项目文件内的`Info.plist`文件，如图添加下面代码

![](http://cdn.chuyunt.com/uPic/006tNc79gy1fo99gokjf9j30w40fa3z2.jpg)

```
<key>NSAllowsArbitraryLoads</key>
<true/>
```

或者是在 Xcode 中，直接修改 Info.plist 文件

![](http://cdn.chuyunt.com/uPic/006tNc79gy1fo99jtjtixj31cg0o4gpm.jpg)

#### 3. 连接 android 真机无法成功安装

通过 命令行输入： `adb devices`，验证设备是否已连接，adb 安装如下：

```bash
# 通过 Homebrew 安装
brew cask install android-platform-tools
# 测试是否正常安装
adb devices
```

若没有出现如下情况，说明设备还是没有成功连接，进入设备开发者模式，打开 USB 调试

![](http://cdn.chuyunt.com/uPic/006tNc79gy1fruuv5wkh3j30rs048gm5.jpg)

#### 4. iOS: 'glog/logging.h' file not found

```bash
cd node_modules/react-native/third-party/glog-0.3.4
sh ../../scripts/ios-configure-glog.sh
```

#### 5. iOS: Xcode 10 libfishhook.a cannot be found

先`-`libfishhook.a，再重新 `+`libfishhook.a

![](https://cdn.leoao.com/blog/libfishhook.png?imageslim)

---

## 基础知识

### 前端知识

**(针对客户端同学，前端同学可跳过)**

#### NPM

前端包管理工具

```bash
# 全局安装
$ npm install 模块名 -g

# 本地安装
$ npm install 模块名

# 一次性安装多个
$ npm install 模块1 模块2 模块n --save

# 安装运行时依赖包
$ npm install 模块名 --save

# 安装开发时依赖包
$ npm install 模块名 --save-dev

# 更新模块（包）
$ npm update 模块名
$ npm update 模块名 -g
```

#### 样式

##### 盒子模型

![](https://cdn.leoao.com/blog/1669565-9b745c39f71db85f.bmp?imageslim)

![](https://cdn.leoao.com/blog/1669565-6e0a7f2723dfe850.png?imageslim)

##### 层布局模型

> 1、绝对定位(position: absolute) 2、相对定位(position: relative)

- position:'relative'

relative 指的是相对定位，配合 top, right, bottom, left 四个方位属性，加上 z-index 堆叠顺序来对一个元素进行相对于自己左上角为原点的定位。
没有脱离文档流，依然占据着原来的空间，不影响周边元素的位置，如果与其他元素相遇，按照 z-index 来觉得谁显示在“上面”而被我们看到，这个方式可以理解为“灵魂出窍”，“灵魂”展示在那里，但“窍”还占据着原有的空间。

- position:'absolute'

绝对布局。它是相对于父级元素的左上角为原点来定位。绝对定位的元素不会占据原有的流式空间，后面的元素会“补上来”，这个和 html 的 position 也很大不一样。另外还有一个和 html 不一样的是，html 中 position:absolute 要求父容器的 position 必须是 absolute 或者 relative，如果第一层父容器 position 不是 absolute 或者 relative，在 html 会依次向上递归查询直到找到为止，然后居于找到的父容器绝对定位。

##### 样式规则

> 在 React Native 中，你并不需要学习什么特殊的语法来定义样式。我们仍然是使用 JavaScript 来写样式。所有的核心组件都接受名为 style 的属性。这些样式名基本上是遵循了 web 上的 CSS 的命名，只是按照 JS 的语法要求使用了驼峰命名法，例如将 background-color 改为 backgroundColor。

- 使用 StyleSheet.create 来集中定义组件的样式，如：

```jsx
import React, { Component } from "react";
import { AppRegistry, StyleSheet, Text, View } from "react-native";

export default class LotsOfStyles extends Component {
  render() {
    return (
      <View>
        <Text style={styles.red}>just red</Text>
        <Text style={styles.bigblue}>just bigblue</Text>
        <Text style={[styles.bigblue, styles.red]}>bigblue, then red</Text>
        <Text style={[styles.red, styles.bigblue]}>red, then bigblue</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  bigblue: {
    color: "blue",
    fontWeight: "bold",
    fontSize: 30,
  },
  red: {
    color: "red",
  },
});

AppRegistry.registerComponent("LotsOfStyles", () => LotsOfStyles);
```

##### flexBox

可参考之前写过的文章：[css 之 flex 布局](https://lion1ou.win/2016/10/15/)

#### react

##### jsx 的语法规则

1. 在 react 中想将 js 当作变量引入到 jsx 中需要使用{}
2. 在 jsx 中，相邻的两个 jsx 元素 ，渲染时需要外面包裹着一层元素
3. {}取值表达式，取的是有返回值的结果， 可以放 JS 的执行结果

```js
import React, { Component } from "react";
import ReactDOM from "react-dom";

function build(str) {
  return (
    <div>
      {/*这是注释*/}
      <h1>{str.name}建立学校</h1>
      <h1>{str.name}建立学校</h1>
    </div>
  );
}
// let el = <div>{build('哈喽')}</div>;
let el = <div>{build({ name: "哈喽" })}</div>;
ReactDOM.render(el, document.getElementById("root"));
```

##### 循环数组的列子

```js
import React, { Component } from "react";
import ReactDOM from "react-dom";

let lessons = [
  { name: "vue", price: 800 },
  { name: "react", price: 1000 },
];

function toLesson(item) {
  return `当前课程是${item.name} 价格是${item.price}`;
}

// 数组方法 find map filter reduce
let ele = (
  <ul>
    {lessons.map((item, index) =>
      // null在react中也是一个合法的元素 表示不存在，没有
      item.price < 1000 ? null : <li key={index}>{toLesson(item)}</li>
    )}
  </ul>
);

ReactDOM.render(ele, window.root);
// window.root 直接取id
```

##### 组件的两种定义方式

声明组件的方式有两种：函数声明（名字开头必须大写,没有生命周期、状态、this）和类声明（有生命周期： componentDidMount 渲染完成，componentWillUnmount 组件将要卸载,有状态和 this）

- 第一种方式是函数声明

```js
import React,{Component} from 'react';
import ReactDOM,{render} from 'react-dom';
let school1 = {name:'张三',age:8};
let school2 = {name:'李四',age:0};

function Build(props) {
    return <p>{props.name}{props.age}</p>
}

render(<div>
    {/*<Build name={school1.name} age={school1.age}/>*/}
    {/*<Build name={school2.name} age={school2.age}/>*/}
    {/*将对象中的内容解构出来传递给Build组件  不用一个个取出来传递*/}
    <Build name={...school1}/>
    <Build name={...school2}/>
</div>,window.root)
```

- 第二种方式是类声明

```js
import React, { Component } from "react";
import ReactDOM, { render } from "react-dom";
import PropTypes from "prop-types"; // 属性校验的包

// 1、属性是由外界传递的，外面不能改属性，只有状态是属于组件自己的
class School extends Component {
  // Component提供了列如this.setState()方法
  static propType = {
    // 静态属性 es7,es6只支持静态函数
    age: PropTypes.string,
  };
  static defaultProps = {
    // 校验默认属性
    age: "100",
  };
  // 类上有自己的构造函数constructor()，super()子类继承父类私有属性,extends继承的是公有
  constructor(props) {
    super(props);
  }
  render() {
    // render组件长什么样子，render的返回值只能有一个根元素
    return (
      // 通过{}取值不能打印对象  可以转化成字符串打印
      <div>{JSON.stringify(this.props)}</div>
    );
  }
}
// School.prototype = {age:PropTypes.string};
// render将虚拟dom装换成真实dom
render(<School name={"珠峰"} age={8} />, window.root);
```

##### 组件内数据

> 组件的数据来源有两个地方, props 外界传递过来的(默认属性，属性校验); state 状态是自己的,改变状态唯一的方式就是 setState

- 修改 state

```js
this.setState({
  // 改变状态唯一的方式就是setState
  count: { number: this.state.count.number + 1 },
});

this.setState(
  {
    // setState是异步的，依赖设置值 就需要在回调中执行
    count: { number: this.state.count.number + 1 },
  },
  () => {
    this.setState({
      count: { number: this.state.count.number + 1 },
    });
  }
);
```

- 组件通讯

```js
// 父传子
class Panel extends Component {
  render() {
    let { header, body } = this.props;
    return (
      <div className="container" style={{ color: "red" }}>
        <div className="panel-default panel">
          <Header header={header} />
          <Body body={body} />
        </div>
      </div>
    );
  }
}

class Header extends Component {
  render() {
    return <div className="panel-heading">{this.props.header}</div>;
  }
}

class Body extends Component {
  render() {
    return <div className="panel-body">{this.props.body}</div>;
  }
}
```

```js
// 子传父
class Panel extends Component {
  constructor() {
    super();
    this.state = { color: "primary" };
  }
  changColor = (color) => {
    // 到时候儿子传递一个颜色
    this.setState({ color: color });
  };
  render() {
    return (
      <div className="container" style={{ color: "red" }}>
        <div className={"panel-" + this.state.color + " panel"}>
          <Header header={this.props.header} change={this.changColor} />
        </div>
      </div>
    );
  }
}

class Header extends Component {
  handleClick = () => {
    this.props.change("danger");
  };
  render() {
    return (
      <div className="panel-heading">
        {this.props.header}
        <button className="btn btn-danger" onClick={this.handleClick}>
          改颜色
        </button>
      </div>
    );
  }
}
```

##### 组件声明周期

```js
class Counter extends React.Component {
  // 他会比较两个状态相等就不会刷新视图 PureComponent是浅比较
  static defaultProps = {
    name: "名字",
  };
  constructor(props) {
    super();
    this.state = { number: 0 };
    console.log("1.constructor构造函数");
  }
  componentWillMount() {
    // 取本地的数据 同步的方式：采用渲染之前获取数据，只渲染一次
    console.log("2.组件将要加载 componentWillMount");
  }
  componentDidMount() {
    console.log("4.组件挂载完成 componentDidMount");
  }
  handleClick = () => {
    this.setState({ number: this.state.number + 1 });
  };
  // react可以shouldComponentUpdate方法中优化 PureComponent 可以帮我们做这件事
  shouldComponentUpdate(nextProps, nextState) {
    // 代表的是下一次的属性 和 下一次的状态
    console.log("5.组件是否更新 shouldComponentUpdate");
    return nextState.number % 2;
    // return nextState.number!==this.state.number; //如果此函数种返回了false 就不会调用render方法了
  } //不要随便用setState 可能会死循环
  componentWillUpdate() {
    console.log("6.组件将要更新 componentWillUpdate");
  }
  componentDidUpdate() {
    console.log("7.组件完成更新 componentDidUpdate");
  }
  render() {
    console.log("3.render");
    return (
      <div>
        <p>{this.state.number}</p>
        {this.state.number > 3 ? null : <ChildCounter n={this.state.number} />}
        <button onClick={this.handleClick}>+</button>
      </div>
    );
  }
}

class ChildCounter extends Component {
  componentWillUnmount() {
    console.log("组件将要卸载componentWillUnmount");
  }
  componentWillMount() {
    console.log("child componentWillMount");
  }
  render() {
    console.log("child-render");
    return <div>{this.props.n}</div>;
  }
  componentDidMount() {
    console.log("child componentDidMount");
  }
  componentWillReceiveProps(newProps) {
    // 第一次不会执行，之后属性更新时才会执行
    console.log("child componentWillReceiveProps");
  }
  shouldComponentUpdate(nextProps, nextState) {
    return nextProps.n % 3; //子组件判断接收的属性 是否满足更新条件 为true则更新
  }
}

// defaultProps
// constructor
// componentWillMount
// render
// componentDidMount
// 状态更新会触发的
// shouldComponentUpdate nextProps,nextState=>boolean
// componentWillUpdate
// componentDidUpdate
// 属性更新
// componentWillReceiveProps newProps
// 卸载
// componentWillUnmount
```

### iOS 知识

**（针对前端同学，ios 同学可跳过）**

在使用 react-native 的时候，安装 ios 依赖时经常就会使用到 cocoapods，这里我们介绍一下 cocoaPods。

#### 什么是 CocoaPods

CocoaPods 是 OS X 和 iOS 下的一个第三类库管理工具，通过 CocoaPods 工具我们可以为项目添加被称为“Pods”的依赖库（这些类库必须是 CocoaPods 本身所支持的），并且可以轻松管理其版本。

1. 在引入第三方库时它可以自动为我们完成各种各样的配置，包括配置编译阶段、连接器选项、甚至是 ARC 环境下的-fno-objc-arc 配置等。

2. 使用 CocoaPods 可以很方便地查找新的第三方库，这些类库是比较“标准的”，而不是网上随便找到的，这样可以让我们找到真正好用的类库。

#### cocoapods 的安装

1. gem 简介

Gem 是一个管理 Ruby 库和程序的标准包，它通过 Ruby Gem（如 http://rubygems.org/ ）源来查找、安装、升级和卸载软件包，非常的便捷。

> 常用命令

- 查看 gem 版本 gem --version
- 更新 gem update --system
- 查看数据源 gem source
- 安装软件包 gem install 软件包名称
- 卸载安装包 gem uninstall

2. 使用 gem 安装 cocoapods

```bash
sudo gem install cocoapods
```

#### 使用 cocoapods 集成第三方

1.检索第三方框架

`pod search 框架关键字`

内部原理：从本地缓存的"第三方框架描述信息" 生成的检索文件中检索到 相关框架的信息

常见错误：unable to find....

删除 cocoapods 索引文件

2.安装第三方框架

创建 Podfile 文件, 到自己工程内(一级目录)

Podfile 文件作用：其实就是使用 ruby 语法编写的 "框架依赖描述文件"; 就是告诉 cocoapods 需要下载集成哪些框架

创建命令: `pod init`

3.安装框架

安装命令 `pod install`

原理：直接就是根据 Podfile 文件从本地索引库中找到框架信息, 然后下载集成
找不到目标框架

更新本地框架信息源信息: pod install --no-repo-update (快速)

生成的重要文件 Podfile.lock

作用: 记录着上一次下载的框架最新版本

- pod install 和 pod update 区别

`pod install`: 如果 Podfile.lock 文件存在, 直接从此文件中读取框架信息下载安装, 如果不存在, 依然会读取 Podfile 文件内的框架信息,下载好之后, 再根据下载好的框架信息, 生成 Podfile.lock 文件

`pod update` 不管 Podfile.lock 是否存在, 都会读取 Pod file 文件的的框架信息去下载。主要区别在于, Podfile 文件内的框架信息, 版本描述没有指定具体版本

### Android 知识

**（针对前端同学，android 同学可跳过）**

android 开发环境中，ADB 是我们进行 android 开发经常要用的调试工具，它的使用当然是我们 Android 开发者必须要掌握的；

Android Debug Bridge，Android 调试桥接器，简称 ADB，是用于管理模拟器或真机状态的万能工具，通俗一点讲 adb 就是 pc 和移动设备通信的桥梁，它采用了 c/s 模型，包括三个部分：

1、客户端部分，运行在开发用的电脑上，可以在命令行中运行 adb 命令来调用该客户端，像 ADB 插件和 DDMS 这样的 Android 工具也可以调用 adb 客户端，需要说明的是客户端与手机或者模拟器是一对多的关系，也就是说不管连接多少设备客户端就只有唯一的一个实例存在。

2、服务端部分，是运行在开发用电脑上的后台进程，用于管理客户端与运行在模拟器或真机的守护进程通信。

3、守护进程部分，运行于模拟器或手机的后台（简称 adb daemon）。

#### 常用的 ADB 命令

1：`adb devices/adb get-serialno` 作用：列举当前连接的设备（可以是多个设备）；

执行结果如下所示：

```bash
Listof devices attached

emulator-5554device

emulator-5556device

emulator-5558device
```

> adb get-serialno 只能当连接一个设备时使用，并拿到设备的序列号；

2：`adb -s / －e / -d` 作用：指定对某个连接成功的设备执行命令；

```bash
adb -s emulator-5556  install helloWorld.apk
```

这条命令就是往 emulator-5556 模拟器安装 apk 文件；

-s: 指定要操作的设备;

-e: 默认操作模拟器；

-d:默认操作硬件设备；

3：`adb install -r/-s` 作用：使用 adb install 命令可以从开发用电脑中复制应用程序并且安装到模拟器或手机上，adb install 命令必须指定待安装的.apk 文件的路径；

-r:保留数据和缓存文件，重新安装 apk

-s:安装 apk 到 sd 卡

4：`adb uninstall [-k] {package}` 作用：卸载指定包名的 apk 文件，(-k:不删除程序运行所产生的数据和缓存目录)

5：`adb pull [-a] {remote-path} {local-path}` 作用：从模拟器或手机拷贝文件或文件夹(包括文件夹的子目录)到电脑(-a:保留文件时间戳及属性)，remote-path 为手机端文件路径，local-path 为文件复制到的路径；

6：`adb push {loacal-path} {remote-path}` 作用：将文件或文件夹(包括文件夹的子目录)拷贝到模拟器或手机;

比如，我想把桌面的 log.txt 复制到手机的 dev 目录下，则命令如下：

```bash
adb push /Users/littlejie/Desktop/log.txt  /dev
```

7:  `adb kill-server` 和 `adb start-server` 作用：在某些情况下需要重启 adb 服务来解决问题，比如 adb 无响应，这时你可以通过 adb kill-server 来实现这一操作，之后，通过 adb start-server 命令来重启 adb 服务；

8:  `adb help` 作用：调出 adb 命令提示；

9:  `adb reboot` 作用：重启连接成功的设备。

如果连接了多个设备可以指定重启其中一个设备，命令如下

```bash
adb -s xxx reboot
```

10:  `adb shell cat /sys/class/net/wlan0/address` 作用：获取机器 mac 地址；

说明：adb shell 命令表示进入设备或模拟器的 shell 环境中，在这个 Linux Shell 中，你可以执行各种 Linux 的命令;

adb shell netcfg  //查看当前连接成功手机的 ip 地址；

11:  `adb shell am start -n {packagename}` 作用：启动指定包名的应用

12:  `adb shell ps` 作用 ：列出当前运行的进程；

13:  `adb shell mkdir path/foldelname` 作用：新建文件夹；

`adb shell chmod777 {folder}`设置文件的权限;

`adb shell cat {folder/file}` 查看文件内容；

### RN 基础知识

#### 样式

> 在 React Native 中，你并不需要学习什么特殊的语法来定义样式。我们仍然是使用 JavaScript 来写样式。所有的核心组件都接受名为 style 的属性。这些样式名基本上是遵循了 web 上的 CSS 的命名，只是按照 JS 的语法要求使用了驼峰命名法，例如将 background-color 改为 backgroundColor。

- 使用 StyleSheet.create 来集中定义组件的样式，如：

> 可以直接写在 style 上，也可以创建对象，相当于前端的 css 类

> RN 布局主要使用 flexbox 布局，几乎所有样式都可以使用

```js
import React, { Component } from "react";
import { AppRegistry, StyleSheet, Text, View } from "react-native";

export default class LotsOfStyles extends Component {
  render() {
    return (
      <View>
        <Text style={{ color: "red" }}>just red</Text>
        <Text style={styles.bigblue}>just bigblue</Text>
        <Text style={[styles.bigblue, styles.red]}>bigblue, then red</Text>
        <Text style={[styles.red, styles.bigblue]}>red, then bigblue</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  bigblue: {
    color: "blue",
    fontWeight: "bold",
    fontSize: 30,
  },
  red: {
    color: "red",
  },
});

AppRegistry.registerComponent("LotsOfStyles", () => LotsOfStyles);
```

- `<Text>` 元素布局不同于其他组件

在 Text 内部的元素不再使用 flexbox 布局，而是采用文本布局。这意味着`<Text>`内部的元素不再是一个个矩形，而可能会在行末进行折叠。

- 样式继承限制

在 CSS 中，我们可以在 html 上设置可继承样式（font-size），浏览器在渲染每个节点，会在渲染树上，一路向上查询，直到根节点。但在 RN 中，第一，你必须把你的文本节点放在`<Text>`组件内，不能直接在`<View>`下放置文本。第二，不能设置全局的可继承样式，可使用组件和全局样式来实现。第三，只有在文本标签的子节点，才可以继承样式。

```js
<Text style={{ fontWeight: "bold" }}>
  I am bold
  <Text style={{ color: "red" }}>and red</Text>
</Text>
```

- 不同设备样式尺寸样式兼容，使用封装的方法对设计稿的尺寸进行转换

```js
const UIBaseWidth = 750; // 设计稿基础尺寸
const px2dp = (UIPx) =>
  Math.floor(((UIPx * screenWidth) / UIBaseWidth) * 10) / 10; // 根据设计稿转换，向下取整保留一位小数

// 具体使用

<View
  style={{
    height: px2dp(222),
    marginHorizontal: px2dp(32),
    paddingVertical: px2dp(12),
    backgroundColor: baseColor.veinsColorF5F5F5,
    borderRadius: px2dp(8),
    marginBottom: px2dp(80),
  }}
></View>;
```

- zIndex 调整层级无效(绝对定位的同级元素)

实际在使用 zIndex 属性的时候发现根本没有效果，跟 web 的 z-index 所呈现的效果完全不一样

**解决方法：**

改变元素的顺序，而不使用 zIndex。默认情况下，使用了`position: 'absolute'`后，在后面的元素会覆盖在前面的元素之上

- 常用的样式

详见之前写过的内容：[样式手册](http://lion1ou.win/2018/05/29/)

#### 高度与宽度

##### 弹性宽高

- 使用`flex: 1`来指定某个组件扩张以撑满所有剩余空间
- 多个并列子组件使用`flex: 1`，则这几个组件平分父组件剩余空间，如果数值不同比例也相应不同
- 前提是父组件的尺寸不为零（设置固定的 width，height，或 flex）

```html
<View style="{{flex:" 1}}>
  <View style="{{flex:" 2}}></View>
  <View style="{{flex:" 1}}></View>
</View>
```

##### Dimensions

本模块用于获取设备屏幕的宽高。

- 初始的尺寸信息应该在 runApplication 之后被执行，这样才可以在任何其他的 require 被执行之前使用。不过在稍后可能还会更新。

注意：尽管尺寸信息立即就可用，但它可能会在将来被修改（譬如设备的方向改变），所以基于这些常量的渲染逻辑和样式应当每次 render 之后都调用此函数，而不是将对应的值保存下来。（举例来说，你可能需要使用内联的样式而不是在 StyleSheet 中保存相应的尺寸）。

示例： `var {height, width} = Dimensions.get('window');`

#### 触摸事件

[官方文档](https://reactnative.cn/docs/0.51/handling-touches.html#content)

> 在 React Native 上处理点击等常见的触摸手势，不像在 web 上直接在标签上绑定相应的手势事件就好了。需要在对应的标签外包裹一个手势组件，再使用相应的事件进行触发。

点击、长按事件，可以使用"Touchable"开头的一系列组件。这些组件通过`onPress`属性接受一个点击事件的处理函数，使用`onLongPress`属性来实现长按事件。默认以冒泡形式调用，可以通过处理代码，达到捕获形式调用。

```js
class MyButton extends Component {
  _onPressButton() {
    console.log("You tapped the button!");
  }
  render() {
    return (
      <TouchableHighlight onPress={this._onPressButton}>
        <View>
          <Text>Button</Text>
        </View>
      </TouchableHighlight>
    );
  }
}
```

- TouchableHighlight: 背景会在用户手指按下时变暗
- TouchableNativeFeedback: 在用户手指按下时形成类似墨水涟漪的视觉效果(在 Android)
- TouchableOpacity: 在用户手指按下时降低按钮的透明度，而不会改变背景的颜色
- TouchableWithoutFeedback: 在处理点击事件的同时不显示任何视觉反馈

如果你想实现视图的拖拽，或是实现自定义的手势，那么请参阅 [PanResponder API](https://reactnative.cn/docs/0.51/panresponder.html) 或是手势识别系统的文档。

#### 网络

[官方文档](https://reactnative.cn/docs/0.51/network.html#content)

- Fetch

> React Native 提供了和 web 标准一致的 Fetch API，用于满足开发者访问网络的需求。如果你之前使用过 XMLHttpRequest(即俗称的 ajax)或是其他的网络 API，那么 Fetch 用起来将会相当容易上手。

```js
fetch("https://mywebsite.com/endpoint/", {
  method: "POST",
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    firstParam: "yourValue",
    secondParam: "yourOtherValue",
  }),
});
```

> 注：默认情况下，iOS 会阻止所有非 HTTPS 的请求。如果你请求的接口是 http 协议，那么首先需要添加一个 App Transport Securty 的例外，或者干脆完全禁用 ATS，

- 使用其他的网络库（Axios）

> React Native 中已经内置了 XMLHttpRequest API(也就是俗称的 ajax)。一些基于 XMLHttpRequest 封装的第三方库也可以使用，例如 frisbee 或是 axios 等，但注意不能使用 jQuery。
> 需要注意的是，安全机制与网页环境有所不同：在应用中你可以访问任何网站，没有跨域的限制。

- WebSocket 支持

> React Native 还支持 WebSocket，这种协议可以在单个 TCP 连接上提供全双工的通信信道。

#### 基础 API

##### AppRegistry

AppRegistry 负责注册运行 React Native 应用程序的入口。通过 AppRegistry.registerComponent 来注册，当注册完成后，Native 系统就会加载 jsbundle 文件并且触发 AppRegistry.runApplication 运行应用。有以下方法：

1. registerConfig(config: Array):静态方法，注册配置。
2. registerComponent(appKey: string, getComponentFunc: ComponentProvider):注册入口组件。
3. registerRunnable(appKey: string, func: Function):注册函数监听。
4. getAppKeys():获取 registerRunnable 注册的监听键。
5. runApplication(appKey: string, appParameters: any):运行 App。

##### AsyncStorage

AsyncStorage 是一个简单的、具有异步特性的键值对的存储系统。相对整个 App 而言，它是全局的，应该用于替代 LocalStorage。

AsyncStorage 提供了比较安全的方法供我们使用。每个方法都有一个回调函数，而回调函数的第一个参数都是错误对象。如果发生错误该对象就会展示错误信息，否则为 null。所有的方法执行后，都会返回一个 Promise 对象。

##### Linking

Linking 提供了一个通用的接口来与传入和传出的 App 链接进行交互。可以简单的理解为，跟其他 APP 的通讯。

- 被外部链接打开(仅用在原生代码的项目, 本节仅适用于使用 react-native init 或使用 Create React Native App 创建的项目，这些项目已经弹出。 有关"弹出"的详细信息，请参阅 Create React Native App 代码库中的指南。)

如果你的应用被其注册过的外部 url 调起，则可以在任何组件内这样获取和处理它：

```js
componentDidMount() {
  Linking.getInitialURL().then((url) => {
    if (url) {
      console.log('Initial url is: ' + url);
    }
  }).catch(err => console.error('An error occurred', err));
}
```

- 打开外部链接

要启动一个链接相对应的应用（打开浏览器、邮箱或者其它的应用），只需调用：

```js
Linking.openURL(url).catch((err) => console.error("An error occurred", err));
```

如果想在打开链接前先检查是否安装了对应的应用，则调用以下方法：

```js
Linking.canOpenURL(url)
  .then((supported) => {
    if (!supported) {
      console.log("Can't handle url: " + url);
    } else {
      return Linking.openURL(url);
    }
  })
  .catch((err) => console.error("An error occurred", err));
```

##### PixelRatio

PixelRatio 类提供了访问设备的像素密度的方法。

##### AppState

[官方文档](https://reactnative.cn/docs/0.51/appstate.html#content)

APP 状态有三种：

- active - 应用正在前台运行。
- background - 应用正在后台运行。用户既可能在别的应用中，也可能在桌面。
- inactive - 此状态表示应用正在前后台的切换过程中，或是处在系统的多任务视图，又或是处在来电状态中。

要获取当前的状态，你可以使用 AppState.currentState，这个变量会一直保持更新。不过在启动的过程中，currentState 可能为 null，直到 AppState 从原生代码得到通知为止。

##### Platform

React Native 也没有完全做到说真正的跨平台使用，所以我们有时候会针对不同的平台做一些事情，使用 Platform.OS 可以获取到当前的设备平台：

```js
import { Text, Platform } from "react-native";

<Text>
  当前平台是：{Platform.OS}, Version: {Platform.Version}
</Text>;
```

Platform.OS 在 iOS 上会返回 ios，而在 Android 设备或模拟器上则会返回 android。

还有个实用的方法是 Platform.select()，它可以以 Platform.OS 为 key，从传入的对象中返回对应平台的值，见下面的示例：

```js
import { Platform, StyleSheet } from "react-native";

var styles = StyleSheet.create({
  container: {
    flex: 1,
    ...Platform.select({
      ios: {
        backgroundColor: "red",
      },
      android: {
        backgroundColor: "blue",
      },
    }),
  },
});
```

#### 常用组件

##### View，ScrollView，FlatList

ScrollView 和 FlatList 应该如何选择？ScrollView 会简单粗暴地把所有子元素一次性全部渲染出来。其原理浅显易懂，使用上自然也最简单。然而这样简单的渲染逻辑自然带来了性能上的不足。想象一下你有一个特别长的列表需要显示，可能有好几屏的高度。创建和渲染那些屏幕以外的 JS 组件和原生视图，显然对于渲染性能和内存占用都是一种极大的拖累和浪费。

这就是为什么我们还有专门的 FlatList 组件。FlatList 会惰性渲染子元素，只在它们将要出现在屏幕中时开始渲染。这种惰性渲染逻辑要复杂很多，因而 API 在使用上也更为繁琐。除非你要渲染的数据特别少，否则你都应该尽量使用 FlatList，哪怕它们用起来更麻烦。

##### TextInput

TextInput 是一个允许用户在应用中通过键盘输入文本的基本组件。本组件的属性提供了多种特性的配置，譬如自动完成、自动大小写、占位文字，以及多种不同的键盘类型（如纯数字键盘）等等。

##### Text

一个用于显示文本的 React 组件，并且它也支持嵌套、样式，以及触摸处理。

在下面的例子里，嵌套的标题和正文文字会继承来自 styles.baseText 的 fontFamily 字体样式，不过标题上还附加了它自己额外的样式。标题和文本会在顶部依次堆叠，并且被代码中内嵌的换行符分隔开。

```js
// ...
render() {
  return (
    <Text style={styles.baseText}>
      <Text style={styles.titleText} onPress={this.onPressTitle}>
        {this.state.titleText}
      </Text>
      <Text numberOfLines={5}>
        {this.state.bodyText}
      </Text>
    </Text>
  );
}

const styles = StyleSheet.create({
  baseText: {
    fontFamily: 'Cochin',
  },
  titleText: {
    fontSize: 20,
    fontWeight: 'bold',
  },
});
```

##### Image, ImageBackground

用于显示多种不同类型图片的 React 组件，包括网络图片、静态资源、临时的本地图片、以及本地磁盘上的图片（如相册）等。

##### KeyboardAvoidingView

[官方文档](https://reactnative.cn/docs/keyboardavoidingview.html)

本组件用于解决一个常见的尴尬问题：手机上弹出的键盘常常会挡住当前的视图。本组件可以自动根据键盘的位置，调整自身的 position 或底部的 padding，以避免被遮挡。

用法：

```
import { KeyboardAvoidingView } from 'react-native';

<KeyboardAvoidingView style={styles.container} behavior="padding" enabled>
  ... 在这里放置需要根据键盘调整位置的组件 ...
</KeyboardAvoidingView>

```

![](https://cdn.leoao.com/Mar-24-2019%2019-05-25.gif)

##### Modal

[官方文档](https://reactnative.cn/docs/modal.html)

Modal 组件是一种简单的覆盖在其他视图之上显示内容的方式。

##### RefreshControl

此组件用在 ScrollView 及其衍生组件的内部，用于添加下拉刷新的功能。

### 两端兼容

#### TextInput

> - iOS 下的 textAlign 取值 auto left right center justify
> - android 下的 textAlign 取值为 start center end
> - 安卓平台有黑色边框和选中黄框，可通过设置 underlineColorAndroid='rgba(0,0,0,0)'去掉
> - 安卓平台无清除按钮，可以使用 react-native-textinput 来兼容双平台

#### Image

> - iOS 下 resizeMode 可以写在行间属性，也可以写在 style，后者覆盖前者
> - android 下 resizeMode 只可以写在行间，写在 style 无效

```js
//android
<Image resizeMode={'stretch'}></Image>
//ios, style中的cover会覆盖掉stretch
<Image resizeMode={'stretch'} style={{'resizeMode': 'cover'}}></Image>
```

#### Text

> - allowFontScaling，控制字体是否要根据系统的“字体大小”辅助选项来进行缩放。默认值为 true。
> - textAlign: enum('auto', 'left', 'right', 'center', 'justify')，指定文本的对齐方式。其中'justify'值仅 iOS 支持，在 Android 上会变为 left。

#### style position: 'absolute'

> - iOS 下正常
> - android 下，position: 'absolute' 超过父节点高宽部分，会隐藏掉。

> 解决办法：当需要用 position: 'absolute'的时候，恰巧要求：子节点定位超出父节点高或宽，放弃使用，改用别的布局，或者将子节点放到于父节点同级，再定位。

#### picker 完全不一致

> - iOS 组件是一个滚动的滚轮样式，
> - android 组件是一个下拉选框的样式

#### 有关屏幕的高度 Dimensions.get('window').height

> - 两个平台都是整个屏幕的高度(包含 statusBar, 安卓端不包含虚拟按键)
> - iOS 平台的布局是从 statusBar 的顶端开始
> - android 平台的布局是从 statusBar 的底端开始(设置 translucent: true 后也从 statusBar 顶端开始)

如果设置 view 的高度是 Dimensions.get('window').height，然后设置 position: 'absolute', top: 0，会发现 android 平台 view 的底端被遮住了一小部分，这一小部分正好就是 android 平台 statusBar 的高度
安卓端 statusBar 通常是 25dp，虚拟按键通常是 48dp

解决方法有四：

- 设置 view 的高度是整屏的高度减去 statusBar 的高度
- 设置 top 值为负的 statusBar 的高度
- 设置 bottom: -Dimensions.get('window').height 替代 top: 0
- 在每一个 Navigator 的入口设置< StatusBar translucent={true}/ >

大坑: 有些手机通过上述方法获取到的屏幕高度竟然包含了虚拟按键的高度，如魅族 pro4，只能引入 react-native-device-info 这个库来 hack 一下了

#### zIndex 层级问题

shadow（阴影）开头样式可以在 iOS 上应用，但在安卓中是不生效的，而 Android 上对应的属性是 elevation。设置 elevation 属性就等价于使用原生的 elevation API，因而也有同样的限制（比如最明显的就是需要 Android 5.0 以上版本）。此外还会影响到层叠视图在空间 z 轴上的顺序，结论：

- 对于 Android，两个同一层级的定位组件（position：“absolute”）

  1、 既没有 ZIndex 属性，又没有 elevation 属性时，在 z 轴的层叠关系由其摆放位置决定的，放在下面的组件会在上层；
  2、 两个组件只有 zIndex 没有 elevation 属性时，zIndex 大的在上层
  3、 两个组件有 elevation 属性时，elevation 大的在上层
  4、 两个组件既有 zIndex 属性 elevation 属性时，以 elevation 为准

- 对于 IOS，同层级的组件，z 轴的层叠关系只与摆放顺序与 zIndex 有关，与 elevation 无关

### 外部组件库

#### IconFont

[具体使用详情](http://lion1ou.win/2018/11/17/)

### 项目介绍

1. 分为两个一级页面组件，每个组件独立维护一套自己的路由地址
2. 通过默认页面的路由重置，实现 RN 页面和 Native 页面的跳转

![](https://cdn.leoao.com/blog/coach-page-test.png?imageslim)

## 学习资源

### ES6 语法

- 阮一峰 ECMAScript 6 入门 [http://es6.ruanyifeng.com/](http://es6.ruanyifeng.com/)

### React.js

- react.js 入门教程(gitbook) [https://hulufei.gitbooks.io/react-tutorial/content/introduction.html](https://hulufei.gitbooks.io/react-tutorial/content/introduction.html)

- **react.js 快速入门教程 - 阮一峰** [http://www.ruanyifeng.com/blog/2015/03/react.html](http://www.ruanyifeng.com/blog/2015/03/react.html)

- react.js 视频教程  [http://react-china.org/t/reactjs/584](http://react-china.org/t/reactjs/584)

- React Native 之 React 速学教程[https://github.com/crazycodeboy/RNStudyNotes/tree/master/React%20Native%E4%B9%8BReact%E9%80%9F%E5%AD%A6%E6%95%99%E7%A8%8B](https://github.com/crazycodeboy/RNStudyNotes/tree/master/React%20Native%E4%B9%8BReact%E9%80%9F%E5%AD%A6%E6%95%99%E7%A8%8B)

### React-Native

- react-native 官方 api 文档  [http://facebook.github.io/react-native/docs/getting-started.html](http://facebook.github.io/react-native/docs/getting-started.html)

- react-native 中文文档(react native 中文网，人工翻译，官网完全同步) [http://react-native.cn/docs/getting-started.html](http://react-native.cn/docs/getting-started.html)

- react-native 中文文档(极客学院) [http://wiki.jikexueyuan.com/project/react-native/](http://wiki.jikexueyuan.com/project/react-native/)

- React Native 布局篇  [https://segmentfault.com/a/1190000002658374](https://segmentfault.com/a/1190000002658374)

- React Native 基础练习指北（一） [https://segmentfault.com/a/1190000002645929](https://segmentfault.com/a/1190000002645929)

- React Native 基础练习指北（二） [https://segmentfault.com/a/1190000002647733](https://segmentfault.com/a/1190000002647733)

### 进阶内容

- **React-native 组件库**（比较全的组件库，可以直接搜索） [https://js.coach/](https://js.coach/)

- **最佳轮播类组件** [https://github.com/leecade/react-native-swiper](https://github.com/leecade/react-native-swiper)

- 选择器  [https://github.com/beefe/react-native-picker](https://github.com/beefe/react-native-picker)

- 导航器 [https://github.com/react-navigation/react-navigation](https://github.com/react-navigation/react-navigation)

### 资源网站

- React-native 官网  [http://facebook.github.io/react-native/](http://facebook.github.io/react-native/)

- **React-China 社区** [http://react-china.org/](http://react-china.org/)

- **React Native 中文社区** [http://bbs.react-native.cn/](http://bbs.react-native.cn/)

- **React-native 组件库**（比较全的组件库） [http://react.parts/](http://react.parts/)

- **React Native Modules** [http://reactnativemodules.com/](http://reactnativemodules.com/)

- **Use React Native 资讯站**(使用技巧及新闻) [http://www.reactnative.com/](http://www.reactnative.com/)

- React Native Tools [http://www.rntools.co/](http://www.rntools.co/)

- 11 款 React Native 开源移动 UI 组件  [http://www.oschina.net/news/61214/11-react-native-ui-components](http://www.oschina.net/news/61214/11-react-native-ui-components)
