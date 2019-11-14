---
title: Java之Mybatis多参数传递Map方式及结果排序
toc: true
comments: true
categories: Java
tags: Java
date: 2017-02-08 20:46:46
photos:
description:
---

### Mybatis多参数传递Map方式

使用映射器接口方式，具体代码如下：

接口方法：
```java
public List<Teacher> findTeacherByPage(Map<String, Object> map);
```

执行类方法：
```java
Map<String, Object> params = new HashMap<String, Object>();
//以name字段升序排序，
params.put("sort", "name");
params.put("dir", "asc");
//查询结果从第0条开始，查询2条记录
params.put("start", 0);
params.put("limit", 2);
//查询职称为教授或副教授的教师
params.put("title", "%教授");
//分页查询教师信息
List<Teacher> teachers = mapper.findTeacherByPage(params);
```

查询方法：
```xml
<select id="findTeacherByPage" resultMap="supervisorResultMap"
parameterType="java.util.Map">
select * from teacher where title like #{title}
order by ${sort} ${dir} limit #{start},#{limit}
</select>
```

### 查询结果排序

如上面代码所示，在order by子句中应使用`${}`的方式。实际上，这里的`parameterType="java.util.Map"`可以不要。

用`#{}`的语义是产生preparedStatement:上面的SQL预编译后产生的SQL如下:

`select * from student t order by ?`

在运行时将`?`替换为`"t.xCode Desc"`, mybatis会安全的处理类型，产生的最终SQL如下：

`select * from student t order by ‘t.xCode Desc’ `

所以会造成排序失败，但是该sql能正常运行。用`${}`直接进行字符串的替换，产生的SQL 为：

`select * from student t order by t.xCode Desc` 排序成功

#### 总结

* `#`将传入的数据都当成一个字符串，会对自动传入的数据加一个双引号。如：order by `#{user_id}`，如果传入的值是111,那么解析成sql时的值为order by "111", 如果传入的值是id，则解析成的sql为order by "id"。
* $将传入的数据直接显示生成在sql中。如：order by `${user_id}`，如果传入的值是111,那么解析成sql时的值为order by 111, 如果传入的值是id，则解析成的sql为order by id。
* `#`方式能够很大程度防止sql注入。
* `$`方式无法防止Sql注入。
* `$`方式一般用于传入数据库对象，例如传入表名。
* 一般能用#的就别用$。




