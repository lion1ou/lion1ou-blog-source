---
title: 签名打包Android版apk
toc: true
date: 2016-07-17 14:02:08
tags: Cordova
categories: Cordova
comments: true
---

首先是关于apk签名，Android程序的安装是以包名（package name）进行区分的，就是同样的包名会被认作是同一个程序。这样就可以进行升级、替换。但是包名是一个可以被查看的字符串，这样就可能被伪造，然后其他人就可以自己创建一个应用去替代你的应用，结果可想而知。而签名就是为了防止这样的情况发生，当你的程序被签名后安装，只有同样包名与签名的程序才能被替换安装。而签名是不可能简单被伪造的，从而保证了程序的安全性。
<!-- more -->

>打包签名apk可以通过命令行、eclipse和android studio，这里先介绍命令行和eclipse方式，其他的之后补上。


## 使用命令行打包签名apk

1. 打包apk

```shell
cordova bulid android              //用于测试的打包方式，生成已签名apk
cordova build --release android    //生成没有签名的apk
```

	>第一个命令生成的是一个Cordova-debug.apk，很明显是用来进行本地开发测试使用的，注意这个apk是有签名的，所以能被安装在手机上，但是这个不能用来上架。

	>因为只有在绝对同样的环境下进行打包，才能保证这个apk的签名相同，意味着你这台机器必须始终保持正常并且系统和打包工具等不作修改。这明显是不合理的。

	>所以，我们必须采用生产的方式打包，就是第二个命令，这个命令生成的是一个无签名的apk，他无法安装在手机上，必须进行签名。

2. 生成签名文件

```shell
keytool -genkey -v -keystore demo.keystore -alias demo.keystore -keyalg RSA -validity 20000
```

	>keytool是工具名称；

	>-genkey意味着执行的是生成数字证书操作；

	>-v表示将生成证书的详细信息打印出来；

	>-keystore demo.keystore 表示证书的文件名；

	>-alias demo.keystore 表示证书的别名；

	>-keyalg RSA 生成密钥文件所采用的算法；

	>-validity 20000 该数字证书的有效期，单位是天；

	输入后会让你输入密码，并回答一些关于你公司和地区的问题，回答完后截屏记录，防止忘记。

- 签名apk

```shell
jarsigner -verbose -keystore /yourpath/demo.keystore -signedjar /yourpath/demo_signed.apk  /yourpath/demo.apk  /yourpath/demo.keystore
```
	>jarsigner是工具名称，

	>-verbose表示将签名过程中的详细信息打印出来；

	>/yourpath/  （根据自己的情况配置）相对于当前命令行所在文件夹的位置，可将下列文件放在同一目录下;

	>-keystore   /yourpath/demo.keystore   刚刚生成的签名文件；

	>-signedjar  /yourpath/demo_signed.apk  签名后的apk名称

	>/yourpath/demo.apk  需要签名的apk

	>/yourpath/demo.keystore 证书的别名


- 查看apk的签名

	查看签名是否成功，可将签名后的文件，后缀名apk的改为zip，解压。在该目录下，输入如下命令：
	```shell
	keytool -printcert -file META-INF/CERT.RSA
	```

	>META-INF/TEST.RSA   根据自己的情况配置

	输入命令行后，会出现类似下图信息

	![13E87187-23B8-4A4B-9C1D-92BC260982B6.jpg](http://ww1.sinaimg.cn/large/72f96cbagw1f6d81otra6j214203ymz4.jpg)



## 使用eclipse打包签名apk

1. 首先，选择Export...如下图：

	![5F2BDF7A-EABD-4C88-B534-129F3BBFD10E.jpg](http://ww1.sinaimg.cn/large/72f96cbagw1f6d83mf0ynj20el0bk3zt.jpg)

2. 创建密钥库keystore,输入密钥库导出位置和密码，记住密码，下次Use existing keystore会用到。

	![733A2366-A67B-4DAB-A71B-4CEE8F53AB63.jpg](http://ww1.sinaimg.cn/large/72f96cbagw1f6d8407cj9j20eh0f7q44.jpg)

3. 填写密钥库信息，填写一些apk文件的密码，使用期限和组织单位的信息。

	![904EF7A1-CDFE-4157-BCAB-DF46401B914A.jpg](http://ww3.sinaimg.cn/large/72f96cbagw1f6d84a3idij20ei0f90ug.jpg)

4. 生成带签名的apk文件，到此就结束了。

	![F096A79B-CA8D-412E-B1A8-C82CB3879D92.jpg](http://ww4.sinaimg.cn/large/72f96cbagw1f6d855j9p2j20eh0f6dgx.jpg)

若有不对之处，请批评指正，谢谢！

                          

