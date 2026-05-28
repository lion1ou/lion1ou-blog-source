---
name: lion1ou-article-channel
description: >-
  当用户要把已确认的母版文章改写成博客、微信公众号、小红书或其他渠道的可发布成品时使用，尤其是渠道改写、公众号改写、小红书图文、博客最终版、主图、配图、Markdown 转微信 HTML、渠道包。不要用于初稿写作或最终发布，前置使用 lion1ou-article-editor，后续使用 lion1ou-article-publish。
---

# Article Channel

渠道改写与成品生成 skill。它把 `lion1ou-article-editor` 产出的母版文章变成目标渠道可用的最终成品包。它可以改变表达、结构、标题、节奏、图片和格式，但不能改变母版文章的事实结论。

## 边界

适用场景：

- 将 `master.md` 改写成博客、微信公众号、小红书等渠道版本。
- 生成渠道标题、摘要、CTA、标签、封面图、正文图、卡片图、微信 HTML。
- 根据不同账号侧重点调整风格和内容密度。
- 生成可交给 `lion1ou-article-publish` 的渠道包。

不适用场景：

- 从零写文章或决定核心论点。先用 `lion1ou-article-editor`。
- 执行 deploy、公众号草稿创建或公开发布。后续用 `lion1ou-article-publish`。
- 在没有母版文章时直接生成渠道版本，除非用户明确要求把当前输入视作母版。

## 核心规则

母版文章是事实和观点的来源。渠道版可以：

- 改标题、开头、段落长度、顺序、表达方式。
- 删除不适合渠道的细节。
- 增加过渡句、CTA、读者提示、图片说明。
- 把长文拆成图文卡片或微信 HTML。

渠道版不可以：

- 添加母版没有支持的新事实结论。
- 为了传播性夸大效果、收益、健康功效、产品能力。
- 擅自替用户做公开发布动作。

## 渠道默认定位

| 渠道 | 目标 | 默认改写方向 | 主要产物 |
| --- | --- | --- | --- |
| `blog` | 长期归档、搜索、个人知识库 | 保留深度，优化 Hexo 元数据和阅读结构 | Markdown 文章 |
| `wechat` | 阅读完成率、分享、关注 | 强化开头、节奏、标题和摘要，减少密集代码 | Markdown、HTML、封面 |
| `xhs` | 收藏、转发、种草、轻量传播 | 卡片化、清单化、视觉化、标签化 | 文案、卡片脚本、图片 |

## 目录结构规范

`lion1ou-article-channel` 必须在 `lion1ou-article-editor` 创建的文章工作区内工作，不新建平行目录。

文章工作区默认形态：

```text
articles/<YYYYMMDD>-<topic-slug>/
```

渠道产物固定放在：

```text
articles/<YYYYMMDD>-<topic-slug>/
├── channels/
│   ├── blog/
│   │   ├── article.md
│   │   └── channel-meta.json
│   ├── wechat/
│   │   ├── article.md
│   │   ├── article.html
│   │   ├── assets/
│   │   └── channel-meta.json
│   └── xhs/
│       ├── copy.md
│       ├── cards/
│       └── channel-meta.json
└── assets/
    ├── cover/
    ├── inline/
    └── refs/
```

路径约束：

- `articles/` 是文章生产工作区；`source/` 是 Hexo 工作目录，两者必须区分。
- 不把渠道成品写到仓库根目录、`docs/`、`source/` 或临时目录。
- 博客渠道只生成 `channels/blog/article.md`，不直接发布到 `source/_posts/`。
- 公众号 HTML、封面和正文图放在 `channels/wechat/` 或通用 `assets/`。
- 小红书文案和卡片放在 `channels/xhs/`。
- 通用素材放 `assets/`；渠道专属素材放对应 `channels/<channel>/assets/` 或 `cards/`。
- 覆盖任何渠道文件前，先备份为 `<name>.backup-YYYYMMDD-HHMMSS.<ext>`。

## 流程

开始后复制并维护这个进度：

```markdown
Article Channel 进度：
- [ ] 第 1 步：读取母版和元数据
- [ ] 第 2 步：确认渠道和账号定位
- [ ] 第 3 步：生成渠道改写方案
- [ ] 第 4 步：生成渠道正文
- [ ] 第 5 步：生成视觉和格式资产
- [ ] 第 6 步：组装渠道包
- [ ] 第 7 步：发布前交接检查
```

### 第 1 步：读取母版和元数据

优先读取：

- `master.md`：必须。
- `research.md`：用于保留来源、引用和不确定性。
- `assets-brief.md`：用于封面、正文配图和卡片规划。
- `editorial-review.md`：避免重新引入已知问题。

提取或补全：

- `title`, `slug`, `date`, `categories`, `tags`.
- `topic`, `articleType`, `audience`, `sourceLevel`.
- `channels`。
- 已有图片和本地路径。
- 文章核心结论，后续所有渠道版必须保持一致。

如果目标渠道缺失，让用户选择 `blog`、`wechat`、`xhs` 或多个渠道。没有明确选择时，默认先生成 `blog` 渠道包。

### 第 2 步：确认渠道和账号定位

每个渠道都要明确：

- 渠道目标：归档、搜索、涨粉、转化、分享、记录。
- 账号定位：技术、AI、茶叶、生活方式、NAS、个人品牌或自定义。
- 语气：专业、个人、实用、观点鲜明、温暖、简洁。
- 篇幅：长文、短文、图文卡片、清单。
- 资产需求：封面、正文图、截图、卡片图、HTML。

用户未提供账号定位时，使用保守默认值：

- 博客：完整、可搜索、适合长期沉淀。
- 公众号：可读、可分享、有清晰开头和结尾。
- 小红书：视觉化、清单化、可收藏。

### 第 3 步：生成渠道改写方案

先写 `adaptation-plan.md`，再写渠道正文。模板：

```markdown
# 渠道改写方案

## 输入
- 母版文章：
- 目标渠道：
- 账号定位：

## 核心结论
- [必须保持不变的事实和观点]

## 渠道策略
- 标题策略：
- 开头策略：
- 结构调整：
- 视觉策略：
- CTA：

## 删除或弱化
- [不适合该渠道的内容]

## 新增但不改变事实的内容
- [过渡、解释、提示、CTA、图片说明]
```

### 第 4 步：生成渠道正文

#### 博客

输出 `channels/blog/article.md`。

规则：

- 保留母版深度，不为了短平快删掉关键论证。
- 规范 Hexo frontmatter。
- `<!--more-->` 放在开头钩子或第一小节之后。
- 保留代码块、引用、链接和本地图片路径。
- 长段落要拆分，标题要利于博客目录阅读。
- CJK 空格、frontmatter、Markdown 排版需要优化时调用 `baoyu-format-markdown`。

博客 frontmatter 优先使用：

```yaml
---
title: ""
toc: true
comments: true
categories: ""
tags:
  - ""
date: ""
photos:
description: ""
topic: ""
articleType: ""
audience: ""
sourceLevel: ""
channels:
  - blog
status: adapted
---
```

博客正文检查：

- 是否适合后续由 `lion1ou-article-publish` 写入 `source/_posts/`。
- 图片路径是否从目标文章位置可解析。
- 标题、摘要和 `<!--more-->` 是否匹配。
- 代码块语言是否标注。

#### 公众号

输出 `channels/wechat/article.md`，需要 HTML 时再生成 `channels/wechat/article.html`。

规则：

- 标题更强调读者收益、冲突、经验或判断，但不能标题党。
- 开头 150 到 300 字内说明场景、痛点和读者收益。
- 段落更短，一段尽量只表达一个意思。
- 技术文章先解释意义，再给代码；代码太长时保留关键片段。
- 外链根据需要转为底部引用。
- 结尾要有自然 CTA，如提问、评论引导、相关阅读。
- 需要封面图时优先基于 `assets-brief.md`。

需要时调用：

- `baoyu-cover-image`：生成封面图。
- `baoyu-article-illustrator`：生成正文配图。
- `baoyu-markdown-to-html`：生成微信兼容 HTML。

注意：不要在调用需要 Markdown 的发布 skill 前强行预转换 HTML。渠道包可以同时保存 Markdown 和 HTML 供审阅，最终由 `lion1ou-article-publish` 根据发布方式选择输入。

公众号元数据建议：

```yaml
---
channel: wechat
title: ""
titleCandidates:
  - ""
summary: ""
author: ""
cover: ""
theme: default
citeExternalLinks: true
status: adapted
---
```

#### 小红书

输出 `channels/xhs/copy.md` 和 `channels/xhs/cards/`。

规则：

- 从母版提炼“可收藏”的单一主题，不贪多。
- 一张卡只表达一个核心点。
- 优先使用清单、对比、步骤、误区、避坑、选购建议。
- 标题短，标签具体，结尾引导收藏或评论。
- 技术内容要转为概念解释、流程图、工具清单或避坑指南。
- 生活和茶叶内容保留感受，但避免绝对化功效承诺。

需要图片卡片时调用 `baoyu-xhs-images`。

小红书包模板：

```markdown
# 小红书发布包

## 标题候选
- ...

## 正文文案
...

## 标签
#...

## 卡片脚本
1. 封面：
2. 内容卡：
3. 结尾卡：

## 图片资产
- ...
```

### 第 5 步：生成视觉和格式资产

优先使用 `assets-brief.md`。如果缺失，先从母版文章补一个简版，不要直接盲目出图。

推荐路由：

- 封面图：`baoyu-cover-image`。
- 正文概念图：`baoyu-article-illustrator`。
- 微信 HTML：`baoyu-markdown-to-html`。
- 小红书图片卡片：`baoyu-xhs-images`。
- Markdown 排版：`baoyu-format-markdown`。

遵守下游 skill 的确认规则。用户没有明确说“直接生成”“跳过确认”时，不跳过图片生成确认。

资产命名建议：

```text
assets/
├── cover.png
├── inline-01.png
└── xhs-card-01.png
```

### 第 6 步：组装渠道包

每个渠道单独目录，必须位于文章工作区的 `channels/` 下：

```text
channels/
├── blog/
│   ├── article.md
│   └── channel-meta.json
├── wechat/
│   ├── article.md
│   ├── article.html
│   └── channel-meta.json
└── xhs/
    ├── copy.md
    ├── channel-meta.json
    └── cards/
```

`channel-meta.json` 模板：

```json
{
  "channel": "blog",
  "account": "",
  "title": "",
  "summary": "",
  "source": "../../master.md",
  "cover": "",
  "assets": [],
  "status": "adapted",
  "publishChecks": []
}
```

如果项目或用户偏好 Markdown-only，允许把同样字段放在 frontmatter 中。

### 第 7 步：发布前交接检查

移交给 `lion1ou-article-publish` 前检查：

- 渠道版仍符合母版文章的核心事实和结论。
- 标题和摘要没有夸大。
- 必需资产已存在，或明确列出缺失项。
- 本地图片路径有效。
- 公众号需要 HTML 时已生成 HTML。
- 小红书至少有卡片脚本；如果要求最终成品，则有卡片图片。
- 没有执行任何外部发布动作。

## 完成报告

结束时报告：

- 生成的渠道包路径。
- 相比母版文章做了哪些变化。
- 调用了哪些下游 skill。
- 缺失资产或人工检查项。
- 推荐下一步使用 `lion1ou-article-publish`。

## 稳定产出检查

完成前逐项确认：

- 已读取 `master.md` 或用户明确指定的母版输入。
- 已写 `adaptation-plan.md` 或在报告中说明渠道策略。
- 每个目标渠道都有独立目录和最终正文。
- 所有渠道产物位于文章工作区的 `channels/` 下。
- 公众号成品有 Markdown；需要 HTML 时也有 HTML。
- 小红书成品有标题、正文、标签、卡片脚本；需要图片时有图片资产。
- 所有渠道包都没有“待定”、`TODO`、未替换占位符。
- 没有执行发布动作。
