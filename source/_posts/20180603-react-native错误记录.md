---
title: react-native错误记录
toc: true
comments: true
date: 2018-06-03 10:03:21
categories:
tags:
photos:
---

<!--more-->

###  error:Connot add a child that doesn't have a YogaNode to a parent without a measure function

造成原因主要有两种：

1. 由于注释没有写正确，在标签内注释一般用 {/* */}，如果不在任何标签内，可以用 //
2. 在通过数组循环加载数据时，可能数组没有数据，但是在View标签内必须要有`其他标签`或是`null`，不能是空字符，否则也会报错

### rn 安卓上fetch请求失败 possible unhandled promise rejection

1. 在使用promise的时候需要正确写代码，不要省略catch ，否则报错时不会输出错误，就会有黄色警告，

### 网络请求失败

1. 在ios上，原因有可能是因为在ios9以后，是不允许访问http协议的接口， 只能访问https。可以通过设置解决，https://segmentfault.com/a/1190000002933776
2. 在androids上，好像是不可以访问本地服务，必须是线上服务  https://segmentfault.com/q/1010000014559666


**转载请标注原文地址**

