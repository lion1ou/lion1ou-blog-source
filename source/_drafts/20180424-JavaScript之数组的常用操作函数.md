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

js对数组的操作非常频繁，但是每次用到的时候都会被搞混，都需要去查相关API，感觉这样很浪费时间。为了加深印象，所以整理一下对数组的相关操作。

<!--more-->

## 常用的函数

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

**转载请标注原文地址**
