---
title: performance
toc: true
comments: true
categories: 技术博客
tags: Default
date: 2019-06-16 22:06:38
photos:
description:
---


我们都知道浏览器从打开 url 到整个页面渲染完成，中间的过程，大致是 DOM 解析，CSSOM 解析，JS 解析，渲染。网上关于这些内容的文章也很多了，本文不再赘述。

今天主要介绍 performance 这个衡量页面加载性能的工具。

performance 有好几个属性，但是由于浏览器支持程度不同，我们主要用到的是支持最广泛，最常用的 performance.timing 这个属性。

performance.timing 主要属性如下：

这些属性记录的都是时间戳

```js
{
  navigationStart:1500979373880,            // 地址栏输入 url 回车之后，或者用户点击链接开始打开 href 时
  unloadEventStart:0,                       // 前一个页面触发 unload 时间时，和当前页面同源时才统计
  unloadEventEnd:0,                         // 前一个页面 unload 事件处理函数结束时，和当前页面同源时才统计
  redirectStart:0,                          // 重新向到当前页面时，同源才统计
  redirectEnd:0,                            // 重定向结束时，同源才统计
  fetchStart:1500979373880,                 // 开始请求页面
  domainLookupStart:1500979373880,          // 开始解析域名，如果是本地有 DNS 缓存，或者使用 http-alive 复用 TCP 连接，则此属性值和 fetchStart 相同
  domainLookupEnd:1500979373880,            // 域名解析结束时，如果是本地有 DNS 缓存，或者使用 http-alive 复用 TCP 连接 ，则此属性值和 fetchStart 相同
  connectStart:1500979373886,               // 开始向服务器请求建立连接
  secureConnectionStart:0,                  // 开始进行 SSL 连接，不走 HTTPS 这个属性值为0
  connectEnd:1500979373887,                 // 连接建立完毕
  requestStart:1500979373887,               // 开始向服务器发起请求
  responseStart:1500979374433,              // 服务器开始响应请求
  responseEnd:1500979374540,                // 服务器可能会采用流式响应，或者分片传输。这个属性表示浏览器接收到完整页面的时刻
  domLoading:1500979374442,                 // 开始解析 DOM, 此时 document.readyState 变成
  loadingdomInteractive:1500979375806,      // DOM 树解析完成，此时 document.readyState 变成 interactive，可以在 JS 里面访问 DOM 了，但此时 JS 未必解析执行完毕了
  domContentLoadedEventStart:1500979375806, // JS 也解析执行完了(不包括 async 加载的 JS)，触发 DOMContentLoaded 事件
  domContentLoadedEventEnd:1500979375827,   // DOMContentLoaded 事件结束
  domComplete:1500979376043,                // 页面内资源全部加载完毕（比如图片、音视频），JS 解析完毕，此时 document.readyState 变为
  completeloadEventStart:1500979376043,     // 触发 onload 事件
  loadEventEnd:1500979376049                // onload 事件结束
}
```

拿到这些节点的时间戳之后，各个阶段的耗时就能知道了

如果我们把 JS 放在

前面，那么 JS 执行耗时为 domContentLoadedEventStart - domInteractive

DOM 和 CSS 解析渲染耗时：domInteractive - domLoading

白屏时间：domLoading - navigationStart

另外，目前我们比较多的用 react vue 等框架，经常在加载 JS 之后生成虚拟 DOM 再挂载到页面上，这种情况，DOM 渲染完毕就需要我们手动埋点了，比如在 Vue 的跟组件 mounted() 钩子中埋点。