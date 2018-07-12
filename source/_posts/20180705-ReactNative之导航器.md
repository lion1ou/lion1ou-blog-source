---
title: ReactNative之导航器
toc: true
comments: true
date: 2018-07-05 17:54:52
categories:
tags:
photos:
---

<!--more-->

### StackNavigator

StackNavigator组件采用堆栈式的页面导航来实现各个界面跳转。它的构造函数：

```js
StackNavigator(RouteConfigs, StackNavigatorConfig)
```

有RouteConfigs和StackNavigatorConfig两个参数。

##### RouteConfigs

表示各个页面路由配置，类似于前端路由配置页，它是让导航器知道需要导航的路由对应的页面。
```js
const RouteConfigs = {
    Home: {
        screen: HomePage,
        navigationOptions: ({navigation}) => ({
            title: '首页',
        }),
    },
    Find: {
        screen: FindPage,
        navigationOptions: ({navigation}) => ({
            title: '发现',
        }),
    },
    Mine: {
        screen: MinePage,
        navigationOptions: ({navigation}) => ({
            title: '我的',
        }),
    },
};
```
这里给导航器配置了三个页面，Home、Find、Mine为路由名称，screen属性值HomePage、FindPage、MinePage为对应路由的页面。

##### navigationOptions

>上述代码中的navigationOptions是配置对应路由页面的一些属性。

* title：标题，可当作headerTitle的备用的字符串，不推荐使用
* header：可以设置一些导航的属性，如果隐藏顶部导航栏只要将这个属性设置为null
* headerTitle：设置导航栏标题，推荐
* headerTitleAllowFontScaling：标题栏中字体是否根据字体大小自动缩放设置。 默认为true。
* headerBackTitle：iOS上的返回按钮的文字使用的字符串，或者使用null来禁用。默认为上一个页面的headerTitle。
* headerTruncatedBackTitle：设置当上个页面标题不符合返回箭头后的文字时（一般是因为文字太多），默认改成"返回"
* headerRight：设置导航条右侧。可以是按钮或者其他视图控件
* headerLeft：设置导航条左侧。可以是按钮或者其他视图控件
* headerStyle：设置导航条的样式。背景色，宽高等
* headerTitleStyle：设置导航栏文字样式
* headerBackTitleStyle：设置导航栏‘返回’文字样式
* headerTintColor：设置导航栏颜色
* headerPressColorAndroid：安卓独有的设置颜色纹理，需要安卓版本大于5.0
* gesturesEnabled：是否支持滑动返回手势，iOS默认支持，安卓默认关闭
* gestureResponseDistance：触发滑动返回手势的属性
    * horizontal - 数值型 - 水平方向的距离，默认值25
    * vertical - 数值型 - 垂直方向的距离，默认值135.
* gestureDirection：用来设置关闭页面的手势方向，默认default是从做往右，inverted是从右往左

##### StackNavigatorConfig

>可以通过设置StackNavigatorConfig，来全局设置navigator页面的基本样式和属性

```js
const StackNavigatorConfig = {
    initialRouteName: 'Home',
    initialRouteParams: {initPara: '初始页面参数'},
    navigationOptions: {
        title: '标题',
        headerTitleStyle: {fontSize: 18, color: '#666666'},
        headerStyle: {height: 48, backgroundColor: '#fff'},
    },
    paths: 'page/main',
    mode: 'card',
    headerMode: 'screen',
    cardStyle: {backgroundColor: "#ffffff"},
    transitionConfig: (() => ({
        screenInterpolator: CardStackStyleInterpolator.forHorizontal,
    })),
    onTransitionStart: (() => {
        console.log('页面跳转动画开始');
    }),
    onTransitionEnd: (() => {
        console.log('页面跳转动画结束');
    }),
};
```
* initialRouteName：设置默认的页面组件，必须是上面已注册的页面组件
* initialRouteParams：初始路由参数
* navigationOptions：用于页面的默认导航选项
* mode：定义跳转风格
    * card：使用iOS和安卓默认的风格
    * modal：iOS独有的使屏幕从底部画出。类似iOS的present效果 
* headerMode：返回上级页面时动画效果
    * float：iOS默认的效果，渲染一个放在顶部的标题栏，并在页面改变时显示动画。 这是iOS上的常见模式。
    * screen：渲染一个放在顶部的标题栏，并在页面改变时显示动画。 这是iOS上的常见模式。
    * none：无动画
* cardStyle：自定义设置跳转效果
* transitionConfig： 自定义设置滑动返回的配置
    * transitionProps - 新页面跳转的属性。
    * prevTransitionProps - 上一个页面跳转的属性
    * isModal - 指定页面是否为modal。
* onTransitionStart：当转换动画即将开始时被调用的功能
* onTransitionEnd：当转换动画完成，将被调用的功能
* path：路由中设置的路径的覆盖映射配置，path属性适用于其他app或浏览器使用url打开本app并进入指定页面。path属性用于声明一个界面路径，例如：【/pages/Home】。此时我们可以在手机浏览器中输入：app名称://pages/Home来启动该App，并进入Home界面。

##### 页面内配置

页面的配置选项navigationOptions通常还可以在对应页面中去静态配置，比如在HomePage页面中：
```
export default class HomePage extends Component {
    // 配置页面导航选项
    static navigationOptions = ({navigation}) => ({
        title: 'HOME',
        titleStyle: {color: '#ff00ff'},
        headerStyle:{backgroundColor:'#000000'}
    });

    render() {
        return (
            <View></View>
        )
    };
}
```

>同样地，在页面里面采用静态的方式配置navigationOptions中的属性，会覆盖StackNavigator构造函数中两个参数RouteConfigs和StackNavigatorConfig配置的navigationOptions里面的对应属性。navigationOptions中属性的优先级是：页面中静态配置 > RouteConfigs > StackNavigatorConfig

已经配置好导航器以及对应的路由页面了，但是要完成页面之间的跳转，还需要navigation。

##### navigation
在导航器中的每一个页面，都有navigation属性，该属性有以下几个属性/方法：

* navigate - 跳转到其他页面
* state - 当前页面导航器的状态
* setParams - 更改路由的参数
* goBack - 返回
* dispatch - 发送一个action

**navigete**

调用这个方法可以跳转到导航器中的其他页面，此方法有三个参数：

* routeName 导航器中配置的路由名称
* params 传递参数到下一个页面
* action action

比如：this.props.navigation.navigate('Find', {param: 'i am the param'});

**state**

state里面包含有传递过来的参数params、key、路由名称routeName，打印log可以看得到：
```
{ 
  params: { param: 'i am the param' },
  key: 'id-1500546317301-1',
  routeName: 'Mine' 
}
```

**setParams**

更改当前页面路由的参数，比如可以用来更新头部的按钮或者标题。
```
componentDidMount() {
    this.props.navigation.setParams({param:'i am the new param'})
}
```

**goBack**

回退，可以不传，也可以传参数，还可以传null。
```
this.props.navigation.goBack();       // 回退到上一个页面
this.props.navigation.goBack(null);   // 回退到任意一个页面
this.props.navigation.goBack('Home'); // 回退到Home页面复制代码
```

**dispatch**


### TabNavigator

```
TabNavigator(RouteConfigs, TabNavigatorConfig)
```

TabNavigator配置与StackNavigator配置是一样的。

* screen：和导航的功能是一样的，对应界面名称，可以在其他页面通过这个screen传值和跳转。

##### navigationOptions

* title：标题，可用作headerTitle和tabBarLabel回退标题
* tabBarVisible：是否隐藏标签栏。默认不隐藏(true)
* tabBarIcon：设置标签栏的图标。需要给每个都设置
* tabBarLabel：设置标签栏的title。推荐
* swipeEnabled：是否允许tab页之间滑动切换，如果未设置，则使用TabNavigatorConfig的swipeEnabled选项
* tabBarOnPress：tab被点击时的回调函数；参数是一个对象，包含一下属性：
    * previousScene: { route, index } ：正在离开的页面
    * scene: { route, index } 被点击的页面
    * jumpToIndex 执行跳转操作必须的参数

##### TabNavigatorConfig

* tabBarComponent - 用作渲染tab bar的组件，例如TabBarBottom（这是iOS上的默认设置），TabBarTop（这是Android上的默认设置）。
* tabBarPosition：设置tabbar的位置，iOS默认在底部，安卓默认在顶部。（属性值：'top'，'bottom'）
* swipeEnabled：是否允许在标签之间进行滑动
* animationEnabled：是否在更改标签时显示动画
* configureTransition - 给定currentTransitionProps和nextTransitionProps的函数，其返回一个配置对象，该对象用于描述tab页之间的动画
* initialLayout - 可以传递包含初始height和width的可选对象，用以防止react-native-tab-view渲染中一个帧的延迟
* tabBarOptions - Tab配置属性，用在TabBarTop和TabBarBottom时有些属性不一致：
    * 用在TabBarBottom(在iOS上的默认tabBar)
        * activeTintColor：label和icon的前景色 活跃状态下
        * activeBackgroundColor：label和icon的背景色 活跃状态下
        * inactiveTintColor：label和icon的前景色 不活跃状态下
        * inactiveBackgroundColor：label和icon的背景色 不活跃状态下
        * showLabel：是否显示label，默认开启
        * style：tabbar的样式
        * labelStyle：label的样式安卓属性
        * tabStyle - tab页的样式
        * allowFontScaling - 文本字体大小是否可以缩放取决于该设置，默认为true。
    * 用在TabBarTop(在Android上的默认tabBar)
        * activeTintColor：label和icon的前景色 活跃状态下
        * inactiveTintColor：label和icon的前景色 不活跃状态下
        * showIcon：是否显示图标，默认关闭
        * showLabel：是否显示label，默认开启 style：tabbar的样式
        * upperCaseLabel - 是否将文本转换为大小，默认是true
        * pressColor - material design中的波纹颜色(仅支持Android >= 5.0)
        * pressOpacity - 按下tab bar时的不透明度(仅支持iOS和Android < 5.0).
        * scrollEnabled - 是否允许滑动切换
        * tabStyle - tab页的样式
        * indicatorStyle - tab 页指示符的样式 (tab页下面的一条线).
        * labelStyle - tab bar的文本样式
        * iconStyle - tab bar的图标样式
        * style - tab bar的样式
        * allowFontScaling - 文本字体大小是否可以缩放取决于该设置，默认为true。

几个被传递到底层的路由，用于修改导航逻辑的选项

* initialRouteName - 第一次加载tab bar时路由的routeName
* order - 定义了tab bar顺序的一个routeNames数组
* paths - 提供routeName到path config的映射，它覆盖了routeConfigs中设置的path。
* backBehavior - 返回按钮是否会导致tab切换到初始tab页？ 如果是，则设置为initialRoute，否则为none。 默认为initialRoute。



### DrawerNavigator

在原生Android MD 风格里面很多app都会采用侧滑抽屉来做主页面的导航，利用DrawerNavigator在RN中可以很方便来实现抽屉导航。

```js
DrawerNavigator(RouteConfigs, DrawerNavigatorConfig)
```

和DrawerNavigator的构造函数一样，参数配置也类似。

可以手动去操作抽屉导航

```js
this.props.navigation.navigate('DrawerOpen'); // open drawer
this.props.navigation.navigate('DrawerClose'); // close drawer
this.props.navigation.navigate('DrawerToggle'); // toggle drawer
```

##### DrawerNavigatorConfig

* drawerWidth - 抽屉的宽度
* drawerPosition - 选项是左或右。 默认为左侧位置
* contentComponent - 用于呈现抽屉内容的组件，例如导航项。 接收抽屉的导航。 默认为DrawerItems
* useNativeAnimations - 是否使用原生动画，默认true.
* drawerBackgroundColor - 抽屉的背景色，默认是white.
* contentOptions 用来配置抽屉内容的属性。
    * items - 路由数组，可以被修改或者覆盖
    * activeItemKey - 当前选中页的路由的key
    * activeTintColor - 选中的DrawerItem的文本和图标颜色
    * activeBackgroundColor - 选中的DrawerItem的背景色
    * inactiveTintColor - 未选中的DrawerItem的文本和图标颜色
    * inactiveBackgroundColor - 未选中的DrawerItem的背景色
    * onItemPress(route) - DrawerItem被点击时触发的事件
    * itemsContainerStyle - DrawerItem容器的样式
    * itemStyle - 每个DrawerItem的样式, 可以包含文本或图标
    * labelStyle - 当文本是字符串时，设置DrawerItem中文本的样式
    * iconContainerStyle - 用于覆盖View图标容器的样式

几个被传递到底层的路由，用于修改导航逻辑的选项

* initialRouteName - 初始路由的routeName
* order - 定义抽屉项目顺序的routeNames数组。
* paths - 提供routeName到路径配置的映射，它覆盖routeConfigs中设置的路径。
* backBehavior - 后退按钮是否会切换到初始路由？ 如果是，设置为initialRoute，否则为none。 默认为initialRoute行为

**转载请标注原文地址**

