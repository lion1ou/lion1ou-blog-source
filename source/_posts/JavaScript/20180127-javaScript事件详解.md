---
title: javaScript事件详解
toc: true
comments: true
date: 2018-01-27 10:38:32
categories: JavaScript
tags: JavaScript
photos:
---

<!--more-->
### 事件绑定和普通事件有什么区别
事件绑定就是针对dom元素的事件，绑定在dom元素上。普通事件即为非针对dom元素的事件。

* 普通事件不能同时注册多个事件
* 普通事件只在冒泡被调用

```js
// 普通事件
var btn = document.getElementById("hello");
btn.onclick = function(){
    alert(1);
};
btn.onclick = function(){
    alert(2);
}; //这个事件只会弹出2;
// 在事件冒泡过程中被调用
// 作为btn的属性绑定事件，function1会被function2覆盖而只执行function2;

// 事件绑定
var btn = document.getElementById("hello");
btn.addEventListener("click",function(){
    alert(1);
},false);
btn.addEventListener("click",function(){
    alert(2);
},false); //这个事件首先会弹出1，然后在弹出2;
```

### IE和DOM事件流的区别(事件模型)

##### 1.执行顺序不一样，IE采用冒泡型事件，DOM使用先捕获后冒泡型事件，Netscape使用捕获型事件
```html
<body>
    <div>
        <button>点击这里</button>
    </div>
</body>
```
* 冒泡型事件模型： button->div->body (IE事件流)
* 捕获型事件模型： body->div->button (Netscape事件流)
* DOM事件模型： body->div->button->button->div->body (先捕获后冒泡)

##### 2.事件侦听函数的区别（参数不同，事件是否"on"，this指向问题）

```js
// IE使用:
[Object].attachEvent("onclick", fnHandler); //绑定函数
[Object].detachEvent("onclick", fnHandler); //移除绑定
// IE下利用attachEvent注册的处理函数调用时，this指向不再是先前注册事件的元素，这时的this为window对象了

// DOM使用：(该方法既支持注册冒泡型事件处理，又支持捕获型事件处理)
[Object].addEventListener("click", fnHandler, false/true); //绑定函数
[Object].removeEventListener("click", fnHandler, false/true); //移除绑定
// 第三个参数注明该处理回调函数是在事件传递过程中的捕获阶段(true)被调用还是冒泡阶段(flase)被调用

// 通用方法，注册事件
function addEvent(element, type, handler) {
    if (element.addEventListener) {
        //事件类型、需要执行的函数、是否捕捉
        element.addEventListener(type, handler, false);
    } else if (element.attachEvent) {
        element.attachEvent('on' + type, function() {
            handler.call(element);
        });
    } else {
        element['on' + type] = handler;
    }
}
// 通用方法，移除事件
function removeEvent(element, type, handler) {
    if (element.removeEventListener) {
        element.removeEventListener(type, handler, false);
    } else if (element.datachEvent) {
        element.detachEvent('on' + type, handler);
    } else {
        element['on' + type] = null;
    }
}
// 通用方法，获取事件目标
function getTarget(event) {
    return event.target || event.srcElement;
}
```

##### 如何取消浏览器事件的传递

取消事件传递是指：停止捕获型事件或冒泡型事件的进一步传递。在body处理停止事件传递后，位于上层的document的事件监听器就不再收到通知，不再被处理。

```js
// IE下,通过设置event对象的cancelBubble为true
window.event.cancelBubble = true;

// DOM标准情况下，通过调用event对象的stopPropagation()方法
event.stopPropagation()

// 通用方法
function stopHandler(event) {
    window.event ? window.event.cancelBubble = true : event.stopPropagation();
};
```

##### 事件传递后浏览器的默认处理

事件传递后的默认处理是指：通常浏览器在事件传递并处理完后会执行与该事件关联的默认动作（如果存在这样的动作）

```js
// IE下通过设置event对象的returnValue为flase
window.event.returnValue = false

// DOM下调用event对象的preventDefault()方法
event.preventDefault()

// 通用方法
function cancelHandler(event){
  var event = event || window.event;  //用于IE
  if(event.preventDefault) event.preventDefault();  //标准技术
  if(event.returnValue) event.returnValue = false;  //IE
  return false;   //用于处理使用对象属性注册的处理程序
}

```

##### 应用场景

1. 捕获型事件传递由最不精确的祖先元素一直到最精确的事件源元素，传递方式与操作系统中的全局快捷键与应用程序快捷键相似。当一个系统组合键发生时，如果注册了系统全局快捷键监听器，该事件就先被操作系统层捕获，全局监听器就先于应用程序快捷键监听器得到通知，也就是全局的先获得控制权，它有权阻止事件的进一步传递。所以捕获型事件模型适用于作全局范围内的监听，这里的全局是相对的全局，相对于某个顶层结点与该结点所有子孙结点形成的集合范围。例如你想作全局的点击事件监听，相对于document结点与document下所有的子结点，在某个条件下要求所有的子结点点击无效，这种情况下冒泡模型就解决不了了，而捕获型却非常适合，可以在最顶层结点添加捕获型事件监听器
2. 可以说我们平时用的都是冒泡事件模型，因为IE只支持这模型。这里还是说说，在恰当利用该模型可以提高脚本性能。在元素一些频繁触发的事件中，如onmousemove, onmouseover,onmouseout,如果明确事件处理后没必要进一步传递，那么就可以大胆的取消它。此外，对于子结点事件监听器的处理会对父层监听器处理造成负面影响的，也应该在子结点监听器中禁止事件进一步向上传递以消除影响。

### 什么是事件代理（事件委托）

当我们需要对很多元素添加事件的时候，可以通过将事件添加到它们的父节点而将事件委托给父节点来触发处理函数。这主要得益于浏览器的事件冒泡机制
```html
<ul id="parent-list">
  <li id="post-1">Item 1</li>
  <li id="post-2">Item 2</li>
  <li id="post-3">Item 3</li>
  <li id="post-4">Item 4</li>
  <li id="post-5">Item 5</li>
  <li id="post-6">Item 6</li>
</ul>
```

当我们的鼠标移到Li上的时候，需要获取此Li的相关信息并飘出悬浮窗以显示详细信息，或者当某个Li被点击的时候需要触发相应的处理事件。我们通常的写法，是为每个Li都添加一些类似onMouseOver或者onClick之类的事件监听。

```js
// 获取父节点，并为它添加一个click事件
document.getElementById("parent-list").addEventListener("click",function(e) {
  // currentTarget属性，事件绑定的对象
  // 检查事件源e.targe是否为Li
  if(e.target && e.target.nodeName.toUpperCase == "LI") {
    // 真正的处理过程在这里
    console.log("List item ",e.target.id.replace("post-")," was clicked!");
  }
});
```

使用事件代理的好处是可以提高性能，可以大量节省内存占用，减少事件注册，比如在table上代理所有td的click事件就非常棒，还可以实现当新增子对象时无需再次对其绑定



**转载请标注原文地址**
