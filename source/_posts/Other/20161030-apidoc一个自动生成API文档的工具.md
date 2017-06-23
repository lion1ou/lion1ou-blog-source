---
title: apidoc一个自动生成API文档的工具
toc: true
comments: true
categories: Other
tags: Tools
date: 2016-10-30 11:12:31
photos:
description:
---

`apidoc`是一个生成`RESTful API文档`的工具，它通过代码注释中的特定格式和内容，生成API文档。目前支持的语法有:Java、Javascript、C#、C/C++、D、Erlang、Go、Groovy、Pascal/Delphi、 Perl、PHP、Python、Ruby、Rust、Scala 和 Swift。

* 项目主页：[http://apidocjs.com/](http://apidocjs.com/) 
* Github：[https://github.com/apidoc/apidoc](https://github.com/apidoc/apidoc)
<!--more-->
## 安装

可以通过`npm install apidoc -g`进行全局安装

## 用法

仅需要在终端当前目录下创建一个apidoc.json文件和一个存放生成的文档的`apidoc`文件夹。

执行以下命令：
```shell
apidoc -i your-project-dir/ -o apidoc/
```

参数说明：

* -i 表示输入，后面是文件夹路径
* -o 表示输出，后面是文件夹路径
* -c，默认会带上，在当前路径下寻找配置文件(apidoc.json)，如果找不到则会在package.json中寻找`"apidoc": { }`对象
* -f 为文件过滤，后面是正则表达式，`-f ".*\.js$"`为只选着js文件
* -e 表示要排除的`文件/文件夹`，也是使用正则表达式

另外apidoc还支持自动化构建工具：

* gulp：[https://github.com/c0b41/gulp-apidoc](https://github.com/c0b41/gulp-apidoc)
* grunt：[https://github.com/apidoc/grunt-apidoc](https://github.com/apidoc/grunt-apidoc)

## 配置

可以在之前创建的`apidoc.json`中添加配置内容：

```js
{
  "name" : "koa-api",
  "version": "1.0.0",
  "title": "API文档", // 浏览器标题
  "url": "http://localhost:3100",//所有API的baseUrl
  "sampleUrl": "http://localhost:3100",//测试API的地址
  "description": "这是一个基于koa开发的RESTful API项目"
}
```

也可以在package.json中使用已定义的相同字段,并在`apidoc`对象定义额外字段，如下：

```js
{
  "name": "koa-api",
  "private": true,
  "version": "1.0.0",
  "description": "这是一个基于koa开发的RESTful API项目",
  "apidoc": {
    "url": "http://localhost:3100",//所有API的baseUrl
    "sampleUrl": "http://localhost:3100",//测试API的地址
    "title": "API文档" //浏览器标题
  },
  ...
}
```

## 注释规范

#### 常规使用

* `@api {method} path [title]`

    只有使用`@api`标注的注释块才会在解析之后生成文档

    `method`可以有空格，如{POST GET}

    `title`会被解析为API文档中导航菜单`@apiGroup`下的小菜单

* `@apiIgnore` 

    凡是带此标签的代码块，表示该文档暂时被忽略。父标签：@api。

* `@apiGroup name`
  
    提供了对 api 的分组信息，不同的分组，最终可能会被呈现在不同的页面。

* `@apiVersion verison`
  
    接口版本，major.minor.patch的形式，如1.1.1

* `@apiSampleRequest url`
  
    接口测试地址以供测试，发送请求时，@api method必须为POST/GET等其中一种，该参数也可以在之前的配置文件中统一配置

* `@apiPermission name`

    name必须独一无二，描述@api的访问权限，如admin/anyone/none

* 示例代码如下：

```js
/**
 * @api {post} /api/v1/admin  登录后台验证 
 * @apiGroup admin
 * @apiVersion 1.1.0
 * @apiPermission none
 *
 * @apiHeader {String} access-key Users unique access-key.
 * @apiHeader {String} Authorization 用户验证信息
 *
 */
```

* 对应生成的文档样式如下：

![](http://ww4.sinaimg.cn/large/006y8lVagw1fabo85xestj30r00hrjsr.jpg)

#### 参数

* `@apiParam [(group)] [{type}] [field=defaultValue] [description]`

* 示例代码如下：

```js
/**
 * @apiParam {String} [firstname]  Optional Firstname of the User.
 * @apiParam {String} lastname     Mandatory Lastname.
 * @apiParam {String} country="DE" Mandatory with default value "DE".
 * @apiParam {Number} [age=18]     Optional Age with default 18.
 *
 * @apiParam (Login) {String} pass Only logged in users can post this.
 *                                 In generated documentation a separate
 *                                 "Login" Block will be generated.
 */                                 
```

* 对应生成的文档样式如下：

![](http://ww3.sinaimg.cn/large/006y8lVagw1fabo5ltbj0j31cs0nmwhr.jpg)

#### 参数结果

* 相关参数和结果

    `@apiHeader [(group)] [{type}] [field=defaultValue] [description]`

    `@apiError [(group)] [{type}] field [description]`

    `@apiSuccess [(group)] [{type}] field [description]`
      
    用法基本类似，分别描述请求参数、头部，响应错误和成功；group表示参数的分组，type表示类型(不能有空格)，入参可以定义默认值(不能有空格)

* 展示示例

    `@apiParamExample [{type}] [title] example`

    `@apiHeaderExample [{type}] [title] example`

    `@apiErrorExample [{type}] [title] example`

    `@apiSuccessExample [{type}] [title] example`
      
    用法完全一致，但是type表示的是example的语言类型example书写成什么样就会解析成什么样，所以最好是书写的时候注意格式化，(许多编辑器都有列模式，可以使用列模式快速对代码添加*号)

* 示例代码如下：

```js
/**
 * @apiSuccess (200) {String} OK 描述
 * @apiSuccessExample {json} Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "firstname": "John",
 *       "lastname": "Doe"
 *     }
 */
```

* 对应生成的文档样式如下：

![](http://ww4.sinaimg.cn/large/006y8lVagw1fabo1cxcizj316w0hggn7.jpg)


#### 定义

* `@apiDefine MySuccess`

    定义一个注释块(不包含@api)，配合@apiUse使用可以引入注释块，在@apiDefine内部不可以使用@apiUse

* `@apiUse name`
  
    引入一个@apiDefine的注释块



* 示例代码如下：

    如下代码,定义一个API调用成功的内容,然后在其他API文档中调用这个内容

```js
/**
 * @apiDefine MySuccess
 * @apiSuccess {string} firstname The users firstname.
 * @apiSuccess {number} age The users age.
 */

/**
 * @api {post} /api/v1/admin  登录后台验证 
 * @apiGroup admin
 * @apiUse MySuccess
 *
 */
```

* 对应生成的文档样式如下：

![](http://ww2.sinaimg.cn/large/006y8lVagw1faboaw3539j31ce0oodit.jpg)


**转载请标注原文地址**

(end)
