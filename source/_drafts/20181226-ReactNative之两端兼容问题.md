---
title: ReactNative之两端兼容问题
toc: true
comments: true
date: 2018-12-26 16:56:44
categories: 前端技术
tags: ReactNative
photos:
---

<!--more-->


#### TextInput

>* iOS下的textAlign取值 auto left right center justify
>* android下的textAlign取值为 start center end
>* 安卓平台有黑色边框和选中黄框，可通过设置underlineColorAndroid='rgba(0,0,0,0)'去掉
>* 安卓平台无清除按钮，可以使用 react-native-textinput 来兼容双平台

#### Image

>* iOS下resizeMode可以写在行间属性，也可以写在style，后者覆盖前者
>* android下resizeMode只可以写在行间，写在style无效
    
```js
//android 
<Image resizeMode={'stretch'}></Image>
//ios, style中的cover会覆盖掉stretch
<Image resizeMode={'stretch'} style={{'resizeMode': 'cover'}}></Image>
```

#### Text 

>* allowFontScaling，控制字体是否要根据系统的“字体大小”辅助选项来进行缩放。默认值为true。
>* textAlign: enum('auto', 'left', 'right', 'center', 'justify')，指定文本的对齐方式。其中'justify'值仅iOS支持，在Android上会变为left。

#### style position: 'absolute'

>* iOS下正常
>* android下，position: 'absolute' 超过父节点高宽部分，会隐藏掉。

>解决办法：当需要用position: 'absolute'的时候，恰巧要求：子节点定位超出父节点高或宽，放弃使用，改用别的布局，或者将子节点放到于父节点同级，再定位。


#### picker 完全不一致

>* iOS组件是一个滚动的滚轮样式，
>* android组件是一个下拉选框的样式


#### 有关屏幕的高度Dimensions.get('window').height

>* 两个平台都是整个屏幕的高度(包含statusBar, 安卓端不包含虚拟按键)
>* iOS平台的布局是从statusBar的顶端开始
>* android平台的布局是从statusBar的底端开始(设置translucent: true后也从statusBar顶端开始)

如果设置view的高度是Dimensions.get('window').height，然后设置position: 'absolute', top: 0，会发现android平台view的底端被遮住了一小部分，这一小部分正好就是android平台statusBar的高度
安卓端statusBar通常是25dp，虚拟按键通常是48dp

解决方法有四：

* 设置view的高度是整屏的高度减去statusBar的高度
* 设置top值为负的statusBar的高度
* 设置bottom: -Dimensions.get('window').height 替代top: 0
* 在每一个Navigator的入口设置<StatusBar translucent={true}/>

大坑: 有些手机通过上述方法获取到的屏幕高度竟然包含了虚拟按键的高度，如魅族pro4，只能引入react-native-device-info这个库来hack一下了



**转载请标注原文地址**

