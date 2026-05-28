---
title: Mac安装配置Tomcat环境
toc: true
comments: true
categories: Java
tags: Java
date: 2016-12-01 14:09:46
photos:
description:
---

Tomcat是由Apache软件基金会下属的Jakarta项目开发的一个Servlet容器，按照Sun Microsystems提供的技术规范，实现了对Servlet和JavaServer Page(JSP)的支持，并提供了作为Web服务器的一些特有功能,如Tomcat管理和控制平台、安全域管理和Tomcat阀等。由于Tomcat本身也内含了一个HTTP服务器，它也可以被视作一个单独的Web服务器。

由于有了Sun 的参与和支持，最新的Servlet 和JSP 规范总是能在Tomcat 中得到体现。因为Tomcat 技术先进、性能稳定，而且免费，因而深受Java 爱好者的喜爱并得到了部分软件开发商的认可，成为目前比较流行的Web 应用服务器。

<!--more-->
### 安装下载Tomcat
1. 下载

    从apache官网[http://tomcat.apache.org/](http://tomcat.apache.org/)上下载最新的tomcat二进制包（注：是mac版本的.gz文件包）

2. 将上述二进制包解压后改名为Tomcat，并复制到/Library(资源库)目录下

    新建Finder窗口—— `shift + Command + G` —— 输入/Library(资源库)，进入此目录，将Tomcat文件夹复制到此目录下

3. 修改目录权限

    方式一：选中Tomcat文件夹 ， `Command＋i` 打开简介， 修改文件权限。

    方式二：打开终端，输入`sudo chmod 755 /Library/Tomcat` 

4. `cd`到`/Library/Tomcat/bin`目录下

    在终端输入命令：`sh startup.sh`  或者 `./startup.sh start` 命令启动tomcat

    在终端输入命令：`sh shutdown.sh`  或者 `./shutdown.sh stop` 命令关闭tomcat

5. 验证`tomcat`是否安装成功

    启动tomcat后，打开http://localhost:8080查看是否Tomcat已经启动。

6. 配置Tomcat启动脚本

新建一个`tomcat`文件,小写并不加后缀名,复制以下代码.

```shell
#!/bin/bash
case $1 in
start)
sh /Library/Tomcat/bin/startup.sh
;;
stop)
sh /Library/Tomcat/bin/shutdown.sh
;;
restart)
sh /Library/Tomcat/bin/shutdown.sh
sh /Library/Tomcat/bin/startup.sh
;;
*)
echo “Usage: start|stop|restart”
;;
esac
exit 0
```

然后执行`chmod 777 tomcat`,给予权限.并将文件放置在终端包含的路径中,例如:`/usr/bin`

然后就可以在终端上直接输入`tomcat start`/`tomcat stop`/`tomcat restart`

* 注: 但是如果将文件放在其他文件夹,则需要将路径`配置到环境变量`中,我是放在/Library/Tomcat/bin则

    * 执行`vim .bash_profile`

    * 复制`export PATH=$PATH:/Library/Tomcat/bin`,粘贴到命令行中

    * 然后`esc`退出insert状态，并在最下方`输入:wq`，再`回车`保存退出。

    * 输入：`source .bash_profile`回车执行，运行环境变量。

### 相关内容

* [Apache HTTP Server 与 Tomcat 的三种连接方式介绍](https://www.ibm.com/developerworks/cn/opensource/os-lo-apache-tomcat/)






