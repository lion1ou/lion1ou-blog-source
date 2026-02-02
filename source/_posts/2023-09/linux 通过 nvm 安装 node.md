---
title: Linux 通过 nvm 安装 Node
date: 2023-09-10 10:00:00
tags: Linux
toc: true
categories: 运维笔记
comments: true
photos:
---

在 CentOS 7 下，无法安装 Node 18 以上版本，该如何解决？本文给出完整步骤与常见错误的处理。

<!-- more -->

### 安装nvm
+ 下载 压缩文件并解压到指定文件夹

```bash
sudo chmod 777 /.nvm  # 获取权限

cd / # 打开根目录

wget https://github.com/nvm-sh/nvm/archive/refs/tags/v0.39.1.tar.gz # 下载文件

mkdir -p /.nvm  # 创建nvm文件夹

ll -a # 查看目录

tar -zxvf v0.39.1.tar.gz -C .nvm  # 解压文件

```



+ 修改 .bashrc 文件

`vim ~/.bashrc`

```bash
export NVM_DIR="/.nvm/nvm-0.39.1"  # 注意版本号
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

`source ~/.bashrc`



+ 验证是否安装成功

`nvm ls`

<!-- 这是一张图片，ocr 内容为：[15:08:15 LS NVM SYSTEM N/A (DEFAULT) IOJS STABLE (-> N/A) (DEFAULT) NODE N/A(DEFAULT) UNSTABLE -->
![](https://cdn.lion1ou.tech/picGo/dcb4662c98521f3e26f0338fd2aeea85_MD5.png)  

这样就说明安装成功了，然后根据自己的需求安装相应的node



+ 安装node

`nvm install 18`

<!-- 这是一张图片，ocr 内容为：[15:35:0 # NVM INSTALL 18 DOWNLOADING AND INSTALLING NODE V18.17.1... DOWNLOADING HTTPS://NODEJS.ORG/DIST/V18.17.1/NODE-V18.17.1-LINUX-X64.TAR.9Z. ##################################################################################################### ##################################################################################################### COMPUTING CHECKSUM WITH SHA256SUM CHECKSUMS MATCHED! NOW USING NODE V18.17.1 (NPM V) 18 CREATING DEFAULT ALIAS:DEFAULT V18.17.1) -->
![](https://cdn.lion1ou.tech/picGo/f536a46a63834b90b40be70de3e3ae4c_MD5.png)



+ 验证是否可用

`node -v`

### 安装 C++ 基础依赖
如果根据上面的步骤执行完，可以看到node版本返回，那么就成功了，就不需要看下面的了。

如果出现下面报错，则需要根据下面步骤解决：

<!-- 这是一张图片，ocr 内容为：[15:15:02ROOT@FAT-CONCHSERVICE-DC01-026091: # NODE-V LNODE: /IB64/LIBM.SO.6: VERSION (REQUIRED BY NOT FOUND (REQUIRED BY NODE) INODE: /LIB64/LIBC.SO.6: VERSION (GLIBC_25' NOT FOUND (REQUIRED BY NODE) -/LIBC.SO.6: VERSION 'GLIBC_2.28' NOT FOUND (REQUIRED BY NODE) NODE://LIB64/LI NOT FOUND (REQUIRED BY NODE) NODE: /LIB64/LIBSTDC++.SO.6: VERSION 'CXXABI_1.3.9 NOT FOUND (REQUIRED BY NODE) NODE: /LIB64/LIBSTDC++.SO.6:VERSION GLIBCXX_3.4.20 'GLIBCXX_3.4.21' NOT FOUND (REQUIRED BY NODE) INODE:/LIB64/LIBSTDC++.SO.6:VERSION -->
![](https://cdn.lion1ou.tech/picGo/be7d854f09e51c7af52a4ad274a40274_MD5.png)

出现这个报错的原因是：新版的node v18开始 都需要GLIBC_2.28支持，可是目前系统内却没有那么高的版本。

#### 解决 GLIBC 问题
可以根据需求在 [http://ftp.gnu.org/gnu/glibc/](http://ftp.gnu.org/gnu/glibc/) ，找到需要的版本，这里使用2.28版本

```bash
cd /

wget http://ftp.gnu.org/gnu/glibc/glibc-2.28.tar.gz

tar xf glibc-2.28.tar.gz 

cd glibc-2.28/ && mkdir build  && cd build

../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
```



根据上面步骤安装完后，可能会出现以下错误，没出现错误的可以跳过。

+ 错误1

<!-- 这是一张图片，ocr 内容为：:/GLIBC-2.28/BUILD] [10:12:27 ../CONFIGURE --WITH-BINUTILS/USR/BIN "USR --DISABLE-PROFILE --ENABLE-ADD-ONS --WITH-HEADERS-/USR/INCLUDE -PREFIX CHECKING BUILD SYSTEM TYPE... X86-64-PC-LINUS PC-LINUX-GNU CHECKING HOST SYSTEM TYPE.. X86_64-PC-LINUX-GNU CHECKING FOR GCC.... NO CHECKING FOR CC.... NO CHECKING FOR CL.EXE... .. NO CONFIGURE:ERROR:IN /GLIBC-2.28/BUILD': CONFIGURE: ERROR: NO ACCEPTABLE C COMPILER FOUND IN $PATH 'CONFIG.LOG''FOR MORE DETAILS SEE -->
![](https://cdn.lion1ou.tech/picGo/1d88f011528faad907f9bbef039b825c_MD5.png)

原因是gcc 不存在，需要安装gcc， `yum install gcc`

安装后，继续执行上面的命令



+ 错误2

<!-- 这是一张图片，ocr 内容为：CHECKING VERSION OF MSGFMT... 0.19.8.1, 0 `1, OK CHECKING FOR MAKEINFO... NO CHECKING FOR SED. SED LON OF SED...4.2.2,OK CHECKING VERSION OF CHECKING FOR GAWK... GAWK CHECKING VE GVERSION OF GAWK....4.0.2,OK FOR  BISON.....NO CHECKING IF GCC -B/USR/BIN/ IS SUFFICIENT TO BUILD LIBC... NO CHECKING CHECKING FOR N NM.. NM CHECKING FOR PYTHON3. PYTHON3 CONFIGURE: ERROR: *** THESE CRITICAL PRE AL PROGRAMS ARE MISSING OR TOO OLD: MAKE BISON COMPILER CHECK THE INSTALL FILE FOR REQUIRED VERSIONS. 水水水 -->
![](https://cdn.lion1ou.tech/picGo/7a498c2d533842c3f66e24158c9b3703_MD5.png)

<font style="color:rgb(35, 38, 59);">解决办法：升级gcc与make</font>

```shell
# 升级GCC(默认为4 升级为8)
yum install -y centos-release-scl
yum install -y devtoolset-8-gcc

mv /usr/bin/gcc /usr/bin/gcc-4.8.5
ln -s /opt/rh/devtoolset-8/root/bin/gcc /usr/bin/gcc
mv /usr/bin/g++ /usr/bin/g++-4.8.5 # 如果出现不存在，跳过，直接执行下面命令
ln -s /opt/rh/devtoolset-8/root/bin/g++ /usr/bin/g++

# 升级 make(默认为3 升级为4)
cd /
wget http://ftp.gnu.org/gnu/make/make-4.3.tar.gz
tar -xzvf make-4.3.tar.gz && cd make-4.3/
./configure  --prefix=/usr/local/make
make && make install
cd /usr/bin/ && mv make make.bak
ln -sv /usr/local/make/bin/make /usr/bin/make
```

返回目录执行

```shell
cd /glibc-2.28/build

../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
```



+ 错误3

<!-- 这是一张图片，ocr 内容为：CHECKING FOR NM...NM CHECKING FOR PYTHON3...PYTHON3 CONFIGURE: ERROR: THESE CRITICAL PROGRAMS ARE MISSING OR TOO OLD: BISON 水水水 水水水 CHECK THE INSTALL FILE FOR REQUIRED VERSIONS -->
![](https://cdn.lion1ou.tech/picGo/59b58125a77f205431be7be53162bec4_MD5.png)

安装 `yum install bison`

到这里所有问题解决完了。



```shell
cd /glibc-2.28/build

../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
```



然后就执行 `make && make install`，开始编译吧，大概需要半小时时间。



参考：[node: /lib64/libm.so.6: version `GLIBC_2.27′ not found - 丁少华 - 博客园](https://www.cnblogs.com/dingshaohua/p/17103654.html)



#### 解决 GLIBCXX 问题
<!-- 这是一张图片，ocr 内容为：[15:46:02ROOT@FAT-CONCHSERVICE-DC01-026091:/GLIBC-2.28/BUILD] NODE -V O.6: VERSION 'CXXABI_1.3.9' NOT FOUND (REQUIRED BY NODE) NODE://LIB64/LIBSTDC++.SO.6 S VERSION 'GLIBCXX_3.4.20' NOT FOUND (REQUIRED BY NODE) NODE://LIB64/LIBSTDC++.SO.6:VEL LNODE: /LIB64/LIBSTDC++SO.6: VERSION (GLIBCXX.3.4.21' NOT FOUND (REQUIRED BY NODE) -->
![](https://cdn.lion1ou.tech/picGo/9fa828b8495e74916bc22032cfa16d4a_MD5.png)

问题跟上面其实是一样的，缺少GLIBCXX依赖



+ 首先检查，当前系统的动态库

```shell
strings /usr/lib64/libstdc++.so.6 | grep GLIBC
```

会发现确实不存在我们需要的依赖

<!-- 这是一张图片，ocr 内容为：/USR/LIB64/LIBSTDC++.SO T.SO.6 GLIBC STRINGS GREP GLIBCXX_3.4 GLIBCXX_3.4.1 GLIBCXX_3.4.2 GLIBCXX_3.4.3 GLIBCXX_3.4.4 GLIBCXX_3.4.5 GLIBCXX_3.4.6 GLIBCXX_3.4.7 GLIBCXX_3.4.8 GLIBCXX_3.4.9 GLIBCXX_3.4.10 GLIBCXX_3.4.11 GLIBCXX_3.4.12 GLIBCXX_3.4.13 GLIBCXX_3.4.14 GLIBCXX_3.4.15 GLIBCXX_3.4.16 GLIBCXX_3.4.17 GLIBCXX_3.4.18 GLIBCXX_3.4.19 GLIBC_2.3 GLIBC_2.2.5 GLIBC_2.14 GLIBC_2.4 GLIBC_2.3.2 GLIBCXX_DEBUG_MESSAGE_LENGTH -->
![](https://cdn.lion1ou.tech/picGo/a79f0bad653869205a633e63e31283a6_MD5.png)

+ 检查当前动态库的位置和版本

```shell
find / -name libstdc++.so.6*
```

<!-- 这是一张图片，ocr 内容为：FIND /-NAME LIBSTDC++.SO.6 0  6* /USR/LIB64/LIBSTDC++.SO.6 /USR/LIB64/LIBSTDC++.SO.6.0.19 /USR/SHARE/GDB/AUTO-LOAD/USR/LIB64/LIBSTDC++.SO.6.0.19-GDB.PY /USR/SHARE/GDB/AUTO-LOAD/USR/LIB64/LIBSTDC++.SO.6.0.19-GDB.PY /USR/SHARE/GDB/AUTO-LOAD/USR/LIB64/LIBSTDC++.SO.6.0.19-GDB.PYO -->
![](https://cdn.lion1ou.tech/picGo/c5d30852d9a7a8f5cdae47288e027e7e_MD5.png)  

发现我们系统本地也不存在新的动态库，那只能去升级了

+ 下载gcc版本，选择最新的

```bash
cd /

wget https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz  --no-check-certificate

tar -zxvf  gcc-13.2.0.tar.gz  # 解压

cd gcc-13.2.0

./contrib/download_prerequisites # 下载各项依赖

mkdir build && cd build 

../configure --enable-checking=release --enable-languages=c,c++ --disable-multilib

make && make install  # 需要几个小时时间(我花了4个小时)，耐心等着吧
```

+ 检查 gcc 版本，`gcc -v`



可能出现错误：

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.lion1ou.tech/picGo/a1415b1f4d32beb008cafbd0deda969c_MD5.png)  



+ 创建软链接

查找GCC编译时生成的最新的动态库位置

```bash
find / -name "libstdc++.so*"
```

<!-- 这是一张图片，ocr 内容为：# FIND / -NAME "LIBSTDC++.SO*" /USR/LIB/GCC/X86_64-REDHAT-LINUX/4.8.2/32/TIBSTDC++.S0 /USR/LIB/GCC/X86_64-REDHAT-LINUX/4.8.2/LIBSTDC++.SO /USR/LIB64/LIBSTDC++.SO.6 /USR/LIB64/LIBSTDC++.SO.6.0.19 /USR/SHARE/GDB/AUTO-LOAD/USR/LIB64/LIBSTDC++.SO.6.0.19-GDB.PY /USR/SHARE/GAB/AUTO-LOAD/USR/LIB64/LIBSTDC++.SO.6.0.19-GDB.PY /USP/SHARE/GAB/AUTO-LOAD/USR/LIB64/LIBSTDC++.SO.6.0.19-GDB.PYO /USR/LOCAL/LIB64/LIBSTDC++.SO.6.0.32 /USR/LOCAL/LIB64/LIBSTDC++.SO.6 /USR/LOCAL/LIB64/LIBSTDC++.SO /USR/LOCAL/LIB64/LIBSTDC++.SO.6.0.32-GDB.PY /OPT/TH/DEVTOOLSET-8/ROOT/USR/LIB/GCC/X86-64-REDHAT-LINUX/8/3Z/LIBSTDC++.SO /OPT/RH/DEVTOOLSET-8/ROOT/USP/LIB/GCC/X86-64-REDHAT-LINUX/8/LIBSTAC++ SO /GCC-13.2.0/BUILD/X86_64-PC-LINUX-GNU/LIBSTDCH+V3/SRC/.LIBS/LIBSTDC++.S0.6.0.32 /9CC-13,2.0/BULLD/X86_64-PC-11NUX-GNU/LIBSTDCH+V3/SRC/.1IBS/LIBSTDCH+.SO. /GCC-13.2.0/BUILD/X86-64-PC-LINUX-GHU/LIBSTDC++-V3/SRC/.LIBS/LIBSTDC++.SO /9CC-13.2.9/BUILD/PREV-X86-64-PC-LINUX-GNU/LIBSTAC++V3/SRC/,LIBS/LIBS/LIBSTDC++50.6.0.33 /GCC-13.2.0/BUILD/PREV-X86.64-PC-LINUX-GNU/LIBSTDC++V3/SRC/.LIBS/LIBSTDC++.SO.6 /GCC-13.2.0/BUILD/PREV-X86-64-PC-LINUX-GNU/LIBSTDC++V3/SRC/.LIBS/LIBSTDCH+.SO /9CC-13.2.0/BUILD/STAGEL-X86-64-PC-LINUX-GNU/LIBSTDC++-V3/SRC/.LIBS/LIBSTDCH+SO.6.0.6.0.32 /9CC-13.2.0/BUILD/STAGEL-X86-64-PC-LINUX-GNU/LIBSTAC++-V3/SRC/,1IBS/LIBSTDC++50.9 /GCC-13,2.0/BUILA/STAGEI-X86-64-PC-LINUX-GNU/LIBSTDC++-V3/SRC/.IIBS/LIBSTDCH+SO -->
![](https://cdn.lion1ou.tech/picGo/7618026338ce53a8cbb9687b2ea5948a_MD5.png)  

<font style="color:rgb(77, 77, 77);">可以看到，有更高的版本 </font>`<font style="color:rgb(77, 77, 77);">/usr/local/lib64/libstdc++.so.6.0.32</font>`

```bash
cp /usr/local/lib64/libstdc++.so.6.0.32 /usr/lib64/

cd /usr/lib64/

rm libstdc++.so.6

ln -s libstdc++.so.6.0.32 libstdc++.so.6
```

最后 执行 `node -v`，如果展示node版本，就说明大功告成了


参考：[https://www.imqianduan.com/linux/gcc-update-libstdc.html](https://www.imqianduan.com/linux/gcc-update-libstdc.html)




