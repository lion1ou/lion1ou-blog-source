---
title: NodeJs之Express入门
toc: true
comments: true
categories: 技术博客
date: 2016-10-19 09:44:04
tags: NodeJs
photos: http://ww4.sinaimg.cn/large/801b780agw1f9kzqrejecj20xc0dwdjt.jpg
---

Express 是一种保持最低程度规模的灵活 Node.js Web 应用程序框架，为 Web 和移动应用程序提供一组强大的功能。详见：[官网](http://expressjs.com/) 、[中文网站](http://www.expressjs.com.cn/)
<!-- more -->
## 一、准备工作

首先你需要安装NodeJS环境 这里不再做介绍。

### 1.1 安装Express

```shell
  npm install express -g //安装全局的express
  npm install express-generator -g //安装全局的express命令行工具
```

### 1.2 初始化项目

```shell
  cd code //项目空间
  express todo (-e) //项目名称（添加参数是使用ejs模板，默认使用jade），生成一个express脚手架项目
```

![](http://ww2.sinaimg.cn/large/65e4f1e6gw1f8xdq5mbvfj20aw0bmmyy.jpg)

项目目录如下：
```
todo
    bin 
        www          //用来启动应用（服务器）
    public           //存放静态资源目录
        images
        javascript
        stylesheets        
    routes           //路由用于确定应用程序如何响应对特定端点的客户机请求，包含一个URI（或路径）和一个特定的 HTTP 请求方法（GET、POST等）。每个路由可以具有一个或多个处理程序函数，这些函数在路由匹配时执行。
        index.js
        users.js
    views            //模板文件所在目录 默认文件格式为.jade，这里我们使用的是ejs
        error.ejs
        index.ejs
    app.js           //程序main文件 这个是服务器启动的入口
    package.json     //项目的配置文件
```

### 1.3 添加gitignore

在根目录上添加gitignore，排除一些文件，方便之后的git使用。

```
.DS_Store
node_modules
```

### 1.4 在package中添加依赖

根据自身项目的特殊要求，添加不同的依赖。

```
{
  "name": "todo",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "start": "node ./bin/www"
  },
  "dependencies": {
    "body-parser": "~1.15.1",
    "cookie-parser": "~1.4.3",
    "debug": "~2.2.0",
    "ejs": "~2.4.1",
    "express": "~4.13.4",
    "morgan": "~1.7.0",
    "serve-favicon": "~2.3.0"
    //在这里根据自身项目添加依赖
  }
}
```

### 1.5 初始化项目

根据终端最后两行提示：

![](http://ww2.sinaimg.cn/large/65e4f1e6gw1f8xcyoajv1j20au03a0ss.jpg)

执行下面代码，初始化项目，安装所有依赖。

```shell
cd todo && npm install //进入todo项目目录，安装相关依赖
```

在文件目录中会多出一个文件夹`node_modules` 即依赖模块的文件夹。

## 二、启动服务

### 2.1 启动服务器

```shell
npm start   //启动服务器
```

![](http://ww1.sinaimg.cn/large/65e4f1e6gw1f8xdpfm82rj20a2021q34.jpg)

显示上面图片，表示服务器已启动。

### 2.2 浏览器访问

打开浏览器，在浏览器中访问 http://localhost:3000/或http://127.0.0.1:3000/ 浏览器输出：

![](http://ww3.sinaimg.cn/large/65e4f1e6gw1f8xdtfr6xyj216o0d675f.jpg)

## 三、基本使用

以下是app.js的相关代码解释，如有什么不对，请批评指正。

### 3.1 实现逻辑

```js
// 引入对象
var express = require('express');
var path = require('path'); //path对象，规范连接和解析路径
var favicon = require('serve-favicon'); //页面图标
var logger = require('morgan'); //http请求日志记录器
var cookieParser = require('cookie-parser'); //解析cookie
var bodyParser = require('body-parser'); //处理请求body的中间件
var app = express();
var routes = require('./routes/index'); //home page接口
var users = require('./routes/users'); //用户接口

///======= view engine setup  模板 开始===========//
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
///======= view engine setup  模板 结束===========//

///======= 使用中间件 开始===========//
// uncomment after placing your favicon in /public (需要显示favicon时，取消注释)
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));

app.use(logger('dev')); //以开发者模式，使用log
app.use(bodyParser.urlencoded({ extended: false })); //解析 application/x-www-form-urlencoded类型
app.use(bodyParser.json()); //解析 application/json类型
app.use(cookieParser()); //cookie中间件
app.use(express.static(path.join(__dirname, 'public'))); //静态文件夹方法
///======= 使用中间件 结束===========//


///=======路由信息 （接口地址）开始 ===========//
//存放在./routes目录下
app.use('/', routes); //在app中注册routes该接口 
app.use('/users', users); //在app中注册users接口
///=======路由信息 （接口地址) 介绍===========//

// catch 404 and forward to error handler(捕获404错误，并转向错误处理程序)
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

///======= error handlers  错误处理程序  开始========//

// development error handler(开发者错误处理程序)
// will print stacktrace(将会打印堆栈跟踪)
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500); //返回错误状态码
        res.render('error', { //渲染error视图模板
            message: err.message,
            error: err
        });
    });
}
// production error handler(生产环境下的处理程序)
// no stacktraces leaked to user(不会泄露堆栈跟踪给用户)
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});
///======= error handlers  错误处理程序  结束========//
module.exports = app;
```

当我们在浏览器中 访问 http://localhost:3000/ 时通过app.js中的代码：
```
app.use('/', routes); //在app中注册routes该接口 
```
调用 `routes/index.js` ，即：

```js
var express = require('express');
var router = express.Router();//使用 express.Router 类创建模块化、可挂载的路由句柄

//定义一个get请求 path为根目录'/'
/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });//渲染index视图模板。
});

module.exports = router;//暴露外部接口router
```

所以当我们在浏览器中 访问 http://localhost:3000/users 时通过app.js中的代码：`app.use('/users', users); //在app中注册routes该接口 `
调用 `routes/users.js` 

### 3.2 路由定义

定义一个路由的基本格式为：
```js
app.METHOD(PATH, HANDLER)//PATH 是服务器上的路径。HANDLER 是在路由匹配时执行的函数。
```
METHOD是HTTP 请求对应的路由方法：get, post, put, head, delete等。其中`app.all()`是一个特殊的路由方法，没有任何 HTTP 方法与其对应，它的作用是对于一个路径上的所有请求加载中间件。

### 3.3 响应方法

|方法|描述|
|---|---|
|res.download()  |提示下载文件。|
|res.end()   |终结响应处理流程。|
|res.json()  |发送一个 JSON 格式的响应。|
|res.jsonp() |发送一个支持 JSONP 的 JSON 格式的响应。|
|res.redirect()  |重定向请求。|
|res.render()    |渲染视图模板。|
|res.send()  |发送各种类型的响应。|
|res.sendFile    |以八位字节流的形式发送文件。|
|res.sendStatus()    |设置响应状态代码，并将其以字符串形式作为响应体的一部分发送。|

### 3.4 接口实例

下面我们来实现一个获取用户信息接口：

#### 3.4.1 创建模型

在routes文件夹内创建model.js，定义一个User模型。

```js
function User() {
    this.name;
    this.city;
    this.age;
}
module.exports = User;
```

#### 3.4.2 添加方法

在routes/users.js文件中添加引用：
```js
var URL = require('url'); //引入URL中间件
var User = require('./model'); //引入数据模型
```
并继续添加如下方法：
```js
router.get('/getUserInfo', function(req, res, next) {
    var user = new User(); //实例化对象
    var params = URL.parse(req.url, true).query;//获取url参数
    console.log('params', params);
    if (params.id == '1') { //根据参数赋值
        user.name = "luo";
        user.age = "11";
        user.city = "北京市";
    } else {
        user.name = "lion";
        user.age = "22";
        user.city = "杭州市";
    }
    //这里我们写死了返回数据，并没有查询数据库。
    var response = { status: 200, data: user }; //定义返回数据
    res.send(JSON.stringify(response)); //发送请求
});
```
由于users.js路由信息已经在app.js注册，所以不要重新注册，只要停止服务器 重新start服务器即可直接访问

#### 3.4.3 调用接口

访问：

[http://localhost:3000/users/getUserInfo?id=1](http://localhost:3000/users/getUserInfo?id=1)

![](http://ww2.sinaimg.cn/large/006y8lVagw1f8yiyry8yqj30pe09uq3w.jpg)

或

[http://localhost:3000/users/getUserInfo?id=2](http://localhost:3000/users/getUserInfo?id=2)

![](http://ww3.sinaimg.cn/large/006y8lVagw1f8yiy0gwfrj30o609yjsd.jpg)

**转载请标注原文地址**                           
(end)