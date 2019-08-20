# CSS

## css的引入方式

* 内联：直接在html页面上使用style标签
* 嵌入：直接在html元素上，添加style属性
* 外联：通过在HTML上link标签引入，通过在css内@import引入

```html
<!-- @import 引入 -->
<style type="text/css" media="screen">
    @import url("http://www.test.com/test.css");
</style>

<!-- link 引入 -->
<link href="default.css" type="text/css" media="all" />
```

### link和@import的区别：

1. 老祖宗的差别，link属于XHTML标签，所以它支持定义RSS,定义rel连接属性，而@import是css提供的一种方式，只支持css
2. 加载顺序的差别，link会在页面加载时同时加载，而@import会在页面加载完毕后才开始加载
3. 兼容性的差别，link没有兼容性问题，@import是css2.1后提供的，所以在IE5以上的浏览器才能使用
4. 使用dom控制样式时的差别，当使用js控制DOM去改变css样式的时候，只能使用link标签，因为import是不能被DOM控制的。

## box盒子模型
所有HTML元素可以看作盒子，在css中，盒子模型是指由`margin(外边距)`，`padding(内边距)`，`border(边框)`和`content(内容)`组成的一个结构。通过这几个部分来确定一个元素的定位。

盒子模型有两种，IE盒子模型（IE5.X和6在怪异模式）content部分把border和padding计算了进去；W3C盒子模型，可以通过设置box-sizing为border-box来变成IE模型；

### box-sizing常用的属性有哪些？分别有什么作用？

>作用是：控制box以哪种”盒模型”（box model）渲染的

```css
box-sizing: content-box(default)|border-box|padding-box;
```

* content-box: 宽度和高度分别应用到元素的内容框（content），在内容框之外绘制内边距(padding)和边框(border)。
* border-box: 设置的宽度和高度应用在边框(border)上，宽高包括内边距(padding)和边框(border)的宽高。
* padding-box: 设置的宽高应用在内边距(padding)上，不包括边框(border)的宽高。

## BFC(块级格式化)
BFC (Block Formatting Context ）对布局的影响主要体现在对 float 和 margin 两个属性的处理。BFC 让 float 和 margin 这两个属性的表现更加符合我们的直觉。

### BFC的触发条件
BFC 可以被理解为元素的一个属性，但是这个属性无法被显式的设置，那么如何触发一个元素的 BFC 属性呢？在代码中使用 `overflow:hidden` 就是触发 BFC 的一种方式，除了设置 `overflow:hidden`，下面的 css 属性设置都可以触发 BFC:

* 父级元素，浮动元素：float 设置为除 none 之外的取值；
* 父级元素的overflow 设置为除 visible 之外的取值；
* 父级元素，绝对定位元素：position 设置为absolute 或 fixed；
* 父级元素，display 设置为 table-cell、table-caption、inline-block 中的任一取值；

详细内容：[css之BFC（块级格式化上下文）](http://lion1ou.win/2017/02/16/)

### overflow的属性

1. visible：默认值， 内容不会被修剪，会呈现在元素框外；
2. hidden：内容被修剪，超出部分会被隐藏，不显示；
3. scroll：内容被修剪，浏览器会生成滚动条以便查看超出部分内容；
4. auto：如果内容被修剪，浏览器会生成滚动条以便查看超出部分内容；

这里需要注意的是，scroll和auto的不同之处：

* scroll：不管内容有没有超出，都会生成上下和左右的滚动条
* auto： 只有内容超出，才会生成滚动条，不超出不生成，上下超出则生成上下滚动条，左右超出则生成左右滚动条。

### 清除浮动

浮动的框可以向左或向右移动，直到它的外边缘碰到`包含框`或`另一个浮动框`的边框为止。浮动元素`脱离文档流`，不占据空间。


* 在父级元素上使用:after和zoom属性（如上，不兼容低版本浏览器IE8+，推荐）
```html
<div class="father clearfloat">
    <div class="children1"></div>
    <div class="children2"></div>
</div>
```
```css
.father{
  border: 1px solid #f00;
}
.children1,.children2{
  float: left;
  height: 100px;
  width: 100px;
  border: 1px solid #ff0;
}
.clearfloat:after{
    display: block;
    clear: both;
    content: "";
    visibility: hidden;
}
.clearfloat{
    zoom: 1 /* zoom(IE专有属性)可解决ie6,ie7浮动问题 */
}
```
* 在结尾添加带有`{clear: both}`属性的空标签，清除浮动（增加无意义标签，浏览器支持好）
```html
<div class="father">
    <div class="children1"></div>
    <div class="children2"></div>
    <div class="clear"></div>
</div>
```
```css
.father{
  border: 1px solid #f00;
}
.children1,.children2{
  float: left;
  height: 100px;
  width: 100px;
  border: 1px solid #ff0;
}
.clear{
  clear: both;
}
```
* 在父级元素上添加`{overflow:hidden/auto}`样式，不能定义height，使用overflow:hidden时，浏览器会自动检查浮动区域的高度，触发BFC属性，使元素成为一个BFC容器（不能和position配合使用，因为超出的尺寸的会被隐藏或滚动）

```html
<div class="father">
    <div class="children1"></div>
    <div class="children2"></div>
</div>
```
```css
.children1,.children2{
  float: left;
  height: 100px;
  width: 100px;
  border: 1px solid #ff0;
}
.father{
  border: 1px solid #f00;
  overflow: hidden;
}
```

* 在父元素添加`{float: left/right}`属性，让整个div成为一个浮动整体（影响页面其他元素布局，没有真正解决问题，不推荐）
* 在相邻元素中添加`{clear: both}`属性（页面结构变动时，需要修改多个元素，不推荐）
* 在父级元素添加`{display: table}`,将div属性变成表格(不推荐)


## position的属性

* absolute：生成绝对定位的元素，相对于position属性为static`以外`的第一个父元素进行定位
* fixed：生成绝对定位的元素，相对于`浏览器窗口`进行定位（老IE不支持）
* relative：生成相对定位的元素，相对于其`正常位置`进行定位
* static 默认值。没有定位，元素出现在正常的流中（忽略 top, bottom, left, right z-index 声明）。
* inherit 规定从父元素继承 position 属性的值

### 描述z-index和叠加上下文是如何形成的。
首先来看在css中叠加上下文形成的原因：

1. 负边距
    >margin为负值时元素会依参考线向外偏移。一般可以利用负边距来进行布局，堆叠顺序由元素`在文档中的先后位置`决定，在`后面出现的`会在上面。
2. position的relative/absolute/fixed定位
    >当为元素设置position值为relative/absolute/fixed后，元素发生的偏移可能产生重叠，且z-index属性被激活。`z-index值`可以控制定位元素在垂直于显示屏方向（Z 轴）上的堆叠顺序（stack order），`值大的元素`会在值小的元素上面。
3. 使用相对性：z-index值只决定`同一父元素`中的同级子元素的堆叠顺序。
    >父元素的z-index值（如果有）为子元素定义了堆叠顺序（css版堆叠“拼爹”）。向上追溯找不到含有z-index值的父元素的情况下，则可以视为自由的z-index元素，它可以与父元素的同级兄弟定位元素或其他自由的定位元素来比较z-index的值，决定其堆叠顺序。同级元素的z-index值如果相同，则堆叠顺序由元素在文档中的先后位置决定，后出现的会在上面。所以如果当你发现一个z-index值较大的元素被值较小的元素遮挡了，请先检查它们之间的dom结点关系，多半是因为其父结点含有激活并设置了z-index值的position定位元素。

```html
<div style="position:relative; height: 100px;">
    <div style="position:absolute; z-index:100;background:green; height:100px; width:100px; "></div>
    <div style="position:absolute; z-index:99">
        <div style="position:absolute; z-index:101;background:red; height:100px; width:100px; "></div>
        <div style="position:absolute; z-index:103;background:yellow; height:100px; width:100px; "></div>
    </div>
</div>
```
代码效果：
<css-case1/>


## display的属性

* display:inline (默认值)
> inline元素`不会独占一行`，多个相邻的行内元素会排列在同一行里，直到一行排列不下，才会新换一行，`其宽度随元素的内容`而变化。 inline元素设置width,height属性`无效`。inline元素的margin和padding属性，`水平方向`的padding,margin可以产生边距效果；但`竖直方向`的padding，margin`不会`产生边距效果。

* display:block
> block元素会`独占一行`，多个block元素会各自新起一行。默认情况下，block元素`宽度自动填满`其父元素宽度。 block元素可以设置`width,height`属性。块级元素即使设置了宽度,仍然是独占一行。 block元素可以`设置margin和padding`属性。

* display:inline-block
> 简单来说就是将对象`呈现为inline对象`，但是对象的`内容作为block对象呈现`。多个内联对象会被排列在同一行内。比如我们可以给一个（a元素）inline-block属性值，使其既具有block的宽度高度特性又具有inline的同行特性。即对inline-block元素可以设置宽度和高度，同时inline-block元素又可以在同行进行排列。
> IE6和7是不支持这个属性的，需要通过`{*display:inline;zoom:1}`做hack处理。

* display:none  此元素不会被显示。
* display:list-item  像块类型元素一样显示，并添加样式列表标记。
* display:table  此元素会作为块级表格来显示。
* display:inherit  规定应该从父元素继承 display 属性的值。


### 解决inline-block元素之间有空隙问题

> li与li之间有看不见的空白间隔是什么原因引起的？有什么解决办法？

在inline-block的元素之间存在“4px”(Chrome下是8px)的空白，下面我们就来说说解决这个“4px”(Chrome下是8px)的几种方法：

* 改变HTML结构，如：将所有涉及到的标签放在同一行（不适用于HTML后端生成）
* 使用负margin的方法（不完美，可能会有偏差）
* 设置父元素`font-size: 0;`，然后在inline-block元素上重置字体大小（在Safari下可问题依然存在）
* 丢失inline-block元素的关闭标签
* 使用JQuery来改变“nodeType”值
* css完全兼容方法：在父元素中设置font-size:0,用来兼容chrome，而使用letter-space:-xx px来兼容safari。


## FlexBox

容器属性：

* flex-direction 属性决定主轴的方向（即项目的排列方向）(4)
* flex-wrap 属性定义如果一条轴线排不下，如何换行 (3)
* flex-flow 是前两项的简写形式
* justify-content 属性定义了项目在主轴（横轴）上的对齐方式 (5)
* align-items 属性定义项目在交叉轴（竖轴）上如何对齐 (5)
* align-content 属性定义了多根轴线的对齐方式。如果项目只有一根轴线，该属性不起作用 (6)

元素属性：

* order 属性定义项目的排列顺序。数值越小，排列越靠前，默认为0
* flex-grow 属性定义项目的放大比例，默认为0，即如果存在剩余空间，也不放大
* flex-shrink 属性定义了项目的缩小比例，默认为1，即如果空间不足，该项目将缩小
* flex-basis 属性定义了在分配多余空间之前，项目占据的主轴空间（main size）
* flex 前三者的简写，默认值为0 1 auto。后两个属性可选 `flex:auto (1 1 auto)`,`flex:none (0 0 auto)` ;
* align-self 属性允许单个项目有与其他项目不一样的对齐方式，可覆盖align-items属性

[详细内容:http://lion1ou.win/2016/10/15/](http://lion1ou.win/2016/10/15/)


## css选择器

|选择器|例子|描述|
|---|---|---|
|#id             | #name  |  选择 id="name" 的所有元素。|
|.class          | .intro |  选择 class="intro" 的所有元素。|
|element         | p      |  选择所有 `<p>` 元素。|
|伪类             |a:active|  选择被选定的a标签|
|[attribute]     |[target]|  选择带有 target 属性所有元素。|
|element,element |div,p   |  选择所有 `<div>` 元素和所有 `<p>` 元素。 |
|element element |div p   |  选择 `<div>` 元素内部的所有 `<p>` 元素。|
|element>element |div>p   |  选择父元素为 `<div>` 元素的所有 `<p>` 元素。|
|element+element |div+p   |  选择紧接在 `<div>` 元素之后的所有 `<p>` 元素。|
|*               | *      |  选择所有元素。通配符|

### css3新增伪类有那些？

|选择器| 描述|
|--|--|
|p:first-of-type |选择属于其父元素的首个`<p>`元素。|
|p:last-of-type |选择属于其父元素的最后 `<p>` 元素。|
|p:only-of-type |选择属于其父元素唯一的 `<p>`元素。|
|p:only-child |选择属于其父元素的唯一子元素。|
|p:nth-child(2) |选择属于其父元素的第二个子元素的每个 `<p>` 元素，还可以填写odd(奇数)或even(偶数)|
|:after |在元素之前添加内容,也可以用来做清除浮动。|
|:before |在元素之后添加内容|
|:enabled|表示任何启用的元素。如果一个元素能够被激活（如选择、点击或接受文本输入）或获取焦点，则该元素是启用的。|
|:disabled |控制表单控件的禁用状态。|
|:checked |单选框或复选框被选中|


### 伪元素/伪类

> ::before 和 :after中双冒号和单冒号有什么区别？解释一下这2个伪元素的作用?

单冒号(:)用于css3伪类，双冒号(::)用于css3伪元素。对于css2之前已有的伪元素，比如:before，单冒号和双冒号的写法::before作用是一样的。

* `伪类`的作用为，即允许选择一些无法用其他选择器选取的元素，必须对应某个现有的HTML元素，伪类用于向某些选择器添加特殊的效果。
* `伪元素`是它并不依赖于HTML树的结构，即可以创造新的元素，伪元素用于将特殊的效果添加到某些选择器。

```html
<!-- 这里用伪类 :first-child 和伪元素 :first-letter 来进行比较。 -->
<style>
   p>i:first-child {color: red}
</style>
<p>
    <i>first</i>
    <i>second</i>
</p>

<style>
   p:first-letter {color: red}
</style>
<p>first second</p>
```

### 子串匹配属性选择器

|选择器| 描述|
|--|--|
|[attribute]| 用于选取带有指定属性的元素。|
|[attribute=value]  | 用于选取带有指定属性和值的元素。|
|[attribute~=value] | 用于选取属性值中包含指定词汇的元素。|
|`[attribute|=value]` | 用于选取带有以指定值开头的属性值的元素，该值必须是整个单词。|
|[attribute^=value] | 匹配属性值以指定值开头的每个元素。|
|[attribute$=value] | 匹配属性值以指定值结尾的每个元素。|
|[attribute*=value] | 匹配属性值中包含指定值的每个元素。|

例子：

```css
a[href^="http://"]{
    color: red;
}
img[src|="abc"]{
    height: 100px;
}
*[lang*="en"]{
    color: red;
}
```

### 浏览器如何匹配某个css选择器？

浏览器会先产生一个元素集合，这个集合往往由最后一个部分的索引产生（如果没有索引就是所有元素的集合）。然后向上匹配，如果不符合上一个部分，就把元素从集合中删除，直到这个选择器都匹配完，还在集合中的元素就匹配这个选择器了。

举个例子，有选择器：

```css
body.ready #wrapper > .test{}
```

> 先把所有class中有test的元素拿出来组成一个集合，然后上一层，对每一个集合中的元素，如果元素的 父级id`不是`#wrapper则把元素从集合中删去。再向上匹配，从这个元素的父元素开始向上找，没有找到一个tagName为body且class中有ready的元素，就把原来的元素从集合中删去。最后留在集合内的元素就是选择器选择的元素。

## css优先级

* 通配选择符的权值 0,0,0,0
* 元素和伪元素，加0,0,0,1
* 类选择器、属性选择器或伪类，加0,0,1,0
* ID的权值为 0,1,0,0
* important的权值为最高 1,0,0,0("!important"会覆盖所有的样式规则(技术上 !important 与优先级毫无关系，应该尽量避免))
* 同权重情况下样式定义最近者为准，载入样式以最后载入的定位为准;

```css
a{color: yellow;} /*特殊性值：0,0,0,1*/
div a{color: green;} /*特殊性值：0,0,0,2*/
.demo a{color: black;} /*特殊性值：0,0,1,1*/
.demo input[type="text"]{color: blue;} /*特殊性值：0,0,2,1*/
.demo *[type="text"]{color: grey;} /*特殊性值：0,0,2,0*/
#demo a{color: orange;} /*特殊性值：0,1,0,1*/
div#demo a{color: red;} /*特殊性值：0,1,0,2*/
```

## css各种单位

> pt、px、rem和em的区别，vh,vw是什么？
* pt(point)是印刷行业常用的单位，等于1/72英寸，表示绝对长度。
* px像素（Pixel）。相对长度单位。像素px是`相对于显示器屏幕分辨率`而言的。
* em是相对单位。相对于当前对象内文本的字体尺寸。em会继承`父级元素`的字体大小，若父级元素没有定义字体大小，则相对于浏览器的默认字体尺寸。(任意浏览器的默认字体高都是16px。)
* rem是css3新增的一个相对单位，区别在于使用rem为元素设定字体大小时，仍然是相对大小，但`相对的只是HTML根元素`。（除了IE8及更早版本外，所有浏览器均已支持rem。）
* vh,vw 是相对于视口（viewpoint）的宽度或者高度，1vh=视口高度/100


## 样式继承

定义到元素本身的样式，包括浏览器默认样式，一定比继承得到的样式优先级高。因此，可以这样认定：继承得到的样式的优先级是最低的，在任何时候，只要元素本身有同属性的样式定义，就可以覆盖掉继承值：

* 不可继承的

display，margin，padding，border，background，height，min-height，max-height，width，min-width，max-width，overflow，position，left，right，top，bottom，z-index，float，clear，table-layout，vertical-align，page-break-after，page-bread-before，unicode-bidi

* 所有元素可继承

visibility，cursor(光标形状)

* 内联元素可继承

letter-spacing(字符间距)，word-spacing(单词间距)，white-space(文本是否换行)，line-height，color，font，font-family，font-size，font-style，font-variant(显示小型大写字母)，font-weight，text-decoration(文本修饰，横线)，text-transform(转换文本大小写)，direction(文字书写方向)

* 终端块状元素可继承

text-indent(段落首行缩进)，text-align。

* 列表元素可继承

list-style，list-style-type，list-style-position，list-style-image。



## 隐藏内容的方法

>考虑保证屏幕阅读器可用，屏幕阅读器：是为视觉上有障碍的人设计的读取屏幕内容的程序

1. `display: none;`搜索引擎可能认为被隐藏的文字属于垃圾信息而被忽略，屏幕阅读器会忽略被隐藏的文字。
2. `visibility: hidden;`隐藏的内容会占据它所应该占据物理空间。即内容虽然被隐藏，但是它所在的文档流的位置变成空白，会占据页面上的空间同时可以被屏幕阅读器发现。
3. `overflow: hidden; height: 0;`可以隐藏div内部的内容且同时可以被屏幕阅读器发现。
4. 利用定位将内容移出屏幕。
5. 将内容透明度设置为0.

### display:none;与visibility:hidden;的区别

* `display:none;`会让元素完全从渲染树中消失，渲染的时候不占据任何空间；`visibility:hidden;`不会让元素从渲染树消失，渲染时元素继续占据空间，只是内容不可见。
* `display:none;`是非继承属性，子孙节点消失由于元素从渲染树消失造成，造成子孙节点属性无法显示；`visibility:hidden;`是继承属性，子孙节点消失由于继承了hidden，通过设置visibility: visible;可以让子孙节点显式。
* 修改常规流中元素的display通常会造成文档`重排`，修改visibility属性只会造成本元素的`重绘`。
* 屏幕阅读器不会读取`display:none;`元素内容；会读取`visibility: hidden;`元素内容


## 媒体查询和媒体类型

media type(媒体类型)是css 2中的一个非常有用的属性，通过media type我们可以对不同的设备指定特定的样式，从而实现更丰富的界面。media query(媒体查询)是对media type的一种增强，是css3的重要内容之一。

* media type

```html
<link rel="stylesheet" type="text/css" href="style.css" media="screen print">
<style>
    @media screen{
        body{
            font-size: medium;
        }
    }
</style>
```

* media query事实上我们可以看成是media type+css属性判断。

```html
<!-- media=”screen and (animation)”是指有屏幕并且支持动画的媒体设备  -->
<link rel="stylesheet" media="screen and (animation)" herf="style1.css">
<style>
    @media screen and (max-width:240px){
        /* 前半部分就可以看为是媒体类型的规定，后面可以看做对媒体类型的css属性的判断。*/
        body{
            font-size: medium;
        }
    }
</style>
```

## 图片格式区分

* GIF：8位像素，256色，采用LZW压缩算法进行编码，支持简单动画，支持boolean透明
* PNG：无损压缩，文件小，支持索引透明和alpha透明，无动画，适合图标、背景、按钮(除了GIF不支持动画的优势，能用PNG的地方就用PNG，原因是压缩比高，色彩好)
* JPEG：颜色限于256色，有损压缩，可控制压缩质量，不支持透明，适合照片
* webp：2010年谷歌推出的图片格式，专门用来在web中使用，压缩率只有jpg的2/3或者更低，兼容性不太好, 只有opera,和chrome支持;
* base64：可以加密，减少了http请求，没有缓存（浏览器通过缓存css间接缓存），增大了css（可能造成渲染阻塞）、浏览器兼容问题。

详细介绍：[GIF/PNG/JPG和WEBP/base64/apng图片优点和缺点整理](http://www.cnblogs.com/diligenceday/p/4472035.html)

## css3新特性

1. 文本：text-overflow, white-space, text-decoration, text-shadow
2. 布局：column-count, box-sizing, flexbox, resize, outline-offset(轮廓)
3. 边框：border-raduis, border-image, box-shadow
4. 背景：background-size, background-origin, background-image: url('../test.png') url('../test.png'),backgroud: -webkit-linear-gradient(#fff, #666)
5. transfrom(2d：translate, rotate, scale, skew, matrix; 3d：rotateX, rotateY)
6. 过渡transition
7. 动画animation(通过@keymframs定义, animation引用)

[详情见blog：css3的新特性](http://lion1ou.win/2018/01/11/)



### 使用CSS实现三栏自适应布局（两边宽度固定，中间自适应）

https://blog.csdn.net/Cinderella_hou/article/details/52156333


## 其他小问题

### 如果设计中使用了非标准的字体，你该如何去实现？

1. 用图片代替。
2. 使用在线字库，如Google Webfonts，Typekit，@font-face 引入自定义字库

### 什么是FOUC? 如何避免？

* Flash Of Unstyled Content：用户定义样式表加载之前浏览器使用默认样式显示文档，用户样式加载渲染之后再重新显示文档，造成页面闪烁。
* 解决方法：把样式表放到文档的head

### 在网页中的应该使用奇数还是偶数的字体？为什么呢？

偶数，偶数字号相对更容易和 web 设计的其他部分构成比例关系。

### 如果需要手动写动画，你认为最小时间间隔是多久，为什么？（阿里）

多数显示器默认频率是60Hz，即1秒刷新60次，所以理论上最小间隔为1/60＊1000ms ＝ms

### css图片替换文字

有一些文字需要用图片来美化，例如LOGO、栏目标题等。为了保障可阅读性、搜索优化以及性能优化，我们不方便直接使用 img 标签来加载图片，而是使用 css 设置背景图片来达到替换文字的效果。

```html
<style>
    h1,
    h1 span {
        height: 200px;
        width: 200px;
        background-image:url('../img/images.jpg');
        font-size: 100%;
    }
    h1 span{
        display: block;
        position: relative;
        z-index: 1;
        margin-bottom: -200px;
    }
    h1{
        overflow: hidden;
    }
</style>
<h1><span></span>LOGO</h1>
```

### 实现不使用 border 画出1px高的线

在不同浏览器的标准模式与怪异模式下都能保持一致的效果。

```html
<div style="height:1px;overflow:hidden;background:red"></div>
```

### 如何在页面上实现一个圆形的可点击区域？

1. map + area
2. svg
3. border-radius
4. 纯js实现 需要求一个点在不在圆上简单算法、获取鼠标坐标等等


### 雪碧图（css Sprites）
Css 精灵 把一堆小的图片整合到一张大的图片上，减轻服务器对图片的请求数量。css Sprites其实就是把网页中一些背景图片整合到一张图片文件中，再利用css的“background-image”，“background-repeat”，“background-position”的组合进行背景定位，background-position可以用数字能精确的定位出背景图片的位置。

优点：

* 减少HTTP请求数，极大地提高页面加载速度
* 增加图片信息重复度，提高压缩比，减少图片大小
* 更换风格方便，只需在一张或几张图片上修改颜色或样式即可实现

缺点：

* 图片合并麻烦
* 维护麻烦，修改一个图片可能需要从新布局整个图片，样式

### css hack

由于不同的浏览器，比如IE5,IE6,IE7,FF等，对css的解析认识不一样，因此会导致生成的页面效果不一样，得不到我们所需要的页面效果。这个时候我们就需要针对不同的浏览器去写不同的css，让它能够同时兼容不同的浏览器，能在不同的浏览器中也能得到我们想要的页面效果。这个针对不同的浏览器写不同的css code的过程，就叫css hack。

## 纯css三角形

> 实现等边三角形，直角三角形

```css
.demo{
  width:0;
  height:0;
  border-width: 20px;
  border-style: solid;
  border-color: transparent transparent #000 transparent;
}
```

```css
.demo{
  width:0;
  height:0;
  border-bottom: 20px solid #ff0;
  /* border-top: 20px solid #0ff; */
  border-left: 20px solid #f0f;
  border-right: 20px solid #f8f;
}
```