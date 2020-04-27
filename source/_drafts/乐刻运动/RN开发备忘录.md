

问题：

1. 开发方式的改变，以rn给出aar的形式，rn项目中的ios、android工程为基础demo，所有库都以二进制形式给出，保证rn bridge 测试用例完全覆盖

RN组件问题：

1. dialog对话框定位问题，使用Modal是否可以解决   （已解决）
2. 时间选择器组件问题（已解决）

教练端业务问题：

1. 获取用户信息都是RN层去调用接口，可以直接从端上获取，减少请求数

碰到比较棘手的问题：

1. 推送的RN链接,老的RN代码没有相应的页面（codepush 没有来的及更新），造成ios奔溃，闪退（已解决）
2. RN页面、h5页面、Native页面相互跳转问题 （已解决，适用native路由方式）
3. 多环境的的数据共享问题
4. RN内部报错不好捕获，不好做错误监控，会出现crash（已解决，使用错误处理handler，出错出现浮窗，支持重试）

项目问题

1. resume Bridge入参不够 判断不够（已解决）

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

* React-Native 升级至0.59.9

  事情的起因是谷歌宣布19年8月1号开始在Google Play上架的应用都必须支持64位体系，而RN版本对64位的支持从0.58才开始，而项目组使用的版本比这低，因此升级是在所难免的。
  升级的第一个问题是该升到哪个版本。当前时间段最新的版本有0.59和0.60（吐槽下时隔四年RN还没1.0版本）。从0.60的 changelog 中我们发现有一个重大的 breaking change 就是 AndroidX support。这个改动不像支持64位体系那样改改编译参数就行，还必须改动原生代码，是个改动量非常大的升级（主要是针对第三方库以及项目中的原生代码改动较大），而特性并没有比 0.59 多太多，反而去掉了很多以前的内置组件，移到社区托管了。因此最终钦定 0.59.10 为升级目标版本。

  问题：
   数值需要判空，不然会直接报错
  QRcode 组件（react-native-qrcode）无法使用   不兼容新版RN  

  "react-native-qrcode": "github:wanxsb/react-native-qrcode#1a08f9cedcb747fd230be717fe815c686e4427cb",

  更新  npm install react-native-qrcode --save

  有些样式出现错误，原因是  0.49.5  box-sizing默认是content-box,  0.59.9 box-sizing 默认是 border-box