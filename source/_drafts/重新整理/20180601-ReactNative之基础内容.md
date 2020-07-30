---
title: ReactNative之基础内容
toc: true
comments: true
date: 2018-06-01 16:33:39
categories: 前端技术
tags: ReactNative
photos:
---

环境搭建完了，我开始了解一下ReactNative的基础内容吧。包括样式、高度宽度、

<!--more-->

### 样式

>在React Native中，你并不需要学习什么特殊的语法来定义样式。我们仍然是使用JavaScript来写样式。所有的核心组件都接受名为style的属性。这些样式名基本上是遵循了web上的CSS的命名，只是按照JS的语法要求使用了驼峰命名法，例如将background-color改为backgroundColor。

* 使用 StyleSheet.create 来集中定义组件的样式，如：

```jsx
import React, { Component } from 'react';
import { AppRegistry, StyleSheet, Text, View } from 'react-native';

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
    color: 'blue',
    fontWeight: 'bold',
    fontSize: 30,
  },
  red: {
    color: 'red',
  },
});

AppRegistry.registerComponent('LotsOfStyles', () => LotsOfStyles);
```

* <Text> 元素布局不同于其他组件

在Text内部的元素不再使用flexbox布局，而是采用文本布局。这意味着<Text>内部的元素不再是一个个矩形，而可能会在行末进行折叠。

* 样式继承限制

在CSS中，我们可以在html上设置可继承样式（font-size），浏览器在渲染每个节点，会在渲染树上，一路向上查询，直到根节点。但在RN中，第一，你必须把你的文本节点放在<Text>组件内，不能直接在<View>下放置文本。第二，不能设置全局的可继承样式，可使用组件和全局样式来实现。第三，只有在文本标签的子节点，才可以继承样式。

```jsx
<Text style={{fontWeight: 'bold'}}>
  I am bold
  <Text style={{color: 'red'}}>
    and red
  </Text>
</Text>
```

* 常用的样式

[详见：样式手册](http://lion1ou.win/2018/05/29/)

### 高度与宽度

* 弹性宽高

    * 使用`flex: 1`来指定某个组件扩张以撑满所有剩余空间
    * 多个并列子组件使用`flex: 1`，则这几个组件平分父组件剩余空间，如果数值不同比例也相应不同
    * 前提是父组件的尺寸不为零（设置固定的width，height，或flex）

### [网络](https://reactnative.cn/docs/0.51/network.html#content)

* Fetch

>React Native提供了和web标准一致的Fetch API，用于满足开发者访问网络的需求。如果你之前使用过XMLHttpRequest(即俗称的ajax)或是其他的网络API，那么Fetch用起来将会相当容易上手。

```js
fetch('https://mywebsite.com/endpoint/', {
  method: 'POST',
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    firstParam: 'yourValue',
    secondParam: 'yourOtherValue',
  })
})
```

>注：默认情况下，iOS会阻止所有非HTTPS的请求。如果你请求的接口是http协议，那么首先需要添加一个App Transport Securty的例外，或者干脆完全禁用ATS，

* 使用其他的网络库（Axios）

>React Native中已经内置了XMLHttpRequest API(也就是俗称的ajax)。一些基于XMLHttpRequest封装的第三方库也可以使用，例如frisbee或是axios等，但注意不能使用jQuery。

>需要注意的是，安全机制与网页环境有所不同：在应用中你可以访问任何网站，没有跨域的限制。

* WebSocket支持

>React Native还支持WebSocket，这种协议可以在单个TCP连接上提供全双工的通信信道。

### [触摸事件](https://reactnative.cn/docs/0.51/handling-touches.html#content)

在React Native上处理点击等常见的触摸手势，不像在web 上直接在标签上绑定相应的手势事件就好了。需要在对应的标签外包裹手势组件，再使用相应的事件进行触发。

* 点击、长按事件，可以使用"Touchable"开头的一系列组件。这些组件通过onPress属性接受一个点击事件的处理函数，使用onLongPress属性来实现长按事件。

```jsx
class MyButton extends Component {
  _onPressButton() {
    console.log("You tapped the button!");
  }

  render() {
    return (
      <TouchableHighlight onPress={this._onPressButton}>
        <Text>Button</Text>
      </TouchableHighlight>
    );
  }
}
```

```js
// TouchableHighlight: 背景会在用户手指按下时变暗
// TouchableNativeFeedback: 在用户手指按下时形成类似墨水涟漪的视觉效果(在Android)
// TouchableOpacity: 在用户手指按下时降低按钮的透明度，而不会改变背景的颜色
// TouchableWithoutFeedback: 在处理点击事件的同时不显示任何视觉反馈
```

* 其他事件

如果你想实现视图的拖拽，或是实现自定义的手势，那么请参阅[PanResponder API](https://reactnative.cn/docs/0.51/panresponder.html)或是手势识别系统的文档。

### 平台区分

React Native提供了一个检测当前运行平台的模块。如果组件只有一小部分代码需要依据平台定制，那么这个模块就可以派上用场。
```js
import { Platform, StyleSheet } from 'react-native';

var styles = StyleSheet.create({
  height: (Platform.OS === 'ios') ? 200 : 100,
});
```
Platform.OS在iOS上会返回ios，而在Android设备或模拟器上则会返回android。

### [调试](https://reactnative.cn/docs/0.51/debugging.html#content)

* 访问App内的开发菜单
    * 你可以通过摇晃设备或是选择iOS模拟器的"Hardware"菜单中的"Shake Gesture"选项来打开开发菜单。
    * 在iOS模拟器中运行，还可以按下Command⌘ + D 快捷键，Android模拟器对应的则是Command⌘ + M（windows上可能是F1或者F2）。

* 刷新JavaScript
    * 在iOS模拟器中按下Command⌘ + R ，Android模拟器上对应的则是按两下R。
    * 选择开发菜单中的"Enable Live Reload"可以开启自动刷新。(增加了新的资源(比如给iOS的Images.xcassets或是Andorid的res/drawable文件夹添加了图片)
    更改了任何的原生代码)

* 应用内报错
    * 红屏或黄屏提示都只会在开发版本中显示，正式的离线包中是不会显示的。
    * 可以通过在代码中执行`console.disableYellowBox = true;`，手动关闭警告
    * 可以通过指定警告类型，来指定性关闭`console.ignoredYellowBox = ['Warning: ...'];`

* 访问控制台日志
    * 可以在终端上执行`react-native log-ios`，或者在iOS模拟器的菜单中选择Debug → Open System Log...来查看。
    * 可以在终端上执行`react-native log-android`，或者在Android模拟器或是真机上，都可以通过在终端命令行里运行`adb logcat *:S ReactNative:V ReactNativeJS:V`命令来查看。

* Chrome开发者工具
    * 在开发者菜单中选择"Debug JS Remotely"选项，即可以开始在Chrome中调试JavaScript代码。点击这个选项的同时会自动打开调试页面 http://localhost:8081/debugger-ui.






