---
title: ES6入门(一) - let和const命令
toc: true
comments: true
categories: JavaScript
date: 2016-09-13 11:31:44
tags: ES6
---

## 一、let命令

### 1. 声明只在代码块内有效

let命令，用来声明变量。它的用法类似于var，但是所声明的变量，只在let命令所在的代码块内有效。

```js
{
  let a = 10;
  var b = 1;
}

a // ReferenceError: a is not defined.
b // 1
```
<!-- more -->
>let声明的变量报错，var声明的变量返回了正确的值，let声明的变量只在它所在的代码块有效。

for循环的计数器，就很合适使用let命令。

```js
for (let i = 0; i < arr.length; i++) {}

console.log(i);
//ReferenceError: i is not defined
```
上面代码的计数器i，只在for循环体内有效。

### 2. 不存在变量提升

let不像var那样会发生“变量提升”现象。所以，变量一定要在声明后使用，否则报错。

```js
console.log(foo); // 输出undefined
console.log(bar); // 报错ReferenceError

var foo = 2;
let bar = 2;
```

### 3. 暂时性死区

只要块级作用域内存在let命令，它所声明的变量就“绑定”（binding）这个区域，不再受外部的影响。
```js
var tmp = 123;

if (true) {
  tmp = 'abc'; // ReferenceError
  let tmp;
}
```

### 4. 不允许重复声明

let不允许在相同作用域内，重复声明同一个变量。
```js
// 报错
function () {
  let a = 10;
  var a = 1;
}

// 报错
function () {
  let a = 10;
  let a = 1;
}
```

## 二、块级作用域

let实际上为JavaScript新增了块级作用域。

```js
function f1() {
  let n = 5;
  if (true) {
    let n = 10;
  }
  console.log(n); // 5
}
```


ES5 规定，函数只能在顶层作用域和函数作用域之中声明，不能在块级作用域声明。

```js
if (true) {
  function f () {}
}
// 在ES5中，这是非法的（由于浏览器为兼容旧代码没有遵守规定，实际能运行，不会报错）
```

ES6引入了块级作用域，明确允许在块级作用域之中声明函数。

```js
// ES6严格模式
'use strict';
if (true) {
  function f() {}
}
// 不报错
```

并且ES6规定，块级作用域之中，函数声明语句的行为类似于let，在块级作用域之外不可引用。

```js
function f() { console.log('I am outside!'); }
(function () {
  if (false) {
    // 重复声明一次函数f
    function f() { console.log('I am inside!'); }
  }
  f();
}());
// ES5: I am inside! （函数声明提升）
// ES6: Uncaught TypeError: f is not a function （ES6浏览器不遵守规则，有自己的行为，类似于var）
// 考虑到环境导致的行为差异太大，应该避免在块级作用域内声明函数。
```

## 三、const命令

### 1. 声明只读常量

`const`声明一个`只读的常量`。一旦声明，常量的值就不能改变。

```js
const PI = 3.1415;
PI // 3.1415

PI = 3;
// TypeError: Assignment to constant variable.
```

const声明的变量不得改变值，这意味着，const一旦声明变量，就必须立即初始化，不能留到以后赋值。

```js
const foo;
// SyntaxError: Missing initializer in const declaration
```

上面代码表示，对于const来说，只声明不赋值，就会报错。

### 2. 与let命令具有相同特性

* 声明只在代码块内有效
* 不存在变量提升
* 暂时性死区
* 不允许重复声明

### 3. 变量指向数据所在内存地址

对于复合类型的变量，变量名不指向数据，而是指向数据所在的地址。

```js
const foo = {};
foo.prop = 123;

foo.prop
// 123

foo = {}; // TypeError: "foo" is read-only
```
上面代码中，常量foo储存的是一个地址，这个地址指向一个对象。不可变的只是这个地址，即不能把foo指向另一个地址，但对象本身是可变的，所以依然可以为其添加新属性。

下面是另一个例子。

```js
const a = [];
a.push('Hello'); // 可执行
a.length = 0;    // 可执行
a = ['Dave'];    // 报错
```
上面代码中，常量a是一个数组，这个数组本身是可写的，但是如果将另一个数组赋值给a，就会报错。

## 四、全局对象的属性

ES5之中，全局对象的属性与全局变量是等价的。

```js
window.a = 1;
a // 1

a = 2;
window.a // 2
```

ES6为了改变这一点，一方面规定，为了保持兼容性，var命令和function命令声明的全局变量，依旧是全局对象的属性；另一方面规定，let命令、const命令、class命令声明的全局变量，不属于全局对象的属性。也就是说，从ES6开始，全局变量将逐步与全局对象的属性脱钩。

```js
var a = 1;
// 如果在Node的REPL环境，可以写成global.a
// 或者采用通用方法，写成this.a
window.a // 1

let b = 1;
window.b // undefined
```


                          
