---
title: github之配置SHH
toc: true
comments: true
categories: Other
date: 2016-09-10 16:34:12
tags: Git
---

打开GitHub，点击页面上方的齿轮按钮进入设置界面，点击左边的SSH keys，添加一个SSH keys。SSH keys的好处是让我们以后在本地进行操作并同步到GitHub上时不用输密码，那么如何配置SSH keys？
<!-- more -->

1. 创建SSH Key

    * 打开终端,输入 `ssh-keygen -t rsa -C "xxxxx@qq.com"` 邮箱更新为自己的
    * 回车保存默认位置
    * 输入密码,用来加密私钥(以后就要用这个密码)

    ![image](http://7xvowi.com1.z0.glb.clouddn.com/blog/sshKey.png)

    * 密钥存放在主文件夹的.ssh文件夹内
    * 打开文件备份 id_rsa(私钥) ; id_rsa.pub(公钥)两个文件,打开公钥,复制所有内容

2. 与远程仓库绑定

    * 在远程服务器,如coding/github页面内找到`添加公钥选项`,粘贴刚刚复制的内容,添加即可.

    ![add-key.png](http://ww3.sinaimg.cn/large/72f96cbagw1f5ri2y4lq6j20li0c1aam.jpg)

3. 测试是否配置成功：

    `ssh -T git@github.com`

    ` ssh -T git@git.coding.net`

    >如果返回的结果如下：

    ![屏幕快照 2016-07-12 22.40.58.png](http://ww2.sinaimg.cn/large/72f96cbagw1f5ri63qh0sj20gm01vwf5.jpg)

    >输入yes，就能看到

    ![屏幕快照 2016-07-12 22.42.01.png](http://ww3.sinaimg.cn/large/72f96cbagw1f5ri77dmgyj20j500raa8.jpg)

    >这样你的SSH key就配置完成了。

4. 若需要重复输入帐号密码

    将repo连接修改为ssh的链接

**转载请标注原文地址**                           
(end)
