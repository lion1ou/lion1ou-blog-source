---
title: mongoDB入门指南
toc: true
comments: true
categories: 技术博客
tags: Default
date: 2018-04-08 19:43:52
photos:
description:
---

MongoDB 是一个基于分布式文件存储的数据库。由 C++ 语言编写。旨在为 WEB 应用提供可扩展的高性能数据存储解决方案。MongoDB 是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。

MongoDB 将数据存储为一个文档，数据结构由键值(key=>value)对组成。MongoDB 文档类似于 JSON 对象。字段值可以包含其他文档，数组及文档数组。


### 安装

使用 brew 安装

此外你还可以使用 OSX 的 brew 来安装 mongodb：

```bash
sudo brew install mongodb
```

如果要安装支持 TLS/SSL 命令如下：

```shell
sudo brew install mongodb --with-openssl
```

安装最新开发版本：

```bash
sudo brew install mongodb --devel
```

### 运行

运行 MongoDB

首先我们创建一个数据库存储目录 /data/db：

```bash
sudo mkdir -p /data/db
```

启动 mongodb，默认数据库目录即为 /data/db：

```bash
sudo mongod
```

### 连接

如果没有创建全局路径 PATH，需要进入以下目录
cd /usr/local/mongodb/bin
sudo ./mongod
