---
title: JavaScript之字符串的常用操作函数
toc: true
comments: true
categories: JavaScript
tags: JavaScript
date: 2018-04-23 07:31:21
photos:
description:
---

字符串的操作在js中非常繁琐，但也非常重要。在使用过程中，也会经常忘记，今天就对这个进行一下整理。

<!--more-->

## String 对象

String 对象用于处理文本（字符串）。

```
new String(s); // 返回一个新创建的 String 对象，存放的是字符串 s 或 s 的字符串表示。
String(s);     // 只把 s 转换成原始的字符串，并返回转换后的值。
```

## String 属性

* constructor 对创建该对象的函数的引用
* length  字符串的长度
* prototype   允许您向对象添加属性和方法
prototype在面向对象编程中会经常用到，用来给对象添加属性或方法，并且添加的方法或属性在所有的实例上共享。因此也常用来扩展js内置对象，如下面的代码给字符串添加了一个去除两边空格的方法：

```js
String.prototype.trim = function(){
    return this.replace(/^\s*|\s*$/g, '');
}
```

## String 函数

#### 获取类函数

* charAt()

```js
StringObj.charAt()
```

charAt()方法可用来获取指定位置的字符串，index为字符串索引值，从0开始到string.leng - 1，若不在这个范围将返回一个空字符串。如：

```js
var str = 'qwertyuiop'
str.charAt(3)
// "r"
str.charAt(11)
// ""
```

* charCodeAt()

charCodeAt()用于返回指定位置的Unicode 编码，于charAt()使用类似。

```js
var str = 'qwertyuiop'
str.charCodeAt(3)
// 114
str.charCodeAt(11)
// NaN
```

* fromCharCode()

fromCharCode()可接受一个或多个Unicode值，然后返回一个字符串。另外该方法是String 的静态方法，字符串中的每个字符都由单独的数字Unicode编码指定。

```js
String.fromCharCode(99, 99, 100)
// "ccd"
```

#### 查找类函数

* indexOf()

indexOf()用来检索指定的字符串值在字符串中首次出现的位置。它可以接收两个参数，searchvalue表示要查找的子字符串，fromindex表示查找的开始位置，省略的话则从开始位置进行检索。lastIndexOf()，从后向前搜索字符串。

```js
var str = 'abcdabcd'
str.indexOf('a')
// 0
str.indexOf('s')
// -1
str.indexOf('a', 2)
// 4
```

* search()

search()方法用于检索字符串中指定的子字符串，或检索与正则表达式相匹配的子字符串。它会返回第一个匹配的子字符串的起始位置，如果没有匹配的，则返回-1。

```js
var str = 'abcdabcd'
str.search('b')
// 1
str.search('s')
// -1
str.search(/d/i)
// 3
```

* match()

match()方法可在字符串内检索指定的值，或找到一个或多个正则表达式的匹配。

如果参数中传入的是子字符串或是没有进行全局匹配的正则表达式，那么match()方法会从开始位置执行一次匹配，如果没有匹配到结果，则返回null。否则则会返回一个数组，该数组的第0个元素存放的是匹配文本，除此之外，返回的数组还含有两个对象属性index和input，分别表示匹配文本的起始字符索引和stringObject 的引用(即原字符串)。

```js
var str = 'qwer23tyqwer23ty'
str.match('ba')
// null
str.match('y')
// ["y", index: 7, input: "qwer23tyqwer23ty", groups: undefined]
str.match(/y/)
// ["y", index: 7, input: "qwer23tyqwer23ty", groups: undefined]
str.match(/y/g)  // 正则全局匹配
// ["y", "y", "y", "y"]
```

如果参数传入的是具有全局匹配的正则表达式，那么match()从开始位置进行多次匹配，直到最后。如果没有匹配到结果，则返回null。否则则会返回一个数组，数组中存放所有符合要求的子字符串，并且没有index和input属性。

```js
var str = 'qwer23tyqwer23ty'

str.match(/y/g)  // 正则全局匹配
// ["y", "y", "y", "y"]

str.match(/\d/g) // 正则全局匹配
// ["2", "3", "2", "3"]
```

#### 截取类函数

* substring

substring()是最常用到的字符串截取方法，它可以接收两个参数(参数不能为负值)，分别是要截取的开始位置和结束位置，它将返回一个新的字符串，其内容是从start处到end-1处的所有字符。若结束参数(end)省略，则表示从start位置一直截取到最后。

```js
var str = 'qazwsxedc'
str.substring(1,4)
// "azw"
str.substring(3)
// "wsxedc"
str.substring(-1, 4)
// "qazwsxedc"
```

* slice()

slice()方法与substring()方法非常类似，它传入的两个参数也分别对应着开始位置和结束位置。而区别在于，slice()中的参数可以为负值，如果参数是负数，则该参数规定的是从字符串的尾部开始算起的位置。也就是说，-1 指字符串的最后一个字符。

```js
var str = 'qazwsxedc'
str.slice(1,4)
// "azw"
str.slice(-1)
// "c"
str.slice(3)
// "wsxedc"
```

* substr()

substr()方法可在字符串中抽取从start下标开始的`指定数目`的字符。其返回值为一个字符串，包含从 stringObject的start（包括start所指的字符）处开始的length个字符。如果没有指定 length，那么返回的字符串包含从start到stringObject的结尾的字符。另外如果start为负数，则表示从字符串尾部开始算起。

```js
var str = 'asdfghjkl'
str.substr(0, 4)
// "asdf"
str.substr(-1, 9)
// "l"
```

#### 其他函数

* replace()

replace()方法用来进行字符串替换操作，它可以接收两个参数，前者为被替换的子字符串（可以是正则），后者为用来替换的文本。

如果第一个参数传入的是子字符串或是没有进行全局匹配的正则表达式，那么replace()方法将只进行一次替换（即替换最前面的），返回经过一次替换后的结果字符串。

```js
var str = 'abcdeabcde'
str.replace('a', 'A')
// "Abcdeabcde"
str.replace(/\w/, 'Q')
// "Qbcdeabcde"
```

如果第一个参数传入的全局匹配的正则表达式，那么replace()将会对符合条件的子字符串进行多次替换，最后返回经过多次替换的结果字符串。

```js
var str = 'abcdeabcde'
str.replace(/a/g, 'A')
// "AbcdeAbcde"
str.replace(/\w/g, '$')
// "$$$$$$$$$$"
```

* split()

split()方法用于把一个字符串分割成字符串数组。第一个参数separator表示分割位置(参考符)，第二个参数howmany表示返回数组的允许最大长度(一般情况下不设置)。

```js
var str = 'a|b|c|d|e'
str.split('|')
// ["a", "b", "c", "d", "e"]
str.split('')
// ["a", "|", "b", "|", "c", "|", "d", "|", "e"]
str.split('|', 3)
// ["a", "b", "c"]
```

也可以用正则来进行分割
```js
var str = 'a1b2c3d4e'
str.split(/\d/)
// ["a", "b", "c", "d", "e"]
```

* toLowerCase()和toUpperCase()

toLowerCase()方法可以把字符串中的大写字母转换为小写，toUpperCase()方法可以把字符串中的小写字母转换为大写。

```js
var str = 'JavaScript';
str.toLowerCase()
// javascript
str.toUpperCase()
// JAVASCRIPT
```






