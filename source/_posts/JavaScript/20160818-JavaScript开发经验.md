---
title: JavaScript开发经验
toc: true
comments: true
categories: JavaScript
date: 2016-08-18 15:54:50
tags: JavaScript
---

## 进制转换
```js
//十进制转其他(将十进制的x转换成其他进制)
var x=110;  
console.log(x);  
console.log(x.toString(8));  
console.log(x.toString(32));  
console.log(x.toString(16));  
//其他转十进制(将x当做其他进制，转换成十进制)
var x='110';  
console.log(parseInt(x,2));  
console.log(parseInt(x,8));  
console.log(parseInt(x,16));  
//其他转其他(先用parseInt转成十进制再用toString转到目标进制  )
console.log(String.fromCharCode(parseInt(141,8)))  
console.log(parseInt('ff',16).toString(2));
```
<!-- more -->
## 实现拉到底部自动加载内容：

```js
$("#picture11").scroll(function() {
    var $this = $(this),
    viewH = $(this).height(), //可见高度(当前div的可视高度) 
    contentH = $(this).get(0).scrollHeight, //内容高度(整条滚动条的高度) 
    scrollTop = $(this).scrollTop(); //滚动高度(被滚动隐藏起来的内容高度) 
    //if(contentH - viewH - scrollTop <= 100) { //到达底部100px时,加载新内容 
    if (scrollTop / (contentH - viewH) >= 0.995) { //到达底部100px时,加载新内容

        console.log('到底了')
    }
});
```

## 页面之间通过url传值：

### 跳转链接的写法：

```js
window.location.href = "#/exhibit?key=value&key=value"; //跳转到某个页面
```
　
或：

```js
<a href="#exhibit?key=value&key=value">　　
```

### 到达指定页面的接收代码：

1.
```js
var exhibitUrl = window.location.href;//获取当前url
var n1 = exhibitUrl.length; //地址的总长度
var n2 = exhibitUrl.indexOf("="); //取得=号的位置
var value = exhibitUrl.substr(n2 + 1, n1 - n2); //从=号后面的内容
console.log(value);//打印出value
```

2.
```js
////////获取url参数值///////////////
function GetArgsFromHref(sHref, sArgName) { //获取url传过来的参数
  var args = sHref.split("?");
  var retval = "";
  if (args[0] == sHref) /*参数为空*/ {
      return retval; /*无需做任何处理*/
  }
  var str = args[1];
  args = str.split("&");
  for (var i = 0; i < args.length; i++) {
      str = args[i];
      var arg = str.split("=");
      if (arg.length <= 1) continue;
      if (arg[0] == sArgName)
          retval = arg[1];
  }
  return retval;
}
//currentUrl为当前带值得url
var parameter = GetArgsFromHref(currentUrl, "parameter"); 
```
 
## 版本号字符串，转换为可比较大小的整型：

```js
function analysisVersion(version) {
      //将版本信息转换为可比较大小的整数类型
     var versionArray = version.split('.');
     var versionTemp = versionArray[0] + ".";
     for (var i = 1; i < versionArray.length; i++) {
      versionTemp += versionArray[i];
     }
     return parseFloat(versionTemp);
}
var updateVersionInt = analysisVersion(data.appVersion);
```

## 回调函数
另外，最好保证回调存在且必须是函数引用或者函数表达式：
```js
(callback && typeof(callback) === "function") && callback();

实例：
function fn(arg1, arg2, callback){
    var num = Math.ceil(Math.random() * (arg1 - arg2) + arg2);
    callback(num);　　//传递结果
}

fn(10, 20, function(num){
   console.log("Callback called! Num: " + num);
});　　　　//结果为10和20之间的随机数
```

## 把外部JavaScript文件放在HTML底部
把文件引用放在HTML底部吧（就在`<body>`之前），提升加载速度。

## 单引号和双引号
为了避免混乱，我们建议在HTML中使用双引号，在JavaScript中使用单引号。

## 用尽量简短的代码
```js
//对于条件判断只有两次的，这是一种冗长的写法
var direction;
if(x > 100){
direction = 1;
} else {
direction = -1;
}

//更好的代码
var direction = (x > 100) ? 1 : -1;

//判断一个 变量是否定义，如果否，就赋予一个值，糟糕的代码
if(v){
var x = v;
} else {
var x = 10;
}

//更好的代码
var x = v || 10;
```
## 总是检查数据

要检查你的方法输入的所有数据，一方面是为了安全性，另一方面也是为了可用性。

用户随时随地都会输入错误的数据。这不是因为他们蠢，而是因为他们很忙，并且思考的方式跟你不同。

用typeof方法来检测你的function接受的输入是否合法。

另一个安全隐患是直接从DOM中取出数据使用。比如说你的function从用户名输入框中取得用户名做某项操作，但用户名中的单引号或者双引号可能会导致你的代码崩溃。

## 避免全局变量

全局变量和全局函数是非常糟糕的。因为在一个页面中包含的所有JavaScript都在同一个域中运行。所以如果你的代码中声明了全局变量或者全局函数的话，后面的代码中载入的脚本文件中的同名变量和函数会覆盖掉（overwrite）你的。

```js
//糟糕的全局变量和全局函数var current = null;
function init(){...}
function change(){...}
function verify(){...}
//解决办法有很多，Christian Heilmann建议的方法是：

//如果变量和函数不需要在“外面”引用，那么就可以使用一个没有名字的方法将他们全都包起来。
(function(){
var current = null;
function init(){...}
function change(){...}
function verify(){...}
})();

//如果变量和函数需要在“外面”引用，需要把你的变量和函数放在一个“命名空间”中
//我们这里用一个function做命名空间而不是一个var，因为在前者中声明function更简单，而且能保护隐私数据
myNameSpace = function(){
  var current = null;
  function init(){...}
  function change(){...}
  function verify(){...}
  //所有需要在命名空间外调用的函数和属性都要写在return里面
  return{
    init:init,
    //甚至你可以为函数和属性命名一个别名
    set:change
  }
}();
```

### 颠倒数组的位置：
```js
var a = [2, 3, 4, 5, 6];
for (var i = 0; i < a.length / 2; i++) {
    var temp = a[i];
    a[i] = a[a.length - 1 - i];
    a[a.length - 1 - i] = temp;
}
console.log(a);//[6, 5, 4, 3, 2]
```

### 判断闰年的方法:

```js
//年份能够被400整除.(2000)
//年份能够被4整除但不能被100整除.(2008)
function isLeapyear(year) {
    return ((year % 400 == 0) || (year % 4 == 0 && year % 100 != 0));
}
console.log(isLeapyear(2002));//false
console.log(isLeapyear(2004));//true
```
 
### //素数/质数：只能被1和这个数字本身整除的数字（输出100内的所有素数）

```js
for (var i = 2; i <= 100; i++) {
    var b = true;
    for (var j = 2; j < i; j++) {
        //除尽了说明不是质数 也就没有再往下继续取余的必要了
        if (i % j == 0) {
            b = false;
            break;
        }
    }
    if (b) {
        console.log(i);
    }
}
```
      

### 冒泡排序：就是将一个数组中的元素按照从大到小的顺序进行排列。
```js
var nums = [9, 81, 7, 16, 5, 41, 3, 21, 1, 0];
for (var i = 0; i < nums.length - 1; i++) {
    for (var j = 0; j < nums.length - 1 - i; j++) {
        if (nums[j] < nums[j + 1]) {//修改为 > 则从小到大排列
            var temp = nums[j];
            nums[j] = nums[j + 1];
            nums[j + 1] = temp;
        }
    }
}
console.log(nums);
```

### JQuery的`ready`和Dom的`onload`的区别

```js
// 当页面Dom元素加载完毕后时执行代码
$(document).ready(function() {
    alert(“加载完毕！”);
});
//相等
$(function() {
    alert(“加载完毕！”);
});
//注册事件的函数，和普通的dom不一样，不需要在元素上标记onload这样的事件。
```

JQuery的`ready`和Dom的`onload`的区别：

* `onload`是所有Dom元素创建完毕、图片、Css等都加载完毕后才被触发。
* `ready`则是Dom元素创建完毕后就被触发，这样可以提高网页的响应速度。
* 在JQuery中也可以用`$(window).load()`来实现onload那种事件调用的时机。

```js
//onload只能注册一次
window.onload=function(){
  alert(“加载完毕！”);
}
//后注册的取代前注册的，则ready则可以多次注册都会被执行。
```

### JQuery隐式迭代
如何判断对象是否存在，JQuery选择器返回的是一个对象数组，调用text(),html(),click()之类方法的时候其实是对数组中的每个元素迭代调用每个方法，因此即使通过id选择的元素不存在也不会报错，如果需要判断指定的id是否存在，应该写：
```js
if($());
```
**转载请标注原文地址**                           
(end)
