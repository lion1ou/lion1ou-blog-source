---
title: Java之equals方法及==的用法
toc: true
comments: true
categories: 技术博客
tags: Default
date: 2017-01-07 15:50:04
photos:
description:
---
对于字符串变量来说，使用`==`和`equals()`方法比较字符串时，其比较方法不同。`==`比较两个变量本身的值，即两个对象`在内存中的首地址`。`equals()`比较字符串中`所包含的内容是否相同`。

<!--more-->

`equals`方法是 Java.lang.Object 类的方法。

#### 用法一

比如：
```java
String s1,s2,s3 = "abc", s4 ="abc" ;
s1 = new String("abc");
s2 = new String("abc");

s1==s2   //false      
//两个变量的内存地址不一样，也就是说它们指向的对象不一样，故不相等。
s1.equals(s2) //true    //两个变量的所包含的内容是abc，故相等。
```

* 注意（1）：
```java
StringBuffer s1 = new StringBuffer("a");
StringBuffer s2 = new StringBuffer("a");
s1.equals(s2)  //是false
```
解释：StringBuffer类中没有重新定义equals这个方法，因此这个方法就来自Object类，而Object类中的equals方法是用来比较地址的，所以等于false.

* 注意（2）：

对于s3和s4来说，有一点不一样要引起注意，由于s3和s4是两个字符串常量所生成的变量，其中所存放的内存地址是相等的，所以s3==s4是true（即使没有s3=s4这样一个赋值语句）

#### 用法二

对于`非字符串变量`来说，`==`和`equals`方法的作用是相同的都是用来比较`其对象在堆内存的首地址`，即用来比较两个引用变量是否指向同一个对象。
比如：
```java
class A
{
    A obj1   =   new  A();
    A obj2   =   new  A();
}
obj1==obj2         //false
obj1.equals(obj2)  //false
 
//但是如加上这样一句：
obj1=obj2;

//那么  
obj1==obj2        //true
obj1.equals(obj2) //true
```
总之：

* `equals`方法对于字符串来说是比较内容的，而对于非字符串来说是比较其指向的对象是否相同的。
* `==`比较符也是比较指向的对象是否相同的也就是对象在对内存中的的首地址。
  
String类中重新定义了`equals`这个方法，而且比较的是值，而不是地址。所以是true。

**转载请标注原文地址**

(end)
