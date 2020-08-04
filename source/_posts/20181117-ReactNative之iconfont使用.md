---
title: ReactNative之iconfont使用
toc: true
comments: true
date: 2018-11-17 00:10:16
categories: 前端技术
tags: ReactNative
photos:
---

iconfont 显示成图形图标的字体，因为字体是矢量化图形，具有分辨率无关的特性，在任何分辨率和 ppi 下面，都可以做到完美缩放，不像传统位图如：png，jpg 一样，放大后会有锯齿或者模糊。
为什么使用 iconfont 对比图片大小来说容量更小，支持样式修改(大小，颜色)，适应多分辨率，网上有很多现成的 iconfont 资源可以使用。

<!--more-->

### 在 RN 中使用 iconfont

简单介绍完 iconfont，现在说说在 RN 中整么用它。这里推荐使用 react-native-vector-icons，它会把字体文件转换成相应的 iconSets 在 RN 供我们使用。

- 安装 react-native-vector-icons

```bash
npm i --save react-native-vector-icons
```

### ios 下配置

用 XCode 打开项目目录下的 ios，为了管理字体，我们新建一个 fonts 目录，字体文件统一放在里面，把字体文件拖进这个文件夹。会有弹框提示并且记得 Add to targets 选中当前项目。

![](http://cdn.chuyunt.com/ios-icon1.png)

确保 Build Phases 的 Copy Bundle REsources 中有字体文件

![](http://cdn.chuyunt.com/ios-icon2.png)

接着修改 info.plist，在 information Property List 下新增 Fonts provided by application，在 Fonts provided by application 下在增加字体文件，到这里 ios 就配置好了。

![](http://cdn.chuyunt.com/ios-icon3.png)

### android 配置

安卓下会从 android/app/src/main/assets/fonts 目录读取字体文件，所以我们需要把字体文件`*.ttf`放在这个目录下，然后在 android/app/build.gradle 文件中按需增加下面的配置。

```java
//使用内置的iconSets
apply from: "../../node_modules/react-native-vector-icons/fonts.gradle"
//使用自定义iconSets
project.ext.vectoricons = [
   iconFontNames: [ 'iconfont.ttf'] // Name of the font files you want to copy
]
```

使用内置的 iconSets

```java
import Icon from 'react-native-vector-icons/FontAwesome';
<Icon name='rocket' size={60} color="#4F8EF7" />
```

上面的方式引用的是 react-native-vector-icons 内置的一种 iconSets, 除了 FontAwesome 还有其他 iconSets，可以到[react-native-vector-icons](https://github.com/oblador/react-native-vector-icons)查看

虽然内置了很多 iconSets 给我们使用，但往往我们做项目时一般都会使用自己的 iconfont，整么使用自己的 iconfont 呢？

react-native-vector-icons/FontAwesome 这个返回的是一个 iconSets，简单理解这个 iconSets 是一个可以帮我们显示字体图标的组件。其中 name 对应图标在 glyphMap.json 文件中对应的 key。

看 react-native-vector-icons/FontAwesome 的源码

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

- glyphMap: json 对象(key 是图标的 name, value 是图标对应的 10 进制数)
- fontFamily: 字体库对应的 fontFamily
- fontFile：字体文件名称(注意这里只声明字体库名称，字体库路径分平台配置)

看 glyphMap 对应的 glyphmaps/FontAwesome.json

```json
{
  "glass": 61440,
  "music": 61441,
  "search": 61442,
  "envelope-o": 61443,
  "heart": 61444,
  "star": 61445
}
```

总结一下：

就是根据字体文件(.ttf|.otf)和 glyphMap.json 创建对应的 IconSets，所以要想使用自定义的 iconfont 我们需要准备这两样东西。

### 使用自定义的 iconSets

看完上面的源码分析，我们开始自定义 iconSets，先准备一套 iconfont，作者习惯使用阿里巴巴矢量图标库，这里就拿这个来作为栗子。选取你需要的图标，添加为一个项目，如下：

项目默认的 fontFamily 为 iconfont，还记得上面创建 iconSets 函数的第二个参数吗，每次对应的就是这个，这里我修改一下。

下载项目，里面的 iconfont.ttf 就是我们需要的 iconfont 了。

回想一下，创建 createIconSet 需要的东西，还少了 glyphMap，glyphMap 整么来呢。看这里

其中 e69b 是图标对应的 16 进制 unicode 我们需要的是 10 进制，所以把它转换一下， 下面使用的是 js

```js
parseInt("e69b", 16);
59035;
```

每个图标都需要转换一次很麻烦，所以基于阿里巴巴图标矢量库下载的文件，我用 js 写了一个生成 json 的工具类。把刚下载下来的 iconfont.css，iconfont.json, genJson.js 放在同一目录。�node 执行 genJson.js，所需要的 json 对象就被写入 iconfont.json 中了。

```css
/*iconfont.css*/
/* ...省略... */
.ica {
  font-family: "ica" !important;
  font-size: 16px;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.icon-all:before {
  content: "\e696";
}

.icon-back:before {
  content: "\e697";
}

.icon-cart:before {
  content: "\e698";
}

.icon-category:before {
  content: "\e699";
}

.icon-close:before {
  content: "\e69a";
}

.icon-comments:before {
  content: "\e69b";
}
```

```js
/*genJson.js*/
const path = require("path");

const oldPath = path.resolve(__dirname, "iconfont.css");
const newPath = path.resolve(__dirname, "iconfont.json");

var gen = (module.exports = function () {
  const readline = require("readline");
  const fs = require("fs");

  const fRead = fs.createReadStream(oldPath);
  const fWrite = fs.createWriteStream(newPath, {
    flags: "w+",
    defaultEncoding: "utf8",
  });

  const objReadLine = readline.createInterface({
    input: fRead,
  });

  var ret = {};

  objReadLine.on("line", (line) => {
    line = line && line.trim();
    if (!line.includes(":before") || !line.includes("content")) return;
    var keyMatch = line.match(/\.(.*?):/);
    var valueMatch = line.match(/content:.*?\\(.*?);/);
    var key = keyMatch && keyMatch[1];
    var value = valueMatch && valueMatch[1];
    value = parseInt(value, 16);
    key && value && (ret[key] = value);
  });

  objReadLine.on("close", () => {
    console.log("readline close");
    fWrite.write(JSON.stringify(ret), "utf8");
  });
});

gen();
```

创建 iconSets 需要的东西都准备好了，开始创建吧。

```js
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
