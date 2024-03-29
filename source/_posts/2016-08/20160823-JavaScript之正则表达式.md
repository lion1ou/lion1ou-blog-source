---
title: JavaScript之正则表达式
toc: true
comments: true
categories: JavaScript
tags: JavaScript
date: 2016-08-23 17:28:39
photos:
description:
---

正则表达式（Regular Expression，在代码中常简写为regex、regexp或RE）是计算机科学的一个概念。正则表达式使用单个字符串来描述、匹配一系列符合某个句法规则的字符串。正则表达式是由普通字符（例如字符 a 到 z）以及特殊字符（称为"元字符"）组成的文字模式。模式描述在搜索文本时要匹配的一个或多个字符串。正则表达式作为一个模板，将某个字符模式与所搜索的字符串进行匹配。

<!--more-->

## 特殊字符

所谓特殊字符，就是一些有特殊含义的字符。

|特殊字符|描述|
|---|---|
|$ | 匹配输入字符串的结尾位置。|
|()| 标记一个子表达式的开始和结束位置。|
|* |  匹配前面的子表达式零次或多次。|
|+ |  匹配前面的子表达式一次或多次。|
|. |  匹配除换行符 `\n` 之外的任何单字符|
|`[]`|  一个字符集合。匹配方括号的中任意字符，包括转义序列。你可以使用破折号（-）来指定一个字符范围。对于点（.）和星号（*）这样的特殊符号在一个字符集中没有特殊的意义。|
|? |  匹配前面的子表达式零次或一次，或指明一个非贪婪限定符。|
|\ |  将下一个字符标记为或特殊字符、或原义字符、或向后引用、或八进制转义符。|
|^ |  匹配输入字符串的开始位置，除非在方括号表达式中使用，此时它表示不包含该字符集合（即“非”）。|
|{ |  标记限定符表达式的开始。|
|&#124;|  指明两项之间的一个选择。|

## 限定符

限定符用来指定正则表达式的一个给定组件必须要出现多少次才能满足匹配。

|字符|  描述|
|---|---|
|*  | 匹配前面的子表达式零次或多次。|
|+   |匹配前面的子表达式一次或多次。|
|?|   匹配前面的子表达式零次或一次。|
|{n} |n 是一个非负整数。匹配确定的 n 次。|
|{n,} |   n 是一个非负整数。至少匹配n 次。|
|{n,m} |  m 和 n 均为非负整数，其中n <= m。最少匹配 n 次且最多匹配 m 次。|

## 定位符

定位符用来描述字符串或单词的边界，^和$分别指字符串的开始与结束，\b描述单词的前或后边界，\B表示非单词边界。

|字符|  描述|
|---|---|
|^   |匹配输入字符串开始的位置。|
|$   |匹配输入字符串结尾的位置。|
|\b  |匹配一个字边界，即字与空格间的位置。|
|\B  |非字边界匹配。|

## 修饰符（添加在最后）

|字符|  描述|
|---|---|
|/i | 忽略大小写 |
|/g | 全文查找出现的所有匹配字符 |
|/m | 多行查找 |
|/gi| 全文查找、忽略大小写 |
|/ig| 全文查找、忽略大小写 |

## 其他

|字符|  描述|
|---|---|
|\d | 匹配一个数字。等价于[0-9]。 |
|\D | 匹配一个非数字字符。等价于[^0-9]。 |
|\w | 匹配一个单字字符（字母、数字或者下划线）。等价于[A-Za-z0-9_]。 |
|\W | 匹配一个非单字字符。等价于[^A-Za-z0-9_]。 |
|\s | 匹配任何空白字符，包括空格、制表符、换页符等等。等价于 [ \f\n\r\t\v]。|
|\S | 匹配任何非空白字符。等价于 [^ \f\n\r\t\v]。|


## 反向引用

1、正向预查

* (?:pattern) 匹配结果。Java(?:6|7)等效于Java6|Java7，结果Java6 Java7

* (?=pattern) 正向匹配。Java(?=6)，匹配后面跟着6的Java，即第一个Java，结果Java6 Java7

* (?!pattern) 正向不匹配。Java(?!6)，匹配后面不跟着6的Java，即第二个Java，结果Java6 Java7

2、反向预查

* (?<=pattern) 反向匹配。(?<=J)a，匹配紧跟字母J后面的a，结果Java6 Java7

* (?<!pattern) 反向不匹配。(?<!J)a，不匹配紧跟字母J后面的a，结果Java6 Java7

## 常用方法

```js
var reg = /\d+/g  // 常规写的时候可以不需要 两个|（斜杠）
var reg1 = new RegExp('\\d+', 'g') // 注意，在使用引号来表示正则时，一定要两个\\（斜杠）, 因为一个\（斜杠）会被转义掉

reg.test('222222')  // true
reg1.test('2333')   // true

reg.exec('quehjq   whdja129u318873e') // ["129", index: 14, input: "quehjq   whdja129u318873e", groups: undefined]

'ssss128367812asda3485762  dfsd32424'.match(reg) //  ["128367812", "3485762", "32424"]

'ssss128367812asda3485762  dfsd32424'.replace(reg, '*') // ssss*asda*  dfsd*
'ssss128367812asda3485762  dfsd32424'.replace(reg, '$&,') // ssss128367812,asda3485762,  dfsd32424,

'ssss128367812asda3485762  dfsd32424'.search(reg) // 4

'ssss128367812asda3485762  dfsd32424'.split(reg) //  ["ssss", "asda", "  dfsd", ""]
```

* test -- 用来测试字符串是否匹配相应的正则规则，返回boolean；
* exec -- 返回包含第一个匹配的数组
* match -- 返回所有匹配的数组
* replace -- 完成字符串中匹配值的指定替换,返回替换后的字符串
* search -- 类似于indexOf的用法，不过search支持正则，返回第一个匹配值的index
* split -- 根据规则拆分字符串，返回被拆分后的字符串数组


## 常用正则表达式

|字符|  描述|
|---|---|
|`^[\u4e00-\u9fa5]{0,}$` |匹配中文字符串|
|`[^\x00-\xff]` |　匹配双字节字符(包括汉字在内)|
|`\n\s*\r` |匹配空白行|
|<code>^\s*&#124;\s*$</code> |匹配首尾空白字符|
|`\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*`|匹配Email地址|
|<code>\d{3}-\d{8}*&#124;\d{4}-\d{7}</code>|匹配国内电话号码|
|`[1-9][0-9]{4,}`|匹配腾讯QQ号|
|`[1-9]\d{5}(?!\d)`|匹配中国邮政编码|
|`[a-zA-z]+://[^\s]*`|匹配网址URL|
|`^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,10}$`|强密码(必须包含大小写字母和数字的组合，不能使用特殊字符，长度在8-10之间)|


匹配特定数字：

|字符|  描述|
|---|---|
|`^[1-9]\d*$`　 　 |匹配正整数|
|`^-[1-9]\d*$` 　 |匹配负整数|
|`^-?[1-9]\d*$`　　 |匹配整数|
|<code>^[1-9]\d*&#124;0$</code>　 |匹配非负整数（正整数 + 0）|
|<code>^-[1-9]\d*&#124;0$</code>　　 |匹配非正整数（负整数 + 0）|
|<code>^[1-9]\d*\.\d*&#124;0\.\d*[1-9]\d*$</code>　　 |匹配正浮点数|
|<code>^-([1-9]\d*\.\d*&#124;0\.\d*[1-9]\d*)$</code>　 |匹配负浮点数|
|<code>^-?([1-9]\d*\.\d*&#124;0\.\d*[1-9]\d*&#124;0?\.0+&#124;0)$</code>　 |匹配浮点数|
|<code>^[1-9]\d*\.\d*&#124;0\.\d*[1-9]\d*&#124;0?\.0+&#124;0$</code>　　 |匹配非负浮点数（正浮点数 + 0）|
|<code>^(-([1-9]\d*\.\d*&#124;0\.\d*[1-9]\d*))&#124;0?\.0+&#124;0$</code>　　|匹配非正浮点数（负浮点数 + 0）|

匹配特定字符串：

|字符|  描述|
|---|---|
|`^[A-Za-z]+$`　　|匹配由26个英文字母组成的字符串|
|`^[A-Z]+$`　　|匹配由26个英文字母的大写组成的字符串|
|`^[a-z]+$`　　|匹配由26个英文字母的小写组成的字符串|
|`^[A-Za-z0-9]+$`　　|匹配由数字和26个英文字母组成的字符串|
|`^\w+$`　　|匹配由数字、26个英文字母或者下划线组成的字符串|



### 用户名正则

```js
//用户名正则，4到16位（字母，数字，下划线，减号）
var uPattern = /^[a-zA-Z0-9_-]{4,16}$/;
//输出 true
console.log(uPattern.test("caibaojian"));
```

### 密码强度正则

```js
//密码强度正则，最少6位，包括至少1个大写字母，1个小写字母，1个数字，1个特殊字符
var pPattern = /^.*(?=.{6,})(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*? ]).*$/;
//输出 true
console.log("=="+pPattern.test("caibaojian#"));
```

### 整数正则

```js
//正整数正则
var posPattern = /^\d+$/;
//负整数正则
var negPattern = /^-\d+$/;
//整数正则
var intPattern = /^-?\d+$/;
//输出 true
console.log(posPattern.test("42"));
//输出 true
console.log(negPattern.test("-42"));
//输出 true
console.log(intPattern.test("-42"));
```

### 数字正则

```js
可以是整数也可以是浮点数

//正数正则
var posPattern = /^\d*\.?\d+$/;
//负数正则
var negPattern = /^-\d*\.?\d+$/;
//数字正则
var numPattern = /^-?\d*\.?\d+$/;
console.log(posPattern.test("42.2"));
console.log(negPattern.test("-42.2"));
console.log(numPattern.test("-42.2"));
```

### Email正则

```js
//Email正则
var ePattern = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
//输出 true
console.log(ePattern.test("99154507@qq.com"));
```

### 手机号码正则

```js
//手机号正则
var mPattern = /^1[34578]\d{9}$/; //http://caibaojian.com/regexp-example.html
//输出 true
console.log(mPattern.test("15507621888"));
```

### 身份证号正则

```js
//身份证号（18位）正则
var cP = /^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/;
//输出 true
console.log(cP.test("11010519880605371X"));
```

### URL正则

```js
//URL正则
var urlP= /^((https?|ftp|file):\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;
//输出 true
console.log(urlP.test("http://caibaojian.com"));
```

### IPv4地址正则

```js
//ipv4地址正则
var ipP = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
//输出 true
console.log(ipP.test("115.28.47.26"));
```

### 十六进制颜色正则

```js
//RGB Hex颜色正则
var cPattern = /^#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/;
//输出 true
console.log(cPattern.test("#b8b8b8"));
```

### 日期正则

```js
//日期正则，简单判定,未做月份及日期的判定
var dP1 = /^\d{4}(\-)\d{1,2}\1\d{1,2}$/;
//输出 true
console.log(dP1.test("2017-05-11"));
//输出 true
console.log(dP1.test("2017-15-11"));
//日期正则，复杂判定
var dP2 = /^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/;
//输出 true
console.log(dP2.test("2017-02-11"));
//输出 false
console.log(dP2.test("2017-15-11"));
//输出 false
console.log(dP2.test("2017-02-29"));
```

### QQ号码正则

```js
//QQ号正则，5至11位
var qqPattern = /^[1-9][0-9]{4,10}$/;
//输出 true
console.log(qqPattern.test("65974040"));
```

### 微信号正则

```js
//微信号正则，6至20位，以字母开头，字母，数字，减号，下划线
var wxPattern = /^[a-zA-Z]([-_a-zA-Z0-9]{5,19})+$/;
//输出 true
console.log(wxPattern.test("caibaojian_com"));
```

### 车牌号正则

```js
//车牌号正则
var cPattern = /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$/;
//输出 true
console.log(cPattern.test("粤B39006"));
```

### 包含中文正则

```js
//包含中文正则
var cnPattern = /[\u4E00-\u9FA5]/;
//输出 true
console.log(cnPattern.test("蔡宝坚"));
```


