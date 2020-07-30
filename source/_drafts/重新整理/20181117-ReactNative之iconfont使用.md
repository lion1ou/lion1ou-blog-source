---
title: ReactNative之iconfont使用
toc: true
comments: true
date: 2018-11-17 00:10:16
categories: 前端技术
tags: ReactNative
photos:
---

iconfont显示成图形图标的字体，因为字体是矢量化图形，具有分辨率无关的特性，在任何分辨率和ppi下面，都可以做到完美缩放，不像传统位图如：png，jpg一样，放大后会有锯齿或者模糊。
为什么使用iconfont对比图片大小来说容量更小，支持样式修改(大小，颜色)，适应多分辨率，网上有很多现成的iconfont资源可以使用。

<!--more-->

### 在RN中使用iconfont

简单介绍完iconfont，现在说说在RN中整么用它。这里推荐使用react-native-vector-icons，它会把字体文件转换成相应的iconSets在RN供我们使用。

* 安装react-native-vector-icons

```bash
npm i --save react-native-vector-icons
```

### ios下配置

用XCode打开项目目录下的ios，为了管理字体，我们新建一个fonts目录，字体文件统一放在里面，把字体文件拖进这个文件夹。会有弹框提示并且记得Add to targets选中当前项目。

![](http://cdn.chuyunt.com/ios-icon1.png)

确保Build Phases的Copy Bundle REsources中有字体文件

![](http://cdn.chuyunt.com/ios-icon2.png)

接着修改info.plist，在information Property List下新增Fonts provided by application，在Fonts provided by application下在增加字体文件，到这里ios就配置好了。

![](http://cdn.chuyunt.com/ios-icon3.png)


### android配置

安卓下会从android/app/src/main/assets/fonts目录读取字体文件，所以我们需要把字体文件`*.ttf`放在这个目录下，然后在android/app/build.gradle文件中按需增加下面的配置。

```java
//使用内置的iconSets
apply from: "../../node_modules/react-native-vector-icons/fonts.gradle"
//使用自定义iconSets
project.ext.vectoricons = [
   iconFontNames: [ 'iconfont.ttf'] // Name of the font files you want to copy
]
```

使用内置的iconSets

```java
import Icon from 'react-native-vector-icons/FontAwesome';
<Icon name='rocket' size={60} color="#4F8EF7" />
```

上面的方式引用的是react-native-vector-icons内置的一种iconSets, 除了FontAwesome还有其他iconSets，可以到[react-native-vector-icons](https://github.com/oblador/react-native-vector-icons)查看

虽然内置了很多iconSets给我们使用，但往往我们做项目时一般都会使用自己的iconfont，整么使用自己的iconfont呢？

react-native-vector-icons/FontAwesome这个返回的是一个iconSets，简单理解这个iconSets是一个可以帮我们显示字体图标的组件。其中name对应图标在glyphMap.json文件中对应的key。

看react-native-vector-icons/FontAwesome的源码

```java
/**
 * FontAwesome icon set component.
 * Usage: <FontAwesome name="icon-name" size={20} color="#4F8EF7" />
 */

import createIconSet from './lib/create-icon-set';
import glyphMap from './glyphmaps/FontAwesome.json';

const iconSet = createIconSet(glyphMap, 'FontAwesome', 'FontAwesome.ttf');

export default iconSet;
```

createIconSet(glyphMap, fontFamily, fontFile)

参数说明：

* glyphMap: json对象(key是图标的name, value是图标对应的10进制数)
* fontFamily: 字体库对应的fontFamily
* fontFile：字体文件名称(注意这里只声明字体库名称，字体库路径分平台配置)

看glyphMap对应的glyphmaps/FontAwesome.json

```json
{
  "glass": 61440,
  "music": 61441,
  "search": 61442,
  "envelope-o": 61443,
  "heart": 61444,
  "star": 61445,
}
```

总结一下：

就是根据字体文件(.ttf|.otf)和glyphMap.json创建对应的IconSets，所以要想使用自定义的iconfont我们需要准备这两样东西。

### 使用自定义的iconSets

看完上面的源码分析，我们开始自定义iconSets，先准备一套iconfont，作者习惯使用阿里巴巴矢量图标库，这里就拿这个来作为栗子。选取你需要的图标，添加为一个项目，如下：



项目默认的fontFamily为iconfont，还记得上面创建iconSets函数的第二个参数吗，每次对应的就是这个，这里我修改一下。



下载项目，里面的iconfont.ttf就是我们需要的iconfont了。



回想一下，创建createIconSet需要的东西，还少了glyphMap，glyphMap整么来呢。看这里



其中e69b是图标对应的16进制unicode我们需要的是10进制，所以把它转换一下， 下面使用的是js

```js
parseInt("e69b", 16)
59035
```

每个图标都需要转换一次很麻烦，所以基于阿里巴巴图标矢量库下载的文件，我用js写了一个生成json的工具类。把刚下载下来的iconfont.css，iconfont.json, genJson.js放在同一目录。�node执行genJson.js，所需要的json对象就被写入iconfont.json中了。

```
/*iconfont.css*/
...省略...
.ica {
  font-family:"ica" !important;
  font-size:16px;
  font-style:normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.icon-all:before { content: "\e696"; }

.icon-back:before { content: "\e697"; }

.icon-cart:before { content: "\e698"; }

.icon-category:before { content: "\e699"; }

.icon-close:before { content: "\e69a"; }

.icon-comments:before { content: "\e69b"; }
```

```json
/*genJson.js*/
const path = require('path');

const oldPath = path.resolve(__dirname, 'iconfont.css');
const newPath = path.resolve(__dirname, 'iconfont.json');

var gen = module.exports = function () {
    const readline = require('readline');
    const fs = require('fs');

    const fRead = fs.createReadStream(oldPath);
    const fWrite = fs.createWriteStream(newPath, {flags: 'w+', defaultEncoding: 'utf8'});

    const objReadLine = readline.createInterface({
        input: fRead
    });

    var ret = {};

    objReadLine.on('line', line => {
        line = line && line.trim();
        if( !line.includes(":before") || !line.includes("content") ) return;
        var keyMatch = line.match(/\.(.*?):/);
        var valueMatch = line.match(/content:.*?\\(.*?);/);
        var key = keyMatch && keyMatch[1];
        var value = valueMatch && valueMatch[1];
        value = parseInt(value, 16);
        key && value && (ret[key] = value);
    });

    objReadLine.on('close', () => {
        console.log('readline close');
        fWrite.write(JSON.stringify(ret), 'utf8');
    });
};

gen();
```

创建iconSets需要的东西都准备好了，开始创建吧。

```json
／*iconfont.json*／
{
  "icon-comments":  59035,
  "icon-close": 59034
}
/*iconSets.js*/

import createIconSet from 'react-native-vector-icons/lib/create-icon-set';
import glyphMap from './assets/fonts/iconfont.json';

const iconSet = createIconSet(glyphMap, "ica", 'iconfont.ttf');

export default iconSet;

/* componet.js*/
...
import Icon from './iconSets';
<Icon name='icon-comments' size={60} color="#4F8EF7" />
```

运行一下，看字体显示出来了


项目相关代码放在github上了，请移步react-native-iconfont-demo
如果有帮到你，请点个赞吧。




