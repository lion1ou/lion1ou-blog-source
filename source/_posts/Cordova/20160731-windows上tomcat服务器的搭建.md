---
title: iOS开发(4) - windows上tomcat服务器的搭建
toc: true
date: 2016-07-31 16:56:16
tags: iOS
categories: Cordova
comments: true
---

Tomcat 服务器是一个免费的开放源代码的Web 应用服务器，属于轻量级应用服务器，在中小型系统和并发访问用户不是很多的场合下被普遍使用，是开发和调试JSP 程序的首选服务器。
<!-- more -->
## 更新日志
* 2016.07.30  初稿
* 2016.08.08  添加修改默认主页为自己主页  

## 准备条件

> 安装java环境，配置环境变量

1. 下载JDK，[link](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

	![屏幕快照 2016-07-30 17.27.11.png](http://ww1.sinaimg.cn/large/72f96cbagw1f6c2hkxorgj20f408n76s.jpg)

	根据自己的系统，下载对应的版本

2. 安装JDK

	默认选择，正常点击，下一步，下一步，完成安装。

3. 配置环境变量

	右击计算机=》属性=》高级系统设置

	![82EECB57-DFF7-4563-8CFF-40EF0BF85935.jpg](http://ww2.sinaimg.cn/large/72f96cbagw1f6c2nylc7sj20cv0eb0t7.jpg)

	* **配置JAVA_HOME**（如图新建JAVA_HOME，变量值配置为jdkX.X.XX文件夹的位置）

	![9CAC574C-8432-466E-AF8E-21C61C6F8C6D.jpg](http://ww3.sinaimg.cn/large/72f96cbagw1f6c2pxpxzxj20bx063mxd.jpg)

	* **配置classPath**

	在已有的classPath中添加或新建添加`.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;`，记得前面有个"."。

	![屏幕快照 2016-07-31 00.00.26.png](http://ww4.sinaimg.cn/large/72f96cbagw1f6cdme9unqj20hm05u0tl.jpg)

	* **配置Path**（在已有的path中添加”%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;”，多个目录用分号隔开）

	![0C62FF95-28F8-4D23-ADF3-2A6137DE90B2.jpg](http://ww4.sinaimg.cn/large/72f96cbagw1f6c2rih4t6j20bx067dg2.jpg)

	![屏幕快照 2016-07-31 00.03.30.png](http://ww1.sinaimg.cn/large/72f96cbagw1f6cdpplgylj20db068jsk.jpg)

	>(配置完成后，执行命令行时，系统会在path指定的路径中寻找该命令对应的可执行文件)

	* **检验安装**配置是否正确

	组合键Windows+R后，输入cmd后，回车，打开cmd窗口，在窗口中输入`java -version`后回车，出现如下画面则表示成功！

	![82D4068D-117F-497F-8E52-8C69943479AB.png](http://ww3.sinaimg.cn/large/72f96cbagw1f6c2tfy1vpj20em029t8x.jpg)

## Tomcat

>在Windows下安装Tomcat服务器的方式有两种，一种是直接安装，一种是绿色版，解压后就可以直接使用的。

### 绿色版，免安装版

1. 下载Tomcat，[link](http://tomcat.apache.org/download-90.cgi)

	![屏幕快照 2016-07-30 17.55.29.png](http://ww2.sinaimg.cn/large/72f96cbagw1f6c37n0nt9j20kn0d977i.jpg)

	选择其中一种下载。

2. 安装Tomacat

	将Tomcat服务器的压缩包放在任意文件夹目录下(最好跟你的开发文件集中放置，便于管理),解压并且打开后可以看到Tomcat的目录结构如下：

	![Voila_Capture 2016-07-30_18-06-24_.png](http://ww4.sinaimg.cn/large/72f96cbagw1f6c3git1etj203w0773yr.jpg)

	文件解释：

		bin:存放启动和关闭Tomcat的脚本文件
		conf:存放Tomcat服务器的各种配置文件
		lib:存放Tomcat服务器的支持jar包
		logs:存放Tomcat的日志文件
		temp:存放Tomcat运行时产生的临时文件
		webapps:web应用所在目录，即供外界访问的web资源的存放目录
		work:Tomcat的工作目录

3. 配置环境变量（可选配），详细信息：[link](http://www.jianshu.com/p/65881a45ad4a)

4. 启动服务

	打开cmd命令行，进入Tomcat文件夹下的bin目录，输入`startup`命令`启动`Tomcat服务器

	![屏幕快照 2016-07-30 22.25.00.png](http://ww2.sinaimg.cn/large/72f96cbagw1f6cav5ktkjj20l403tjs2.jpg)

	当弹出下图中得Dos窗口，表示Tomcat服务器成功的启动了

	![屏幕快照 2016-07-30 22.25.43.png](http://ww3.sinaimg.cn/large/72f96cbagw1f6cavu17waj20r70fwahn.jpg)

	然后在浏览器中输入`http://localhost:8080/`当浏览器中出现下图所示的提示框表示Tomcat服务器成功的启动了

	![屏幕快照 2016-07-30 22.28.10.png](http://ww2.sinaimg.cn/large/72f96cbagw1f6caygoa7oj20li0d9adi.jpg)

	打开cmd命令行，进入Tomcat文件夹下的bin目录，输入`shutdown`命令`关闭`Tomcat服务器

	![屏幕快照 2016-07-30 23.31.20.png](http://ww1.sinaimg.cn/large/72f96cbagw1f6ccs56pt3j20lf03tt9e.jpg)

	直到之前自动打开的dos窗口关闭，表示服务已关闭

### 安装版

借用人家教程，[link](http://www.lvtao.net/server/windows-setup-tomcat.html)

## 部署项目

>将自己的项目部署到Tomcat服务器上

* 打开webapps页面，将自己的项目放到该文件夹内，如下图：

![屏幕快照 2016-07-30 23.07.50.png](http://ww2.sinaimg.cn/large/72f96cbagw1f6cc3mtqemj20d705raaz.jpg)

>在前面我已经介绍过了webapps是web应用所在目录，即供外界访问的web资源的存放目录，所以就在webapps目录下部署我们自己的项目，前面介绍的输入`http://localhost:8080/`后访问的网页其实访问的就是webapps文件夹下的Tomcat自带的这些文件夹中的文件

* 最后打开浏览器并且在浏览器中输入`http://localhost:8080/apps/index.html`可以访问到放在apps文件夹下的index.html页面。

![屏幕快照 2016-07-30 23.09.11.png](http://ww1.sinaimg.cn/large/72f96cbagw1f6cc51vznvj20mo03ldg0.jpg)

## 访问项目

第一步：需要将Tomcat服务器和手机连接在同一局域网下，我的手机和电脑都连接在同一个路由器下，这样就表示手机和电脑连接在同一局域网下

第二步：查看服务器的ip地址（因为Tomcat安装在电脑中，所以服务器的ip地址就是电脑的ip地址），打开命令行，使用ipconfig命令可以查看主机的ip地址)

![屏幕快照 2016-07-30 23.14.17.png](http://ww2.sinaimg.cn/large/72f96cbagw1f6ccbdf0k7j20hh0bcdhd.jpg)

第三步：确保防火墙已经关闭

![屏幕快照 2016-07-30 23.16.12.png](http://ww4.sinaimg.cn/large/72f96cbagw1f6cccbkf1ej20jh0d0wha.jpg)

第四步：在手机浏览器中打开`http://192.168.0.8:8080/apps/index.html`

![1.jpg](http://ww2.sinaimg.cn/large/72f96cbagw1f6ccl57o5sj20bt045mxd.jpg)

## 修改默认主页

1. 在webapps文件夹下创建一个myindex文件夹，在文件夹内添加自己的index.html主页面。

2. 修改server.xml文件

	在server.xml找到如下位置：

	![屏幕快照 2016-08-08 13.43.31.png](http://ww1.sinaimg.cn/large/006tNbRwgw1f6madykbxuj30i20bitbk.jpg)

	然后在`<Host></Host>`标签之间添加

				<Context path="" docBase="myindex" debug="0" reloadable="true" />

	>path是说明虚拟目录的名字，如果你要只输入ip地址就显示主页，则该键值留为空；

	>docBase是虚拟目录的路径，它默认的是$tomcat/webapps/ROOT目录，现在是我们设置的myindex目录

	>debug和reloadable一般都分别设置成0和true。

3. 修改web.xml

	如果你的主页面是名称为`index`,则这一步就不用修改了。假设你的主页面名称为`a.jsp`。

	在web.xml文件中，找到如下位置：

	![屏幕快照 2016-08-08 13.59.29.png](http://ww1.sinaimg.cn/large/006tNbRwgw1f6matxworoj30dn03mjs2.jpg)

	然后在`<welcome-file-list></welcome-file-list>`标签内，添加如自己的主页面

				<welcome-file>a.jsp</welcome-file>

	然后`保存`上述文件，`重启tomcat`，就可以在浏览器中直接输入`ip地址`访问了。

**转载请标注原文地址**                           
(end)
