---
title: ReactNative之样式手册
toc: true
comments: true
date: 2018-05-29 18:33:52
categories: 前端技术
tags: ReactNative
photos:
---

在React Native中，你并不需要学习什么特殊的语法来定义样式。我们仍然是使用JavaScript来写样式。所有的核心组件都接受名为style的属性。这些样式名基本上是遵循了web上的CSS的命名，只是按照JS的语法要求使用了驼峰命名法，例如将background-color改为backgroundColor。以下备忘一下，常用的样式和用法说明。

<!-- more -->

## Properties 属性

### Text 文本

|属性名 |取值 | 描述 |
|---|---|---|
|color| `<color>` | 对应 CSS 中的 color 属性|
|fontFamily| string | 对应 CSS 中的 font-family 属性|
|fontSize| `<number>` | 对应 CSS 中的 font-size 属性 |
|fontStyle | normal, italic | 对应 CSS 中的 font-style 属性，但阉割了 oblique 取值 |
|fontWeight | normal, bold 100~900 | 对应 CSS 中的 font-weight 属性，但阉割了 bolder, lighter 取值 |
|lineHeight | `<number>` | 对应 CSS 中的 line-height 属性 |
|textAlign | auto, left, right, center, justify`iOS` | 对应 CSS 中的 text-align 属性，增加了 auto 取值 |
|textAlignVertical`Android` | auto, top, bottom, center | 对应 CSS 中的 vertical-align 属性，增加了 auto 取值，center 取代了 middle，并阉割了 baseline, sub 等值 |
|textShadowColor | `<color>` | 对应 CSS 中的 text-shadow 属性中的颜色定义 |
|textShadowOffset | { width: `<number>`, height: `<number>` } | 对应 CSS 中的 text-shadow 属性中的阴影偏移定义 |
|textShadowRadius | `<number>` | 在 CSS 中，阴影的圆角大小取决于元素的圆角定义，不需要额外定义 |
|letterSpacing`iOS` | `<number>` | 对应 CSS 中的 letter-spacing 属性，但取值不同 |
|textDecorationColor`iOS` | `<color>` | 对应 CSS 中的 text-decoration-color 属性 |
|textDecorationLine`iOS` | none, underline, line-through, underline line-through | 对应 CSS 中的 text-decoration-line 属性，但阉割了 overline, blink 取值 |
|textDecorationStyle`iOS` | solid, double, dotted, dashed | 对应 CSS 中的 text-decoration-style 属性，但阉割了 wavy 取值 |
|writingDirection`iOS` | auto, ltr, rtl | 对应 CSS 中的 direction 属性，增加了 auto 取值 |

### Dimension 尺寸

|属性名 | 取值 | 描述 |
|---|---|---|
|width | `<number>`| 对应 CSS 中的 width 属性 |
|height |`<number>`| 对应 CSS 中的 height 属性 |

### Positioning 定位

|属性名 | 取值 | 描述 |
|---|---|---|
|position | absolute, relative | 对应 CSS 中的 position 属性，但阉割了 static, fixed 取值|
|top |`<number>`  | 对应 CSS 中的 top 属性|
|right |  `<number>`  |  对应 CSS 中的 right 属性|
|bottom | `<number>`  |  对应 CSS 中的 bottom 属性|
|left |   `<number>`  |  对应 CSS 中的 left 属性|
|zIndex |   `<number>`  |  对应 CSS 中的 z-index 属性|

### Margin 外部白

|属性名| 取值 | 描述|
|---|---|---|
|margin|  `<number>` |   对应 CSS 中的 margin 属性，不同的是，只能定义一个参数，用以表示上、右、下、左4个方位的外补白|
|marginHorizontal| `<number>` |  CSS中没有对应的属性，相当于同时设置marginRight和marginLeft|
|marginVertical| `<number>` |   CSS中没有对应的属性，相当于同时设置marginTop和marginBottom|
|marginTop| `<number>` | 对应 CSS 中的 margin-top 属性|
|marginRight| `<number>` | 对应 CSS 中的 margin-right 属性|
|marginBottom| `<number>` | 对应 CSS 中的 margin-bottom 属性|
|marginLeft| `<number>` | 对应 CSS 中的 margin-left 属性|

### Padding 内部白

|属性名 | 取值 | 描述|
|---|---|---|
|padding| `<number>` |  对应 CSS 中的 padding 属性，不同的是，只能定义一个参数，用以表示上、右、下、左4个方位的内补白|
|paddingHorizontal| `<number>` |  CSS中没有对应的属性，相当于同时设置paddingRight和paddingLeft|
|paddingVertical| `<number>` |  CSS中没有对应的属性，相当于同时设置paddingTop和paddingBottom|
|paddingTop| `<number>` | 对应 CSS 中的 padding-top 属性|
|paddingRight| `<number>` | 对应 CSS 中的 padding-right 属性|
|paddingBottom| `<number>` | 对应 CSS 中的 padding-bottom 属性|
|paddingLeft| `<number>` | 对应 CSS 中的 padding-left 属性|

### Border 边框

|属性名| 取值 | 描述|
|---|---|---|
|borderStyle| solid, dotted, dashed | 对应 CSS 中的 border-style 属性，但阉割了 none, hidden, double, groove, ridge, inset, outset 取值，且无方向分拆属性|
|borderWidth| `<number>` | 对应 CSS 中的 border-width 属性|
|borderTopWidth| `<number>` | 对应 CSS 中的 border-top-width 属性|
|borderRightWidth| `<number>` | 对应 CSS 中的 border-right-width 属性|
|borderBottomWidth| `<number>` | 对应 CSS 中的 border-bottom-width 属性|
|borderLeftWidth| `<number>` | 对应 CSS 中的 border-left-width 属性|
|borderColor| `<color>` | 对应 CSS 中的 border-color 属性|
|borderTopColor|  `<color>` | 对应 CSS 中的 border-top-color 属性|
|borderRightColor| `<color>` | 对应 CSS 中的 border-right-color 属性|
|borderBottomColor| `<color>` | 对应 CSS 中的 border-bottom-color 属性|
|borderLeftColor| `<color>` | 对应 CSS 中的 border-left-color 属性|
|borderRadius| `<number>` | 对应 CSS 中的 border-radius 属性|
|borderTopLeftRadius| `<number>` | 对应 CSS 中的 border-top-left-radius 属性|
|borderTopRightRadius| `<number>` | 对应 CSS 中的 border-top-right-radius 属性|
|borderBottomLeftRadius| `<number>` | 对应 CSS 中的 border-bottom-left-radius 属性|
|borderBottomRightRadius| `<number>` | 对应 CSS 中的 border-bottom-right-radius 属性|
|shadowColor| `<color>` |对应 CSS 中的 box-shadow 属性中的颜色定义|
|shadowOffset | { width: `<number>`, height: `<number>` } | 对应 CSS 中的 box-shadow 属性中的阴影偏移定义|
|shadowRadius | `<number>` | 在 CSS 中，阴影的圆角大小取决于元素的圆角定义，不需要额外定义|
|shadowOpacity | `<number>` | 对应 CSS 中的 box-shadow 属性中的阴影透明度定义|

### Background 背景

|属性名| 取值 | 描述|
|---|---|---|
|backgroundColor| `<color>` | 对应 CSS 中的 background-color 属性|

### Transform 转换

|属性名| 取值 | 描述|
|---|---|---|
|transform | [{perspective: number}, {rotate: string}, {rotateX: string}, {rotateY: string}, {rotateZ: string}, {scale: number}, {scaleX: number}, {scaleY: number}, {translateX: number}, {translateY: number}, {skewX: string}, {skewY: string}] | 对应 CSS 中的 transform 属性|
|transformMatrix |TransformMatrixPropType |类似于 CSS 中 transform 属性的 matrix() 和 matrix3d() 函数|
|backfaceVisibility  |visible, hidden| 对应 CSS 中的 backface-visibility 属性|

### Flexbox 弹性盒

|属性名 |取值 | 描述|
|---|---|---|
|flex | `<number>` | 对应 CSS 中的 flex 属性|
|flexDirection | row, column |对应 CSS 中的 flex-direction 属性，但阉割了 row-reverse, column-reverse 取值，默认值是column而不是row|
|flexWrap | wrap, nowrap | 对应 CSS 中的 flex-wrap 属性，但阉割了 wrap-reverse 取值|
|justifyContent | flex-start, flex-end, center, space-between, space-around | 对应 CSS 中的 justify-content 属性，但阉割了 stretch 取值。|
|alignItems | flex-start, flex-end, center, stretch  | 对应 CSS 中的 align-items 属性，但阉割了 baseline 取值，默认值是stretch而不是flex-start，stretch只有在不设置尺寸的时候才生效|
|alignSelf | auto, flex-start, flex-end, center, stretch |对应 CSS 中的 align-self 属性，但阉割了 baseline 取值|

### Other 其他

|属性名 |取值 | 描述|
|---|---|---|
|opacity |`<number>` | 对应 CSS 中的 opacity 属性|
|overflow | visible, hidden |对应 CSS 中的 overflow 属性，但阉割了 scroll, auto 取值|
|elevation`Android` | `<number>` | CSS中没有对应的属性，只在 Android5.0+ 上有效|
|resizeMode | cover, contain, stretch |CSS中没有对应的属性，可以参考 background-size 属性|
|overlayColor`Android` |string | CSS中没有对应的属性，当图像有圆角时，将角落都充满一种颜色|
|tintColor`iOS` | `<color>` |CSS中没有对应的属性，iOS 图像上特殊的色彩，改变不透明像素的颜色|

## Valuse 取值

### Color 颜色

React-Native 支持了 CSS 中大部分的颜色类型：

* `#f00 (#rgb)`
* `#f00c (#rgba)：CSS 中无对应的值`
* `#ff0000 (#rrggbb)`
* `#ff0000cc (#rrggbbaa)：CSS 中无对应的值`
* `rgb(255, 0, 0)`
* `rgba(255, 0, 0, 0.9)`
* `hsl(360, 100%, 100%)`
* `hsla(360, 100%, 100%, 0.9)`
* `transparent`
* `Color Name`：支持了基本颜色关键字和拓展颜色关键字，但不支持28个系统颜色

### Number 数值

在 React-Native 中，目前仅支持 Number 这一种长度取值。默认缺省了 pt 单位

## UI自适应问题


在 React-Native 中，支持百分比单位和无单位的方式，无单位即 pt 绝对长度单位，例如：

```js
<View style={{width: 100, height: 50}}></View>
var styles = StyleSheet.create({
    box: {
        width: 100,
        height: 50
    }
});
```

未达到不同设备的UI自适应目的，我们通过等比缩放UI的尺寸大小，来实现不同设备的UI兼容问题：

```js
const UiBaseWidth = 750; // 以iphone6为例等比缩放
const px2dp = (UiPx) => Math.floor((UiPx * screenWidth / UiBaseWidth) * 10) / 10; // 根据设计稿转换，向下取整保留一位小数
```


## 踩坑！！！

### 1. 文字垂直居中(lineHeight设置的数值实际上会离奇的多出0.667)

想要如下图的效果：

![lineHeight1](http://cdn.chuyunt.com/lineHeight1.png)

想法：使用`lineHeight`实现

设置外部容器`height: 36`

![lineHeight2](http://cdn.chuyunt.com/lineHeight2.png)

想让中间字体垂直居中，扣去上下两个边框的宽度，应该设置`lineHeight: 34`

![lineHeight3](http://cdn.chuyunt.com/lineHeight3.png)

发现底部的边框明显少了一部分，查看元素发现一个bug：

![lineHeight4](http://cdn.chuyunt.com/lineHeight4.png)

#### 结论

>   1. 如果不设置lineHeight，Text元素的高度也是`fontSize + 0.667`
>   2. 最好的文字垂直居中方式：Text外再包一层View，在View上用`flex`布局。如下图所示：  
> ![lineHeight5](http://cdn.chuyunt.com/lineHeight5.png)

### 2. zIndex调整层级无效(绝对定位的同级元素)

实际在使用zIndex属性的时候发现根本没有效果，跟web的z-index所呈现的效果完全不一样

解决方法：

改变元素的顺序，而不使用zIndex。默认情况下，使用了`position: 'absolute'`后，在后面的元素会覆盖在前面的元素之上

**转载请标注原文地址**

