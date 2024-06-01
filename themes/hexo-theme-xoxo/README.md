# hexo-theme-sprite

Hexo theme inspired by [xoxo](https://github.com/KevinOfNeu/hexo-theme-xoxo) 

[Demo](https://lion1ou.tech)

## 特点

- 简单
- 干净


## 使用

###  hexo _config.yml

```js

git clone git@github.com:lion1ou/hexo-theme-sprite.git themes/hexo-theme-sprite

```

修改hexo目录下的 _config.yml 的theme

```yml
# ...
theme: hexo-theme-sprite
# ...
```


除了基础 Hexo 配置外,你还需要这样...

### theme _config.yml
```yml

# html lang
language: zh-Hans

###### menu 导航栏 ######

menu:
  home: /
  archives: /archives
  tags: /tags
  # categories: /categories
  search: /search
  about: /about
  # rss: /atom.xml

###### 自定义文件加载 ######

stylesheets:
# - /css/main.css   # css将在head中加载

scripts:
# - /js/main.js     # js将在body之后加载


###### 文章相关 ######

# postItem 首页文章块
index_post:
  show_excerpt: true # 显示摘要 0
  show_tags: true # 显示tags
  show_date: true # 显示时间
  word_count: true # 设置文章字数统计为 true.
  min2read: false # 阅读时长.

# 文章详情
post_info:
  show_date: true
  show_tags: true
  word_count: true # 设置文章字数统计为 true.
  min2read: true # 阅读时长.
  read_count: true # 阅读次数.


###### 统计 ######
# 需要自己去各平台注册，获取相应的code
baidu_analytics: 670319318804add6c99a71df6601f645
google_analytics: UA-153662927-1
cnzz_analytics: 1280415470

###### disqus评论  ######
disqus_shortname: lion1ou

###### 代码高亮主题 ######

# 默认 monokai-sublime, 可选主题详见:https://highlightjs.org/
hljs_style: 'monokai-sublime' 

###### 自动跳转https ######

http2https: true # http自动跳转https

###### admire 赞赏 ######

admire_msg: 觉得写的不错，请我喝杯奶茶呗~
ali_qrcode: https://cdn.chuyunt.com/ali_skm_tiny.png
wx_qrcode: https://cdn.chuyunt.com/wx_skm_tiny.png

###### footer ######

# 各平台主页地址
index: http://lion1ou.tech
# juejin: http://lion1ou.tech
# zhihu: http://lion1ou.tech
# weibo: http://lion1ou.tech
# github: https://github.com/lion1ou

# 显示全站字数
site_total_count: false
# 显示访问量
show_visitor: false
# 网站开始时间， 会展示已运行多少天
site_start_time: '2016-07-01 00:00:00'
# 备案号
bei_an: '浙ICP备2021029843号'

```

## TODO

* 优化搜索样式
* 优化首页菜单栏
* 添加黑夜模式
* 添加评论系统
* 查看大图

## Snapshots

![blog-index.png](https://i.loli.net/2021/10/10/RXdxFbnLtMumAB6.png)
![blog-archives.png](https://i.loli.net/2021/10/10/jmnH71aerS8UFR9.png)
![blog-tags.png](https://i.loli.net/2021/10/10/8Zu1b39gVh7jymB.png)