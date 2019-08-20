---
title: ReactNative之常用组件
toc: true
comments: true
date: 2018-06-02 17:16:01
categories: 前端技术
tags: ReactNative
photos:
---

<!--more-->

### [`<Image />`](https://reactnative.cn/docs/0.31/images.html#content)

[`<Image />` API](https://reactnative.cn/docs/0.31/image.html#content)

从0.14版本开始，React Native提供了一个统一的方式来管理iOS和Android应用中的图片。图片会自动匹配ios和android图片，根据手机分辨率也会自动匹配需要的图片，只要图片上加@2x/@3x。

* 静态图片

```
<Image source={require('./my-icon.png')} />
```

* 网络图片
```
<Image source={{uri: 'https://facebook.github.io/react/img/logo_og.png'}} style={{width: 400, height: 400}} />
```

* 图片的资源属性是个对象（object）
> 第一通过require('./img.png')会返回一个对象，包含图片的详细信息，第二为了考虑未来的拓展，比如支持雪碧图（sprites）,支持裁剪等操作

* 通过嵌套来实现背景图片
```
<Image source={...}>
    <Text>Inside</Text>
</Image>
```

* 在主线程外解码图片


### [TextInput](https://reactnative.cn/docs/0.31/textinput.html#content)

> 用户文本输入组件，常用属性 **onChangeText** (文本改变时), **onSubmitEditing** (文本被提交后，按下键盘上的提交)

### [ScrollView](https://reactnative.cn/docs/0.31/scrollview.html#content)

> ScrollView是一个通用的可滚动的容器，你可以在其中放入多个组件和视图，而且这些组件并不需要是同类型的。ScrollView不仅可以垂直滚动，还能水平滚动（通过horizontal属性来设置）。

> ScrollView适合用来显示数量不多的滚动元素。放置在ScollView中的所有组件都会被渲染，哪怕有些组件因为内容太长被挤出了屏幕外。如果你需要显示较长的滚动列表，那么应该使用功能差不多但性能更好的ListView组件。

### [ListView](https://reactnative.cn/docs/0.31/listview.html#contentRea)

> ListView组件用于显示一个垂直的滚动列表，其中的元素之间结构近似而仅数据不同。ListView更适于长列表数据，且元素个数可以增删。和ScrollView不同的是，ListView并不立即渲染所有元素，而是优先渲染屏幕上可见的元素。

### [react-navigation](https://www.reactnavigation.org.cn/docs/guide-intro)

navigation 跟我们前端的路由跳转不一样，都是在同个页面内去修改路径，让页面发生变化。而navigation更倾向于客户端的方式实现，把所有页面当做一个堆栈，把每个新页面放在堆栈的顶部，返回时把该页面从堆栈顶部移除，来实现页面的切换。

* StackNavigator - 一次只渲染一个页面，并提供页面之间跳转的方法。当打开一个新的页面时，它被放置在堆栈的顶部
* TabNavigator - 渲染一个选项卡，让用户可以在几个页面之间切换
* DrawerNavigator - 提供一个从屏幕左侧滑入的抽屉


**转载请标注原文地址**

