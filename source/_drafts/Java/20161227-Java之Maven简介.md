---
title: Java之Maven简介
toc: true
comments: true
categories: Java
tags: Java
date: 2016-12-27 21:10:03
photos:
description:
---

在进行软件开发的过程中，无论什么项目，采用何种技术，使用何种编程语言，我们 都要重复相同的开发步骤：编码，测试，打包，发布，文档。Maven正是为了将开发人员从这些任务中解脱出来而诞生的。Maven是一个强大的Java项目构建工具。当然，你也可以使用其它工具来构建项目，但由于Maven是用Java开发的，因此Maven被更多的用于Java项目中。Maven提供了开发人员构建一个完整的生命周期框架。开发团队可以自动完成项目的基础工具建设，Maven使用标准的目录结构和默认构建生命周期。
<!--more-->
Apache Maven 是一种创新的软件项目管理工具，提供了一个项目对象模型（POM）文件的新概念来管理项目的构建，相关性和文档。最强大的功能就是能够自动下载项目依赖库。

### 安装Maven

安装Maven，访问Maven下载页，然后按照安装指南的步骤即可。总结一下，你需要做：

1. 下载并解压Maven；
2. 将环境变量M2_HOME设置为解压后的目录；
3. 将M2环境变量设置为M2_HOME/bin（在Windows上是%M2_HOME%/bin，在Unix上是$M2_HOME/bin）；
4. 将M2添加到PATH环境变量中（Windows上是%M2%，Unix上是$M2）；
5. 打开终端输入`mvn`，然后回车；

输入`mvn`命令后，终端上回显示错误信息。不要担心这个错误。因为你没有给Maven传入pom文件，因此出现该错误信息是意料之中的。显示Maven错误信息说明Maven已经安装好了。

注意：Maven运行需要Java环境，因此也需要安装Java，Java版本1.5及以上；

### 核心概念

Maven的中心思想是POM文件（项目对象模型）。POM文件是以XML文件的形式表述项目的资源，如源码、测试代码、依赖（用到的外部Jar包）等。POM文件应该位于项目的根目录下。

下图说明了Maven是如何使用POM文件的，以及POM文件的主要组成部分：
![](https://ww1.sinaimg.in/large/006tNbRwgw1fb5ohmxo2ij30u00maael.jpg)

##### POM文件

当你执行一条Maven命令的时候，你会传入一个pom文件。Maven会在该pom文件描述的资源上执行该命令。

##### 构建生命周期、阶段和目标

Maven的构建过程被分解为`构建生命周期`、`阶段`和`目标`。一个构建周期由一系列的构建阶段组成，每一个构建阶段由一系列的目标组成。当你运行Maven的时候，你会传入一条命令。这条命令就是构建生命周期、阶段或目标的名字。如果执行一个生命周期，该生命周期内的所有构建阶段都会被执行。如果执行一个构建阶段，在预定义的构建阶段中，所有处于当前构建阶段`之前`的阶段也都会被执行。

##### 依赖和仓库

Maven执行时，其中一个首要目标就是检查项目的依赖。依赖是你的项目用到的jar文件（java库）。如果在本地仓库中不存在该依赖，则Maven会从中央仓库下载并放到本地仓库。本地仓库是指你电脑硬盘上的一个目录。你可以根据需要制定本地仓库的位置。你也可以指定下载依赖的远程仓库的地址。

##### 插件

构建插件可以向构建阶段中增加额外的构建目标。如果Maven标准的构建阶段和目标无法满足项目构建的需求，你可以在POM文件里增加插件。Maven有一些标准的插件供选用，如果需要你可以自己实现插件。

##### 配置文件

配置文件用于以不同的方式构建项目。比如，你可能需要在本地环境构建，用于开发和测试，你也可能需要构建后用于开发环境。这两个构建过程是不同的。在POM文件中增加不同的构建配置，可以启用不同的构建过程。当运行Maven时，可以指定要使用的配置。

##### Maven与Ant

Ant是Apache另一个流行的构建工具。如果你熟悉Ant，正在学习Maven，你将会注意到两者在方法上的区别。

Ant使用命令式的方式，即你需要在Ant构建文件里指定Ant应该执行的操作。你可以指定低级别的操作，如复制文件、编译代码等。你指定操作，还需要执行这些操作执行的顺序。Ant没有默认的目录结构。

Maven使用声明式的方式，即你需要在POM文件里指定做什么，而不是如何做。POM文件描述项目的资源-而不是如何构建。相比而言，Ant构建文件描述的是如何构建项目。在Maven里，如何构建是在“Maven 构建声明周期、阶段和目标”中预定义的。

##### Maven POM 文件

Maven的POM文件是一个xml文件，描述项目用到的资源，包括源代码目录、测试代码目录等的位置，以及项目依赖的外部jar包。

POM文件描述的是构建“什么”，而不是“如何”构建。如何构建是取决于Maven的构建阶段和目标。当然，如果需要，你也可以向Maven构建阶段中添加自定义的目标。

每一个项目都有一个POM文件。POM文件即pom.xml，应该放在项目的根目录下。一个项目如果分为多个子项目，一般来讲，父项目有一个POM文件，每一个子项目都有一个POM文件。在这种结构下，既可以一步构建整个项目，也可以各个子项目分开构建。

POM文件的完整文档，参考[Maven POM Reference](http://maven.apache.org/pom.html)

如下为最小化的POM文件示例：

```xml
<project xmlns=”http://maven.apache.org/POM/4.0.0″
xmlns:xsi=”http://www.w3.org/2001/XMLSchema-instance”
xsi:schemaLocation=”http://maven.apache.org/POM/4.0.0
http://maven.apache.org/xsd/maven-4.0.0.xsd”>

<modelVersion>4.0.0</modelVersion>

<groupId>com.jenkov</groupId>

<artifactId>java-web-crawler</artifactId>

<version>1.0.0</version>

</project>
```

1. **modelVersion**属性
    
    表示使用的POM模型的版本。选择和你正在使用的Maven版本一致的版本即可。版本4.0.0适用于Maven 2和3。

2. **groupId**属性
    
    是一个组织或者项目（比如开源项目）的唯一ID。大多数情况下，你会使用项目的java包的根名称作为group ID。

3. **artifactId**属性
    包含你正在构建的项目的名称。artifact ID是Maven仓库中group ID目录下的子目录名。artifact ID也是构建完项目后生成的jar包的文件名的一部分。构建过程的输出，即构建结果，在Maven中成为构件（artifact）。通常它就是一个jar包、war包或者EAR包，但它也可以是别的。

4. **versionId**
    包含项目的版本号。版本号是artifact ID目录下的子目录名。版本号也用作构建结果名称的一部分。（即jar包文件名的一部分–译者注）


上文中的`groupId`，`artifactId`和`version`属性，在项目构建后会生成一个jar文件，位于Maven仓库的如下路径中（目录和文件名）：`MAVEN_REPO/com/jenkov/java-web-crawler/1.0.0/java-web-crawler-1.0.0.jar`

如果你的项目使用[Maven目录结构](http://tutorials.jenkov.com/maven/maven-tutorial.html#maven-directory-structure)，而且项目没有外部依赖，上面的最简化POM文件就是你构建项目所需的所有配置了。如果你的项目不遵从标准的目录结构，有外部依赖或者在构建过程中需要加入额外操作，你需要向POM文件中添加更多的配置。更多的配置查阅[Maven POM 参考]（链接在上文）。

##### 父pom

所有的Maven pom文件都继承自一个父pom。如果没有指定父pom，则该pom文件继承自根pom。pom文件的继承关系如下图所示：

![](https://ww1.sinaimg.in/large/006tNc79gw1fb6v7btmfij308v08cjrh.jpg)

可以让一个pom文件显式地继承另一个pom文件。这样，可以通过修改公共父pom文件的设置来修改所有子pom文件的设置。在pom文件的起始处指定父pom，例如：

```xml
<project xmlns=”http://maven.apache.org/POM/4.0.0″
xmlns:xsi=”http://www.w3.org/2001/XMLSchema-instance”
xsi:schemaLocation=”http://maven.apache.org/POM/4.0.0
http://maven.apache.org/xsd/maven-4.0.0.xsd”>
<modelVersion>4.0.0</modelVersion>

<parent>
<groupId>org.codehaus.mojo</groupId>
<artifactId>my-parent</artifactId>
<version>2.0</version>
<relativePath>../my-parent</relativePath>
</parent>

<artifactId>my-project</artifactId>
…
</project>
```

子pom文件的设置可以覆盖父pom文件的设置，只需要在子pom文件里指定新的设置即可。关于pom文件继承更详细的内容可以参考Maven POM文档。

##### 有效pom

考虑到pom文件的继承关系，当Maven执行的时候可能很难确定最终的pom文件的内容。总的pom文件（所有继承关系生效后）被称为有效pom（effective pom）。可以使用以下的命令让Maven打印出当前的有效pom：

`mvn help:effective-pom`

执行以上命令，Maven会将有效pom输出到命令行。

##### Maven配置文件

Maven有两个配置文件。配置文件里的设置，对所有的pom文件都是有效的。比如，你可以配置：

* 本地仓库的路径；
* 当前的编译配置选项,等等

配置文件名为settings.xml，两个配置文件分别为：

* Maven安装目录中：$M2_HOME/conf/settings.xml
* 用户主目录中：${user.home}/.m2/settings.xml

两个配置文件都是可选的。如果两个文件都存在，则用户目录下的配置会覆盖Maven安装目录中的配置。

关于Maven配置文件，参考[Maven配置文档](http://maven.apache.org/settings.html)

##### 让Maven跑起来

当你安装好了Maven，并且在项目的根目录下创建了POM文件，可以在项目上运行Maven了。

运行Maven只需在命令行执行`mvn`命令即可。当执行`mvn`命令时，将构建周期、阶段或目标作为参数传进去，Maven就会执行它们。

例如：

* `mvn install`

该命令执行`install`阶段（是默认构建阶段的一部分），编译项目，将打包的JAR文件复制到本地的Maven仓库。事实上，该命令在执行install之前，会执行在构建周期序列中位于install之前的所有阶段。

你可以向mvn命令传入多个参数，执行多个构建周期或阶段，如：

* `mvn clean install`

该命令首先执行clean构建周期，删除Maven输出目录中已编译的类文件，然后执行install构建阶段。

也可以执行一个Maven目标（构建阶段的一部分），将构建阶段与目标名以冒号(:)相连，作为参数一起传给Maven命令。例如：

* `mvn dependency:copy-dependencies`

该命令执行`dependency`构建阶段中的`copy-dependencies`目标。





