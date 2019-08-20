# HTML

## HTML语义化

* 根据页面需要使用合适的标签，即用正确的元素做正确的事
* 正确使用HTML标签，在`没有css样式`的情况保证页面以一种文档形式显示，保证可读性
* 搜索引擎的爬虫依赖于HTML标签来确定上下文和关键字的权重，正确使用标签`有利于seo`
* 正确使用标签有利于开发者`阅读维护理解`
* 宁可少用用对，不要多用用错

## 元素类型

根据css显示分类，HTML元素被分为三种类型:块状元素，内联元素，可变元素

1. 块状元素（block element）

* 1）块状元素在网页中就是以块的形式显示，所谓块状就是元素显示为矩形区域，常用的块状元素包块div,dl,dt,dd,ol,ul,(h1-h6),p,form,hr,table,tr,td等；
* 2）默认情况下，块状元素都会占据一行，通俗地说，两个相邻块状元素不会出现并列显示的现象；默认情况下，块状元素会按顺序自上而下排列。
* 3）块状元素都可以定义自己的宽度和高度。
* 4）块状元素一般都作为其他元素的容器，它可以容纳其它内联元素和其它块状元素。我们可以把这种容器比喻为一个盒子。width不写 默认100%；

2. 内联元素（inline element）（或是行内元素、行间元素、内嵌元素）

* 1) 常见的内联元素如：a,span,i,em,strong,b，img，input等
* 2) 内联元素的表现形式是始终以行内逐个进行显示；
* 3) 内联元素没有自己的形状，不能定义它的宽和高,它显示的宽度、高度只能根据所包含内容的高度和宽度来确定，它的最小内容单元也会呈现矩形形状；
* 4) 内联元素也会遵循盒模型基本规则，如可以定义padding,border,margin,background等属性，但个别属性不能正确显示;

3. 可变元素

* 需要根据上下文关系确定该元素是块元素或者内联元素块元素(block element)；`display: block/inline//list-item/table-cell/none;`大概有这么六种转变。盒模型主要下面三种转变。Block: 块级元素，可以设置宽高，独占一行。Inline: 内联元素，inline-block：既能设置宽高 有能一行显示。

## Doctype作用

* `<!DOCTYPE>`声明位于位于HTML文档中的第一行，处于 `<html>` 标签之前。告知浏览器的解析器用什么文档标准解析这个文档。DOCTYPE不存在或格式不正确会导致文档以兼容模式呈现

* 标准模式是规定浏览器`以自身支持的最高版本标准`来解析加载页面排版和js运作，`不支持已经废除的标签`。兼容模式是以较为宽松，`向后兼容的规则`进行解析加载页面。即一些已经废除的标签同样可以使用，模拟老式浏览器的行为以防止站点无法工作。

### HTML5为什么只需要写`<!DOCTYPE HTML>`

因为HTML5已经不再基于`SGML`，因此不需要对DTD进行引用，但需要`对doctpye来规范页面的加载方式`。HTML4.01是基于SGML，所以需要对DTD进行引用，来告知浏览器所使用的文档类型。

>DTD（文档类型定义）是一组机器可读的规则，规定版本每个版本中允许有什么，不允许有什么。在浏览器解析时，浏览器将根据这些规则检查页面有效性并做出相应的措施。

## H5新特性

html5新增了哪些知识点和作用

* 章节语意标签，比如：`<footer><article>`等，可以使我们创建更友好的页面结构，便于搜索引擎抓取；
* 表单元素，属性，比如：number、email、autocomplete等，可以让我们规定表单元素的输入类型，长度，表单元素的行为；
* 多媒体标签，比如： `<video> <audio>`。可以让我们定义多媒体文件的类型和行为；
* 2D绘图，矢量图应用，`<canvas> <svg>`标签可以让我们在网页上绘制复杂的图形和显示复杂的图形；
* 拖拽事件，`drag、drop` 事件可以让我们在网页上对元素进行拖放操作；
* 离线数据的存储，`localStorage sessionStorage`可以让开发者根据用户行为在客户端缓存数据，提高网站性能和用户体验；
* 获取当前用于的地理位置，`geolocation` 可以让我们不依赖客户端就可以获取用户位置；
* `Application Cache` 可以让我们对Web应用进行缓存，离线时也可以访问，增加用户体验；
* `web worker` 可以让我们脱离JavaScript是单线程的这个魔咒，而且web worker独立于其它的脚本不会影响页面性能；
* 被动的获取服务端数据，`EventSource` 对象可以让我们的应用程序不主动发送HTTP 请求的情况下接收服务端推送的消息，并且做出响应；

drag:

<drag-test></drag-test>

HTML5 现在已经不是 SGML 的子集，主要是关于图像，位置，存储，多任务等功能的增加。

* HTML5 引入audio和video两个新的媒体标签
* 引入 canvas 标签，实现图像绘画功能
* 引入localStorage和sessionStorage,用于本地离线存储
* 引入webworker,websocket,geolocation等新技术
* 添加表单控件: date、email、time、calendar、url、search
* 添加语义化标签，article/footer/header/nav/section

移除了：

* 纯表现的元素：basefont，big，center，font, s，strike，tt，u;
* 对可用性产生负面影响的元素：frame，frameset，noframes;

兼容性问题：

* IE8/IE7/IE6支持通过`document.createElement`方法产生的标签，可以使用`document.createElement()`方法添加新标签，添加新标签后还需要添加标签默认样式。

* 使用开源的成熟框架来解决这个问题：html5shim.js

## HTML本地存储
* cookie是网站为了标示用户身份而储存在用户本地终端（Client Side）上的数据（通常经过加密）。cookie数据始终在`同源的http请求`中携带（即使不需要），即会在浏览器和服务器间来回传递

* sessionStorage和localStorage不会自动把数据发给服务器，仅在本地保存

存储大小：

* cookie数据大小不能超过4k
* sessionStorage和localStorage虽然也有存储大小的限制，但比cookie大得多，可以达到5M或更大

有期时间：

* localStorage 存储持久数据，浏览器关闭后数据不丢失除非主动删除数据
* sessionStorage 数据在当前`浏览器窗口关闭`后自动删除
* cookie 设置的cookie过期时间之前一直有效，即使窗口或浏览器关闭

## HTML全局属性

全局属性(global attribute)是所有HTML元素共有的属性; 它们可以用于所有元素，尽管属性可能对某些元素没有影响。

* title 元素的相关信息
* data-*  为元素增加的自定义属性,允许HTML与和它对应DOM表现形式之间的专有信息交换
* style 行内CSS样式
* lang 元素内容语言
* id 元素id，文档内的唯一标识
* class 元素的类标识
* draggable 设置元素是否支持拖拽

## HTML5的离线缓存

在线的情况下，浏览器发现html头部有manifest属性，它会请求manifest文件，如果是第一次访问app，那么浏览器就会根据manifest文件的内容下载相应的资源并且进行离线存储。如果已经访问过app并且资源已经离线存储了，那么浏览器就会使用离线的资源加载页面，然后浏览器会对比新的manifest文件与旧的manifest文件，如果文件没有发生改变，就不做任何操作，如果文件改变了，那么就会重新下载文件中的资源并进行离线存储。离线的情况下，浏览器就直接使用离线存储的资源。

原理：HTML5的离线存储是基于一个新建的.appcache文件的缓存机制(不是存储技术)，通过这个文件上的解析清单离线存储资源，这些资源就会像cookie一样被存储了下来。之后当网络在处于离线状态下时，浏览器会通过被离线存储的数据进行页面展示

如何使用：

* 页面头部像下面一样加入一个manifest的属性；
* 在cache.manifest文件的编写离线存储的资源
* 在离线状态时，操作window.applicationCache进行需求实现

详细：[HTML离线存储](http://www.cnblogs.com/chyingp/archive/2012/12/01/explore_html5_cache.html)、
[HTML5 离线缓存-manifest简介](http://yanhaijing.com/html/2014/12/28/html5-manifest/)、
[有趣的HTML5：离线存储](http://segmentfault.com/a/1190000000732617)

## 其他问题

### XHTML与HTML有什么区别？

* HTML是一种基本的WEB页面设计语言，XHTML是一个基于XML的置标语言
* XHTML必须要关闭标签，不能随意嵌套，必须用小写字母，必须要有根标签

### `<img>`的title和alt有什么区别

title是在鼠标划过图片时显示，alt是在图片无法加载时显示。

### iframe有那些缺点？

* iframe会阻塞主页面的onload事件
* 搜索引擎的检索程序无法解读这种页面，不利于SEO
* iframe和主页面共享连接池，而浏览器对相同域的连接有限制，所以会影响页面的并行加载。
* 使用iframe之前需要考虑以上两个缺点。必须使用时，最好是通过javascript动态给iframe添加src属性值，这样可以绕开以上两个问题

### Canvas和SVG有什么区别？

SVG 是一种使用 XML 描述 2D 图形的语言。SVG 基于 XML，这意味着 SVG DOM 中的每个元素都是可用的。您可以为某个元素附加 JavaScript 事件处理器。在 SVG 中，每个被绘制的图形均被视为对象。如果 SVG 对象的属性发生变化，那么浏览器能够自动重现图形。

Canvas 通过 JavaScript 来绘制 2D 图形。Canvas 是逐像素进行渲染的。如果其位置发生变化，那么整个场景也需要重新绘制，包括任何或许已被图形覆盖的对象。

### 前端需要注意哪些SEO

1. 合理使用的head中的meta，title,description,keywords，权重逐个递减
2. 语义化的HTML代码，有利于搜索引擎理解网页内容
3. 重要内容放在页面前面，搜索引擎抓取有长度限制
4. 重要内容不要通过js输出，爬虫不会执行js获取内容
5. 少用iframe，搜索引擎不会获取iframe的内容
6. 非装饰的图片一定要使用alt属性
7. 提高网页速度有助于搜索引擎排名

### 什么叫优雅降级和渐进增强？(如何为有功能限制的浏览器提供网页？你会使用哪些技术和处理方法？)

优雅降级：即在所有新式浏览器上实现完美功能后，再根据老式浏览器的问题，进行相应的降级处理。针对不同版本的IE的hack实践，增加相应的替补方案，使之在旧式浏览器上以某种形式降级体验而不至于完全失效。

渐进增加：在所有浏览器支持的基础之上，在不影响旧式浏览器的前提下，渐进增加一些只有新式浏览器才支持的功能和效果。但浏览器支持时，页面效果和功能自动会显示出来。

### WEB标准以及W3C标准是什么?

WEB标准不是某一个标准，而是一系列标准的集合。网页主要由三部分组成：结构（Structure）、表现（Presentation）和行为（Behavior）。对应的标准也分三方面：结构化标准语言主要包括XHTML和XML，表现标准语言主要包括CSS，行为标准主要包括对象模型（如W3C DOM）、ECMAScript等。这些标准大部分由W3C起草和发布，也有一些是其他标准组织制订的标准，比如ECMA（European Computer Manufacturers Association）的ECMAScript标准。

### HTML5的form如何关闭自动完成功能？

给不想要自动完成的form或某个input设置为`autocomplete=off`。

### 如何实现浏览器内多个标签页之间的通信? (阿里)

WebSocket、SharedWorker(共享进程接口)；也可以调用localstorge、cookies等本地存储方式；

localstorge另一个浏览上下文里被添加、修改或删除时，它都会触发一个事件，我们通过监听事件，控制它的值来进行页面信息通信；

>注意quirks：Safari 在无痕模式下设置localstorge值时会抛出 QuotaExceededError 的异常；

### 网页验证码是干嘛的，是为了解决什么安全问题。

1. 区分用户是计算机还是人的公共全自动程序。可以防止恶意破解密码、刷票、论坛灌水；
2. 有效防止黑客对某一个特定注册用户用特定程序暴力破解方式进行不断的登陆尝试。

### 页面可见性（Page Visibility API） 可以有哪些用途？

1. 通过 visibilityState 的值检测页面当前是否可见，以及打开网页的时间等;
2. 在页面被切换到其他后台进程的时候，自动暂停音乐或视频的播放；

[用 visibilitychange 事件判断页面可见性 ](http://www.css88.com/archives/6103)

### title与h1的区别、b与strong的区别、i与em的区别？

* title属性没有明确意义只表示是个标题，H1则表示层次明确的标题，对页面信息的抓取也有很大的影响；
* strong是标明重点内容，有语气加强的含义，使用阅读设备阅读网络时：`<strong>`会重读，而`<b>`是展示强调内容。
* i内容展示为斜体，em表示强调的文本；

Physical Style Elements -- 自然样式标签:b, i, u, s, pre

Semantic Style Elements -- 语义样式标签:strong, em, ins, del, code

应该准确使用语义样式标签, 但不能滥用, 如果不能确定时首选使用自然样式标签。

### label标签

可以直接使用label标签和input，通过input标签的id属性和label标签的for属性绑定，然后就可以直接通过点击label标签绑定对应的value，input标签上的name则是它们的key

```html
<!-- 带有两个输入字段和相关标记的简单 HTML 表单： -->
<form>
  <label for="male">Male</label>
  <input type="radio" name="sex" id="male" />
  <br />
  <label for="female">Female</label>
  <input type="radio" name="sex" id="female" />
</form>
```

### 把 Script 标签 放在页面的最底部的 body 封闭之前 和封闭之后有什么区别？浏览器会如何解析它们？

html标签只包含head 和body两个标签，解析时，所有标签都会解析进这两个标签里边。body之前的任何位置都会解析进head里边，之后的都会解析进body里边。

### documen.write和 innerHTML的区别?

* document.write是直接写入到页面的内容流，如果在写之前没有调用document.open, 浏览器会自动调用open。每次写完关闭之后重新调用该函数，会导致页面被重写。
* innerHTML则是DOM页面元素的一个属性，代表该元素的html内容。你可以精确到某一个具体的元素来进行更改。如果想修改document的内容，则需要修改document.documentElement.innerElement,且innerHTML将内容写入某个DOM节点，不会导致页面全部重绘。

