---
title: call、apply和bind的区别
toc: true
comments: true
date: 2018-01-26 10:40:55
categories:
tags:
photos:
---

JavaScript的一大特点是，函数存在`定义时的上下文`和`运行时的上下文`以及`上下文是可以改变的`这样的概念。call、apply和bind都是为了改变某个函数运行时的上下文而存在的，换句话说，就是为了改变函数体内部this的指向。以下是三个相似点：

<!--more-->

* 都是用来改变函数的this对象的指向的。
* 第一个参数都是this要指向的对象。
* 都可以利用后续参数传参。

```js
function student () {}

student.prototype = {
  age: 18,
  name: '小明',
  say: function () {
    document.write(`我的名字叫${this.name},今年${this.age}岁。<br>`)
  }
}

var student1 = new student()
student1.say()

var student2 = {
  name: '小红',
  age: 20
}

student1.say.call(student2)
student1.say.apply(student2)
student1.say.bind(student2)()
```

##### call 和 apply 的区别

对于 apply、call 二者而言，作用完全一样，只是接受参数的方式不太一样。

```js

function student () {}

student.prototype = {
  age: 18,
  name: '小明',
  say: function (school, className) {
    document.write(`我的名字叫${this.name},今年${this.age}岁。就读于${school}${className}<br>`)
  }
}

var student1 = new student()
var student2 = {
  name: '小红',
  age: 12
}

var student3 = {
  name: '小华',
  age: 15
}
student1.say.call(student2,'实验小学','五年级')   // 直接接在后面，在已经参数数量的情况下使用
student1.say.apply(student3,['实验中学','初一'])  // 通过数组形式，在未知参数数量时，可通过push方式，为数组添加参数
// call 需要把参数按顺序传递进去，而 apply 则是把参数放在数组里。
```

##### bind

bind()方法与apply/call很相似，也可以改变函数内this的指向的。

MDN的解释是：bind()方法会创建一个新函数，称为绑定函数，当调用这个绑定函数时，绑定函数会以创建它时传入 bind()方法的第一个参数作为 this，传入 bind() 方法的第二个以及以后的参数加上绑定函数运行时本身的参数按照顺序作为原函数的参数来调用原函数。

```js
var foo = {
  bar: 1,
  eventBind : function () {
    document.getElementById('bind').onclick = function () {
      console.log(this)
    }
  }
}
foo.eventBind() 
// <div id="bind">点击</div>

var foo = {
  bar: 1,
  eventBind : function () {
    document.getElementById('bind').onclick = function () {
      console.log(this)
    }.bind(this)
  }
}
foo.eventBind() 
// {bar: 1, eventBind: ƒ}
```

### bind、call、apply 三者区别

```js
var obj = {
    x: 81,
};
 
var foo = {
    getX: function() {
        return this.x;
    }
}
 
console.log(foo.getX.bind(obj)());  //81
console.log(foo.getX.call(obj));    //81
console.log(foo.getX.apply(obj));   //81
```

* apply 、 call 、bind 三者都是用来改变函数的this对象的指向的；
* apply 、 call 、bind 三者第一个参数都是this要指向的对象，也就是想指定的上下文；
* apply 、 call 、bind 三者都可以利用后续参数传参；
* apply 、call 区别在于传递参数的类型，call按顺序传递可确定个数参数
* bind 是返回对应函数，便于稍后调用；apply 、call 则是立即调用 。

[详细参考链接：http://web.jobbole.com/83642/](http://web.jobbole.com/83642/)

**转载请标注原文地址**

