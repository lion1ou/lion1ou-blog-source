---
title: ReactNative之导航器使用
toc: true
comments: true
date: 2018-07-17 00:09:07
categories: 前端技术
tags: ReactNative
photos:
---

接上面那篇文章，上篇文章主要是介绍了react-navigation的相关配置和样式设置等，这篇文章主要讲讲react-navigation内的navigation属性。

<!--more-->

## navigation

>应用中的每个页面组件都会自动提供 navigation prop， 该 prop 包含便捷的方法用于触发导航操作， 如下所示:

* navigate -转到另一个屏幕, 计算出需要执行的操作
* goBack -关闭活动屏幕并在堆栈中向后移动
* addListener -订阅导航生命周期的更新
* isFocused -函数返回 true 如果屏幕焦点和 false 否则。
* state -当前状态/路由
* setParams -对路由的参数进行更改
* getParam -获取具有回退的特定参数
* dispatch - 向路由发送 action
* dangerouslyGetParent - 返回父级 navigator 的函数

重要的是要强调navigation prop 不传递给所有组件; 只有screen组件会自动收到此 prop。


### Navigator-dependent functions

this.props.navigation 上有一些取决于当前 navigator 的附加函数

如果是 StackNavigator，除了navigate 和 goBack ，还提供了如下方法：

* push - 推一个新的路由到堆栈
* pop - 返回堆栈中的上一个页面
* popToTop - 跳转到堆栈中最顶层的页面
* replace - 用新路由替换当前路由
* reset操作会擦除整个导航状态，并将其替换为多个操作的结果。
* dismiss - 关闭当前堆栈

如果是 DrawerNavigator, 则还可以使用以下选项:

* openDrawer - 打开
* closeDrawer - 关闭
* toggleDrawer - 切换，如果是打开则关闭，反之亦然


### 通用 API 参考

与 navigation 到大部分操作都涉及到 navigate、goBack、state 、 setParams 和 getParams。

#### navigate - 链接到其它页面

调用此方法可跳转到应用程序中的另一个页面. 可采用以下参数:

navigation.navigate({ routeName, params, action, key })

或者

navigation.navigate(routeName, params, action)

* routeName - 已在应用程序路由器中某处注册的目标routeName
* params - 合并到目标路由的参数
* action -如果页面是 navigator，则是子路由中运行的子操作，有关支持的操作的完整列表，请参见 Actions Doc
* key - 要导航到的路由的可选标识符。 如果已存在，将后退到此路由

```js
class HomeScreen extends React.Component {
  render() {
    const { navigate } = this.props.navigation;

    return (
      <View>
        <Text>This is the home screen of the app</Text>
        <Button
          onPress={() => navigate('Profile', { name: 'Brent' })}
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
          onPress={() => goBack('screen-123')}
          title="Go back from screen-123"
        />
      </View>
    );
  }
}
```

使用 goBack从一个指定的页面返回

请记住以下导航堆栈历史记录：

```js
navigation.navigate(SCREEN_KEY_A);
navigation.navigate(SCREEN_KEY_B);
navigation.navigate(SCREEN_KEY_C);
navigation.navigate(SCREEN_KEY_D);
```

现在你在 `* screen D` 上，并且想要回到 `screen A *`（销毁D、C和B）。 然后你需要提供一个 `goBack * FROM *` 的 key：

```js
navigation.goBack(SCREEN_KEY_B) // 将从 screen B 跳转到 screen A
```

如果，`* screen A *` 在堆栈的顶部, 你可以使用 navigation.popToTop()方法。

#### addListener - 订阅导航生命周期的更新

React Navigation 将事件发送到订阅了它们的页面组件：

* willFocus -页面将获取焦点
* didFocus - 页面已获取到焦点（如果有过渡动画，等过渡动画执行完成后响应）
* willBlur - 页面将失去焦点
* didFocus - 页面已获取到焦点（如果有过渡动画，等过渡动画执行完成后响应）

```js
const didBlurSubscription = this.props.navigation.addListener(
  'didBlur',
  payload => {
    console.debug('didBlur', payload);
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

let isFocused = this.props.navigation.isFocused();

您可能希望使用 withNavigationFocus 而不是直接使用此方法, 它将传入一个布尔型的 prop -- isFocused 到你的组件。

#### state - 当前的 state 或 route

页面可以通过 this.props.navigation.state访问其路由。每一个都将返回一个对象, 其内容如下:

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
        onPress={() => this.props.navigation.setParams({ name: 'Lucy' })}
        title="Set title name to 'Lucy'"
      />
    );
  }
}
```

#### getParam - 获取指定的的参数，可设置获取失败的返回值

过去, 当 params 未定义时, 你可能在获取 params 时遇到问题。 现在，你不必直接访问参数，可以调用 getParam方法。

之前：

```js
const { name } = this.props.navigation.state.params;
```

如果 params 未定义, 则此操作失败

现在：

```js
const name = this.props.navigation.getParam('name', 'Peter');
```

如果 name 或 param 未定义, 则返回 Peter。

### Stack Actions

下列操作将在所有 stack navigator 中起作用：

* Push

类似于navigate, push将跳转到堆栈中的新的路由 与navigate的区别在于，如果有已经加载的页面，navigate方法将跳转到已经加载的页面，而不会重新创建一个新的页面。 push 总是会创建一个新的页面，所以一个页面可以被多次创建

navigation.push(routeName, params, action)

routeName - 已在应用程序路由器中某处注册的目标routeName
params - 合并到目标路由的参数
action -如果页面是 navigator，则是子路由中运行的子操作，有关支持的操作的完整列表，请参见 Actions Doc
Pop
返回到堆栈中的上一个页面，如果提供一个参数 n，则指定在堆栈内返回几层。

navigation.pop(n)

* PopToTop

调用该方法将直接跳转到堆栈最顶层的路由，销毁其它所有页面。

navigation.popToTop()

* Replace

调用该方法将使用指定的路由覆盖当前的页面，可以附带参数（params和 sub-action）

navigation.replace(routeName, params, action)

* Reset

操作会擦除整个导航状态，并将其替换为多个操作的结果。

navigation.reset([NavigationActions.navigate({ routeName: 'Profile' })], 0)

* Dismiss

如果你想关闭整个 stack 回到父级 stack 中，调用这个方法

navigation.dismiss()


虽然 dispatch 方法并不常用，但是当使用 navigate 和 goBack无法满足要求时，该方法会是个不错的选择。

* dispatch - 向路由发送 action

使用 dispatch 将任何导航操作发送到路由后，该操作都将具有最高优先级。

请注意，如果您想分发 react-navigation 操作，则应使用此库中提供的操作创建者。


```js
import { NavigationActions } from 'react-navigation';

const navigateAction = NavigationActions.navigate({
  routeName: 'Profile',
  params: {},

  // navigate can have a nested navigate action that will be run inside the child router
  action: NavigationActions.navigate({ routeName: 'SubProfileRoute' }),
});
this.props.navigation.dispatch(navigateAction);
```

* dangerouslyGetParent - get parent navigator

例如，如果您有一个可以在多个导航器中显示的屏幕组件，则可以使用此组件根据其所在的导航器来影响其行为。

另一个很好的用例是在父路由列表中查找活动路由的索引。 因此，如果您在索引0处于堆栈的情况下，那么您可能不想渲染后退按钮，但如果您在列表中的其他位置，那么您将渲染后退按钮。

请务必始终检查调用是否返回有效值。

```js
class UserCreateScreen extends Component {
  static navigationOptions = ({ navigation }) => {
    const parent = navigation.dangerouslyGetParent();
    const gesturesEnabled =
      parent &&
      parent.state &&
      parent.state.routeName === 'StackWithEnabledGestures';

    return {
      title: 'New User',
      gesturesEnabled
    };
  };
}
```


**转载请标注原文地址**

