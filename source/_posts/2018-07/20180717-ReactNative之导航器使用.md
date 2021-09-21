---
title: ReactNative之导航器使用
toc: true
comments: true
date: 2018-07-17 00:09:07
categories: 前端技术
tags: ReactNative
photos:
---

主要是介绍了 react-navigation 的相关配置和样式设置，以及 react-navigation 内的 navigation 属性。navigator 主要分为以下三种类型：StackNavigator、TabNavigator、DrawerNavigator，每种类型都有其相应的使用场景和配置项。

<!--more-->

## navigator 类型

### StackNavigator

StackNavigator 组件采用堆栈式的页面导航来实现各个界面跳转。它的构造函数：

```js
StackNavigator(RouteConfigs, StackNavigatorConfig);
```

有 RouteConfigs 和 StackNavigatorConfig 两个参数。

##### RouteConfigs

表示各个页面路由配置，类似于前端路由配置页，它是让导航器知道需要导航的路由对应的页面。

```js
const RouteConfigs = {
  Home: {
    screen: HomePage,
    navigationOptions: ({ navigation }) => ({
      title: "首页",
    }),
  },
  Find: {
    screen: FindPage,
    navigationOptions: ({ navigation }) => ({
      title: "发现",
    }),
  },
  Mine: {
    screen: MinePage,
    navigationOptions: ({ navigation }) => ({
      title: "我的",
    }),
  },
};
```

这里给导航器配置了三个页面，Home、Find、Mine 为路由名称，screen 属性值 HomePage、FindPage、MinePage 为对应路由的页面。

##### navigationOptions

> 上述代码中的 navigationOptions 是配置对应路由页面的一些属性。

- title：标题，可当作 headerTitle 的备用的字符串，不推荐使用
- header：可以设置一些导航的属性，如果隐藏顶部导航栏只要将这个属性设置为 null
- headerTitle：设置导航栏标题，推荐
- headerTitleAllowFontScaling：标题栏中字体是否根据字体大小自动缩放设置。 默认为 true。
- headerBackTitle：iOS 上的返回按钮的文字使用的字符串，或者使用 null 来禁用。默认为上一个页面的 headerTitle。
- headerTruncatedBackTitle：设置当上个页面标题不符合返回箭头后的文字时（一般是因为文字太多），默认改成"返回"
- headerRight：设置导航条右侧。可以是按钮或者其他视图控件
- headerLeft：设置导航条左侧。可以是按钮或者其他视图控件
- headerStyle：设置导航条的样式。背景色，宽高等
- headerTitleStyle：设置导航栏文字样式
- headerBackTitleStyle：设置导航栏‘返回’文字样式
- headerTintColor：设置导航栏颜色
- headerPressColorAndroid：安卓独有的设置颜色纹理，需要安卓版本大于 5.0
- gesturesEnabled：是否支持滑动返回手势，iOS 默认支持，安卓默认关闭
- gestureResponseDistance：触发滑动返回手势的属性
  - horizontal - 数值型 - 水平方向的距离，默认值 25
  - vertical - 数值型 - 垂直方向的距离，默认值 135.
- gestureDirection：用来设置关闭页面的手势方向，默认 default 是从做往右，inverted 是从右往左

##### StackNavigatorConfig

> 可以通过设置 StackNavigatorConfig，来全局设置 navigator 页面的基本样式和属性

```js
const StackNavigatorConfig = {
  initialRouteName: "Home",
  initialRouteParams: { initPara: "初始页面参数" },
  navigationOptions: {
    title: "标题",
    headerTitleStyle: { fontSize: 18, color: "#666666" },
    headerStyle: { height: 48, backgroundColor: "#fff" },
  },
  paths: "page/main",
  mode: "card",
  headerMode: "screen",
  cardStyle: { backgroundColor: "#ffffff" },
  transitionConfig: () => ({
    screenInterpolator: CardStackStyleInterpolator.forHorizontal,
  }),
  onTransitionStart: () => {
    console.log("页面跳转动画开始");
  },
  onTransitionEnd: () => {
    console.log("页面跳转动画结束");
  },
};
```

- initialRouteName：设置默认的页面组件，必须是上面已注册的页面组件
- initialRouteParams：初始路由参数
- navigationOptions：用于页面的默认导航选项
- mode：定义跳转风格
  - card：使用 iOS 和安卓默认的风格
  - modal：iOS 独有的使屏幕从底部画出。类似 iOS 的 present 效果
- headerMode：返回上级页面时动画效果
  - float：iOS 默认的效果，渲染一个放在顶部的标题栏，并在页面改变时显示动画。 这是 iOS 上的常见模式。
  - screen：渲染一个放在顶部的标题栏，并在页面改变时显示动画。 这是 iOS 上的常见模式。
  - none：无动画
- cardStyle：自定义设置跳转效果
- transitionConfig： 自定义设置滑动返回的配置
  - transitionProps - 新页面跳转的属性。
  - prevTransitionProps - 上一个页面跳转的属性
  - isModal - 指定页面是否为 modal。
- onTransitionStart：当转换动画即将开始时被调用的功能
- onTransitionEnd：当转换动画完成，将被调用的功能
- path：路由中设置的路径的覆盖映射配置，path 属性适用于其他 app 或浏览器使用 url 打开本 app 并进入指定页面。path 属性用于声明一个界面路径，例如：【/pages/Home】。此时我们可以在手机浏览器中输入：app 名称://pages/Home 来启动该 App，并进入 Home 界面。

##### 页面内配置

页面的配置选项 navigationOptions 通常还可以在对应页面中去静态配置，比如在 HomePage 页面中：

```js
export default class HomePage extends Component {
  // 配置页面导航选项
  static navigationOptions = ({ navigation }) => ({
    title: "HOME",
    titleStyle: { color: "#ff00ff" },
    headerStyle: { backgroundColor: "#000000" },
  });

  render() {
    return <View></View>;
  }
}
```

> 同样地，在页面里面采用静态的方式配置 navigationOptions 中的属性，会覆盖 StackNavigator 构造函数中两个参数 RouteConfigs 和 StackNavigatorConfig 配置的 navigationOptions 里面的对应属性。navigationOptions 中属性的优先级是：页面中静态配置 > RouteConfigs > StackNavigatorConfig

已经配置好导航器以及对应的路由页面了，但是要完成页面之间的跳转，还需要 navigation。

##### navigation

在导航器中的每一个页面，都有 navigation 属性，该属性有以下几个属性/方法：

- navigate - 跳转到其他页面
- state - 当前页面导航器的状态
- setParams - 更改路由的参数
- goBack - 返回
- dispatch - 发送一个 action

**navigete**

调用这个方法可以跳转到导航器中的其他页面，此方法有三个参数：

- routeName 导航器中配置的路由名称
- params 传递参数到下一个页面
- action action

比如：this.props.navigation.navigate('Find', {param: 'i am the param'});

**state**

state 里面包含有传递过来的参数 params、key、路由名称 routeName，打印 log 可以看得到：

```js
{
  params: { param: 'i am the param' },
  key: 'id-1500546317301-1',
  routeName: 'Mine'
}
```

**setParams**

更改当前页面路由的参数，比如可以用来更新头部的按钮或者标题。

```js
componentDidMount() {
    this.props.navigation.setParams({param:'i am the new param'})
}
```

**goBack**

回退，可以不传，也可以传参数，还可以传 null。

```js
this.props.navigation.goBack(); // 回退到上一个页面
this.props.navigation.goBack(null); // 回退到任意一个页面
this.props.navigation.goBack("Home"); // 回退到Home页面复制代码
```

**dispatch**

### TabNavigator

```js
TabNavigator(RouteConfigs, TabNavigatorConfig);
```

TabNavigator 配置与 StackNavigator 配置是一样的。

- screen：和导航的功能是一样的，对应界面名称，可以在其他页面通过这个 screen 传值和跳转。

##### navigationOptions

- title：标题，可用作 headerTitle 和 tabBarLabel 回退标题
- tabBarVisible：是否隐藏标签栏。默认不隐藏(true)
- tabBarIcon：设置标签栏的图标。需要给每个都设置
- tabBarLabel：设置标签栏的 title。推荐
- swipeEnabled：是否允许 tab 页之间滑动切换，如果未设置，则使用 TabNavigatorConfig 的 swipeEnabled 选项
- tabBarOnPress：tab 被点击时的回调函数；参数是一个对象，包含一下属性：
  - previousScene: { route, index } ：正在离开的页面
  - scene: { route, index } 被点击的页面
  - jumpToIndex 执行跳转操作必须的参数

##### TabNavigatorConfig

- tabBarComponent - 用作渲染 tab bar 的组件，例如 TabBarBottom（这是 iOS 上的默认设置），TabBarTop（这是 Android 上的默认设置）。
- tabBarPosition：设置 tabbar 的位置，iOS 默认在底部，安卓默认在顶部。（属性值：'top'，'bottom'）
- swipeEnabled：是否允许在标签之间进行滑动
- animationEnabled：是否在更改标签时显示动画
- configureTransition - 给定 currentTransitionProps 和 nextTransitionProps 的函数，其返回一个配置对象，该对象用于描述 tab 页之间的动画
- initialLayout - 可以传递包含初始 height 和 width 的可选对象，用以防止 react-native-tab-view 渲染中一个帧的延迟
- tabBarOptions - Tab 配置属性，用在 TabBarTop 和 TabBarBottom 时有些属性不一致：
  - 用在 TabBarBottom(在 iOS 上的默认 tabBar)
    - activeTintColor：label 和 icon 的前景色 活跃状态下
    - activeBackgroundColor：label 和 icon 的背景色 活跃状态下
    - inactiveTintColor：label 和 icon 的前景色 不活跃状态下
    - inactiveBackgroundColor：label 和 icon 的背景色 不活跃状态下
    - showLabel：是否显示 label，默认开启
    - style：tabbar 的样式
    - labelStyle：label 的样式安卓属性
    - tabStyle - tab 页的样式
    - allowFontScaling - 文本字体大小是否可以缩放取决于该设置，默认为 true。
  - 用在 TabBarTop(在 Android 上的默认 tabBar)
    - activeTintColor：label 和 icon 的前景色 活跃状态下
    - inactiveTintColor：label 和 icon 的前景色 不活跃状态下
    - showIcon：是否显示图标，默认关闭
    - showLabel：是否显示 label，默认开启 style：tabbar 的样式
    - upperCaseLabel - 是否将文本转换为大小，默认是 true
    - pressColor - material design 中的波纹颜色(仅支持 Android >= 5.0)
    - pressOpacity - 按下 tab bar 时的不透明度(仅支持 iOS 和 Android < 5.0).
    - scrollEnabled - 是否允许滑动切换
    - tabStyle - tab 页的样式
    - indicatorStyle - tab 页指示符的样式 (tab 页下面的一条线).
    - labelStyle - tab bar 的文本样式
    - iconStyle - tab bar 的图标样式
    - style - tab bar 的样式
    - allowFontScaling - 文本字体大小是否可以缩放取决于该设置，默认为 true。

几个被传递到底层的路由，用于修改导航逻辑的选项

- initialRouteName - 第一次加载 tab bar 时路由的 routeName
- order - 定义了 tab bar 顺序的一个 routeNames 数组
- paths - 提供 routeName 到 path config 的映射，它覆盖了 routeConfigs 中设置的 path。
- backBehavior - 返回按钮是否会导致 tab 切换到初始 tab 页？ 如果是，则设置为 initialRoute，否则为 none。 默认为 initialRoute。

### DrawerNavigator

在原生 Android MD 风格里面很多 app 都会采用侧滑抽屉来做主页面的导航，利用 DrawerNavigator 在 RN 中可以很方便来实现抽屉导航。

```js
DrawerNavigator(RouteConfigs, DrawerNavigatorConfig);
```

和 DrawerNavigator 的构造函数一样，参数配置也类似。

可以手动去操作抽屉导航

```js
this.props.navigation.navigate("DrawerOpen"); // open drawer
this.props.navigation.navigate("DrawerClose"); // close drawer
this.props.navigation.navigate("DrawerToggle"); // toggle drawer
```

##### DrawerNavigatorConfig

- drawerWidth - 抽屉的宽度
- drawerPosition - 选项是左或右。 默认为左侧位置
- contentComponent - 用于呈现抽屉内容的组件，例如导航项。 接收抽屉的导航。 默认为 DrawerItems
- useNativeAnimations - 是否使用原生动画，默认 true.
- drawerBackgroundColor - 抽屉的背景色，默认是 white.
- contentOptions 用来配置抽屉内容的属性。
  - items - 路由数组，可以被修改或者覆盖
  - activeItemKey - 当前选中页的路由的 key
  - activeTintColor - 选中的 DrawerItem 的文本和图标颜色
  - activeBackgroundColor - 选中的 DrawerItem 的背景色
  - inactiveTintColor - 未选中的 DrawerItem 的文本和图标颜色
  - inactiveBackgroundColor - 未选中的 DrawerItem 的背景色
  - onItemPress(route) - DrawerItem 被点击时触发的事件
  - itemsContainerStyle - DrawerItem 容器的样式
  - itemStyle - 每个 DrawerItem 的样式, 可以包含文本或图标
  - labelStyle - 当文本是字符串时，设置 DrawerItem 中文本的样式
  - iconContainerStyle - 用于覆盖 View 图标容器的样式

几个被传递到底层的路由，用于修改导航逻辑的选项

- initialRouteName - 初始路由的 routeName
- order - 定义抽屉项目顺序的 routeNames 数组。
- paths - 提供 routeName 到路径配置的映射，它覆盖 routeConfigs 中设置的路径。
- backBehavior - 后退按钮是否会切换到初始路由？ 如果是，设置为 initialRoute，否则为 none。 默认为 initialRoute 行为

### 监听事件

```js
let _this = null;

export default class WebViewPage extends Component {
    static navigationOptions = ({ navigation }) => ({
        // ......
                    onPress={() => _this.reload() }>
        // ......
        )
    });
   componentDidMount() {
       _this = this;
   }
    _reload() {
        console.log("aaaaaaa");
    }
```

## navigation

> 应用中的每个页面组件都会自动提供 navigation prop， 该 prop 包含便捷的方法用于触发导航操作， 如下所示:

- navigate -转到另一个屏幕, 计算出需要执行的操作
- goBack -关闭活动屏幕并在堆栈中向后移动
- addListener -订阅导航生命周期的更新
- isFocused -函数返回 true 如果屏幕焦点和 false 否则。
- state -当前状态/路由
- setParams -对路由的参数进行更改
- getParam -获取具有回退的特定参数
- dispatch - 向路由发送 action
- dangerouslyGetParent - 返回父级 navigator 的函数

重要的是要强调 navigation prop 不传递给所有组件; 只有 screen 组件会自动收到此 prop。

### Navigator-dependent functions

this.props.navigation 上有一些取决于当前 navigator 的附加函数

如果是 StackNavigator，除了 navigate 和 goBack ，还提供了如下方法：

- push - 推一个新的路由到堆栈
- pop - 返回堆栈中的上一个页面
- popToTop - 跳转到堆栈中最顶层的页面
- replace - 用新路由替换当前路由
- reset 操作会擦除整个导航状态，并将其替换为多个操作的结果。
- dismiss - 关闭当前堆栈

如果是 DrawerNavigator, 则还可以使用以下选项:

- openDrawer - 打开
- closeDrawer - 关闭
- toggleDrawer - 切换，如果是打开则关闭，反之亦然

### 通用 API 参考

与 navigation 到大部分操作都涉及到 navigate、goBack、state 、 setParams 和 getParams。

#### navigate - 链接到其它页面

调用此方法可跳转到应用程序中的另一个页面. 可采用以下参数:

```js
navigation.navigate({ routeName, params, action, key });
```

或者

```js
navigation.navigate(routeName, params, action);
```

- routeName - 已在应用程序路由器中某处注册的目标 routeName
- params - 合并到目标路由的参数
- action -如果页面是 navigator，则是子路由中运行的子操作，有关支持的操作的完整列表，请参见 Actions Doc
- key - 要导航到的路由的可选标识符。 如果已存在，将后退到此路由

```js
class HomeScreen extends React.Component {
  render() {
    const { navigate } = this.props.navigation;

    return (
      <View>
        <Text>This is the home screen of the app</Text>
        <Button
          onPress={() => navigate("Profile", { name: "Brent" })}
          title="Go to Brent's profile"
        />
      </View>
    );
  }
}
```

#### goBack - 关闭当前页面并返回上一个页面

可以选择提供一个 key, 指定要返回的路由。 默认情况下, goBack 将关闭调用该方法的页面 如果目标是在任何位置返回 `*`, 而不指定要关闭的内容, 请调用 `.goBack(null);` 注意, null 参数在嵌套 StackNavigators 的情况下很有用 如果子导航器在堆栈中已经只有一个项目, 则返回父导航器。

```js
class HomeScreen extends React.Component {
  render() {
    const { goBack } = this.props.navigation;
    return (
      <View>
        <Button onPress={() => goBack()} title="Go back from this HomeScreen" />
        <Button onPress={() => goBack(null)} title="Go back anywhere" />
        <Button
          onPress={() => goBack("screen-123")}
          title="Go back from screen-123"
        />
      </View>
    );
  }
}
```

使用 goBack 从一个指定的页面返回

请记住以下导航堆栈历史记录：

```js
navigation.navigate(SCREEN_KEY_A);
navigation.navigate(SCREEN_KEY_B);
navigation.navigate(SCREEN_KEY_C);
navigation.navigate(SCREEN_KEY_D);
```

现在你在 `* screen D` 上，并且想要回到 `screen A *`（销毁 D、C 和 B）。 然后你需要提供一个 `goBack * FROM *` 的 key：

```js
navigation.goBack(SCREEN_KEY_B); // 将从 screen B 跳转到 screen A
```

如果，`* screen A *` 在堆栈的顶部, 你可以使用 navigation.popToTop()方法。

#### addListener - 订阅导航生命周期的更新

React Navigation 将事件发送到订阅了它们的页面组件：

- willFocus -页面将获取焦点
- didFocus - 页面已获取到焦点（如果有过渡动画，等过渡动画执行完成后响应）
- willBlur - 页面将失去焦点
- didFocus - 页面已获取到焦点（如果有过渡动画，等过渡动画执行完成后响应）

```js
const didBlurSubscription = this.props.navigation.addListener(
  "didBlur",
  (payload) => {
    console.debug("didBlur", payload);
  }
);

// Remove the listener when you are done
didBlurSubscription.remove();
```

JSON 格式的参数:

```js
{
  action: { type: 'Navigation/COMPLETE_TRANSITION', key: 'StackRouterRoot' },
  context: 'id-1518521010538-2:Navigation/COMPLETE_TRANSITION_Root',
  lastState: undefined,
  state: undefined,
  type: 'didBlur',
};
```

你也可以用 <NavigationEvents/>组件 以声明的方式订阅导航事件。

#### isFocused - 查询页面是否获取到焦点

如果页面已获取到焦点，则返回 true 否则返回 false。

```js
let isFocused = this.props.navigation.isFocused();
```

您可能希望使用 withNavigationFocus 而不是直接使用此方法, 它将传入一个布尔型的 prop -- isFocused 到你的组件。

#### state - 当前的 state 或 route

页面可以通过 this.props.navigation.state 访问其路由。每一个都将返回一个对象, 其内容如下:

```js
{
  // the name of the route config in the router
  routeName: 'profile',
  //a unique identifier used to sort routes
  key: 'main0',
  //an optional object of string options for this screen
  params: { hello: 'world' }
}
```

通过 `navigate` 或 `setParams` 方法传入参数。是获取页面参数最常用的方法。

```js
class ProfileScreen extends React.Component {
  render() {
    return Name: {this.props.navigation.state.params.name};
  }
}
```

#### setParams - 对路由的参数进行更改

触发`setParams`方法允许页面更改路由中的参数，这对于更新标题按钮和标题文本很有用。 `setParams` 就像 React 的 setState -他会将原来的参数与现在的参数合并

```js
class ProfileScreen extends React.Component {
  render() {
    return (
      <Button
        onPress={() => this.props.navigation.setParams({ name: "Lucy" })}
        title="Set title name to 'Lucy'"
      />
    );
  }
}
```

#### getParam - 获取指定的的参数，可设置获取失败的返回值

过去, 当 params 未定义时, 你可能在获取 params 时遇到问题。 现在，你不必直接访问参数，可以调用 getParam 方法。

之前：

```js
const { name } = this.props.navigation.state.params;
```

如果 params 未定义, 则此操作失败

现在：

```js
const name = this.props.navigation.getParam("name", "Peter");
```

如果 name 或 param 未定义, 则返回 Peter。

### Stack Actions

下列操作将在所有 stack navigator 中起作用：

- Push

类似于 navigate, push 将跳转到堆栈中的新的路由 与 navigate 的区别在于，如果有已经加载的页面，navigate 方法将跳转到已经加载的页面，而不会重新创建一个新的页面。 push 总是会创建一个新的页面，所以一个页面可以被多次创建

```js
navigation.push(routeName, params, action);
```

- routeName - 已在应用程序路由器中某处注册的目标 routeName
- params - 合并到目标路由的参数
- action -如果页面是 navigator，则是子路由中运行的子操作，有关支持的操作的完整列表
- Pop - 返回到堆栈中的上一个页面，如果提供一个参数 n，则指定在堆栈内返回几层。

```js
navigation.pop(n);
```

- PopToTop

调用该方法将直接跳转到堆栈最顶层的路由，销毁其它所有页面。

navigation.popToTop()

- Replace

调用该方法将使用指定的路由覆盖当前的页面，可以附带参数（params 和 sub-action）

navigation.replace(routeName, params, action)

- Reset

操作会擦除整个导航状态，并将其替换为多个操作的结果。

navigation.reset([NavigationActions.navigate({ routeName: 'Profile' })], 0)

- Dismiss

如果你想关闭整个 stack 回到父级 stack 中，调用这个方法

navigation.dismiss()

虽然 dispatch 方法并不常用，但是当使用 navigate 和 goBack 无法满足要求时，该方法会是个不错的选择。

- dispatch - 向路由发送 action

使用 dispatch 将任何导航操作发送到路由后，该操作都将具有最高优先级。

请注意，如果您想分发 react-navigation 操作，则应使用此库中提供的操作创建者。

```js
import { NavigationActions } from "react-navigation";

const navigateAction = NavigationActions.navigate({
  routeName: "Profile",
  params: {},

  // navigate can have a nested navigate action that will be run inside the child router
  action: NavigationActions.navigate({ routeName: "SubProfileRoute" }),
});
this.props.navigation.dispatch(navigateAction);
```

- dangerouslyGetParent - get parent navigator

例如，如果您有一个可以在多个导航器中显示的屏幕组件，则可以使用此组件根据其所在的导航器来影响其行为。

另一个很好的用例是在父路由列表中查找活动路由的索引。 因此，如果您在索引 0 处于堆栈的情况下，那么您可能不想渲染后退按钮，但如果您在列表中的其他位置，那么您将渲染后退按钮。

请务必始终检查调用是否返回有效值。

```js
class UserCreateScreen extends Component {
  static navigationOptions = ({ navigation }) => {
    const parent = navigation.dangerouslyGetParent();
    const gesturesEnabled =
      parent &&
      parent.state &&
      parent.state.routeName === "StackWithEnabledGestures";

    return {
      title: "New User",
      gesturesEnabled,
    };
  };
}
```
