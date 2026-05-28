# GitHub 上狂揽 1.8 万 Star！开源平替的 Claude Design。

> 原文链接：https://mp.weixin.qq.com/s/cKFkP7vXTwC1FZ2k2LHFXA
> 文章时间：2026年5月5日 00:24

## 重点内容与核心观点

文章介绍 Open Design 作为 Claude Design 的开源替代品，能够把本机已有的 Claude Code、Codex、Cursor、OpenCode 等 Coding Agent 接入设计工作流。核心观点是，Open Design 不直接提供模型，而是通过本地 daemon、Skill、Design System、提示词栈和实时预览，把自然语言需求转成可导出的 HTML、PDF、PPTX 或 ZIP，使设计生成从封闭产品能力变成可本地编排的开源工作流。

Claude Design 发布没多少天，GitHub 上就有人做了开源复刻版。

4 月 17 日 Anthropic 上线 Claude Design，基于 Opus 4.7。

输入一句话，直接出设计成品，不是草图，不是线框图，是能交付的 HTML 页面、PPT、移动端原型。

![Image](images/01.png)

效果确实炸裂，瞬间出圈。

11 天后，nexu-io 团队把 Open Design 开源了。

现在已经快 2 万的星星了。

![Image](images/02.png)

01

**开源项目简介**

Open Design 是 Claude Design 的开源替代品。

但它不自带 AI 模型，它做的事是把你电脑上已经装好的 Coding Agent 变成设计引擎。

![Image](images/03.jpg)

![Image](images/04.jpg)

![Image](images/05.jpg)

![Image](images/06.jpg)

![Image](images/07.jpg)

![Image](images/08.jpg)

![Image](images/09.jpg)

![Image](images/10.jpg)

你输入一句话需求，比如「帮我做一份杂志风的官网」，这个先弹出一个表单确认你的需求，比如目标平台、受众、调性、品牌啥的。

然后 Agent 从 5 套视觉方向里选一个，拉出一份实时 Todo 计划，在 你电脑上创建真实的项目目录。

读模板、写 CSS、生成 HTML，最后在沙盒 iframe 里渲染出来。整个过程你可以随时介入纠偏。

输出不是截图，不是草图，是完整的单文件 HTML，可以直接导出为 HTML、PDF、PPTX、ZIP。

![Image](images/11.png)

Claude Code、Codex、Cursor、OpenCode 等等，哪个在就用哪个。

内置 19 个可组合 Skill + 71 套品牌级 Design System

可以看成是把你手上最强的 Coding Agent 接进设计工作流的中间层。

```
开源地址：github.com/nexu-io/open-design
```

02

**什么原理**

这个项目的架构分两层：浏览器里跑一个 Next.js Web 界面，你电脑本地跑一个 Node daemon 服务。

![Image](images/12.png)

核心流程是这样的：

你输入需求后，daemon 把 SKILL.md 设计能力描述和 DESIGN.md 品牌风格规范 拼装进提示词栈，然后通过 stdio 调用你机器上的 coding agent CLI 去执行。

Agent 拿到的是真实文件系统权限，它真的在你的电脑上读模板文件、grep CSS 里的 hex 色值、写 brand-spec.md、生成 HTML 和图片。

不是虚拟沙盒，不是内存模拟。

agent 跑完一轮，daemon 把产出的 HTML 塞进沙盒 iframe 实时预览。你可以在界面上直接编辑文件，也可以一键导出 HTML、PDF、PPTX、 ZIP。

**你有什么 Agent 它就用什么 Agent**

Daemon 启动的时候自动扫 PATH，检测你装了哪些 CLI。

不绑定任何一家模型，每一层都是 BYOK。

![Image](images/13.png)

Claude Design 只能用 Opus 4.7，Open Design 用你手上最强的那个 agent 就行。

**反 AI 味的提示词工程**

这个项目在提示词层面做了不少事来防止 AI 生成那种一眼假的设计。

开始生产之前，先弹一个初始化问题表单，让你选 surface、受众、调性、品牌上下文。

30 秒勾选完，比来回改需求高效得多。

输出之前还有一轮五维自评审，AI 自己给自己打分，低于 3 分的维度要重做。

另外还有一份 slop 黑名单，暴力紫渐变、通用 emoji 图标、手绘 SVG 真人脸、Inter 当 display 字体，全部明令禁止。

没有真数字就写破折号，不编数据。

**71 套 Design System + 19 个 Skill 开箱即用**

71 套品牌设计系统，Apple、Stripe、Vercel、Airbnb、Tesla、Notion、Cursor、Figma，直接从下拉框选，切换后下一次渲染就用新 token。

![Image](images/14.png)

19 个 Skill 覆盖网页原型、杂志风 PPT、Dashboard、移动端原型、定价页、邮件营销、社媒轮播图等等。

![Image](images/15.png)

03

**怎么跑起来**

三条命令：

```
git clone https://github.com/nexu-io/open-design.gitcd open-designpnpm install && pnpm dev:all
```

```
最简单的办法是把开源项目丢给你的 Agent，让它自己装。
```

```
跑起来后打开 localhost:3000，选一个 Skill、选一套 Design System、写需求，回车就行。
```

它会先弹问题表单让你锁定需求，然后 agent 开始干活，

实时 todo 卡片流入 UI，最后在沙盒 iframe 里渲染成品。

支持导出 HTML、PDF、PPTX、ZIP。

![Image](images/16.jpg)

![Image](images/17.jpg)

![Image](images/18.jpg)

![Image](images/19.jpg)

![Image](images/20.jpg)

![Image](images/21.jpg)

![Image](images/22.jpg)

04

**点击下方卡片，关注逛逛 GitHub**

这个公众号历史发布过很多有趣的开源项目，如果你懒得翻文章一个个找，你直接关注微信公众号：逛逛 GitHub ，后台对话聊天就行了：

![Image](images/23.webp)
