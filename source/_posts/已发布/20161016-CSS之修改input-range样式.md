---
title: CSS之修改input range样式
toc: true
comments: true
categories: 技术博客
tags: CSS
date: 2016-10-16 20:33:59
photos:
description:
---

今天来探讨一下 HTML5 的 `range` 这个新的 input 类型，不过重点不是在 `range` 要如何使用，而是在如何去改变 `range` 的样式，做出一个漂漂亮亮的滑动杆。

过去我们要制作美美的滑动杆 ( `range slider` )，不外乎就是用个 `span` 或 `div` ，搭配判断滑鼠座标 ( pageX、pageY ) 与点击事件来制作，就算是 HTML5 具有了 `range` 的 `input` 类型，预设的样式只能满足基本的需求，对于有一些要求视觉设计的网站来说，根本就毫无用武之地，只好自己手动干一个 `range slider` 来用了。
<!--more-->

虽然这篇会介绍两种修改 `range` 样式的方法，但由于 HTML5 与 CSS3 在各个浏览器之间仍然没有完全统一 ( 虽然之前好像就说标准制定完成了 )，所以要改变 `range` 的样式，仍然必须使用到各家浏览器自己的特有写法来调整，因此下列的范例，主要以 Chrome 为主，也会介绍 Firefox 的用法，至于 IE，能吃吗？哈哈哈~~

首先要来写一个 range 出来，min 是最小值，max 是最大值，step 是每隔间距，value 是预设数值：
 
```html
<input type="range" min="0" max="100" step="1" value="50">
```

如果没有意外，看到的长相就会是下面这个样子非常的....嗯...你懂的...

<input type="range" min="0" max="100" step="1" value="50">

#### 第一种方法

纯 CSS 的做法，由于 `range` 是 `input` 的一种类型，我们无法用传统的 CSS 编辑方法来修改样式，这裡必须要使用到`-webkit-appearance`这个特殊属性，这是 `webkit` 特有的属性，代表使用系统预设的外观，可惜 `W3C` 到写这篇文章的时候，都还没有纳入规范 ( 不然 `webkit` 简直是神呀 )，只要我们将这个属性设为`none`，那麽原本 `range` 的样式就不会呈现了，这时我们只要加入自己的背景、阴影...等样式，就可以看到样式被换过来了。

```css
input[type="range"]{
  -webkit-appearance: none;
  overflow:hidden;     /* 限定范围 */
  width:200px;
  height:20px;
  outline : none;      /* 避免点选会有蓝线或虚线 */
  background:none;
}
```
 

![](http://ww2.sinaimg.cn/large/006tNbRwgw1fapes1ngc8g30bf01pq2v.gif)

上面的 CSS 只是针对 `range` 的本体，但还有一个拉把的按钮样式还没改，这时候我们要使用另外一个 webkit 的伪元素`::-webkit-slider-thumb`来修改。

```css
input[type="range"]::-webkit-slider-thumb{
  -webkit-appearance: none;
  position: relative;    /* 设为相对位置，为了前后区块的绝对位置而设定 */
  width:10px;
  height:10px;
  background:#f22;
  border-radius:50%;
  transition:.2s;        /* 点选放大时候的渐变时间 */
}
```

写完上面这两段，应该就可以看到`range slider`变成下面这个样子只有一个红点，然后这个红点可以左右拉动。

![](http://ww4.sinaimg.cn/large/006tNbRwgw1fapeqn641pg30bf01pjre.gif)

接下来要进行的步骤就是加上一些颜色和效果，主要让圆点左边的区域是红色，右边的区域是浅红色，这样看起来才像是不同的 `range`，为了达到这个目的，我们要使用`伪元素裡面的伪元素`，也就是在 webkit 的`::-webkit-slider-thumb`伪元素的前后，各再安插`:before`和`:after`的伪元素，并让这两个伪元素颜色不同，就可以做出前后颜色差异的效果。

```css
input[type="range"]::-webkit-slider-thumb:before,
input[type="range"]::-webkit-slider-thumb:after
{
  position: absolute;
  top: 3px;
  width: 2000px;          /* 长度很长没关係，因为刚刚有用 overflow:hidden 了 */
  height: 4px;
  content:"";
  pointer-events: none;   /* 让滑鼠可以点击穿透伪元素，不然会点不到下面 */
  transition:.2s;
}

input[type="range"]::-webkit-slider-thumb:before{
  left: -1997px;
  background: #f22;
}
input[type="range"]::-webkit-slider-thumb:after {
  left: 10px;
  background: #edc;
}
```
 

这样写完之后，应该就已经可以看到前后不同颜色的 `range slider` 效果。

![](http://ww4.sinaimg.cn/large/006tNbRwgw1fapfbrwsd6g305v01paa3.gif)

不过光是这样还不够，接着我们要来让点击的时候圆圈会变大，本来想做滑鼠移上去就会变大，但两层伪元素虽然会变大，但位置却无法控制，所以就只好用 `active` 来代替。

```css
input[type="range"]:active::-webkit-slider-thumb:before,
input[type="range"]:active::-webkit-slider-thumb:after
{
  top: 6px;
}

input[type="range"]:active::-webkit-slider-thumb{
  width:16px;
  height:16px;
}

input[type="range"]:active::-webkit-slider-thumb:after {
  left: 16px;
}
```


完成之后的长相就会像下图这样。

![](http://ww3.sinaimg.cn/large/006tNbRwgw1fapfcqqz53g305v01pdfw.gif)

不过如果是 `Firefox`，就必须要做一些修改，因为 `Firefox` 是认不得 `webkit` 的，要在 `Firefox` 跑的 CSS 就要写成下面这样，相较于 `webkit`，`Firefox` 就显得比较直觉，因为他裡面具有一个`::-moz-range-progress`的伪元素，利用这个伪元素，我们就不用在前后加个区块，他直接就可以呈现 range 的色彩囉！

```css
input[type="range"]{
  width:200px;
  height:16px;
  outline : none;
  background:none;
}

input[type="range"]::-moz-range-track{
  height:4px;
  background:#edc;
  border:none;
}

input[type="range"]::-moz-range-thumb{
  width:10px;
  height:10px;
  background:#f22;
  border:none;
  border-radius:50%;
}

input[type="range"]::-moz-range-thumb:hover,input[type="range"]:active::-moz-range-thumb{
  width:16px;
  height:16px;
}

input[type="range"]::-moz-range-progress{
  height:4px;
  background:#f22;
}

input[type="range"]::-moz-focus-outer{
  border:none;    /* 去除 focus 时候的外框虚线 */
}
```


#### 第二种方法

接着介绍一下如何用`CSS + jQuery`做出一样的效果，同样的，我们要先用`-webkit-appearance`把原始样式隐藏，先看到`input[type="range"]`的样式，这边我利用背景颜色渐层的方式，来完成左右颜色不同的效果 ( 虽然方便，但相对的就不能用纯 CSS 控制 )。

```css
input[type="range"]{
  -webkit-appearance: none;
  border-radius:2px;
  width:200px;
  height:3px;
  background-image:-webkit-linear-gradient(left ,#f22 0%,#f22 50%,#fff 50%, #fff 100%);
  box-shadow:inset #ebb 0 0 5px;
  outline : none;
  transition:.1s;
}
```
 
接着看到input[type="range"]::-webkit-slider-thumb的样式，并加上 hover 的效果：

```css
input[type="range"]::-webkit-slider-thumb{
  -webkit-appearance: none;
  width:10px;
  height:10px;
  background:#f22;
  border-radius:50%;
  transition:.1s;
}

input[type="range"]::-webkit-slider-thumb:hover,
input[type="range"]::-webkit-slider-thumb:active{
  width:16px;
  height:16px;
}
```

因为背景是用渐层产生的呀，如果要动态改背景，就不是纯 CSS 能办得到的领域，这时候就要借助 jquery 来帮忙了，利用简单的focus和mousemove，我们就可以让背景跟着移动咯！

```js
$(function(){
  var r = $('input');
  r.on('mouseenter',function(){
    var p = r.val();
    r.on('click',function(){
      p = r.val();
      bg(p);
    });
    r.on('mousemove',function(){
      p = r.val();
      bg(p);
    });
  });
  function bg(n){
      r.css({
        'background-image':'-webkit-linear-gradient(left ,#f22 0%,#f22 '+n+'%,#fff '+n+'%, #fff 100%)'
      });
  }
});
```

以上就是用 CSS 和 jQuery 去修改 `range slider` 样式的基本方法，分享给大家，活用这个方法，就可以做出许多非常有特色的 `range slider` 囉。

**转载请标注原文地址**

(end)
