---
title: RN项目总结
toc: true
comments: true
categories: 技术博客
tags: Default
date: 2020-01-02 16:23:28
photos:
description:
---


1. 开发方式的改变，以rn给出aar的形式，rn项目中的ios、android工程为基础demo，所有库都以二进制形式给出，保证rn bridge 测试用例完全覆盖

RN组件问题：

1. dialog对话框定位问题，使用Modal是否可以解决
2. 时间选择器组件问题

教练端业务问题：

1. 获取用户信息都是RN层去调用接口，可以直接从端上获取，减少请求数

碰到比较棘手的问题：

1. 推送的RN链接,老的RN代码没有相应的页面（codepush 没有来的及更新），造成ios奔溃，闪退
2. RN页面、h5页面、Native页面相互跳转问题
3. 多环境的的数据共享问题
4. RN内部报错不好捕获，不好做错误监控，会出现crash（错误处理handler，出错出现浮窗，支持重试）

React-native 组件库

1. 美团组件库：beeshell

项目问题

1. resume Bridge入参不够 判断不够（解决）

```js
const MinePageEmitter = new NativeEventEmitter(NativeModules.LKRNBLifecycle);

this.listener = MinePageEmitter.addListener('resume', (component) => {
  console.log('ssscomponent', component);
  if (component && component.moduleName === 'coachMine') { // 要先对component判空
  }
});
// ssscomponent {moduleName: "coachMine"}
```

* RN 组件库开发  不支持 npm link 问题

![https://cdn.leoao.com/blog/20200224135732.png?imageslim](https://cdn.leoao.com/blog/20200224135732.png?imageslim)