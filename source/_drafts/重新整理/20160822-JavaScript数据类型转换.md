---
title: JavaScript数据类型转换
toc: true
comments: true
categories: 前端技术
tags: JavaScript
date: 2016-08-22 09:15:06
photos:
description:
---
JavaScript是一种动态类型语言，变量没有类型限制，可以随时赋予任意值。虽然变量没有类型，但是数据本身和各种运算符是有类型的。如果运算符发现，数据的类型与预期不符，就会自动转换类型。比如，减法运算符预期两侧的运算子应该是数值，如果不是，就会自动将它们转为数值。
<!--more-->

## 强制类型转换
强制转换主要指使用`Number`、`String`和`Boolean`三个构造函数，手动将各种类型的值，转换成数字、字符串或者布尔值。

### Number()

原始类型的值主要是字符串、布尔值、undefined和null，它们都能被Number转成数值或NaN。
```js
// 数值：转换后还是原来的值
Number(324) // 324

// 字符串：如果可以被解析为数值，则转换为相应的数值
Number('324') // 324

// 字符串：如果不可以被解析为数值，返回NaN
Number('324abc') // NaN

// 空字符串转为0
Number('') // 0

// 布尔值：true 转成1，false 转成0
Number(true) // 1
Number(false) // 0

// undefined：转成 NaN
Number(undefined) // NaN

// null：转成0
Number(null) // 0
```
Number函数将字符串转为数值，要比parseInt函数严格很多。基本上，只要有一个字符无法转成数值，整个字符串就会被转为NaN。
```js
parseInt('42 cats') // 42
Number('42 cats') // NaN
//上面代码中，parseInt逐个解析字符，而Number函数整体转换字符串的类型。

//另外，Number函数会自动过滤一个字符串前导和后缀的空格。
Number('\t\v\r12.34\n') // 12.34
```
简单的规则是，Number方法的参数是对象时，将返回NaN。
```js
Number({a: 1}) // NaN
Number([1, 2, 3]) // NaN
```

### String()
使用String函数，可以将任意类型的值转化成字符串。

* 数值：转为相应的字符串。
* 字符串：转换后还是原来的值。
* 布尔值：true转为"true"，false转为"false"。
* undefined：转为"undefined"。
* null：转为"null"。
```js
String(123) // "123"
String('abc') // "abc"
String(true) // "true"
String(undefined) // "undefined"
String(null) // "null"
```

String方法的参数如果是对象，返回一个类型字符串；如果是数组，返回该数组的字符串形式。
```js
String({a: 1}) // "[object Object]"
String([1, 2, 3]) // "1,2,3"
```

### Boolean()
使用Boolean函数，可以将任意类型的变量转为布尔值。
>它的转换规则相对简单：除了以下六个值的转换结果为false，其他的值全部为true。

* undefined
* null
* -0
* 0或+0
* NaN
* ''（空字符串）

```js
Boolean(undefined) // false
Boolean(null) // false
Boolean(0) // false
Boolean(NaN) // false
Boolean('') // false
```
注意，所有对象（包括空对象）的转换结果都是true，甚至连false对应的布尔对象new Boolean(false)也是true。
```js
Boolean({}) // true
Boolean([]) // true
Boolean(new Boolean(false)) // true
```

## 自动转换

遇到以下三种情况时，JavaScript会自动转换数据类型，即转换是自动完成的，对用户不可见。
```js
// 1. 不同类型的数据互相运算
123 + 'abc' // "123abc"

// 2. 对非布尔值类型的数据求布尔值
if ('abc') {
  console.log('hello')
}  // "hello"

// 3. 对非数值类型的数据使用一元运算符（即“+”和“-”）
+ {foo: 'bar'} // NaN
- [1, 2, 3] // NaN
```

### 自动转换为布尔值
当JavaScript遇到预期为布尔值的地方（比如if语句的条件部分），就会将非布尔值的参数自动转换为布尔值。系统内部会自动调用Boolean函数。因此除了以上六个值，其他都是自动转为true。

### 自动转换为字符串
当JavaScript遇到预期为字符串的地方，就会将非字符串的数据自动转为字符串。系统内部会自动调用String函数。字符串的自动转换，主要发生在加法运算时。当一个值为字符串，另一个值为非字符串，则后者转为字符串。

### 自动转换为数值
当JavaScript遇到预期为数值的地方，就会将参数值自动转换为数值。系统内部会自动调用Number函数。除了加法运算符有可能把运算子转为字符串，其他运算符都会把运算子自动转成数值。

## 参考链接
[数据类型转换](http://javascript.ruanyifeng.com/grammar/conversion.html)




