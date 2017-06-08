---
title: cordova项目备忘-Android
toc: true
date: 2016-07-18 08:42:23
tags: Cordova
categories: 技术博客
comments: true
---

## 优化方案

    1. 不要让界面等数据，要先加载界面,再加载数据。如CSS、html写前面JS写后面，ajax异步等等。

    2. 所有的动画用CSS的转换和硬件加速,性能会好很多。

    3. 优化图片，为每一个元素设置一个图片的src是很慢的。直接用CSS Sprite Sheets，在很多图片的APP里面效果明显。

    4. 减少回流.减少DOM的数量,减少DOM访问,避免用js调整布局,全部用CSS来完成.
<!-- more -->
## 长按文字区域弹出复制选择框

因为是web页面，长按住某一个文字区域会弹出复制选择框(android 4.0)可以通过屏蔽
```css
body {
  -webkit-user-select:none;   
}
```

## 通过html标签移除缓存的影响
```html
<meta HTTP-EQUIV="pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
<meta HTTP-EQUIV="expires" CONTENT="0">
```

## 通过`:active`伪类来实现按钮按下的样式切换


## 通过给按钮添加震动提高用户使用感受
```html
<div class="button .vibrate"></div>
```
```js
$(".vibrate").bind('tap', function () { //需要引入phonegap的js
    if(navigator.notification)                       
    setTimeout(function(){ navigator.notification.vibrate(20); },0);
});
```
## 捕捉android返回按键【需要cordova支持】
```js
document.addEventListener("deviceready", onDeviceReady, false);

function onDeviceReady() {
  // 注册回退按钮事件监听器
  document.addEventListener("backbutton", onBackKeyDown, false);
  //其他页面初始化完成后的事件
}

function onBackKeyDown() {
   //这里写上你要处理的事情
}
```

## a标签的href属性机制

触发a的click事件=》读取href属性的值=》如果是URI则跳转=》如果是javascript代码则执行该代码

    >在不需要传递this作为方法的参数时候，推荐使用
```html
<a href="javascript:doSomething()" ></a>
```
    >如果需要使用this参数，推荐
```html
<a href="javascript:void(0);" onclick="doSomething(this)" > </a>
```

**转载请标注原文地址**                           
(end)