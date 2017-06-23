---
title: 云服务之nginx配置https
toc: true
comments: true
categories: Other
tags: 云服务
date: 2017-05-14 11:29:08
photos:
description:
---

<!--more-->

### 保证nginx已经引入ssl模块

### SSL证书介绍

SSL 证书是一种数字证书，它使用 Secure Socket Layer 协议在浏览器和 Web 服务器之间建立一条安全通道，从而实现：
1. 数据信息在客户端和服务器之间的加密传输，保证双方传递信息的安全性，不可被第三方窃听；
2. 用户可以通过服务器证书验证他所访问的网站是否真实可靠。

HTTPS 是以安全为目标的 HTTP 通道，即 HTTP 下加入 SSL 加密层。HTTPS 不同于 HTTP 的端口，HTTP默认端口为80，HTTPS默认端口为443。

### 申请SSL证书

* 进入阿里云控制台，“安全（云盾）”下的“证书服务”，点击购买证书，选择免费型 DV SSL，按提示走就可以，反正不用花钱的。
* 接下来到我的订单页面，看到证书状态是“待完成”，点击“补全”链接，根据提示完成操作，在上传相关信息时，一般选择`系统生成`。
![](https://ws3.sinaimg.cn/large/006tNbRwgy1fgdmbplogfj30u5077mx8.jpg)
* 然后等验证通过，一般十几二十分钟就OK
* 然后下载证书，选择nginx
![](https://ws4.sinaimg.cn/large/006tNbRwgy1fgdm7pqa91j30tm0amweh.jpg)

* 将下载下来的证书解压，里面有两个文件一个是.key，另一个是.pem，把这两个文件传到服务器的一个目录中。
* 配置nginx配置文件，重启nginx即可

### 配置https

```shell
server{
    listen 443;
    server_name www.lion1ou.com;
    ssl on;
    root /home/lion1ou/dist;
    index index.html index.htm;
    ssl_certificate   /home/lion1ou/cert/214128084570320.pem;
    ssl_certificate_key  /home/lion1ou/cert/214128084570320.key;
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;

    # error_page 497 "https://$host$uri?$args";  # 这是跳转Http请求到Https

    location / {
        root /home/lion1ou/dist;
        index index.html index.htm;
    }
}
```

### 将http重定向到https
```shell
server {
     listen 80;
     server_name www.fdshfccy.com;
     rewrite ^/(.*) https://$server_name$1 permanent;    #用于http重定向到Https
}
```

### 问题

通过重定向跳转到https时，浏览器上会出现多次重定向，需要删除缓存才能访问的问题。   

现这个问题没有解决，有解决办法的同学，可以留言告诉我。


**转载请标注原文地址**

(end)
