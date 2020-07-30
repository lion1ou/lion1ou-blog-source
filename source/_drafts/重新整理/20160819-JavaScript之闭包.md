---
title: JavaScript之闭包
toc: true
comments: true
categories: 前端技术
tags: JavaScript
date: 2016-08-19 20:56:08
---

在前端学习中，一直提到 JavaScript 闭包，那闭包到底是什么呢？

<!--more-->

## 概念

接下来我们就聊聊闭包，先来看看下面的代码：

```js
function f1() {
  var n = "hello"; //声明局部变量
  function f2() {
    console.log(n); //调用函数的局部变量
  }
  return f2; //返回函数
}
var result = f1();
result(); // 结果为：hello
```

如上述代码，**闭包就是一个能够访问其他函数作用域内局部变量的函数**，如`f2`函数。

> 由于在 JavaScript 语言中，只有该函数内部的子函数才能访问其局部变量，因此可以把闭包简单理解成"定义在一个函数内部的函数"。所以，在本质上，闭包就是将函数内部和函数外部连接起来的一座桥梁。

## 特性

再来看看先下面的代码：

```js
function add() {
  var x = 1;
  return function () {
    return x++;
  };
}
var fun = add();
console.log(fun()); //1
console.log(fun()); //2
console.log(fun()); //3
fun = null; //回收内存里的x变量
console.log(fun()); // Uncaught TypeError
```

一般函数在执行完毕后，局部对象会被清除，内存只保存全局变量。但是如上述代码，可以发现**使用闭包会改变函数内部变量的值，且会让变量始终保存在内存中**。不会被 JavaScript 自带的内存处理机制给清除掉。所以使用不当，会消耗大量内存，造成性能问题。

## 应用

### 模拟私有方法

像在 java 在内的一些语言一样，将方法声明为私有方法，让它们只能在同一个类中调用。私有方法不仅仅有利于限制对代码的访问：还提供了管理全局命名空间的强大能力，避免非核心的方法弄乱了代码的公共接口部分。

```js
var couter = (function () {
  var a = 1;
  function add(x) {
    a += x;
  }
  return {
    add: function () {
      add(1);
    },
    decrement: function () {
      add(-1);
    },
    value: function () {
      return a;
    },
  };
})();

couter.add();
console.log(couter.value()); //2
couter.add();
couter.add();
couter.decrement();
console.log(couter.value()); //3
```

该共享环境创建于一个匿名函数体内，该函数一经定义立刻执行。环境中包含两个私有项：名为`a`的变量和名为`add`的函数。这两项都无法在匿名函数外部直接访问。必须通过匿名包装器返回的三个公共函数访问。

### 在循环中创建闭包

```html
<p id="help">Helpful notes will appear here</p>
<p>E-mail: <input type="text" id="email" name="email" /></p>
<p>Name: <input type="text" id="name" name="name" /></p>
<p>Age: <input type="text" id="age" name="age" /></p>
```

问题代码：

```js
function showHelp(help) {
  document.getElementById("help").innerHTML = help;
}

function setHelp() {
  var array = [
    {
      id: "email",
      help: "Your e-mail address",
    },
    {
      id: "name",
      help: "Your full name",
    },
    {
      id: "age",
      help: "Your age (you must be over 16)",
    },
  ];
  for (var i = 0; i < array.length; i++) {
    console.log(i);
    var item = array[i];
    document.getElementById(item.id).onfocus = function () {
      showHelp(item.help);
    };
  }
}
```

运行这段代码后，您会发现它没有达到想要的效果。无论焦点在哪个输入域上，显示的都是关于 age 的消息。

该问题的原因在于赋给 onfocus 是闭包（setupHelp）中的匿名函数而不是闭包对象。在 for 循环后，一共创建了三个匿名函数，但是他们却共享一个环境（item）。所以在执行 onfocus 回调时，循环早已结束，且 item 停留在最后一下。

解决的办法是：修改`showHelp`函数为闭包，并将 onfocus 指向一个新的闭包对象：

```js
function showHelp(help) {
  return function () {
    document.getElementById("help").innerHTML = help;
  };
}

function setHelp() {
  var array = [
    {
      id: "email",
      help: "Your e-mail address",
    },
    {
      id: "name",
      help: "Your full name",
    },
    {
      id: "age",
      help: "Your age (you must be over 16)",
    },
  ];
  for (var i = 0; i < array.length; i++) {
    console.log(i);
    var item = array[i];
    document.getElementById(item.id).onfocus = showHelp(item.help);
  }
}
setHelp();
```

如代码所示，所有的回调不再共享同一个环境，`showHelp`函数为每一个回调创建一个新的环境。在这些环境中，help 指向数组中对应的字符串。

## 问题

由于 IE 的 js 对象和 Dom 对象使用不同的垃圾收集方法，因此在使用闭包的时候会产生内存泄露问题，也就是说无法销毁驻留再内存中的元素。

## 参考

- [闭包 - JavaScript | MDN](https://developer.mozilla.org/cn/docs/Web/JavaScript/Closures)
- [学习 Javascript 闭包（Closure） - 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2009/08/learning_javascript_closures.html)
- [详解 js 闭包 - trigkit4 - SegmentFault](https://segmentfault.com/a/1190000000652891)
