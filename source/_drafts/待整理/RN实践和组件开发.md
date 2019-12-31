---
title: RN实践和组件开发
toc: true
comments: true
categories: 技术博客
tags: Default
date: 2019-06-16 22:23:03
photos:
description:
---


>RN在我们的教练端开发中已经有了不少尝试（教练端：我的、课程的训练营等若干子页面），，我们遇到了不少坑也有了一些沉淀。

##### 在RN业务开发的过程中遇到问题

###### 前端开发
- Gradle 和 [CocoaPods基础使用](https://front.leoao-inc.com/lefit-front-md/dist/react-native/ReactNative%E4%B9%8BCocoaPods%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86.html)
- React Navigation的使用，这里我们将经常用到的方法做了[一些总结](http://front.leoao-inc.com/lefit-front-md/dist/react-native/ReactNative%E4%B9%8B5%E5%AF%BC%E8%88%AA%E5%99%A8%E4%BD%BF%E7%94%A8.html)
- 在RN里面样式的使用和前端H5有一些[区别](http://front.leoao-inc.com/lefit-front-md/dist/react-native/ReactNative%E4%B9%8B3%E6%A0%B7%E5%BC%8F%E6%89%8B%E5%86%8C.html#_1-%E6%96%87%E5%AD%97%E5%9E%82%E7%9B%B4%E5%B1%85%E4%B8%AD-lineheight%E8%AE%BE%E7%BD%AE%E7%9A%84%E6%95%B0%E5%80%BC%E5%AE%9E%E9%99%85%E4%B8%8A%E4%BC%9A%E7%A6%BB%E5%A5%87%E7%9A%84%E5%A4%9A%E5%87%BA0-667)需要注意
- RN存在较多[两端兼容性的问题](https://front.leoao-inc.com/lefit-front-md/dist/react-native/%E9%A1%B9%E7%9B%AE%E7%9B%B8%E5%85%B3%E4%B9%8B%E4%B8%A4%E7%AB%AF%E5%85%BC%E5%AE%B9%E9%97%AE%E9%A2%98.html)，这里我们也做了记录，后续会持续更新



###### 移动端开发
- Gradle 或 CocoaPods
- npm
- React语法


以上的一些问题在我们的[大前端文档库](http://front.leoao-inc.com/lefit-front-md/dist/#%E8%AF%A6%E7%BB%86%E5%85%A5%E5%8F%A3%E5%8F%B3%E4%B8%8A)里都记录在案

##### 组件库

根据UED4.0的组件规范我们形成了自己的组件库，我们将所有已完成并且在双端都测试过的的组件放在我们的组件库中。有完善的[文档](http://front.leoao-inc.com/lefit-front-md/dist/react-native/%E9%A1%B9%E7%9B%AE%E7%9B%B8%E5%85%B3%E4%B9%8BRN%E7%BB%84%E4%BB%B6%E5%BA%93%E8%AF%B4%E6%98%8E.html)，开箱即用的[Package](http://npmrepo.leoao-inc.com/package/@lefit/lk-rncomponent)

![](https://note.youdao.com/yws/api/personal/file/WEB79acdaaf0057703e7c41e59badf325aa?method=download&shareKey=722f8c9720b9f3aaf8e1bc4eab97dde1)

在组件库的开发过程中，我们尽量使用JS去编写跨平台的组件。

但是在刷新组件开发的过程中我们遇到了组件资源文件太大，无法精准控制一个gif动画的问题。我们尝试桥接原生代码，在iOS平台上的尝试是比较成功的，我们通过hook,RN的`ScrolView`让`FlatList` `ListView`获得基本上和原生的体验一样。安卓平台上的尝试还在开荒中。

总体来说桥接原生的UI开发和维护的成本都比较高，但是体验较好。

```
@implementation LKRNRefreshControlManager

RCT_EXPORT_MODULE();

- (LKRNRefreshControl *)view
{
  return [LKRNRefreshControl new];
}

RCT_EXPORT_VIEW_PROPERTY(onRefresh, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(refreshing, BOOL)
RCT_REMAP_VIEW_PROPERTY(refreshHeaderStyle,headerStyle, NSInteger);

@end
```

##### 完善的BridgeDemo
所有Native和RN的桥接功能都能在这个Demo里面找到
![](https://note.youdao.com/yws/api/personal/file/WEB9f640711119178ec51c8dc0ebafe455a?method=download&shareKey=28095bf02e18181622b51e713cbb3a05)



##### RN+H5+Native路由跳转
在开发老带新需求的时候，我们借助原生bridge的支持，在打开一个新的RN容器时，我们在RN页面初始化时，对页面router进行重置路由地址，我们可以接受来自外部任何跳转到RN页面的路由。（纯RN应用的导航栈底一般是固定的）,由于原来的初始链接已经定死了，所以才以一个业务页面作为路由初始页面，后续会优化为独立页面。

```
const StackNavigatorConfig = {
  initialRouteName: 'GroupWeekList',
  ....
};
```

```
_resetRouter = (props) => {
    /**
     * 用于读取路由链接上的参数，然后重置RN router
     */
    const resetAction = StackActions.reset({
      index: 0,
      actions: [NavigationActions.navigate({
        routeName: props.routerName || 'GroupWeekList', 
        params: {
          ...props
        }
      })],
    });
    this.props.navigation.dispatch(resetAction);
  };

  componentWillMount(){
    this.props.screenProps.routerName && this._resetRouter(this.props.screenProps);
  }
```


##### 存在的问题

- 在部分安卓和iOS手机上存在性能问题，在以后组件测试中我们会覆盖一些性能较差的手机上。
- 在初始化RN容器的时候会出现可见的白屏现象
- 在多个RN容器的情况下无法共享数据
- 侧滑返回的时候会直接回到上一个Native页面

##### 总结
虽然RN的体验相较于H5已经有了比较大的提升，但是在个别性能差的手机上还是不容乐观。在CodePush第一步迈出后，我们会有更多的RN页面出现在业务里，所以后续的开发中我们会聚焦RN的性能问题。

开荒还在继续