---
title: HTML5之WebSocket实时通讯
toc: true
comments: true
categories: 技术博客
tags: HTML
date: 2016-11-18 08:40:06
photos:
description:
---
WebSocket是HTML5开始提供的一种在单个 TCP 连接上进行全双工通讯的协议。在WebSocket API中，浏览器和服务器只需要做一个握手的动作，然后，浏览器和服务器之间就形成了一条快速通道。两者之间就直接可以数据互相传送。浏览器通过JavaScript向服务器发出建立WebSocket连接的请求，连接建立以后，客户端和服务器端就可以通过TCP连接直接交换数据。
<!--more-->

WebSocket 协议本质上是一个基于 TCP 的协议。为了建立一个 WebSocket 连接，客户端浏览器首先要向服务器发起一个 HTTP 请求，这个请求和通常的 HTTP 请求不同，包含了一些附加头信息，其中附加头信息"Upgrade: WebSocket"表明这是一个申请协议升级的 HTTP 请求，服务器端解析这些附加的头信息然后产生应答信息返回给客户端，客户端和服务器端的 WebSocket 连接就建立起来了，双方就可以通过这个连接通道自由的传递信息，并且这个连接会持续存在直到客户端或者服务器端的某一方主动的关闭连接。


## 使用入门

只需调用 WebSocket 构造函数即可打开 WebSocket 连接：
```js
var connection = new WebSocket('ws://html5rocks.websocket.org/echo', ['soap', 'xmpp']);
```
请注意 ws:。这是 WebSocket 连接的新网址架构。对于安全 WebSocket 连接还有 wss:，就像 https: 用于安全 HTTP 连接一样。第二个参数可接受可选子协议，它既可以是字符串，也可以是字符串数组。每个字符串都应代表一个子协议名称，而服务器只能接受数组中通过的一个子协议。访问WebSocket对象的protocol属性可确定接受的子协议。

下面是 WebSocket 对象的属性。假定我们已经创建了上述的 Socket 对象：

```js
connection.readyState 
//只读属性readyState表示连接的状态。有以下取值：0 表示连接尚未建立。1 表示连接已建立，可以进行通信。2 表示连接正在进行关闭握手。3 表示连接已经关闭或者连接不能打开。

connection.bufferedAmount   
//只读属性bufferedAmount表示已经使用 send() 方法排队的 URF-8 文本字节数。
```
立即向连接附加一些事件处理程序可让您知道连接打开、收到传入讯息或出现错误的时间。
```js
//连接建立时触发
connection.onopen = function () {
    console.log('open');
    connection.send('Ping'); 
};

// 通信发生错误时触发
connection.onerror = function (error) {
    console.log('WebSocket Error ' + error);
};

// 客户端接收服务端数据时触发
connection.onmessage = function (e) {
    console.log('Server: ' + e.data);
};

// 连接关闭时触发
connection.onclose=function(e){
    console.log('Close');
}
```

与服务器建立连接后（启动 open 事件时），我们可以开始对连接对象使用 send('your message') 方法，向服务器发送数据。也可以发送二进制讯息了。要发送二进制数据，您可以使用 Blob 或 ArrayBuffer 对象。
```js
// 发送信息
connection.send('your message');

// Sending canvas ImageData as ArrayBuffer
var img = canvas_context.getImageData(0, 0, 400, 320);
var binary = new Uint8Array(img.data.length);
for (var i = 0; i < img.data.length; i++) {
  binary[i] = img.data[i];
}
connection.send(binary.buffer);

// Sending file as Blob
var file = document.querySelector('input[type="file"]').files[0];
connection.send(file);
```
同样，服务器也可能随时向我们发送讯息。只要发生这种情况，就会启动 onmessage 回调。该回调接收的是事件对象，而实际的讯息可通过 data 属性进行访问。WebSocket 也可以接收二进制讯息。接收的二进制帧可以是 Blob 或 ArrayBuffer 格式。要指定收到的二进制数据的格式，可将 WebSocket 对象的 binaryType 属性设为“blob”或“arraybuffer”。默认格式为“blob”。
```js
connection.binaryType = 'arraybuffer';
connection.onmessage = function(e) {
  console.log(e.data.byteLength); // ArrayBuffer object if binary
};
```

##  使用场景
1. 社交订阅（朋友圈、微博关注）
2. 多玩家游戏（CF等多用户同时在线游戏）
3. 协同编辑/编程
4. 点击流数据（用户在浏览页面是的具体操作数据，分析用户习惯等）
5. 股票基金报价
6. 体育实况更新
7. 多媒体聊天(视频电话、视频会议)
8. 基于位置的应用（记录移动设备GPS数据）
9. 在线教育（多媒体聊天、文字聊天以及与别人合作...）

## 实践
目前大部分浏览器支持 WebSocket() 接口，你可以在以下浏览器中尝试实例： Chrome, Mozilla, Opera 和 Safari。runoob_websocket.html 文件内容:
```html
<!DOCTYPE HTML>
<html>
   <head>
   <meta charset="utf-8">
   <title>菜鸟教程(runoob.com)</title>
    
      <script type="text/javascript">
         function WebSocketTest()
         {
            if ("WebSocket" in window)
            {
               alert("您的浏览器支持 WebSocket!");
               
               // 打开一个 web socket
               var ws = new WebSocket("ws://localhost:9998/echo");
                
               ws.onopen = function()
               {
                  // Web Socket 已连接上，使用 send() 方法发送数据
                  ws.send("发送数据");
                  alert("数据发送中...");
               };
                
               ws.onmessage = function (evt) 
               { 
                  var received_msg = evt.data;
                  alert("数据已接收...");
               };
                
               ws.onclose = function()
               { 
                  // 关闭 websocket
                  alert("连接已关闭..."); 
               };
            }
            
            else
            {
               // 浏览器不支持 WebSocket
               alert("您的浏览器不支持 WebSocket!");
            }
         }
      </script>
        
   </head>
   <body>
   
      <div id="sse">
         <a href="javascript:WebSocketTest()">运行 WebSocket</a>
      </div>
      
   </body>
</html>
```

安装 pywebsocket

在执行以上程序前，我们需要创建一个支持 WebSocket 的服务。从 [pywebsocket](https://github.com/google/pywebsocket) 下载 mod_pywebsocket ,或者使用 git 命令下载：
git clone https://github.com/google/pywebsocket.git

mod_pywebsocket 需要 python 环境支持

mod_pywebsocket 是一个 Apache HTTP 的 Web Socket扩展，安装步骤如下：
解压下载的文件。进入 pywebsocket 目录。

执行命令：
```shell
$ python setup.py build
$ sudo python setup.py install
```
查看文档说明:
```shell
$ pydoc mod_pywebsocket
```
开启服务。在 pywebsocket/mod_pywebsocket 目录下执行以下命令：
```shell
$ sudo python standalone.py -p 9998 -w ../example/
```
以上命令会开启一个端口号为 9998 的服务，使用 -w 来设置处理程序 echo_wsh.py 所在的目录。
现在我们可以在 Chrome 浏览器打开前面创建的 runoob_websocket.html 文件。如果你的浏览器支持 WebSocket(), 点击"运行 WebSocket"。


**转载请标注原文地址**

(end)
