---
title: Windows下安装cordova开发环境
toc: true
date: 2016-07-14 14:02:08
tags: Cordova
categories: Cordova
comments: true
---
## 准备阶段：

### 必备：

- [JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)（根据自己的开发平台下载相应的安装包，可能需要FQ）
<!-- more -->
![46AC8FE5-B5F5-4F78-A655-4D055018F4E2.jpg](http://ww3.sinaimg.cn/large/72f96cbagw1f6d5lisumzj20f908i0ty.jpg)

- [Nodejs](https://nodejs.org/en/download/)  （根据自己的开发平台下载相应的安装包，可能需要FQ）

- [Android SDK Manage](http://developer.android.com/sdk/index.html)  （根据自己的开发平台下载相应的安装包，可能需要FQ）

![B5D0789C-EF1A-4194-949C-0C33599D6B43.jpg](http://ww2.sinaimg.cn/large/72f96cbagw1f6d5mvz8qvj20lw0ckjs9.jpg)

若没办法FQ的同学，可以去[这里](https://github.com/inferjay/AndroidDevTools/)找找看看，也可以直接下载链接：[http://pan.baidu.com/s/1skXwktJ](http://pan.baidu.com/s/1skXwktJ)（2016.4.24整理）

### 其他：

- [Eclipse](https://www.eclipse.org/downloads/)  （根据自己的开发平台下载相应的安装包，可能需要FQ）

![E3020D0F-093D-44EE-BA21-3B97867A4371.jpg](http://ww3.sinaimg.cn/large/72f96cbagw1f6d5oeaiyvj20nb07u74t.jpg)

选择这个下载通道：

![7D18D751-A9ED-427A-9A32-A9F2590AFE63.jpg](http://ww4.sinaimg.cn/large/72f96cbagw1f6d5oyzr6uj20el0400so.jpg)

- [apache-ant](http://ant.apache.org/bindownload.cgi)

![DCCCC77A-F48B-47D1-8397-71896498675E.jpg](http://ww3.sinaimg.cn/large/72f96cbagw1f6d5pxwi7pj20hy05rgmf.jpg)



## 配置阶段：

### 安装JDK

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




### 安装 Android SDK

1. 安装Android SDK Tool,自定义配置安装地址，下一步...下一步，OK！

2. 打开Android SDK Manager，根据自己需求选择下载android SDK。

	（运行后出现如下界面，选择自己需要的Android版本，然后点击"Install X packages"。Installed 表示已经安装、Not installed表示没有安装!!）

	![50B0148D-8A4D-445F-B1EB-5E4526E76931.jpg](http://ww4.sinaimg.cn/large/72f96cbagw1f6d5vy3oyjj20fx0cv0wv.jpg)

	在新出现的界面中选择如下Accept或者Accept All,然后点击Install。Android SDK 管理器就开始下载并安装你所选的包了，我们等一段时间就OK了！

	![B1DB480B-D396-4F0F-963F-F044CF5B2D30.png](http://ww3.sinaimg.cn/large/72f96cbagw1f6d5wxqeyej20gm0a777d.jpg)

	![50B0148D-8A4D-445F-B1EB-5E4526E76931.jpg](http://ww4.sinaimg.cn/large/72f96cbagw1f6d5xhnl0bj20fx0cv0wv.jpg)

	注：可能会出现没有FQ无法下载的情况，我整理的分享链接里，有一个压缩包，是我自己现在在用的SDK包，将其解压到自己相应的文件夹下。

	![7E97BDF0-CA45-42B6-81AE-A40D002434FE.jpg](http://ww4.sinaimg.cn/large/72f96cbagw1f6d5yiwqa0j20go0avjs2.jpg)

3. 配置环境变量
	添加ANDROID_HOME (同添加JAVA_HOME方法)

	![0E302D64-24D0-4E33-9C75-F3D1F086DEDA.png](http://ww1.sinaimg.cn/large/72f96cbagw1f6d5z3gbt4j20ij05at9m.jpg)

	设置PATH中添加ANDROID_HOME目录下的tools和platform-tools目录。

	![5408706E-71DA-4480-8943-09FA4DC1418A.png](http://ww3.sinaimg.cn/large/72f96cbagw1f6d5zlu57gj20fg0fmwhy.jpg)


### 安装Nodejs

1. 安装node.msi，自定义配置安装地址，下一步...下一步，OK！

2. 找到Node.js command prompt或者直接打开cmd

	![91D2745F-47DF-46EF-8039-FCABFF804C4F.jpg](http://ww1.sinaimg.cn/large/72f96cbagw1f6d60xte0xj206p05jt8o.jpg)

3. 输入：node -v 查看安装版本,输出版本即安装成功

	![1A18784A-6321-4DF9-9A60-2D758BA3A2E8.jpg](http://ww1.sinaimg.cn/large/72f96cbagw1f6d6184ec2j204v01ua9u.jpg)

4. 安装cordova
	输入： npm install -g cordova   安装全局的cordova

	![51214CBB-ADCE-4C22-B3C5-B8E12DA7BFB0.jpg](http://ww1.sinaimg.cn/large/72f96cbagw1f6d61gmpi5j208401a0sj.jpg)

	正在安装...

	![D103AEA2-8D88-4EBD-840A-367F581AC52E.jpg](http://ww4.sinaimg.cn/large/72f96cbagw1f6d61s3i0rj20qz07hgmw.jpg)

	安装完成。

5. 重启界面

	到这里环境已经搭建完成，可以直接在命令行上创建和编译cordova项目。详见本人其他相关文章。



## 下面是为习惯使用eclipse的同学准备的。

### 安装eclipse

解压eclipse，双击Eclipse图标后，就可以启动Eclipse了,到这Eclipse就安装完毕了。

注意：最好把解压包放到，之前安装JDK的同级目录上

![14143D42-D54A-45E7-8F07-0A7529AC1041.jpg](http://ww4.sinaimg.cn/large/72f96cbagw1f6d636pztpj20cp08hweo.jpg)

### ADT安卓开发插件安装

ADT(Android Development Tools)安卓开发工具，是安卓在Eclipse IDE环境中的开发工具，为Android开发提供开发工具的升级或者变更，简单理解为在Eclipse下开放工具的升级下载工具。

通过Android开发者官网([developer.android.com](http://developer.android.com/)), 我们可以知道，Eclipse可以通过两种方式安装ADT插件，在线安装、离线安装(需要先下载[ADT插件包](https://github.com/inferjay/AndroidDevTools/)，我整理的分享链接中也有现成的)。

（eclipse离线安装ADT插件）

1. 下载ADT插件的zip文件（不要解压）
2. 启动Eclipse,然后在菜单栏上选择 Help > Install New Software
3. 单击 Add 按钮，在右上角
4. 在"Add Repository"对话框，单击"Archive"
5. 选择下载的adt-X.X.X.zip文件并单击"确认"。
6. 在Name(名称)处输入"ADT Plugin",单击“OK”
7. 在软件对话框中,选中"Developer Tools"复选框,然后点击"Next"
8. 在下一个窗口中，您会看到一个要下载的工具列表。单击“Next”
9. 阅读并接受许可协议，然后单击“Finish”
10. 安装完成后，重新启动Eclipse


### 安装配置apache-ant

1. 解压ant 你得到的是一个压缩包，解压缩它，并把它放在一个尽量简单的目录，例如D:\ant-1.9.6

2. 添加ANT_HOME (同添加JAVA_HOME方法)

3. 设置PATH中添加ANT_HOME目录下的bin目录。

4. 测试一下你的设置，开始-->运行-->cmd进入命令行-->键入 ant 回车

	![AF08A100-709C-4A8E-BE41-C9E71E88CB0E.jpg](http://ww3.sinaimg.cn/large/72f96cbagw1f6d65hbz3aj208j01rt8k.jpg)

5. 配置成功。

现在可在eclipse中导入项目了，因为我很少使用eclipse，所以就不具体说明了。

**转载请标注原文地址**                           

