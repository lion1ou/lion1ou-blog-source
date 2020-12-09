---
title: JavaScript原生绑定事件的三种方法
toc: true
comments: true
categories: JavaScript
date: 2016-08-15 21:53:09
tags: JavaScript
---

## 概述

要想让 JavaScript 对用户的操作作出响应，首先要对 DOM 元素绑定事件处理函数。所谓事件处理函数，就是处理用户操作的函数，不同的操作对应不同的名称。在 JavaScript 中，有三种常用的绑定事件的方法：

<!-- more -->

1. 在 DOM 元素中直接绑定；
2. 在 JavaScript 代码中绑定；
3. 绑定事件监听函数。

### 在 DOM 元素中直接绑定

1. 绑定原生函数

```html
<input onclick="alert('alert')" type="button" value="点击我，弹出alert" />
```

<input  onclick="alert('alert')"  type="button"  value="点击我，弹出alert" />

2. 绑定自定义函数

```html
<input onclick="myAlert()" type="button" value="点击我，弹出alert" />
<script type="text/javascript">
  function myAlert() {
    alert("alert");
  }
</script>
```

<input  onclick="myAlert()"  type="button"  value="点击我，弹出alert" />
<script type="text/javascript">
function myAlert(){
    alert("alert");
}
</script>

### 在 JavaScript 代码中绑定

```html
<input id="demo" type="button" value="点击我，显示 type 属性" />
<script type="text/javascript">
  document.getElementById("demo").onclick = function () {
    alert(this.getAttribute("type")); //  this 指当前发生事件的HTML元素，这里是<div>标签
  };
</script>
```

通过 getElement 获取指定 Dom 元素，然后绑定一个事件，这样使 javascript 代码和 HTML 标签分离，文档结构更加清晰，便于管理和开发。

<input  id="demo"  type="button"  value="点击我，显示 type 属性" />
<script type="text/javascript">
document.getElementById("demo").onclick=function(){
    alert(this.getAttribute("type"));  //  this 指当前发生事件的HTML元素，这里是<div>标签
}
</script>

### 绑定事件监听函数

这种方式是用 addEventListener() 或 attachEvent() 来绑定事件监听函数。

语法：`element.addEventListener(event, handle, useCapture)`

参数值：

| 参数       | 描述                                                                                                                     |
| ---------- | ------------------------------------------------------------------------------------------------------------------------ |
| event      | 必须。字符串，指定事件名。注意: 不要使用 "on" 前缀。 例如，使用 "click" ,而不是使用 "onclick"。                          |
| handle     | 必须。指定要事件触发时执行的函数。当事件对象会作为第一个参数传入函数。                                                   |
| useCapture | 可选。布尔值，指定事件是否在捕获或冒泡阶段执行。可能值:true,事件句柄在捕获阶段执行。false,默认，事件句柄在冒泡阶段执行。 |

attachEvent()函数语法：`element.attachEvent(eventName,handle)`

| 参数      | 说明                                                                                           |
| --------- | ---------------------------------------------------------------------------------------------- |
| eventName | 事件名称。注意，与 addEventListener()不同，这里的事件名称有“ on ”，如鼠标单击事件 onclick 等。 |
| handle    | 事件句柄函数，即用来处理事件的函数。                                                           |

注意：

> addEventListener()是标准的绑定事件监听函数的方法，是 W3C 所支持的，Chrome、FireFox、Opera、Safari、IE9.0 及其以上版本都支持该函数；
> 但是，IE8.0 及其以下版本不支持该方法，它使用 attachEvent()来绑定事件监听函数。
> 所以，这种绑定事件的方法必须要处理浏览器兼容问题。如果浏览器不支持 addEventListener() 方法, 你可以使用 attachEvent() 方法替代。

以下实例演示了跨浏览器的解决方法：

```js
function addEvent(obj, type, handle) {
  try {
    // Chrome、FireFox、Opera、Safari、IE9.0及其以上版本
    obj.addEventListener(type, handle, false);
  } catch (e) {
    try {
      // IE8.0及其以下版本
      obj.attachEvent("on" + type, handle);
    } catch (e) {
      // 早期浏览器
      obj["on" + type] = handle;
    }
  }
}
function handle() {
  //这里写绑定事件的动作代码
}
```

> 这里使用 try{ ... } catch(e){ ... } 代替 if ... else... 语句，避免浏览器出现错误提示。

### 参考

- [JavaScript 事件参考手册](http://www.w3school.com.cn/jsref/jsref_events.asp)
- [原文链接](http://www.itxueyuan.org/view/6338.html)
