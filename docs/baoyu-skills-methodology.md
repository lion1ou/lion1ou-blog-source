# baoyu-skills 方法论分析

## 结论摘要

事实：`baoyu-skills` 不是一组零散工具，而是一套面向 Agent 的生产流水线设计样本。它把复杂任务拆成 4 层：

- `SKILL.md`：负责触发、路由、状态机、人机确认和禁令。
- `references/`：承载风格库、平台规则、质量门禁、故障手册等深水区知识。
- `scripts/`：执行确定性动作，例如抓取、格式化、压缩、发布、解包、转换。
- `EXTEND.md` / `.env` / 中间产物：沉淀用户偏好、凭证、过程状态和可复现的 Prompt。

我的判断：最值得学习的不是某一个具体命令，而是它对「复杂场景可控性」的处理方式：先把任务编译成结构化中间产物，再通过有限状态机、显式门禁、后端路由和失败恢复机制执行。Agent 不再凭感觉一次性完成任务，而是像编译器一样分阶段处理输入。

## 逐一分析

### `baoyu-image-gen`

这是整个视觉生成体系的执行引擎。它支持 OpenAI、Azure OpenAI、Google、OpenRouter、DashScope、Z.AI、MiniMax、Jimeng、Seedream、Replicate 等多个 Provider，统一暴露文生图、参考图、批量生成、比例、质量、模型选择等能力。

可借鉴点：

- 把「创意设计」和「图像生成执行」分开。上层 skill 只产出 `prompts/*.md`，真正调用模型由它负责。
- Provider 差异不塞进主流程，而是沉到 `references/providers/`。
- 默认顺序执行，只有多 Prompt 文件时才进入批量模式，避免 Agent 盲目并发。
- 对身份保持、参考图、多 Provider 能力差异有明确规则，不假装所有模型能力一样。

复杂度控制：

- 使用 `EXTEND.md` 做 Provider 和模型默认值。
- 使用批量 JSON 作为执行计划。
- 失败时只重试失败项，不推翻已成功结果。
- 对高风险后端和 OAuth 后端做显式隔离。

### `baoyu-danger-gemini-web`

这是逆向 Gemini Web 的文本和图像生成后端。它支持文本生成、图像生成、参考图、多轮会话和 session 持久化。

可借鉴点：

- 高风险能力必须先走持久化 consent，且 consent 有版本号。
- 把逆向 API 的复杂实现封装到脚本中，`SKILL.md` 只保留用户可理解的 CLI 契约。
- 作为备用生成后端存在，不污染官方 API 路径。

复杂度控制：

- 先做同意门禁，再执行任何网络请求。
- 模型列表固定，避免开放式参数导致不可控。
- 会话状态落盘，支持多轮但不依赖隐式上下文。

### `baoyu-cover-image`

用于生成文章封面。它用 5 个维度控制设计：类型、色板、渲染风格、文字、情绪，并支持参考图和快速模式。

可借鉴点：

- 用正交维度拆解审美选择，降低「帮我做个封面」这种模糊需求的不可控性。
- 所有推荐都要经过确认，除非用户显式使用 `--quick` 或直接要求快速生成。
- Prompt 必须先落盘，再调用图像生成后端。
- 对封面这种传播物料明确约束留白、文字、写实人物等设计边界。

复杂度控制：

- `references/` 拆分色板、渲染、类型和自动选型规则。
- 输出目录固定为 `cover-image/{slug}/`，含源内容、参考图、Prompt 和最终图。
- 禁止用 SVG 或 ImageMagick 事后修字来冒充生成结果，错误只能回到 Prompt 重做。

### `baoyu-article-illustrator`

用于给文章插图。它把文章拆成多个视觉辅助点，用 Type × Style × Palette 三维方法生成插图。

可借鉴点：

- 先分析文章结构和插图位置，再写 `outline.md`，最后为每张图生成 Prompt。
- 多图任务不直接并发生成，而是先有全局编排清单。
- 明确「画概念，不画字面」，避免插图变成内容复读。
- LABELS 必须来自文章真实数据，降低幻觉。

复杂度控制：

- 密度参数控制插图数量，例如 minimal、balanced、per-section、rich。
- 批量策略清晰：原生 batch 优先，其次有限并行，最后顺序。
- subagent 只用于创意探索，不用于并行渲染。

### `baoyu-comic`

用于生成知识漫画，支持多种画风、语气、布局和角色设定，并可输出 PDF。

可借鉴点：

- 这是跨页一致性设计最完整的 skill：先做角色表，再用角色表作为后续页面参考。
- 分镜、角色、每页 Prompt、页面图、PDF 合并全部文件化。
- 支持局部工作流，例如只生成 storyboard 或重新生成某一页。

复杂度控制：

- 用 Art × Tone × Layout 拆解选择空间，再用 preset 封装常用组合。
- 角色表是依赖图的根节点，页面生成依赖它。
- 参考图失败时降级到 Prompt 内嵌角色描述，而不是流程中断。

### `baoyu-infographic`

用于生成高密度信息图，核心是 Layout × Style 组合。它有大量 layout 和 style，但主流程保持简洁。

可借鉴点：

- 先生成 `structured-content.md`，把原始事实、数字、术语和学习目标整理成中间表示，再进入视觉 Prompt。
- 信息图的重点不是「好看」，而是数据忠实和认知负荷控制。
- Layout 和 Style 正交组合，通过推荐减少用户选择负担。

复杂度控制：

- 大量模板不塞入主 skill，而是按需读取 reference。
- 关键词可以映射到推荐组合，但推荐不等于授权。
- `--no-confirm` 才跳过确认。

### `baoyu-diagram`

用于生成架构图、流程图、时序图、结构图、思维导图等 SVG 图。它是视觉类 skill 中的例外：不走 AI 栅格图，而是 Agent 直接写 SVG。

可借鉴点：

- 技术结构图和审美插图走不同媒介路径。结构图需要精确、可 diff、可编辑，所以用 SVG。
- 用统一设计系统控制颜色、字体、层级、箭头、间距和遮罩。
- 对图类型做 reference 分册，主流程只负责识别类型、规划布局、写 SVG、导出 PNG。

复杂度控制：

- 不依赖 `EXTEND.md`，不走生成后端，减少变量。
- 明确校验重叠、层级和 CJK 字体。
- 输出必须是 standalone `.svg`。

### `baoyu-slide-deck`

用于从内容生成阅读型幻灯片图片，并可合并为 PPTX 或 PDF。

可借鉴点：

- 用 style preset 或 texture × mood × typography × density 四维组合控制视觉风格。
- 先给 deck 大纲，再按页生成 Prompt。
- 把 `STYLE_INSTRUCTIONS` 写入 outline，避免每页重复读风格文件。

复杂度控制：

- 通过 audience、slides、style 等参数控制范围。
- 支持 outline-only 等局部流程，方便人工审阅后继续。
- 默认不是立即生成所有内容，而是先确认风格和结构。

### `baoyu-xhs-images`

用于生成小红书、微信图文等社交图片卡片系列，支持 1 到 10 张图。

可借鉴点：

- 解决多图一致性的核心方法是 image-1 anchor chain：第 1 张先生成，后续图片以第 1 张为参考锚点。
- Smart Confirm 提供三条路径：快速确认、自定义、详细三纲。
- Style × Layout 有兼容矩阵，直接把不适合的组合排除。
- 社交内容拆成封面、内容、结尾三段式。

复杂度控制：

- `--yes` 才进入全自动。
- 用户参考图和内部锚点分层处理，不混在一起。
- `outline.md` 作为整个系列的唯一编排清单。

### `baoyu-format-markdown`

用于格式化纯文本或 Markdown。它强调不改语义，只改结构、排版和明显错别字。

可借鉴点：

- 先输出 `{filename}-analysis.md`，再根据分析生成 `{filename}-formatted.md`。
- 已有 Markdown 时先问模式：全面优化、保留结构、仅 typography。
- 标题生成用公式库，并允许用户选择。
- CJK 间距、引号、强调等确定性格式交给脚本。

复杂度控制：

- Agent 负责读者视角分析和结构选择，脚本负责机械排版。
- 明确禁止增删语义、过度加粗、编辑性标题。
- 输出文件和分析文件分离，方便 review。

### `baoyu-markdown-to-html`

用于把 Markdown 转成适合公众号等平台的 HTML，支持主题、代码高亮、数学公式、Mermaid、PlantUML、脚注和外链底部引用。

可借鉴点：

- 转换结果输出结构化 JSON，方便发布流水线消费。
- 主题配置可以从本 skill 或 `baoyu-post-to-wechat` 的配置回退。
- 默认不启用外链底部引用，只有用户明确要求才开启。

复杂度控制：

- HTML 转换交给脚本，Agent 只负责参数解析和报告。
- Mermaid 渲染失败可降级，不让整个转换失败。
- 输出冲突自动备份。

### `baoyu-translate`

用于翻译文章和文档，支持 quick、normal、refined 三种模式。

可借鉴点：

- 复杂度梯度非常清晰：快翻、标准翻译、精翻。
- 长文翻译前先提取术语和共享 Prompt，再分块并行翻译。
- subagent 只负责初稿，审校、修改、润色由主 Agent 串行处理，避免风格漂移。
- 每一步都有文件：分析、Prompt、初稿、批评、修订、终稿。

复杂度控制：

- 首次 `EXTEND.md` 是阻塞式设置，避免翻译偏好不明。
- 冲突目录备份，不覆盖历史翻译。
- normal 完成后可以继续升级 refined，不需要从头开始。
- 图片本地化只提醒，不自动乱改图。

### `baoyu-url-to-markdown`

用于把任意 URL 保存为 Markdown，底层通过 `baoyu-fetch`、Chrome CDP 和站点 adapter 抓取。

可借鉴点：

- 不信任 CLI exit code。抓取成功后还要读 Markdown 质量，检查是否是壳页、登录页、正文过短或标题异常。
- 每个 URL 独立目录，媒体资源和正文放在一起。
- 媒体下载使用 ask-then-rerun：先保存正文，再根据远程资源决定是否二次下载。

复杂度控制：

- 抓取、交互、强制模式分层。
- Adapter 自动选择，但可覆盖。
- 质量门禁外置为 reference，便于维护。

### `baoyu-youtube-transcript`

用于下载 YouTube 字幕、封面和元数据，支持语言选择、章节、说话人识别、缓存和回退。

可借鉴点：

- 原始字幕、句子级字幕、元数据、封面和 Markdown 成稿分别缓存。
- `.index.json` 建立视频到本地目录的索引，重复处理不需要重新联网。
- 说话人识别是昂贵 AI 后处理，和字幕抓取分离。

复杂度控制：

- InnerTube 失败自动回退 `yt-dlp`。
- 语言变化和 `--refresh` 明确控制缓存刷新。
- URL 必须单引号的说明解决 zsh glob 这类真实使用问题。

### `baoyu-danger-x-to-markdown`

用于把 X/Twitter 推文、线程、X Articles 转为 Markdown。它使用逆向 API，因此有 danger 标记。

可借鉴点：

- consent 版本化，版本不匹配时必须重新确认。
- 专用 X API 和通用 URL 抓取分工清晰：一个适合批量和结构化，一个适合登录态浏览器。
- 媒体下载复用 ask-then-rerun 模型。

复杂度控制：

- 风险门禁先于所有执行。
- 认证支持环境变量或 Chrome 登录缓存。
- 输出目录按 username 和 tweet id 隔离。

### `baoyu-wechat-summary`

用于总结微信群聊，生成结构化群聊精华，并维护历史、摘要归档和用户画像。

可借鉴点：

- 三轮写作模型：骨架、扩写、审计。
- normal 和 roast 两种版本严格隔离，画像目录也隔离。
- `history.json` 用于快速增量，`history-digests.jsonl` 用于归档。
- 大 JSON 不进上下文，先写 `$TMPDIR`，再按需切片读取。

复杂度控制：

- 处理超过 200 条或超过 7 天时拆成多段 digest，再做 meta-summary。
- 图片内容不透明时不编造，只读取已经存在的 `imgs/*.txt`。
- 完成 checklist 防止漏写 history、profiles 和 digest。
- 明确禁止 Agent 自动 sudo 或安装外部依赖。

### `baoyu-post-to-wechat`

用于发布微信公众号文章或贴图，支持 API、浏览器和 remote-api。

可借鉴点：

- 发布类 skill 默认进草稿箱，不直接公开群发。
- API、Browser、Remote API 三条路径分工清晰。
- Remote API 设计很高级：本地保留密钥和渲染，远程只作为白名单网络出口。
- Markdown 默认把外链转底部引用，主动适配微信生态限制。

复杂度控制：

- 首次无 `EXTEND.md` 时阻塞式 setup。
- 多账号只有在 2 个以上时才提问，单账号自动选择。
- 值优先级为 CLI、frontmatter、账号级配置、全局配置、默认值。
- 禁止 Agent 预转 HTML，因为 API 和 Browser 的图片处理路径不同。

### `baoyu-post-to-weibo`

用于发布微博普通帖或微博头条文章。它通过真实 Chrome 和 CDP 操作页面，默认只填好内容，最终发布由用户手动确认。

可借鉴点：

- 「只填不发」是发布自动化的重要安全默认值。
- 头条文章用占位符协议处理图片：先粘 HTML，再替换 `WBIMGPH_`。
- 自动做 Post-Composition Check，检查占位符残留和图片数量。

复杂度控制：

- 标题、导语等平台限制在脚本内校验。
- CDP 端口失败只 kill baoyu 专用 Chrome profile，不杀用户普通 Chrome。
- 真实剪贴板和真实按键比合成事件更适合对抗复杂编辑器。

### `baoyu-post-to-x`

用于发布 X 普通帖、视频帖、引用转推和 X Articles。

可借鉴点：

- 同一 skill 适配 Codex Chrome Plugin、Chrome Computer Use、CDP Script 三种 runtime。
- 模式选择依赖用户措辞和环境检查，但不允许静默切换。
- X Articles 用 `XIMGPH_N` 占位符和 JSON 映射解耦 HTML 粘贴与图片上传。

复杂度控制：

- 禁止使用 in-app Browser，统一真实 Chrome。
- Publish 必须显式确认，CDP 自动提交也必须用户指定 `--submit`。
- 插件或 Computer Use 不可靠时要报告 blocker，再由用户同意 fallback。

### `baoyu-compress-image`

用于压缩和转换图片，默认 WebP，也支持 PNG、JPEG。

可借鉴点：

- 这是薄工具 skill 的好样本：Agent 几乎不参与决策，脚本自动检测可用压缩后端。
- 支持 `--json`，便于被其他发布流水线调用。
- 写 `.tmp` 再原子 rename，失败不破坏原图。

复杂度控制：

- WebP 优先 `cwebp`，再 ImageMagick，再 Sharp。
- macOS 其他格式优先 `sips`。
- 默认替换原文件但保存 `_original`，也可以 `-k` 保留。

### `baoyu-electron-extract`

用于提取已安装 Electron 应用的 `app.asar`，有 source map 时还原源码，否则格式化压缩 JS。

可借鉴点：

- 输出分成 `extracted/`、`extracted.unpacked/`、`restored/` 和 `extract-report.json`，语义清楚。
- 默认建议 `--dry-run`，先验证解析路径再写盘。
- 多匹配 fail-fast，避免解错应用。
- `extract-report.json` 记录警告、路径和计数，便于后续审阅。

复杂度控制：

- 非空输出目录必须 `--force`。
- 对危险输出目录做断言，避免写到根目录、home 根或当前工作目录。
- 跳过 `node_modules` 和运行时代码，降低噪音。

## 横向方法论

### 1. Skill 是状态机，不是说明书

`baoyu-skills` 的 `SKILL.md` 通常不只是告诉 Agent「能做什么」，而是定义状态机：

```text
触发识别 → 前置检查 → 配置加载 → 模式路由 → 中间产物 → 执行后端 → 质量检查 → 完成报告
```

这种写法比普通说明文档更适合 Agent，因为 Agent 需要的是可执行路径，不是背景知识。

### 2. 复杂选择用正交维度拆解

视觉类 skill 最常见的方法是把一个模糊需求拆成多个有限维度：

- 封面：类型、色板、渲染、文字、情绪。
- 插图：类型、风格、色板。
- 漫画：画风、语气、布局、角色。
- 信息图：布局、风格。
- 小红书图：风格、布局、色板。
- 幻灯片：材质、情绪、字体、密度。

这样做的价值是把无限开放的审美问题变成有限组合，再用 preset 和推荐规则降低用户选择成本。

### 3. Prompt-as-Artifact

视觉生成类 skill 基本都遵守一个原则：先写 Prompt 文件，再执行生成。

这解决了 4 个问题：

- 可复现：同一个 Prompt 可以换后端重跑。
- 可审阅：用户和 Agent 都能看到生成依据。
- 可回滚：错误来自 Prompt 时先改 Prompt，而不是直接修图。
- 可批量：`prompts/` 目录天然可以编译成 batch。

我的判断：这是 `baoyu-skills` 最核心的工程化思想之一。它把 Prompt 从一次性聊天内容提升成了版本化产物。

### 4. Agent 做判断，脚本做确定性动作

这些 skill 很少让 Agent 直接完成底层重活。典型分工是：

- Agent：理解意图、选择模式、提出确认、判断质量、组织内容。
- 脚本：抓取网页、转换 HTML、压缩图片、发布草稿、解包 asar、渲染 Mermaid。

这样可以避免 Agent 在文件 IO、DOM 操作、格式化、认证流程上漂移。

### 5. 推荐不等于授权

很多 skill 会自动推荐模式、风格、主题或发布方式，但推荐之后仍要确认。只有用户显式提供 `--yes`、`--quick`、`--no-confirm` 或类似意图时才跳过。

这是一条重要边界：Agent 可以降低决策成本，但不能偷走决策权。

### 6. 高风险动作前置门禁

这些场景都会有门禁：

- 逆向 API：consent 文件和免责声明版本。
- 首次使用：阻塞式 `EXTEND.md` 设置。
- 发布：默认草稿或填完停，公开发布必须用户确认。
- 覆盖输出：backup、`--force`、safe path 断言。
- 浏览器自动化：真实 Chrome、专用 profile、pre-flight。

我的判断：这些门禁不是「啰嗦」，而是复杂 Agent 工具能长期使用的前提。

### 7. 质量检查不依赖退出码

`baoyu-url-to-markdown` 是最典型的例子：CLI 退出码为 0 不等于内容成功。Agent 还要读取结果，判断是否登录页、壳页、正文过短、标题异常。

同类设计还包括：

- 微博和 X 的占位符残留检查。
- Markdown 转 HTML 的 Mermaid 降级报告。
- Electron 解包的 `extract-report.json`。
- 微信群总结的完成 checklist。

### 8. 中间文件是复杂流程的记忆

长流程通常会落盘：

- 翻译：`01-analysis.md`、`02-prompt.md`、`03-draft.md`、`04-critique.md`、`05-revision.md`、`translation.md`。
- 格式化：`*-analysis.md`、`*-formatted.md`。
- 漫画：`analysis.md`、`storyboard.md`、`characters.png`、`prompts/`、页面图、PDF。
- 信息图：`analysis.md`、`structured-content.md`、`prompts/infographic.md`。
- 群聊总结：`history.json`、`history-digests.jsonl`、`profiles/`。

中间文件让任务可以中断、回看、重跑、分块、并行和审阅。

### 9. 并行不是默认加速，而是有边界的编排

这些 skill 对并行很克制：

- 图像生成默认顺序，多 Prompt 文件才批量。
- 插图和漫画先有全局 outline，再并行或批量生成。
- 翻译可以并行分块，但审改润必须主 Agent 串行。
- subagent 用于创意探索或分块初稿，不用于不可控的发布动作。

我的判断：它不是不使用并行，而是把并行限定在「无共享状态、可合并、可重试」的阶段。

### 10. 媒介路由比万能工具更可靠

它没有试图让一个工具解决所有视觉问题：

- 技术结构图走 SVG。
- 审美封面、插图、漫画、卡片走栅格图像生成。
- Markdown 转微信走 HTML。
- X、微博、公众号发布走真实浏览器或官方 API。

这说明它的设计不是「能不能做」，而是「哪种媒介最可控」。

## 复杂场景的可控性机制

### 状态机

每个复杂 skill 都有固定阶段，Agent 不在阶段外自由发挥。阶段命名通常非常具体，例如 setup、analysis、outline、prompt、generate、merge、quality check、report。

可迁移写法：

```text
Step 0：加载配置和前置条件
Step 1：识别输入和模式
Step 2：生成中间表示
Step 3：用户确认关键分叉
Step 4：调用确定性执行后端
Step 5：质量门禁
Step 6：完成报告和下一步
```

### 模式梯度

复杂任务不是只有一个模式，而是有复杂度梯度：

- 翻译：quick、normal、refined。
- 格式化：仅 typography、保留结构、全面优化。
- URL 抓取：headless、interaction、force。
- 群聊总结：单日、小范围、多日拆分、meta-summary。
- 小红书卡片：快速确认、自定义、三纲选择。

好处是用户可以用成本换质量，Agent 也知道何时升级流程。

### 显式依赖图

多产物任务会定义依赖关系：

- 漫画：角色表 → 页面图 → PDF。
- 小红书图：第 1 张 → 后续图。
- 翻译：共享 Prompt → 分块初稿 → 合并 → 审改润。
- X/微博文章：HTML 占位符 → 图片上传 → 占位符清理 → composition check。

显式依赖图让失败恢复更简单：哪个节点失败就重做哪个节点。

### 文件化 IR

很多中间产物本质上是 IR（Intermediate Representation，中间表示）：

- `structured-content.md` 是信息图的内容 IR。
- `outline.md` 是多图和幻灯片的编排 IR。
- `storyboard.md` 是漫画的叙事 IR。
- `02-prompt.md` 是翻译分块共享上下文 IR。
- `md-to-html.ts` 输出的 JSON 是发布图片占位符 IR。

我的判断：这是高级能力的关键。Agent 如果直接操作最终结果，很难稳定；先生成 IR，就有了检查点和接口契约。

### 后端路由

`baoyu-skills` 常见路由顺序是：

```text
用户显式参数 → 项目配置 → 用户配置 → 自动检测 → 无法判断则询问
```

这套顺序同时适用于图像 Provider、发布方式、账号选择、主题、输出路径、压缩后端等。

### 人工确认点

它不会每一步都问用户，只在高影响分叉处问：

- 首次配置缺失。
- 发布方式和账号选择。
- 审美 preset。
- 标题和摘要。
- 是否下载媒体。
- 是否覆盖输出目录。
- 是否公开发布。
- 是否接受逆向 API 风险。

好的确认点应该满足一个标准：用户的选择会显著改变成本、风险或结果。

### 失败恢复

典型恢复策略：

- 自动降级：YouTube API 失败回退 `yt-dlp`，压缩工具从 `cwebp` 回退到 ImageMagick 或 Sharp。
- 局部重试：批量图只重试失败项。
- 人工接管：浏览器发布填完后停下，让用户最终确认。
- 安全失败：Electron 多匹配直接失败并列候选。
- 诊断报告：`extract-report.json`、JSON 输出、完成报告、troubleshooting。

### 安全默认

发布类 skill 的安全默认尤其值得学习：

- 微信 API 只进草稿箱。
- 微博和 X 默认只填编辑器，不点发布。
- X 自动提交必须显式 `--submit`。
- Remote API 不把 AppSecret 放到远程。
- CDP 故障只 kill 专用 Chrome profile。

这类规则让自动化工具不会因为一次误判造成不可逆公开动作。

## 值得学习的高级能力

### 1. 把开放式需求变成有限规格

「生成封面」「做信息图」「发小红书图」都是开放式需求。`baoyu-skills` 的做法不是直接创作，而是先构建有限规格：

```text
场景 → 维度 → preset → 推荐 → 用户确认 → Prompt → 后端
```

这适合迁移到任何内容生产、设计生成、发布编排类 Agent。

### 2. 把 Prompt 工程变成文件工程

它没有把 Prompt 当聊天技巧，而是当文件、接口和可审阅资产。这个转变很重要。

可迁移规则：

- 每个最终产物都应该能追溯到一个 Prompt 文件或结构化输入。
- 重做结果时先改 Prompt，不直接修最终文件。
- 批量任务先生成 Prompt 列表，再执行。

### 3. 把 Agent 的主观判断约束在少数环节

Agent 适合做判断，但不适合无限自由判断。`baoyu-skills` 把判断放在这些位置：

- 用户意图解析。
- 质量 gate。
- 风格推荐。
- 摘要、翻译、文案润色。
- 失败后的下一步建议。

其他确定性动作交给脚本。

### 4. 用 reference 控制知识加载

主 `SKILL.md` 保持流程清晰，复杂细节按主题拆进 reference。这样既能避免上下文爆炸，也能让 Agent 按需读取。

适合拆 reference 的内容：

- 风格库。
- 平台限制。
- 故障排查。
- 质量检查清单。
- Provider 能力矩阵。
- 模板和 Prompt 公式。

### 5. 一致性不是靠描述，而是靠依赖

多图一致性如果只靠「保持一致」这种文字，很容易失败。`baoyu-skills` 用依赖解决：

- 角色表作为漫画页面参考。
- 第 1 张图作为小红书系列参考。
- sessionId 或参考图作为幻灯片和漫画的连续性手段。
- 共享 Prompt 作为翻译分块的一致性来源。

### 6. 用 checklist 定义完成

复杂任务不能只说「完成了」。它需要完成定义：

- 文件是否写出。
- 中间状态是否更新。
- 是否通过质量 gate。
- 是否生成报告。
- 是否保留备份。
- 用户下一步在哪里操作。

`baoyu-wechat-summary` 的完成 checklist 是这类设计的代表。

## 对当前 article 系列 skill 的迁移建议

### `article-editor`

可以学习：

- 增加 `analysis.md`、`outline.md`、`draft.md`、`revision.md` 等阶段化产物。
- 引入模式梯度，例如 quick draft、normal article、refined article。
- 对选题、受众、观点强度、素材可信度设置确认点。
- 把标题公式、结构模板、风格规范拆入 `references/`。

### `article-channel`

可以学习：

- 把「母版文章 → 渠道包」定义成文件化 IR，例如 `channel-plan.md`、`wechat.md`、`xhs-cards-outline.md`、`blog-final.md`。
- 对每个渠道建立平台约束 reference，例如字数、标题长度、图片规格、外链策略。
- 对多渠道一致性建立共享字段，例如核心观点、摘要、金句、标签、封面 Prompt。

### `article-publish`

可以学习：

- 默认只到预览或草稿，不直接发布。
- 发布前有 pre-flight：frontmatter、图片、外链、HTML、封面、摘要。
- 发布后有 completion report：草稿链接、预览链接、部署状态、需要人工确认的事项。
- 对不可逆动作要求显式确认。

## 可复用模板

下面是一份适合新 skill 的骨架：

```markdown
# Skill Name

## Trigger

明确触发词、适用场景、不适用场景。

## Inputs and Outputs

说明输入来源、输出目录、关键中间文件。

## Workflow

Step 0：前置检查和配置加载。
Step 1：识别输入类型和模式。
Step 2：生成分析文件或中间表示。
Step 3：关键分叉确认。
Step 4：调用脚本或后端执行。
Step 5：质量检查。
Step 6：完成报告。

## Gates

列出必须询问用户的场景。

## Backend Routing

说明 CLI 参数、项目配置、用户配置、自动检测、询问的优先级。

## Failure Recovery

列出可重试、可降级、必须停止、必须人工接管的情况。

## Do Not

把高风险禁令写清楚，例如不要自动发布、不要覆盖、不要静默切换后端。
```

## 最值得借鉴的 10 条规则

1. 先写中间产物，再执行最终动作。
2. 推荐可以自动，授权必须明确。
3. 脚本做确定性动作，Agent 做判断和编排。
4. 大量选项要正交拆维度，不要堆成一坨参数。
5. 高风险动作必须前置 consent、confirm 或 draft gate。
6. 质量检查不能只看 exit code。
7. 长流程每一步落盘，方便中断、复核和重跑。
8. 并行只用于可合并、可重试、无共享状态的阶段。
9. 发布类默认草稿或填完停，不默认公开。
10. `references/` 承载知识深度，`SKILL.md` 保持流程锋利。

## 一句话总结

`baoyu-skills` 的高级之处在于：它把 Agent 从「即兴执行者」训练成「可控流水线编排器」。它不依赖一次性聪明，而是通过状态机、文件化 IR、显式门禁、脚本后端、质量 gate 和失败恢复，让复杂任务可以重复、审阅、回滚和扩展。
