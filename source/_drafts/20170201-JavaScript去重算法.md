---
title: JavaScript去重算法
toc: true
comments: true
categories: JavaScript
tags: JavaScript
date: 2017-02-01 22:11:56
photos:
description:
---

<!--more-->

```js
var arr = ['a', 'b', 'c', '1', 0, 'c', 1, '', 1, 0];
///////////////////////////不兼容IE6-8
function unique2(arr) {
    var result = [];
    for (var i = 0; i < arr.length; i++) {
        if (result.indexOf(arr[i]) === -1) {
            result.push(arr[i]);
        }
    }
    return result; //["", 0, "1", 1, "a", "b", "c"]
}
console.log(unique2(arr));
///////////////////////////兼容所有浏览器
function indexOf(arr, item) {
    if ([].indexOf()) {
        var e = arr.indexOf(item);
        return e;
    } else {
        for (var i = 0; i < arr.length; i++) {
            if (arr[i] === item) {
                return i;
            }
        }
        return -1;
    }
}
function unique3(arr) {
    var result = [];
    for (var i = 0; i < arr.length; i++) {
        if (indexOf(result, arr[i]) === -1) {
            result.push(arr[i]);
        }
    }
    return result; //["", 0, "1", 1, "a", "b", "c"]
}
console.log(unique3(arr));
```

参考链接:[https://github.com/lifesinger/blog/issues/113](https://github.com/lifesinger/blog/issues/113)

**转载请标注原文地址**


