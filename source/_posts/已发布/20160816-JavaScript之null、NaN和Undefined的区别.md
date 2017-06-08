---
title: JavaScript之null、NaN和Undefined的区别
toc: true
comments: true
categories: 技术博客
date: 2016-08-16 11:11:55
tags: JavaScript
---

在JavaScript编程中，我们经常会出现undefined、null和NaN。但是要怎么区分呢？该怎么去判断呢？
<!--more-->
## 一、区别

主要是通过 `typeof` 这个方法去判断，`typeof` 返回的是字符串，有六种可能的结果：`"number"`、`"string"`、`"boolean"`、`"object"`、`"function"`、`"undefined"`。

```js
var a1;
var a2 = true;
var a3 = 1;
var a4 = "Hello";
var a5 = new Object();
var a6 = function(){};
var a7 = null;
var a8 = NaN;
var a9 = undefined;

console.log(typeof a);  //显示"undefined"
console.log(typeof a1); //显示"undefined"
console.log(typeof a2); //显示"boolean"
console.log(typeof a3); //显示"number"
console.log(typeof a4); //显示"string"
console.log(typeof a5); //显示"object"
console.log(typeof a6); //显示"function"
console.log(typeof a7); //显示"object"
console.log(typeof a8); //显示"number"
console.log(typeof a9); //显示"undefined"
```

`undefined`是指未定义的值和定义未赋值的值，`null`是一种特殊的object，`NaN`是一种特殊的number。

目前，null和undefined基本是同义的，只有一些细微的差别。
null表示"没有对象"，即该处不应该有值。典型用法是：
（1） 作为函数的参数，表示该函数的参数不是对象。
（2） 作为对象原型链的终点。
```js
Object.getPrototypeOf(Object.prototype)
// null
```
undefined表示"缺少值"，就是此处应该有一个值，但是还没有定义。典型用法是：
（1）变量被声明了，但没有赋值时，就等于undefined。
（2) 调用函数时，应该提供的参数没有提供，该参数等于undefined。
（3）对象没有赋值的属性，该属性的值为undefined。
（4）函数没有返回值时，默认返回undefined。
```js
var i;
i // undefined

function f(x){console.log(x)}
f() // undefined

var  o = new Object();
o.p // undefined

var x = f();
x // undefined
```

## 二、判断

javascript中如何判断一个变量是否是null，undefined还是NaN呢？

1.判断undefined:

```js
var tmp = undefined;
if (typeof(tmp) == "undefined") {
    console.log("undefined");
}
```

2.判断null:
```js
var tmp = null;
if (!tmp && typeof(tmp) != "undefined" && tmp != 0) {
    console.log("null");
}
```

3.判断NaN:
```js
var tmp = 0 / 0;
if (isNaN(tmp)) {
    console.log("NaN");
}
```
说明：如果把 NaN 与任何值（包括其自身）相比得到的结果均是 false，所以要判断某个值是否是 NaN，不能使用==或 === 运算符。

提示：isNaN() 函数通常用于检测 parseFloat() 和 parseInt() 的结果，以判断它们表示的是否是合法的数字。当然也可以用 isNaN() 函数来检测算数错误，比如用 0 作除数的情况。

4.判断undefined和null:
```js
var tmp = undefined;
//var tmp = null;
if (tmp == undefined) {
    console.log("null or undefined");
}

var tmp = undefined;
//var tmp = null;
if (tmp == null) {
    console.log("null or undefined");
}
```

5.判断undefined、null与NaN:
```js
var tmp = null;
//var tmp = undefined;
//var tmp = NaN;
if (!tmp) {
    console.log("null or undefined or NaN");
}
```

**转载请标注原文地址**                           
(end)
