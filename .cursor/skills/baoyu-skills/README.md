# baoyu skills 总览

这组 skills 面向内容生产、图片生成、文章处理、社交平台发布和信息提取。使用时先根据任务类型选择对应 skill；如果涉及图片生成、浏览器登录、平台发布或反向 API，通常还需要先完成对应的 `EXTEND.md`、账号登录或 API key 配置。

## 按任务选择

| 任务 | 优先使用 |
| --- | --- |
| 生成单张 AI 图片或批量出图 | `baoyu-image-gen` |
| 给文章生成封面、插图、信息图、漫画、幻灯片或小红书图片卡 | `baoyu-cover-image`、`baoyu-article-illustrator`、`baoyu-infographic`、`baoyu-comic`、`baoyu-slide-deck`、`baoyu-xhs-images` |
| 处理 Markdown、HTML、翻译和压缩图片 | `baoyu-format-markdown`、`baoyu-markdown-to-html`、`baoyu-translate`、`baoyu-compress-image` |
| 从网页、X 或 YouTube 提取内容 | `baoyu-url-to-markdown`、`baoyu-danger-x-to-markdown`、`baoyu-youtube-transcript` |
| 发布到公众号、X 或微博 | `baoyu-post-to-wechat`、`baoyu-post-to-x`、`baoyu-post-to-weibo` |
| 总结微信群聊 | `baoyu-wechat-summary` |
| 画结构图或分析 Electron 应用 | `baoyu-diagram`、`baoyu-electron-extract` |

## Skill 清单

| Skill | 作用 | 适用场景 |
| --- | --- | --- |
| `baoyu-image-gen` | 通过 OpenAI、Azure OpenAI、Google、OpenRouter、DashScope、Z.AI、MiniMax、Jimeng、Seedream、Replicate 或 Codex CLI 生成图片。支持文本出图、参考图、比例、尺寸和批量任务。 | 用户要「生成图片」「画一张图」「批量出图」，或其他 baoyu 图片类 skill 需要实际图片生成后端时使用。 |
| `baoyu-cover-image` | 为文章生成封面图，按类型、配色、渲染方式、文字密度和情绪强度组合风格。 | 用户要生成文章封面、公众号封面、博客头图、社交分享图，或明确说「cover image」「文章封面」「生成封面」时使用。 |
| `baoyu-article-illustrator` | 分析文章结构，找出需要视觉辅助的位置，并生成多张文章配图。 | 用户要「给文章配图」「为文章加插图」「生成文章中的多张图」，或希望将长文按段落插入插图时使用。 |
| `baoyu-infographic` | 把内容整理成专业信息图，支持多种布局和视觉风格组合。 | 用户要「信息图」「可视化总结」「高密度信息大图」「visual summary」，或希望把数据、框架、流程做成一张大图时使用。 |
| `baoyu-comic` | 生成知识漫画、教育漫画和人物/概念故事漫画，支持分镜、角色设定、页面批量出图和 PDF 合并。 | 用户要「知识漫画」「教育漫画」「四格漫画」「教程漫画」「人物传记漫画」，或希望用漫画讲清一个概念时使用。 |
| `baoyu-xhs-images` | 生成适合小红书、微信图文等社交媒体传播的图片卡片系列。 | 用户要「小红书图片」「图片卡片」「种草图」「微信贴图」，或需要 1 到 10 张连续卡片承载内容时使用。 |
| `baoyu-slide-deck` | 将内容转成面向阅读和分享的幻灯片图片，并可合并为 PPTX 或 PDF。 | 用户要「生成 PPT」「做 slide deck」「把文章做成幻灯片」，或需要每页都是独立视觉图的演示材料时使用。 |
| `baoyu-diagram` | 创建深色主题 SVG 图表，并可导出 @2x PNG。支持架构图、流程图、时序图、结构图、思维导图、时间线等。 | 用户要「画架构图」「画流程图」「sequence diagram」「系统关系图」「把逻辑可视化」时使用。 |
| `baoyu-compress-image` | 压缩图片并转换为 WebP、PNG 或 JPEG，自动选择 `sips`、`cwebp`、ImageMagick 或 Sharp。 | 用户要压缩图片、转 WebP、减小文件体积，或发布前优化图片资源时使用。 |
| `baoyu-format-markdown` | 优化普通文本或 Markdown 的文章结构，补充 frontmatter、标题、摘要、标题层级、加粗、列表和代码块，并做中文排版修正。 | 用户要「格式化 Markdown」「美化文章」「整理排版」「添加标题摘要」，且要求不改写原文内容时使用。 |
| `baoyu-markdown-to-html` | 将 Markdown 转成带内联样式的 HTML，适配微信公众号样式，支持代码高亮、数学公式、Mermaid、PlantUML、脚注和底部引用。 | 用户要「Markdown 转 HTML」「公众号 HTML」「微信外链转底部引用」，或发布前需要一份可粘贴的 HTML 时使用。 |
| `baoyu-translate` | 翻译文章和文档，支持 quick、normal、refined 三种模式，并可通过术语表保持翻译一致。 | 用户要「翻译」「精翻」「本地化」「改成中文/英文」，或给 URL、文件配合翻译意图时使用。 |
| `baoyu-url-to-markdown` | 使用 `baoyu-fetch` 抓取网页并转成 Markdown，内置 X、YouTube、Hacker News 和通用网页适配器，支持登录和验证码等待。 | 用户要「保存网页为 Markdown」「抓取网页正文」「把链接转成文章」，或需要下载页面媒体资源时使用。 |
| `baoyu-youtube-transcript` | 下载 YouTube 字幕、转录文本和封面图，支持多语言、翻译、章节和说话人识别。 | 用户给 YouTube 链接并要字幕、转录、视频封面、章节稿或带时间戳的 Markdown 时使用。 |
| `baoyu-danger-x-to-markdown` | 使用反向工程 X API 将 X/Twitter 推文、线程和文章转换为 Markdown，并可下载媒体。 | 用户要「保存推文」「X to Markdown」「tweet to markdown」，或提供 `x.com` / `twitter.com` 链接要归档时使用。由于使用非官方 API，首次使用需要用户同意风险声明。 |
| `baoyu-danger-gemini-web` | 通过反向工程 Gemini Web API 生成文本或图片，支持参考图、视觉输入和多轮会话。 | 用户明确要用 Gemini Web 生成文本/图片，或没有官方图片 API key 但有 Gemini Web 登录态时使用。由于使用非官方接口，首次使用需要用户同意风险声明。 |
| `baoyu-post-to-wechat` | 将 HTML、Markdown 或纯文本发布到微信公众号，支持 API、远程 API 和 Chrome 浏览器方式；也支持多图贴图。 | 用户要「发布公众号」「微信公众号文章」「贴图/图文」，或希望把 Markdown 转成公众号草稿时使用。 |
| `baoyu-post-to-x` | 发布普通 X 帖子、带图/视频帖子、引用帖和 X Articles 长文。 | 用户要「发 X」「tweet」「发布 Twitter」「分享文章到 X」，或要将 Markdown 长文发布为 X Article 时使用。 |
| `baoyu-post-to-weibo` | 发布微博普通内容和微博头条文章，支持文本、图片、视频和 Markdown 长文。 | 用户要「发微博」「发布微博」「微博头条文章」，或希望把 Markdown 文章填入微博头条编辑器时使用。 |
| `baoyu-wechat-summary` | 基于本地 `wx-cli` 读取微信群聊记录，生成结构化群聊摘要、毒舌版摘要，并维护群聊历史和群友画像。 | 用户要「总结群聊」「群聊精华」「看看某群最近聊了什么」「回溯画像」时使用。 |
| `baoyu-electron-extract` | 提取安装好的 Electron 应用资源和 JavaScript，从 `.asar` 和 source map 中还原源码或格式化压缩代码。 | 用户要「提取 Electron 应用」「反编译 app.asar」「看某个桌面应用源码」「分析 Electron 应用如何构建」时使用。 |

## 常见配置提示

- 多数脚本型 skill 依赖 `bun` 或 `npx -y bun`，首次运行还需要安装对应 `scripts/` 目录下的依赖。
- 图片生成类 skill 通常需要 `baoyu-image-gen` 或运行时原生图片生成能力，并需要至少一个可用的图片后端 API key 或 Codex CLI 登录态。
- 涉及网页登录、平台发布或网页抓取的 skill 通常需要 Chrome/Chromium、登录态、剪贴板权限或辅助功能权限。
- `baoyu-post-to-wechat` 的 API 发布需要 `WECHAT_APP_ID` 和 `WECHAT_APP_SECRET`；浏览器发布需要公众号后台登录态。
- `baoyu-wechat-summary` 依赖外部 `wx-cli`，且需要本机微信已登录并完成 `wx init`。
- `baoyu-danger-x-to-markdown` 和 `baoyu-danger-gemini-web` 使用反向工程接口，首次使用前必须让用户明确接受风险声明。
