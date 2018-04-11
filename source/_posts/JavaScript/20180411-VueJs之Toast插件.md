---
title: VueJs之Toast插件
toc: true
comments: true
date: 2018-04-11 17:15:58
categories:
tags:
photos:
---

<!--more-->

## 插件是什么

插件通常用于为 Vue 添加全局级别的功能。Vue.js 的插件应当有一个公开方法 install 。这个方法的第一个参数是 Vue 构造器 , 第二个参数是一个可选的选项对象:

```js
export default {
    install (Vue, options) {
      Vue.globalMethod = function () {  // 1. 添加全局方法或属性，如: vue-custom-element
        // 逻辑...
      }
      Vue.directive('my-directive', {  // 2. 添加全局资源：指令/过滤器/过渡等，如 vue-touch
        bind (el, binding, vnode, oldVnode) {
          // 逻辑...
        }
        ...
      })
      Vue.mixin({
        created: function () {  // 3. 通过全局 mixin方法添加一些组件选项，如: vuex
          // 逻辑...
        }
        ...
      })
      Vue.prototype.$myMethod = function (options) {  // 4. 添加实例方法，通过把它们添加到 Vue.prototype 上实现
        // 逻辑...
      }
    }
}
```

## 使用插件

通过调用全局方法 Vue.use() 使用插件：
```js
// 调用 `MyPlugin.install(Vue)`
Vue.use(MyPlugin)
```
可以根据情况，传入一些可选的选项：
```js
Vue.use(MyPlugin, { someOption: true })
```
Vue.use 会自动阻止多次使用同一个插件，所以对于同一个插件的多次调用，将只安装一次。

## Toast

* 在使用IOS、Android的APP时，经常会收到系统的一些简短的提示信息，在其显示1--3s后自动关闭。
* 特点：
    * 内容简短，大多数就是一句话
    * 显示在固定且显目的位置
    * 没有关闭按钮
    * 1--3秒后自动关闭消失

### Toast.vue

先实现一个Toast.vue组件，完成基本样式和内容

```html
<template>
    <div class="vue-toast" :class="[visible ? '' : 'hidden', position]">
      <div class="status-icon" v-if="type !== 'default'">
        <!-- 不同类型会有不同图标 -->
        <i class="iconfont icon-style" :class="`icon-toast-${type}`"></i>
      </div>
      <div class="status-text">{{text || defaultText[type]}}</div>
    </div>
</template>
<script>
export default {
  data () {
    return {
      visible: true,
      text: '',
      type: 'default', // success, warn, error, default
      position: '',
      defaultText: {
        'success': '操作成功',
        'error': '操作失败',
        'warn': '操作警告'
      }
    }
  }
}
</script>
<style lang="less" scoped>
.top {
  position: absolute;
  top: 1rem;
  left: 0;
  right: 0;
  margin: auto;
}
.middle {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: auto;
}
.bottom {
  position: absolute;
  bottom: 1rem;
  left: 0;
  right: 0;
  margin: auto;
}

......

// 用于toast消失时的小动画
.hidden{
  opacity: 0;
  transform: scale(0);
  transition: opacity .5s;
}
</style>
```

组件很简单，就是使用vue的数据绑定，默认显示toast内容

### Toast.js

接下来就是写插件内容了

```js
import ToastVue from './Toast.vue'

/**
 * 使用指南
 * // 以下会有图标显示
 * this.$toast.success()  // 操作成功
 * this.$toast.warn()     // 操作警告
 * this.$toast.error()    // 操作失败
 *
 * // 默认没有图标
 * this.$toast({
 *   text: '要提示的内容'
 * })
 *
 * 参数如下：
 * text: '',
 * duration: '', // 关闭延时 默认1500ms
 * position: '', // 提示框位置 top middle bottom 默认middle
 * onShow: function (params) { }, // 钩子，显示toast前触发
 * onHide: function (params) { }  // 钩子，toast隐藏后触发
 *
 */

export default {
  install(Vue, options = {}) {
    // 构造器
    var ToastConstructor = Vue.extend(ToastVue)

    // 用于隐藏toast
    ToastConstructor.prototype.close = function () {
      this.visible = false
      this.$el.addEventListener('transitionend', this.destroyInstance.bind(this))
    }
    // 用于销毁toast，删除dom
    ToastConstructor.prototype.destroyInstance = function (params) {
      this.$destroy(true)
      this.$el.removeEventListener('transitionend', this.destroyInstance)
      this.$el.parentNode.removeChild(this.$el)
    }
    // 
    Vue.prototype.$toast = (option = {}, type) => {
        if (document.getElementsByClassName('vue-toast').length) {
            // 如果toast还在，则不再执行
            return;
        }
        // 通过 new 创建组件实例
        let instance = new ToastConstructor({
            el: document.createElement('div')
        })
        // 向组件内部传递参数
        instance.text = typeof option === 'string' ? option : option.text
        instance.type = type || 'default'
        let duration = option.duration || options.duration || 2000
        instance.position = option.position || 'middle'
        // 设置钩子
        option.onShow && option.onShow(instance)
        // 添加dom
        document.body.appendChild(instance.$el)
        // 设置延时，销毁dom
        setTimeout(() => {
            instance.close()
            option.onHide && option.onHide(instance)
        }, duration)
    }
    // 注册多个常用方法
    ['success', 'warn', 'error'].forEach((key) => {
      Vue.prototype.$toast[key] = (option = {}) => {
        return Vue.prototype.$toast(option, key)
      }
    })
  }
}

```





**转载请标注原文地址**

