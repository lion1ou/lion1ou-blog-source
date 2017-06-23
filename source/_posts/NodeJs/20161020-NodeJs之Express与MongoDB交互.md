---
title: NodeJs之Express与MongoDB交互
toc: true
comments: true
categories: NodeJs
date: 2016-10-20 11:20:08
tags: NodeJs
photos: http://ww2.sinaimg.cn/large/801b780agw1f9kzpr2as3j20xc0dw762.jpg
---

mongoose是一款基于nodejs的优雅数据构建mongodb模型工具。mongodb是一款新型的json（键值对）数据类型的数据存储格式的数据库。在目前来说，使用nodejs和mongodb是为中小型企业以及个人web开发的绝配。
<!-- more -->
## 一、安装MongoDB

### 1.1 Mac

#### 1.1.1 安装

在终端根目录下输入

```shell
 brew install mongodb
```

![](http://ww4.sinaimg.cn/large/006y8mN6gw1f8wemi1pm0j30fv06440f.jpg)

出现上面情况说明安装成功，安装的目录就是 `/usr/local/Cellar/mongodb/3.2.10`。

#### 1.1.2 配置

第一次启动服务端,这里需要做一些准备工作.

* 默认mongodb 数据文件是放到根目录 data/db 文件夹下,如果没有这个文件,请自行创建.

```shell
mkdir -p /data/db
```

* 如果你当前的环境变量还没有加入 mongod  ,手动添加的环境变量中.

```shell
nano ~/.bash_profile

//添加mongodb安装目录到环境变量中
export PATH=/usr/local/Cellar/mongodb/3.2.10/bin:${PATH}
//然后覆盖保存
```

* 如果让环境变量马上生效? 执行下面的shell

```shell
source ~/.bash_profile
```

* 修改mongodb配置文件,配置文件默认在 /usr/local/etc 下的 mongod.conf

>由于Mac默认不显示隐藏文件，所以直接找文件夹是找不到的。要使用下面命令显示隐藏文件

```shell
defaults write com.apple.finder AppleShowAllFiles -boolean true ; killall Finder//显示

defaults write com.apple.finder AppleShowAllFiles -boolean false ; killall Finder//隐藏
```

>配置文件修改后

```
systemLog:
  destination: file
  path: /usr/local/var/log/mongodb/mongo.log
  logAppend: true
storage:
  dbPath: data/db
net:
  bindIp: 127.0.0.1
```

>修改`dbPath`为我们刚刚创建的文件夹`data/db`,如果准备连接非本地环境的mongodb数据库时,bind_ip = 0.0.0.0 即可.

* 给 /data/db 文件夹赋权限

```shell
sudo chown `id -u` /data/db
```

* 启动mongoDB

```shell
mongod
```

![](http://ww1.sinaimg.cn/large/006y8mN6gw1f8wffx2ia1j30g304iq4t.jpg)

ok,mongodb 服务端终于启动起来了。

#### 1.1.3 辅助

安装可视化工具[Robomongo](https://robomongo.org/)。

### 1.2 Windows

mongodb和nodejs的模块包不一样，它是使用c++编写的跨平台数据库，可以在官网（见参考资料）下载安装，本次安装以window 32bit为例：

#### 1.2.1 下载

下载之后解压该安装包到你想要的目录，重命名为mongodb，如图：

![](http://ww1.sinaimg.cn/large/006y8lVagw1f8ykl57x1ej30ar083q3z.jpg)

#### 1.2.2 新建Data

打开mongodb文件夹，新建一个data文件夹用于存储数据库，当然也可以指定其他目录。

#### 1.2.3 新建CMD文件

再打开mongodb\bin文件夹，新建一个cmd文件，内容为：
```bash
mongod --dbpath "d:\program files\mongodb\data"//自定义地址，内容为数据库文档存储文件夹。
```

#### 1.2.4 启动服务
新建完成之后，打开该CMD，保持该CMD窗口为打开状态，后续就可以连接数据库、操作数据库了。

## 二、安装Mongoose

命令行打开项目根目录，执行`npm install mongoose --save`安装Mongoose

![](http://ww2.sinaimg.cn/large/006y8lVagw1f8ykyztwq9j30ib01umxz.jpg)

## 三、使用Mongoose

接下来我将会以一个todo list来作为实例，向大家讲解。有些内容我上篇文章已经说到过，就不多说了，请参见：[nodejs之Express入门](http://lion1ou.win/2016/10/19/)

### 3.1 连接MongoDB
在项目文件夹根目录上，新建db.js，内容：
```js
var mongoose = require("mongoose"); //引入mongoose

var db = mongoose.connection;
db.on('error', function callback() { //监听是否有异常
    console.log("Connection error");
});
db.once('open', function callback() { //监听一次打开
    //在这里创建你的模式和模型
    console.log('connected!');
});

mongoose.connect('mongodb://localhost/todo'); //连接到mongoDB的todo数据库
//该地址格式：mongodb://[username:password@]host:port/database[?options]
//默认port为27017  
module.exports = mongoose;
```
在app.js最前面引入，
```js
require('./db');
```
然后就可以，`npm start`试试，是否连接成功，记住：这时候mongoDB的服务一定要打开！！连接成功如下图：

![](http://ww1.sinaimg.cn/large/006y8lVagw1f8yop1fgxrj30d3032mxh.jpg)

### 3.2 定义属性、模型、实体

* Schema(属性) ：一种以文件形式存储的数据库模型骨架，不具备数据库的操作能力
* Model(模型)  ：由Schema发布生成的模型，具有抽象属性和行为的数据库操作对
* Entity(实体) ：由Model创建的实体，他的操作也会影响数据库

>我们需要一个Schema和一个Model来将数据保存在MongoDB数据库中。Schema定义了一个集合中文档的结构，Model被用来创建将要存储在文档中的数据Entity。Schema生成Model，Model创造Entity，Model和Entity都可对数据库操作造成影响，但Model比Entity更具操作性。

那么接下来我们来定义它们，在`db.js`中添加下面内容：
```js
var TodoSchema = new mongoose.Schema({
    user_id: String, //定义一个属性user_id，类型为String
    content: String, //定义一个属性content，类型为String
    updated_at: Date //定义一个属性updated_at，类型为Date
});

mongoose.model('Todo', TodoSchema); //将该Schema发布为Model
```
模型定义好了，现在我们就要开始往数据库添加数据了。
### 3.3 ejs模板引擎配置
我们用之前文章里的生成的脚手架，开始搭建。这里我们用到的是ejs模板引擎，所以我们需要配置一下：

#### 3.3.1 安装esj-mate

命令行输入：`npm install ejs-mate --save`

#### 3.3.2 在app.js中引入模块，添加如下代码：

```js 
var engine = require('ejs-mate');
///======= view engine setup  模板 开始===========//
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
app.engine('ejs', engine);
///======= view engine setup  模板 结束===========//
```

#### 3.3.3 新建views/layout.ejs

```html
<!DOCTYPE html>
<html>
<head>
    <title>
        <%= title %>
    </title>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap.min.css">
    <link rel='stylesheet' href='/stylesheets/screen.css' />
</head>
<body>
    <div id="layout" class="container-fluid">
        <%- body -%>  <!--之后我们的内容就会填充再这个里面 -->
    </div>
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="http://cdn.bootcss.com/jquery/1.11.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="http://cdn.bootcss.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</body>
</html>
```

### 3.4 新建、保存数据
#### 3.4.1 修改views/index.ejs
```html
   <% layout('layout')  -%>  <!-- 用于识别填充到模板中的内容 -->
    <div class="row">
        <div class="col-xs-12 text-center">
            <h1> <%= title %></h1>
        </div>
    </div>

    <div class="row">
        <div class="col-xs-12 text-center">
            <form action="/create" method="post" accept-charset="utf-8">
                <input class="input" type="text" name="content" />
            </form>
        </div>
    </div>
```
#### 3.4.2  修改routes/index.js
```js
router.post('/create', function(req, res) {
    console.log('req.body', req.body);
    new TodoModel({ //实例化对象，新建数据
        content: req.body.content,
        updated_at: Date.now()
    }).save(function(err, todo, count) { //保存数据
        console.log('内容', todo, '数量', count); //打印保存的数据
        res.redirect('/'); //返回首页
    });
});
```
然后启动服务，`npm start`，在页面输入框输入任何内容，回车。

![](http://ww1.sinaimg.cn/large/006y8lVagw1f8zqveebk8j30bq03oaao.jpg)

#### 3.4.3 问题解决
若出现`req.body`为`undefined`，请检查`app.js`
是否引入：
`var bodyParser = require('body-parser'); //处理请求body的中间件`
是否配置：
```js
app.use(bodyParser.urlencoded({ extended: false })); //解析 application/x-www-form-urlencoded类型
app.use(bodyParser.json()); //解析 application/json类型
```
router定义：
```js
app.use('/', routes); //在app中注册routes该接口 
app.use('/users', users); //在app中注册users接口
```
必须写在配置的后面。

### 3.5 查询、删除数据

#### 3.5.1 添加到views/index.ejs
```html
// 显示所有待办事项
<% todos.forEach( function( todo ){ %>
    <div class="row">      
        <div class="col-xs-2 text-center">
            <p>
                <%= todo.updated_at %>
            </p>
        </div>
        <div class="col-xs-6 text-center">
             <p><%= todo.content %></p>
        </div>
        <div class="col-xs-4 text-center">
              <a href="/destroy/<%= todo._id %>" title="Delete this todo item">Delete</a>
        </div>
    </div>
<% }); %>     
```

#### 3.5.2 修改routes/index.js
```js
router.get('/', function(req, res, next) {
    // 查询数据库获取所有待办事项.
    TodoModel.find(function(err, todos, count) {
        res.render('index', { //渲染页面
            title: 'Todo List',
            todos: todos
        });
    });
});
//需要传入参数id
router.get('/destroy/:id', function(req, res) {
    //根据待办事项的id 来删除它
    TodoModel.findById(req.params.id, function(err, todo) {
        todo.remove(function(err, todo) {
            res.redirect('/');
        });
    });
});
```

#### 3.6 修改、更新数据

实现方式是当鼠标点击待办事项时，页面转向edit页面，将待办事项转化为input text标签。

##### 3.6.1 添加router/index.js
```js
//跳转到编辑页面
router.get('/edit/:id', function(req, res) {
    TodoModel.find(function(err, todos, count) {
        res.render('edit', { //重新渲染页面
            title: 'Todo List',
            todos: todos,
            current: req.params.id
        });
    });
});
//根据传入的数据id,更改数据
router.post('/update/:id', function(req, res) {
    TodoModel.findById(req.params.id, function(err, todo) {
        todo.content = req.body.content;
        todo.updated_at = Date.now();
        todo.save(function(err, todo, count) {
            res.redirect('/');
        });
    });
});
```

##### 3.6.2 添加新页面views/edit.ejs
```html
//省略与index.ejs相同部分；主要修改以下内容
<% todos.forEach( function( todo ){ %>
 <div class="row">  
      <div class="col-xs-2 text-center">
         <p><%= todo.updated_at %></p>
    </div>
    <div class="col-xs-6 text-center">
      <% if( todo._id == current ){ %>
          <form action="/update/<%= todo._id %>" method="post" accept-charset="utf-8">
            <input type="text" name="content" value="<%= todo.content %>" />
          </form>
      <% }else{ %>
            <a href="/edit/<%= todo._id %>" title="Update this todo item"><%= todo.content %></a>
      <% } %>
    </div>
    <div class="col-xs-2 text-center">
          <a href="/edit/<%= todo._id %>" title="Edit this todo item">Edit</a>
    </div>
    <div class="col-xs-2 text-center">
          <a href="/destroy/<%= todo._id %>" title="Delete this todo item">Delete</a>
    </div>
 </div>
<% }); %>     
```
##### 3.6.3 修改页面 views/index.ejs
```html
 <% todos.forEach( function( todo ){ %>
    <div class="row">
        <div class="col-xs-2 text-center">
            <p>
                <%= todo.updated_at %>
            </p>
        </div>
        <div class="col-xs-6 text-center">
            <p>
                <%= todo.content %>
            </p>
        </div>
        <div class="col-xs-2 text-center">
            <a href="/edit/<%= todo._id %>" title="Edit this todo item">Edit</a>
        </div>
        <div class="col-xs-2 text-center">
            <a href="/destroy/<%= todo._id %>" title="Delete this todo item">Delete</a>
        </div>
    </div>
<% }); %>
```
到这里Todo list基本功能已经完成了，下面我们再添加一个排序功能。

#### 3.7 排序
让待办事项更新时间顺序进行排序。
##### 3.7.1 修改router/index.js
```js
router.get('/', function(req, res, next) {
    // 查询数据库获取所有待办事项.
    TodoModel.
    find().
    sort('uadated_at').
        (function(err, todos, count) {
            res.render('index', { //渲染页面
                title: 'Todo List',
                todos: todos
            });
        });
});

//跳转到编辑页面
router.get('/edit/:id', function(req, res) {
    TodoModel.
    find().
    sort('uadated_at').
        (function(err, todos, count) {
            res.render('edit', { //重新渲染页面
                title: 'Todo List',
                todos: todos,
                current: req.params.id
            });
        });
});
```

**源码已经上传到[Github](https://github.com/lion1ou/TodoList)上了，为了美观使用bootstrap简单的修改了一下，其他内容都没有变动。**

**转载请标注原文地址**                           
(end)
