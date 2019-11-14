---
title: Java之Mybatis简介
toc: true
comments: true
categories: Java
tags: Java
date: 2016-12-22 11:28:13
photos:
description:
---

MyBatis是一款一流的支持自定义SQL、存储过程和高级映射的持久化框架。MyBatis几乎消除了所有的JDBC代码，也基本不需要手工去设置参数和获取检索结果。MyBatis能够使用简单的XML格式或者注解进行来配置，能够映射基本数据元素、Map接口和POJOs（普通java对象）到数据库中的记录。相对Hibernate和Apache OJB等“一站式”ORM解决方案而言，Mybatis 是一种“半自动化”的ORM实现。

<!--more-->
## MyBatis工作流程

#### (1)加载配置并初始化

触发条件：加载配置文件

配置来源于两个地方，一处是配置文件，一处是Java代码的注解，将SQL的配置信息加载成为一个个MappedStatement对象（包括了传入参数映射配置、执行的SQL语句、结果映射配置），存储在`内存`中。

#### (2)接收调用请求

触发条件：调用Mybatis提供的API

传入参数：为SQL的ID和传入参数对象

处理过程：将请求传递给下层的请求处理层进行处理。

#### (3)处理操作请求 触发条件：API接口层传递请求过来　

传入参数：为SQL的ID和传入参数对象

处理过程：

* (A)根据SQL的ID查找对应的MappedStatement对象。
* (B)根据传入参数对象解析MappedStatement对象，得到最终要执行的SQL和执行传入参数。
* (C)获取数据库连接，根据得到的最终SQL语句和执行传入参数到数据库执行，并得到执行结果。
* (D)根据MappedStatement对象中的结果映射配置对得到的执行结果进行转换处理，并得到最终的处理结果。
* (E)释放连接资源。

#### (4)返回处理结果将最终的处理结果返回。

* orm工具的基本思想

    无论是用过的hibernate,mybatis,你都可以发现他们有一个共同点：

    * 从配置文件(通常是XML配置文件中)得到 sessionfactory.
    * 由sessionfactory 产生 session
    * 在session 中完成对数据的增删改查和事务提交等.
    * 在用完之后关闭session 。
    * 在java 对象和 数据库之间有做mapping 的配置文件，也通常是xml 文件。

* 功能架构

    ![](https://ww3.sinaimg.in/large/006tNbRwgw1fb5n7ymlyuj30jp0au41b.jpg)

    Mybatis的功能架构分为三层：
    
    * API接口层：提供给外部使用的接口API，开发人员通过这些本地API来操纵数据库。接口层一接收到调用请求就会调用数据处理层来完成具体的数据处理。
    * 数据处理层：负责具体的SQL查找、SQL解析、SQL执行和执行结果映射处理等。它主要的目的是根据调用的请求完成一次数据库操作。
    * 基础支撑层：负责最基础的功能支撑，包括连接管理、事务管理、配置加载和缓存处理，这些都是共用的东西，将他们抽取出来作为最基础的组件。为上层的数据处理层提供最基础的支撑。

* 大多需要添加的驱动包

    ![](https://ww4.sinaimg.in/large/006tNbRwgw1fb5nbl1lb2j309508fgmt.jpg)





