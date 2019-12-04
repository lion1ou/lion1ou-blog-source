---
title: JavaScript之数组的常用操作函数
toc: true
comments: true
categories: JavaScript
tags: JavaScript
date: 2018-04-24 07:31:30
photos:
description:
---



<!--more-->

字符串的操作在js中非常繁琐，但也非常重要。在使用过程中，也会经常忘记，今天就对这个进行一下整理。

<!--more-->

## 字符串 String

String 对象用于处理文本（字符串）。

```
new String(s); // 返回一个新创建的 String 对象，存放的是字符串 s 或 s 的字符串表示。
String(s);     // 只把 s 转换成原始的字符串，并返回转换后的值。
```

### String 属性

* constructor 对创建该对象的函数的引用
* length  字符串的长度
* prototype   允许您向对象添加属性和方法
prototype在面向对象编程中会经常用到，用来给对象添加属性或方法，并且添加的方法或属性在所有的实例上共享。因此也常用来扩展js内置对象，如下面的代码给字符串添加了一个去除两边空格的方法：

```js
String.prototype.trim = function(){
    return this.replace(/^\s*|\s*$/g, '');
}
```

### String 函数

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

## 数组 Array

js对数组的操作非常频繁，但是每次用到的时候都会被搞混，都需要去查相关API，感觉这样很浪费时间。为了加深印象，所以整理一下对数组的相关操作。


#### concat()
连接两个或更多的数组，并返回结果。方法用于连接两个或多个数组。该方法不会改变现有的数组，而仅仅会返回被连接数组的一个副本。

```js
var arr1 = [1, 2, 3]
var arr2 = ['a', 'b', 'c', 'd']
var arr3 = arr1.concat(arr2)
console.log(arr1, arr2, arr3)
// [1, 2, 3] ["a", "b", "c", "d"] [1, 2, 3, "a", "b", "c", "d"]
var arr4 = arr1.concat(1)
console.log(arr4)
// [1, 2, 3, 1]
```

#### join()
把数组的所有元素放入一个字符串。元素通过指定的分隔符进行分隔。

```js
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var str = arr1.join('-')
console.log(str)
// 1-2-3-4-5-6-7-8-9
var str1 = arr1.join()
console.log(str1)
// 1,2,3,4,5,6,7,8,9
```

#### pop()
删除并返回数组的最后一个元素，pop() 方法将删除 arrayObject 的最后一个元素，把数组长度减 1，并且返回它删除的元素的值。如果数组已经为空，则 pop() 不改变数组，并返回 undefined 值。

```js
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var arr2 = arr1.pop()
console.log(arr1, arr2)
// [1, 2, 3, 4, 5, 6, 7, 8]   9
var arr3 = []
var arr4 = arr3.pop()
console.log(arr3, arr4)
// []   undefined
```

#### shift()
删除并返回数组的第一个元素，如果数组是空的，那么 shift() 方法将不进行任何操作，返回 undefined 值。请注意，该方法不创建新数组，而是直接修改原有的 arrayObject。

```js
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var arr2 = arr1.shift()
console.log(arr1, arr2)
// [2, 3, 4, 5, 6, 7, 8, 9]   1
```

### unshift()
向数组的开头添加一个或更多元素，并返回新的长度。unshift() 方法将把它的参数插入 arrayObject 的头部，并将已经存在的元素顺次地移到较高的下标处，以便留出空间。unshift() 方法不创建新的创建，而是直接修改原有的数组。

```js
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var arr2 = arr1.unshift(0, 0, 0, 0)
console.log(arr1, arr2)
// [0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]     13
```

#### push()
向数组的末尾添加一个或更多元素，并返回新的长度。push() 方法可把它的参数顺序添加到 arrayObject 的尾部。它直接修改 arrayObject，而不是创建一个新的数组。push() 方法和 pop() 方法使用数组提供的先进后出栈的功能。

```js
var arr1 = [1, 2, 3, 4]
var arr2 = [5, 6, 7, 8, 9]
var arr3 = arr1.push(arr2)
console.log(arr1, arr2, arr3)
// [1, 2, 3, 4, [5, 6, 7, 8, 9]]   [5, 6, 7, 8, 9]   5
var arr4 = [1]
var arr5 = arr4.push(5, 6, 7, 8, 9)
console.log(arr4, arr5)
// [1, 5, 6, 7, 8, 9]  6
```


#### slice()
从某个已有的数组返回选定的元素，请注意，该方法并不会修改数组，而是返回一个子数组。您可使用负值从数组的尾部选取元素。

```js
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var arr2 = arr1.slice(-5, -2)
console.log(arr1, arr2)
// [1, 2, 3, 4, 5, 6, 7, 8, 9]   [5, 6, 7]
var arr3 = arr1.slice(2, 8)
console.log(arr3)
// [3, 4, 5, 6, 7, 8]
var arr4 = arr1.slice(5)
console.log(arr4)
// [6, 7, 8, 9]
```

#### splice()
删除元素，并向数组添加新元素。方法向/从数组中添加/删除项目，然后返回被删除的项目。该方法会改变原始数组。splice() 方法可删除从 index 处开始的零个或多个元素，并且用参数列表中声明的一个或多个值来替换那些被删除的元素。如果从 arrayObject 中删除了元素，则返回的是含有被删除的元素的数组。

```js
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var arr2 = arr1.splice(1, 5)
console.log(arr1, arr2)
// [1, 7, 8, 9]   [2, 3, 4, 5, 6]
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var arr3 = arr1.splice(2, 3, [0, 0, 0, 0])
console.log(arr1, arr3)
// [1, 2, [0, 0, 0, 0], 6, 7, 8, 9]   [3, 4, 5]
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var arr4 = arr1.splice(2, 3, 0, 0, 0, 0)
console.log(arr1, arr4)
// [1, 2, 0, 0, 0, 0, 6, 7, 8, 9]   [3, 4, 5]
```

#### sort()
对数组的元素进行排序，规定排序顺序。参数必须是函数。对数组的引用。请注意，数组在原数组上进行排序，不生成副本。

如果调用该方法时没有使用参数，将按字母顺序对数组中的元素进行排序，说得更精确点，是按照字符编码的顺序进行排序。要实现这一点，首先应把数组的元素都转换成字符串（如有必要），以便进行比较。

如果想按照其他标准进行排序，就需要提供比较函数，该函数要比较两个值，然后返回一个用于说明这两个值的相对顺序的数字。比较函数应该具有两个参数 a 和 b，其返回值如下：

若 a 小于 b，在排序后的数组中 a 应该出现在 b 之前，则返回一个小于 0 的值。
若 a 等于 b，则返回 0。
若 a 大于 b，则返回一个大于 0 的值。

```js
var arr1 = ['A', 'VCBJN', 'ksjn', 'adf', 'uuu']
var arr2 = arr1.sort()
console.log(arr1, arr2)
// ["A", "VCBJN", "adf", "ksjn", "uuu"]   ["A", "VCBJN", "adf", "ksjn", "uuu"]
var arr1 = ['11', '2222', '3', '44', '555']
arr1.sort()
console.log(arr1)
// ["11", "2222", "3", "44", "555"]
var arr1 = ['11', '2222', '3', '44', '555']
arr1.sort((a, b) => a-b)
console.log(arr1)
// ["3", "11", "44", "555", "2222"]
```

#### reverse()
颠倒数组中元素的顺序。该方法会改变原来的数组，而不会创建新的数组。

```js
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var arr2 = arr1.reverse()
console.log(arr1, arr2)
// [9, 8, 7, 6, 5, 4, 3, 2, 1]   [9, 8, 7, 6, 5, 4, 3, 2, 1]
```

#### toString()
把数组转换为字符串，并返回结果。当数组用于字符串环境时，JavaScript 会调用这一方法将数组自动转换成字符串。但是在某些情况下，需要显式地调用该方法。arrayObject 的字符串表示。返回值与没有参数的 join() 方法返回的字符串相同。

```js
var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var arr2 = arr1.toString()
console.log(arr1, arr2)
// [1, 2, 3, 4, 5, 6, 7, 8, 9]     "1,2,3,4,5,6,7,8,9"
```

#### toLocaleString()
把数组转换为本地数组，并返回结果。首先调用每个数组元素的 toLocaleString() 方法，然后使用地区特定的分隔符把生成的字符串连接起来，形成一个字符串。

```js
var arr1 = ['jssj', 2, 3, '测试', 5, 6, 7, 8, 9]
var arr2 = arr1.toLocaleString()
console.log(arr1, arr2)
// ["jssj", 2, 3, "测试", 5, 6, 7, 8, 9]     "jssj,2,3,测试,5,6,7,8,9"
```

#### valueOf()
valueOf() 方法返回 Array 对象的原始值。该原始值由 Array 对象派生的所有对象继承。valueOf() 方法通常由 JavaScript 在后台自动调用，并不显式地出现在代码中。

#### toSource()
返回该对象的源代码。该原始值由 Array 对象派生的所有对象继承。toSource() 方法通常由 JavaScript 在后台自动调用，并不显式地出现在代码中。只有 Gecko 核心的浏览器（比如 Firefox）支持该方法，也就是说 IE、Safari、Chrome、Opera 等浏览器均不支持该方法。

```js
function employee(name,job,born) {
    this.name=name;
    this.job=job;
    this.born=born;
}
var bill = new employee("Bill Gates","Engineer",1985);
console.log(bill.toSource());
//  ({name:"Bill Gates", job:"Engineer", born:1985})
```


