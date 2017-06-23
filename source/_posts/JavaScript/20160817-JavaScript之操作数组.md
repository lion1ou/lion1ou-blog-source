---
title: JavaScript之操作数组
toc: true
comments: true
categories: JavaScript
tags: JavaScript
date: 2016-08-17 16:22:43
photos:
description:
---
这里记录一些数组的常用操作方法，方便之后的查阅
<!-- more -->
### Array join()
join() 方法用于把数组中的所有元素放入一个字符串。元素是通过指定的分隔符进行分隔的。   

<input type="button" onclick="arrJoin()" value="运行">(打开开发者工具，查看log结果)
<script>
function arrJoin() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"
    console.log(arr.join(".")); //默认值是“,”
}
</script>

```js
function arrJoin() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"
    console.log(arr.join(".")); //默认值是“,”
}
```



### Array concat()
concat()方法用于连接两个或多个数组。该方法不会改变现有的数组，而仅仅会返回被连接数组的一个副本。

<input type="button" onclick="arrConcat()" value="运行">(打开开发者工具，查看log结果)
<script>
function arrConcat() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"

    var arr2 = new Array(3)
    arr2[0] = "James"
    arr2[1] = "Adrew"
    arr2[2] = "Martin"

    var arr3 = new Array(2)
    arr3[0] = "William"
    arr3[1] = "Franklin"
    console.log(arr.concat(arr2));
    console.log(arr.concat(arr2, arr3));
    console.log(arr);
}
</script>

```js
function arrConcat() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"

    var arr2 = new Array(3)
    arr2[0] = "James"
    arr2[1] = "Adrew"
    arr2[2] = "Martin"

    var arr3 = new Array(2)
    arr3[0] = "William"
    arr3[1] = "Franklin"
    console.log(arr.concat(arr2));
    console.log(arr.concat(arr2, arr3));
    console.log(arr);
}
```


### Array pop()
pop()方法用于删除并返回数组的最后一个元素。pop()方法将删除arrayObject的最后一个元素，把数组长度减 1，并且返回它删除的元素的值。如果数组已经为空，则pop() 不改变数组，并返回 undefined 值。

<input type="button" onclick="arrPop()" value="运行">(打开开发者工具，查看log结果)
<script>
function arrPop() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"
    console.log(arr)
    console.log("<br />")
    console.log(arr.pop())
    console.log("<br />")
    console.log(arr)
}
</script>

```js
function arrPop() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"
    console.log(arr)
    console.log("<br />")
    console.log(arr.pop())
    console.log("<br />")
    console.log(arr)
}
```


### Array push()
push()方法可向数组的末尾添加一个或多个元素，并返回新的长度。可将参数中的内容顺序添加到arrayObject 的尾部。它直接修改 arrayObject，而不是创建一个新的数组。push()方法和 pop()方法使用数组提供的先进后出栈的功能。要想数组的开头添加一个或多个元素，请使用 unshift() 方法。

<input type="button" onclick="arrPush()" value="运行">(打开开发者工具，查看log结果)
<script>
function arrPush() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"
    console.log(arr + "<br />")
    console.log(arr.push("James") + "<br />")
    console.log(arr)
}
</script>

```js
function arrPush() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"
    console.log(arr + "<br />")
    console.log(arr.push("James") + "<br />")
    console.log(arr)
}
```

### Array reverse()
reverse() 方法用于颠倒数组中元素的顺序。该方法会改变原来的数组，而不会创建新的数组。

<input type="button" onclick="arrReverse()" value="运行">(打开开发者工具，查看log结果)
<script>
function arrReverse() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"

    console.log(arr + "<br />")
    console.log(arr.reverse())
}
</script>

```js
function arrReverse() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"

    console.log(arr + "<br />")
    console.log(arr.reverse())
}
```

### Array shift()
shift() 方法用于把数组的第一个元素从其中删除，并返回第一个元素的值。如果数组是空的，那么 shift() 方法将不进行任何操作，返回 undefined 值。请注意，该方法不创建新数组，而是直接修改原有的 arrayObject。

<input type="button" onclick="arrReverse()" value="运行">(打开开发者工具，查看log结果)
<script>
function arrReverse() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"

    console.log(arr + "<br />")
    console.log(arr.shift() + "<br />")
    console.log(arr)
}
</script>

```js
function arrReverse() {
    var arr = new Array(3)
    arr[0] = "George"
    arr[1] = "John"
    arr[2] = "Thomas"

    console.log(arr + "<br />")
    console.log(arr.shift() + "<br />")
    console.log(arr)
}
```


**转载请标注原文地址**

(end)
