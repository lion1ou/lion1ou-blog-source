---
title: Angular之ng-class
toc: true
comments: true
categories: 技术博客
date: 2016-08-14 11:24:10
tags: Angular
---

在angular中为我们提供了3种方案处理class：

1. scope变量绑定，如上例。（不推荐使用）
2. 字符串数组形式。
3. 对象key/value处理。
<!-- more -->
## scope变量绑定（不推荐使用）

```js
function ctr($scope){
   $scope.test ='classname';
}
```
```html
<div class="{ {test} }"></div>
```

## 字符串数组形式

字符串数组形式是针对class简单变化，具有排斥性的变化，true是什么class，false是什么class，其形如;
```js
function Ctr($scope) { 
    $scope.isActive = true;
}
```
```html
<div ng-class="{true: 'active', false: 'inactive'}[isActive]"></div>
```
isActive表达式为true，则 active，负责inactive。

## 对象key/value处理

对象key/value处理主要针对复杂的class混合，其形如：
```js
function Ctr($scope) {
    $scope.selected=true;
    $scope.car=true;
}
```
```html
<div ng-class ="{'selected': isSelected, 'car': isCar}"></div> 
```
当isSelected = true 则增加selected class，当isCar=true,则增加car class，所以你结果可能是4种组合。

**转载请标注原文地址**                           
(end)


