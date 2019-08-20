---
title: '浅谈JS模块规范：AMD，CMD，CommonJs'
toc: true
comments: true
categories: JavaScript
tags: JavaScript
date: 2017-03-14 14:22:26
photos:
description:
---
随着JS模块化编程的发展，处理模块之间的依赖关系成为了维护的关键。AMD,CMD,CommonJS是目前最常用的三种模块化书写规范。
<!--more-->
### CommonJS

CommonJS规范是诞生比较早的。NodeJS就采用了CommonJS。是这样加载模块：
```js
var clock = require('clock');
clock.start();
```
这种写法适合服务端，因为在服务器读取模块都是在本地磁盘，加载速度很快。但是如果在客户端，加载模块的时候有可能出现“假死”状况。比如上面的例子中clock的调用必须等待clock.js请求成功，加载完毕。那么，能不能异步加载模块呢？

### AMD

AMD，即 (Asynchronous Module Definition)，这种规范是异步的加载模块，requireJs应用了这一规范。先定义所有依赖，然后在加载完成后的回调函数中执行：
```js
require([module], callback);
用AMD写上一个模块：

require(['clock'],function(clock){
  clock.start();
});
```
AMD虽然实现了异步加载，但是开始就把所有依赖写出来是不符合书写的逻辑顺序的，能不能像commonJS那样
用的时候再require，而且还支持异步加载后再执行呢？

### CMD

CMD (Common Module Definition), 是seajs推崇的规范，CMD则是依赖就近，用的时候再require。它写起来是这样的：
```js
define(function(require, exports, module) {
   var clock = require('clock');
   clock.start();
});
```
AMD和CMD最大的区别是`对依赖模块的执行时机处理不同`，而不是加载的时机或者方式不同，二者皆为`异步加载模块。`
AMD依赖前置，js可以方便知道依赖模块是谁，立即加载；而CMD就近依赖，需要使用把模块变为字符串解析一遍才知道依赖了那些模块，这也是很多人诟病CMD的一点，牺牲性能来带来开发的便利性，实际上解析模块用的时间短到可以忽略。


**转载请标注原文地址**


