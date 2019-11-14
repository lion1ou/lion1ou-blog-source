---
title: eclipse中配置Tomcat
toc: true
comments: true
categories: Java
tags: Java
date: 2016-12-02 11:30:21
photos:
description:
---
Eclipse 有众多版本，最常用的包括Eclipse EE，Eclipse SE。当然还有MyEclipse等，但是MyEclipse是基于Eclipse的商业软件，因此本文不包含MyEclipse。不同版本的eclipse配置tomcat可能有所差异。
<!--more-->

### Eclipse EE 配置Tomcat

Eclipse EE 主要用于Java Web开发和J2EE项目开发。Eclipse EE中配置Tomcat比较简单，新建一个Tomcat Server即可，步骤如下：

1. 打开Servers 视图

    通过菜单Window->Show View->other->Servers打开Servers视图。

2. 新建Tomcat 服务器

    右击空白区域，选择File->New->other->Server（对于没有任何Server的环境，可以点击"new server wizard"链接）；然后在列表中选择Tomcat服务器，选中本机相应版本；选择本机Tomcat目录，点击完成即可。到此，Eclipse EE 配置Tomcat成功。

### Eclipse SE 配置Tomcat

Eclipse SE主要用于`控制台程序`的开发，如果进行`Web开发`建议使用Eclipse EE。当然，Eclipse SE也可以配置Tomcat，具体如下：

1. 下载Tomcat插件

下载地址：[http://www.eclipsetotale.com/tomcatPlugin.html](http://www.eclipsetotale.com/tomcatPlugin.html)，下载时，请注意核对Eclipse版本和Tomcat版本，目前基本都可以使用Tomcat插件最新版本。
PS: 是Tomcat插件，不是Tomcat，两者不同

2. 安装Tomcat插件

解压Tomcat插件，拷贝到Eclipse目录中Plugin下，重启Eclipse，Tomcat插件即可安装成功。

3. 配置Tomcat插件

在Eclipse中，点击Window->Preferences->Tomcat，选择本机Tomcat版本号（已下载并解压Tomcat到本地），选择Tomcat Home目录，即Tomcat所在目录。

配置后在Eclipse中启动Tomcat，并在Eclipse中的Internal Web Browser中输入：localhost:8080，如果出现Tomcat页面，即配置Tomcat插件成功。 

### Tomcat启动后打开页面提示404错误的解决

Eclipse配置并启动Tomcat成功，但有时会访问localhost:8080出现404错误，此时需要修改Tomcat配置。步骤如下：

1. 在Eclipse中双击Tomcat server，打开Tomcat配置页面。

2. 修改Server locations为Use Tomcat installation。

3. 修改Deploy path为webapps,默认为wptwebapps。

4. 保存配置即可。

PS：如果不能修改配置，在Server中删除Tomcat，重新添加一次，即可配置。




