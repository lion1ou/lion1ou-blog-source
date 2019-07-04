# JS框架

## MVVM

MVVM是Model-View-ViewModel的缩写。mvvm是一种设计思想。Model 层代表数据模型，也可以在Model中定义数据修改和操作的业务逻辑；View 代表UI 组件，它负责将数据模型转化成UI 展现出来，ViewModel 是一个同步View 和 Model的对象。

在MVVM架构下，View 和 Model 之间并没有直接的联系，而是通过ViewModel进行交互，Model 和 ViewModel 之间的交互是双向的， 因此View 数据的变化会同步到Model中，而Model 数据的变化也会立即反应到View 上。
ViewModel 通过双向数据绑定把 View 层和 Model 层连接了起来，而View 和 Model 之间的同步工作完全是自动的，无需人为干涉，因此开发者只需关注业务逻辑，不需要手动操作DOM, 不需要关注数据状态的同步问题，复杂的数据状态维护完全由 MVVM 来统一管理。

### mvvm和mvc区别？

mvc和mvvm其实区别并不大。都是一种设计思想。主要就是mvc中Controller演变成mvvm中的viewModel。mvvm主要解决了mvc中大量的DOM 操作使页面渲染性能降低，加载速度变慢，影响用户体验。和当 Model 频繁发生变化，开发者需要主动更新到View

[Vue的MVVM和数据双向绑定及其和React单向数据流的比较](http://liveipool.com/blog/2017/07/12/Vue-VS-React/)

### 谈谈Vue中的MVVM模式
MVVM 全称为 Model-View-ViewModel

把一个普通 Javascript 对象传给 Vue 实例的 data 选项，Vue 将遍历此对象所有的属性，并使用 Object.defineProperty 把这些属性全部转为 getter/setter。(Object.defineProperty 是仅 ES5 支持，且无法 shim 的特性，这也就是为什么 Vue 不支持 IE8 以及更低版本浏览器的原因。
)


## Angular

### Angular的优点
1. 强大的模板功能，通过自带的Angular指令，基本满足日常使用，在有特别需求的时候还可以自定义指令
2. 是一个比较完善的`MV*`框架，包含模板，路由，数据双向绑定，模块化，服务，过滤器，依赖注入等功能

### Angular的缺点

1. 路由功能薄弱，只能使用一个ng-view,不能嵌套多个视图，可以使用UI-router解决这个问题
2. 复杂情况下，性能有点问题，相对笨重，加载慢



## Vue

### 请详细说下你对vue生命周期的理解

vue生命周期总共分为8个阶段: 创建前/后，载入前/后，更新前/后， 销毁前/后。

* beforeCreate （创建前）vue实例的挂载元素$el和数据对象 data都是undefined, 还未初始化

* created (创建后) 完成了 data数据初始化, el还未初始化

* beforeMount (载入前) vue实例的$el和data都初始化了, 相关的render函数首次被调用。实例已完成以下的配置：编译模板，把data里面的数据和模板生成html。注意此时还没有挂载html到页面上。

* mounted (载入后) 在el 被新创建的 vm.$el替换，并挂载到实例上去之后调用。实例已完成以下的配置：用上面编译好的html内容替换el属性指向的DOM对象。完成模板中的html渲染到html页面中。此过程中进行ajax交互

* beforeUpdate (更新前) 在数据更新之前调用，发生在虚拟DOM重新渲染和打补丁之前。可以在该钩子中进一步地更改状态，不会触发附加的重渲染过程。

* updated （更新后） 在由于数据更改导致的虚拟DOM重新渲染和打补丁之后调用。调用时，组件DOM已经更新，所以可以执行依赖于DOM的操作。然而在大多数情况下，应该避免在此期间更改状态，因为这可能会导致更新无限循环。该钩子在服务器端渲染期间不被调用。

* beforeDestroy  (销毁前） 在实例销毁之前调用。实例仍然完全可用。

* destroyed (销毁后） 在实例销毁之后调用。调用后，所有的事件监听器会被移除，所有的子实例也会被销毁。该钩子在服务器端渲染期间不被调用。


### Proxy 相比于 defineProperty 的优势

Object.defineProperty() 的问题主要有三个：

* 不能监听数组的变化
* 必须遍历对象的每个属性
* 必须深层遍历嵌套的对象

Proxy 在 ES2015 规范中被正式加入，它有以下几个特点：

* 针对对象：针对整个对象，而不是对象的某个属性，所以也就不需要对 keys 进行遍历。这解决了上述 Object.defineProperty() 第二个问题

* 支持数组：Proxy 不需要对数组的方法进行重载，省去了众多 hack，减少代码量等于减少了维护成本，而且标准的就是最好的。

除了上述两点之外，Proxy 还拥有以下优势：

* Proxy 的第二个参数可以有 13 种拦截方法，这比起 Object.defineProperty() 要更加丰富

* Proxy 作为新标准受到浏览器厂商的重点关注和性能优化，相比之下 Object.defineProperty() 是一个已有的老方法。

### 常规使用

#### v-show和v-if

* v-show指令是通过修改元素的displayCSS属性让其显示或者隐藏
* v-if指令是直接销毁和重建DOM达到让元素显示和隐藏的效果

#### vue如何实现按需加载配合webpack设置?

webpack中提供了require.ensure()来实现按需加载。以前引入路由是通过import 这样的方式引入，改为const定义的方式进行引入。
不进行页面按需加载引入方式：import  home   from '../../common/home.vue'
进行页面按需加载的引入方式：const  home = r => require.ensure( [], () => r (require('../../common/home.vue')))

#### `<keep-alive></keep-alive>`的作用是什么?
`<keep-alive></keep-alive>`包裹动态组件时，会缓存不活动的组件实例,主要用于保留组件状态或避免重新渲染。

![](https://segmentfault.com/a/1190000010546663)

大白话: 比如有一个列表和一个详情，那么用户就会经常执行打开详情=>返回列表=>打开详情…这样的话列表和详情都是一个频率很高的页面，那么就可以对列表组件使用`<keep-alive></keep-alive>`进行缓存，这样用户每次返回列表的时候，都能从缓存中快速渲染，而不是重新渲染

#### 请说下封装 vue 组件的过程？

答：首先，组件可以提升整个项目的开发效率。能够把页面抽象成多个相对独立的模块，解决了我们传统项目开发：效率低、难维护、复用性等问题。

然后，使用Vue.extend方法创建一个组件，然后使用Vue.component方法注册组件。子组件需要数据，可以在props中接受定义。而子组件修改好数据后，想把数据传递给父组件。可以采用emit方法。

### Vue的双向数据绑定原理

答：vue.js 是采用数据劫持结合发布者-订阅者模式的方式，通过Object.defineProperty()来劫持各个属性的setter，getter，在数据变动时发布消息给订阅者，触发相应的监听回调。

```js
var Book = {}
Object.defineProperty(Book, 'name', {
  set: function (value) {
    name = value
    console.log('你取一个书名叫做'+ value)
  },
  get: function () {
    return `《${name}》`
  }
})
Book.name = 'sss' // 你取一个书名叫做sss
console.log(Book.name) // 《sss》
```

1. 要对所有对象进行监听，就需要通过递归方法，遍历所有属性值，并对其进行`Object.defindProperty()`处理
2. 植入订阅者，创建一个可以容纳订阅者的消息订阅器，

[详细内容：https://www.cnblogs.com/canfoo/p/6891868.html](https://www.cnblogs.com/canfoo/p/6891868.html)


#### v-model

> v-model是什么？怎么使用？ vue中标签怎么绑定事件？

可以实现双向绑定，指令（v-class、v-for、v-if、v-show、v-on）。vue的model层的data属性


### vue生命周期

答：总共分为8个阶段创建前/后，载入前/后，更新前/后，销毁前/后。

创建前/后：

* 在beforeCreated阶段，vue实例的挂载元素$el和数据对象data都为undefined，还未初始化。
* 在created阶段，vue实例的数据对象data有了，$el还没有。

载入前/后：

* 在beforeMount阶段，vue实例的$el和data都初始化了，但还是挂载之前为虚拟的dom节点，data.message还未替换。
* 在mounted阶段，vue实例挂载完成，data.message成功渲染。

更新前/后：当data变化时，会触发beforeUpdate和updated方法。

销毁前/后：

* 在执行destroy方法后，对data的改变不会再触发周期函数，说明此时vue实例已经解除了事件监听以及和dom的绑定，但是dom结构依然存在

### Vue diff算法

比较两棵DOM树的差异是Virtual DOM算法最核心的部分.简单的说就是新旧虚拟dom 的比较，如果有差异就以新的为准，然后再插入的真实的dom中，重新渲染。
借网络一张图片说明:

比较只会在同层级进行, 不会跨层级比较。比较后会出现四种情况：

* 此节点是否被移除 -> 添加新的节点 
* 属性是否被改变 -> 旧属性改为新属性
* 文本内容被改变 -> 旧内容改为新内容
* 节点要被整个替换  -> 结构完全不相同 移除整个替换

### vuex

答：vuex可以理解为一种开发模式或框架。比如PHP有thinkphp，java有spring等。

* 通过状态（数据源）集中管理驱动组件的变化（好比spring的IOC容器对bean进行集中管理）。
* 应用级的状态集中放在store中；
* 改变状态的方式是提交mutations，这是个同步的事物；
* 异步逻辑应该封装在action中。




## React

### React中组件的通信方式

* 父组件和子组件的通信：使用props
* 子组件向父组件通信：使用Props的回调
* 跨级组件间的通信：使用context 对象
* 非嵌套组件间通信：使用事件订阅

### React 生命周期

* constructor：构造函数，在创建组件的时候调用一次
* componentWillMount: 在组件挂载之前调用一次，在这个函数里调用setState，本次的render函数可以看到更新后的state，并且只渲染一次
* componentDidMount: 在组件挂载之后调用一次，这时候子组件都挂载完成了，可以是用refs
* componentWillReceiveProps: props是父组件传递给子组件的，父组件发生render的时候，子组件就会调用componentWillReceiveProps（不管props有没有更新，也不管父子组件之间有没有数据交换）
* shouldComponentUpdate：组件挂载之后，每次调用setState后都会调用shouldComponentUpdate判断是否需要重新渲染组件。默认返回是true，需要重新渲染，在比较复杂的应用里，有一些数据的改变是不影响界面展示的，所以可以在这里加判断，优化渲染效率。
* componentWillUpdate: shouleComponentUpdate返回true,或者调用forceUpdate之后，componentWillUpdate就会被调用
* componentDidUpdate: 除了首次render之后调用的是componentDidMount，其他render后都是调用componentDidUpdate
* render: 是唯一一个React组件中必不可少的核心函数，不要在render中修改state
* conponentWillUnmount：组件在被卸载的时候调用

### 更新方式

在react中，触发render的有4条路径。

1. 首次渲染Initial Render
2. 调用this.setState (并不是一次setState会触发一次render，React可能会合并操作，再一次性进行render)
3. 父组件发生更新，(一般就是props发生改变，但就算props没有改变或者父子组件之前没有数据交换也会触发render)
4. 调用this.forceUpdate

![](https://ws1.sinaimg.in/large/801b780agy1ftt6004vezj20jg0k3gos.jpg)



## Vue Vs React

### 监听数据变化的实现原理不同

* Vue通过改写Object.defindProperty的setter/getter方法，来劫持监听数据的变化，然后在模板编译时收集依赖。以后只要修改data的任何一个属性，就会触发视图的重新渲染，而且是精确的修改对应的vdom。不需要特别的优化就可以达到很好的性能
* 机制是每次setState的时候，调用shouldComponentUpdate，判断state或props改变需不需要重新render，如果返回true才会渲染。默认的实现是返回true，PureComponent的shouldComponnentUpdate浅层对比了两次state，考虑到性能，需要写好shouldComponentUpdate。React默认是通过比较引用的方式进行的，如果不优化（PureComponent/shouldComponentUpdate）可能导致大量不必要的VDom重新渲染

### 数据流的不同

Vue:(在 Vue2.x 中去掉了第一种，也就是父子组件之间不能双向绑定了)

1. 父子组件之间，props 可以双向绑定
2. 组件与DOM之间可以通过 v-model 双向绑定

React: 不支持双向绑定，React一直提倡的是单向数据流，他称之为 onChange/setState()模式。

>一般都会用 Vuex 以及 Redux 等单向数据流的状态管理框架，因此很多时候我们感受不到这一点的区别了


### 组件通信的区别

* Vue
  * 父组件通过props向子组件传递数据或者回调
  * 子组件通过事件向父组件发送消息
  * 2.2以后新增了provide/inject来实现，父组件向子组件注入数据，可以跨多个层级

* React
  * 父组件通过 props 可以向子组件传递数据或者回调
  * 可以通过 context 进行跨层级的通信，这其实和 provide/inject 起到的作用差不多。

### 模板渲染方式不同

在表层上，模板的语法不同

* React：是通过JSX渲染模板
* Vue：是通过template，一个拓展的HTML语法进行渲染

在深层次，模板的原理不同

* React在组件中，通过原生JS代码来实现模板中的常见语法，如插值，条件，循环
* Vue在组件中，JS代码和HTML相互分离，通过指令来实现的，如v-if，v-for

## Vuex Vs Redux

表面上看：

* Vuex: 使用dispatch和commit提交更新，通过mapState或者直接通过this.$store来读取数据。通过action 来做异步请求操作
* Redux: 如果需要每个组件都显示，则使用connect把需要的props和dispatch连接起来，不能直接调用redux

原理上看：

* Redux 使用的是不可变数据，而Vuex的数据是可变的。Redux每次都是用新的state替换旧的state，而Vuex是直接修改
* Redux 在检测数据变化的时候，是通过 diff 的方式比较差异的，而Vuex其实和Vue的原理一样，是通过 getter/setter来比较的
* React更偏向于构建稳定大型的应用，非常的科班化。相比之下，Vue更偏向于简单迅速的解决问题，更灵活，不那么严格遵循条条框框。

react是整体的思路的就是函数式，所以推崇纯组件，数据不可变，单向数据流，当然需要双向的地方也可以做到，比如结合redux-form，组件的横向拆分一般是通过高阶组件。而vue是数据可变的，双向绑定，声明式的写法，vue组件的横向拆分很多情况下用mixin。


## React Native

https://juejin.im/post/5ab9dce951882555712c6091

