---
title: VueJS之Vuex使用指南
toc: true
comments: true
categories: 前端技术
tags: Vue
date: 2017-06-29 11:50:16
photos:
description:
---
Vuex 是 状态管理的编程模式 + 工具库，适用于 Vue.js 编写的应用。它作为一个集中化的 store （状态存储），服务于应用中的所有组件，其中的规则保证了状态只会在可预测的方式下修改。另外，它能与 Vue 官方提供的 devtools 扩展 集成，提供高级功能，如，无需配置就可以基于时间轴调试，以及状态快照的 导入 / 导出。

<!--more-->

如果你没有开发过大型的单页应用就立刻上 Vuex，可能会觉得繁琐然后排斥，这是很正常的 —— 如果是个简单的应用，大多数情况下，不用 Vuex 还好，你要的可能就是个简单的 全局事件总线。不过，如果你构建的是一个 中大型 单页应用，当你在考虑如何更好的在 Vue 组件外处理状态时，Vuex 自然就是你的下一步选择。Redux 的作者有一句话说的不错：

>Flux libraries are like glasses: you’ll know when you need them.（Flux 库正如眼镜：当你需要它们的时候，你就懂了。）

### 核心概念

![](https://ws1.sinaimg.in/large/006tNc79gy1fh21jpvhk6j30jh0fb0sp.jpg)

#### state （ store 的 data）

存放整个应用状态，作为应用的唯一数据源驱动UI视图的更新
尽量初始化详细的state数据

* 组件中直接访问

```js
computed: {
    count () {
        return this.$store.state.count
    }
}
```

* 使用工具函数 mapSate 访问
用于将独立的state数据映射到组件的 computed 属性中

```js
import { mapState } from 'vuex'

export default {
  // ...
  computed: mapState({
    // 箭头函数可以让代码非常简洁
    count: state => state.count,
    // 传入字符串 'count' 等同于 `state => state.count`
    countAlias: 'count',
    // 想访问局部状态，就必须借助于一个普通函数，函数中使用 `this` 获取局部状态
    countPlusLocalState (state) {
      return state.count + this.localCount
    }
  })
}
```

#### actions （ store 的 methods）

不改变状态，只提交(commit) mutation。
可以包含任意异步操作。

* 组件中直接访问

```js
mounted(){
    this.$store.dispatch('getUserData')
}
```

* 工具函数 mapActions 访问
用于将action方法映射到组件的 methods 中

```js
import { mapActions } from 'vuex'
export default {
  // ...
  methods: {
    ...mapActions([
      'increment' // 映射 this.increment() 到 this.$store.dispatch('increment')
    ]),
    ...mapActions({
      add: 'increment' // map this.add() to this.$store.dispatch('increment')
    })
  }
}
```

#### mutations （ store 的 methods）

定义了 同步 改变 state 的唯一方法
在store中，实际改变 状态(state) 的唯一方式是通过 提交(commit) 一个 mutation

* 组件中使用

```js
methods:{
    add(){
        this.$store.commit('ADD_NUMBER',{num: 1})
    }
}
```

* 使用工具函数 mapMutations
将mutation映射到组件的 methods 中

```js
import { mapMutations } from 'vuex'
export default {
  // ...
  methods: {
    ...mapMutations({
      add: 'increment' // 映射 this.add() 到 this.$store.commit('increment')
    })
  }
}
```

#### getters （ store 的 computed）

和计算属性功能相同，基于多个状态生成新的状态

* 组件中使用

```js
computed: {
  doneTodosCount () {
    return this.$store.getters.doneTodosCount
  }
}
```

* 工具函数 mapGetters
用于将getter属性映射到组件的computed中

```js
import { mapGetters } from 'vuex'
export default {
  // ...
  computed: {
    // 使用对象扩展操作符把 getter 混入到 computed 中
    ...mapGetters([
      'doneTodosCount',
      'anotherGetter',
      // ...
    ])
  }
}
```

### 安装

* 直接引入

>在 Vue 后面加载 vuex，它会自动安装的：

```html
<script src="/path/to/vue.js"></script>
<script src="/path/to/vuex.js"></script>
```

* NPM

```shell
npm install vuex 
#如果在一个模块化工程中使用它，必须要通过 Vue.use() 明确地安装路由功能：
```

### 使用（这里提供的是个人使用方案，可能有不足，望留言提点）

源码地址：[https://github.com/lion1ou/vuex-example.git](https://github.com/lion1ou/vuex-example.git)

**转载请标注原文地址**


