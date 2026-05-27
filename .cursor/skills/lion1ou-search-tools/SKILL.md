---
name: lion1ou-search-tools
description: >-
  统一搜索入口与路由器。先判断请求类型，再在需要时执行多源 Web 搜索，并把任务分发到网页读取、反爬抓取、资讯收集、深度研究或浏览器自动化等下游能力。
  对 ***.yuque.com（语雀）** 的链接必须先走 **yuque-read** 技能（Hellobike 语雀走 MCP，其他语雀走登录态），不要当普通 read-url 处理。
  当用户需要搜索、查资料、了解最新信息、读取链接、做网页研究、判断该用哪个搜索或抓取工具时使用，适用于关键词查询、URL 解析、热点榜单与研究型任务。
---

# Tools Search

## 角色

把本 skill 视为所有搜索与网页研究请求的第一入口。

先判断任务类型，再决定是：
- 直接运行 `scripts/search.sh`
- 按本 skill 的「URL 内容获取」流程读取已知 URL
- 直接运行内置热点/榜单脚本
- 直接调用内置 `xhs` 搜索源或远程 `xiaohongshu-mcp`
- 把研究任务交给 `deep-research-pro`
- 把交互式网页任务交给 `agent-browser`

不要绕过本 skill 直接进入 `web_search`、`firecrawl_search` 或其他系统搜索工具。
本目录下的搜索相关 skill 都以本 skill 为入口；下游 skill 只处理被路由后的专门任务。

## 输入

- `query: string` 关键词、问题或研究主题
- `url: string` 已知链接
- `limit: integer` 结果数量，默认 10，限制在 1-100

## 输出

- `route: string` 实际选择的执行路径
- `searchResults: array` 标准化搜索结果列表
- `nextSkill: string` 需要继续调用的下游 skill；无则留空
- `notes: string` 降级原因、限制说明或后续动作

## 何时使用

出现以下任一情况时，先使用本 skill：
- 用户说“搜一下”“查一下”“找资料”“看看最新消息”
- 用户给一个链接，希望读取、总结、提取正文或判断怎么抓
- 用户要做带来源的网页研究，而不是只要一句回答
- 用户问热搜、热榜、音乐榜、票房、收视率、App Store 排行、人民日报版面
- 你不确定该走搜索、抓取还是浏览器自动化

## When NOT to use

不要在这些场景直接使用本 skill：
- 纯本地文件、代码库或数据库查询
- 不需要搜索结果的常识性回答
- RSS 阅读或订阅流处理
- 已经明确要执行登录、点击、表单填写等浏览器交互，且不需要搜索入口判断

## 路由流程

1. 判断输入形态：
   - 只有关键词或问题 → 进入 `search`
   - 有明确 URL 且为 **`*.yuque.com`（语雀）** → 进入 `yuque-read`（Hellobike 语雀走 MCP，其他语雀走登录态 + `fetch.py`），**不要**把语雀当普通 `read-url` 直送 `web_fetch`。
   - 有明确 URL 且**非**语雀 → 进入 `read-url`
   - 明确问中国平台热榜、音乐榜、影视娱乐榜、App Store 排行或人民日报版面 → 进入 `hot-data`
   - 明确要搜索、读取或分析小红书笔记/用户/话题 → 进入 `xhs-mcp`
   - 需要多来源综述、对比、结论报告 → 进入 `deep-research`
   - 需要登录、点击、滚动、截图、表单 → 进入 `interactive-web`
2. 按模式执行路由：
   - `search`：运行 `scripts/search.sh`
   - `read-url`（**非**语雀）：按「URL 内容获取」选择 `web_fetch`、`opencli`、内置反爬抓取脚本或 `agent-browser`
   - 语雀链接：已在上一步直达 `yuque-read`；不并入通用 `read-url` 的 web_fetch 首跳
   - `hot-data`：按「热点与榜单查询」选择 `scripts/hot/` 下的 Node 脚本
   - `xhs-mcp`：按「小红书 MCP」运行 `scripts/sources/xhs.sh` 或直接调用远程 `xiaohongshu-mcp`
   - `deep-research`：转 `deep-research-pro`，并要求其检索步骤调用本 skill 的搜索入口
   - `interactive-web`：转 `agent-browser`
3. 记录实际 `route`、是否发生降级、是否还有后续步骤。

详细决策矩阵见 `references/route-matrix.md`。
失败与降级策略见 `references/failure-policy.md`。

## 搜索执行

对 `search` 模式，在当前 skill 目录运行：

```bash
bash scripts/search.sh \
  --query "大模型最新进展" \
  --limit 10
```

默认并发查询 `scripts/config/engines.sh` 中登记的全部来源：`tavily`、`duckduckgo`、`google`、`github`、`baidu`、`bing`、`web_search`、`xhs`。缺少 API key、本地 CLI 或登录态的来源必须返回空数组并继续其他来源，不得中断聚合搜索。

Tavily key 从当前 skill 目录的 `.env` 读取。小红书搜索源依赖 `mcporter` 与远程 `xiaohongshu-mcp`，默认端点为 `https://xhs.n.lion1ou.tech:16666/mcp`，可通过 `.env` 中的 `XIAOHONGSHU_MCP_URL` 覆盖；安装渠道见 `references/xiaohongshu-mcp-download.md`。

返回结果必须满足：
- `url` 为有效 `http/https`
- `title` 非空
- `snippet` 非空，长度至少 10
- `score` 落在 `0.0-1.0`
- 按 URL 去重

标准输出格式：

```json
{
  "query": "大模型最新进展",
  "results": [
    {
      "source": "tavily",
      "title": "Example",
      "url": "https://example.com",
      "snippet": "Example snippet text...",
      "published": "",
      "score": 0.95
    }
  ],
  "total": 1,
  "latency_ms": 1200
}
```

## 小红书 MCP

小红书相关任务不再依赖其他 skill。当前 skill 直接使用 `scripts/sources/xhs.sh` 和远程 `xiaohongshu-mcp`。

站内搜索：

```bash
bash scripts/sources/xhs.sh \
  --query "关键词" \
  --limit 10 \
  --sortby 综合
```

登录态检查：

```bash
mcporter call "${XIAOHONGSHU_MCP_URL:-https://xhs.n.lion1ou.tech:16666/mcp}.check_login_status" \
  --timeout 30000 \
  --output json
```

获取登录二维码：

```bash
mcporter call "${XIAOHONGSHU_MCP_URL:-https://xhs.n.lion1ou.tech:16666/mcp}.get_login_qrcode" \
  --timeout 30000 \
  --output json
```

笔记详情、用户资料、点赞、收藏、评论等能力通过同一个 MCP 端点暴露；调用前先用：

```bash
mcporter list "${XIAOHONGSHU_MCP_URL:-https://xhs.n.lion1ou.tech:16666/mcp}" --brief
```

涉及发布、点赞、收藏、评论等写操作时，必须先向用户说明目标和影响，并等待明确确认。

## URL 内容获取

`read-url` 只处理已经有明确 URL 的请求；没有 URL 时回到 `search`。每次切换工具都要说明原因，不要静默降级。

语雀 `*.yuque.com` 是例外：必须先走 `yuque-read`。Hellobike 语雀优先 MCP；其他语雀使用登录态和对应 `fetch.py`。不要把语雀链接当普通网页直接送 `web_fetch`。

决策流程：

```text
有明确 URL？
├─ YES → 静态内容（文章/文档/API/RSS）？
│        ├─ YES → web_fetch
│        │        失败（空白/403/CAPTCHA/骨架 HTML）→ opencli → 内置反爬抓取 → agent-browser
│        └─ NO（JS/登录/交互/截图）→ opencli → agent-browser
└─ NO  → search
```

### `web_fetch`

用于新闻文章、博客、技术文档、API 页面、RSS 等静态内容。失败信号包括空白页、403、CAPTCHA、骨架 HTML 或正文明显缺失。

### `opencli`

`web_fetch` 失败或页面需要站点专用结构化访问时，先试 `opencli`，再考虑浏览器自动化。详细命令见 `references/opencli-guide.md`。

首次使用如果提示 `opencli: command not found`，在当前 skill 目录运行：

```bash
bash scripts/setup-opencli.sh
```

渐进式发现：

```bash
opencli --help
opencli <site> --help
opencli <site> <command> --help
```

### 内置反爬抓取

遇到公众号、Cloudflare、Medium/Substack 或强反爬页面，标准抓取与 `opencli` 都失败时，直接运行当前 skill 的免费抓取脚本。不要在同一路径反复重试。

```bash
python3 scripts/fetch.py "https://mp.weixin.qq.com/s/xxxxxx"
python3 scripts/fetch.py "https://example.com" --fast
python3 scripts/fetch.py "https://example.com" --text --max-chars 10000
```

输出默认为 JSON，字段包括 `title`、`author`、`content`、`word_count`、`fetcher`、`url`；加 `--text` 只输出正文。

工具选择：
- 微信公众号、Medium、Substack、Cloudflare 保护页：优先内置反爬抓取。
- 普通文章页：优先 `web_fetch`，失败后可用 `python3 scripts/fetch.py <url> --fast` 走 Jina Reader。
- Twitter/X、微博、Instagram、Facebook 等强登录站点：不要用该脚本硬抓，转 `agent-browser` 并要求用户确认登录。

依赖：`scrapling[all]` 和 Playwright Chromium。缺依赖时按需在当前环境安装：

```bash
python3 -m pip install 'scrapling[all]'
python3 -m playwright install chromium
```

已知反爬站点与限制见 `references/antibot-sites.md`。本 skill 只内置免费抓取能力，不包含付费计费脚本。

### `agent-browser` / browser

仅在需要登录、点击、滚动、截图、扫码、验证码或动态页面交互时使用。登录操作必须先告知用户并得到确认；发帖、删除、支付等敏感操作必须二次确认。等待页面时使用目标元素出现作为条件，不要用固定 `sleep` 代替。

常用站点入口见 `references/well-known-sites.json`，例如 `social.weibo.login`、`search.baidu`；带 `{query}` 的 URL 需要替换为实际关键词。

## 热点与榜单查询

对热搜、榜单、报纸、票房、收视率、音乐排行、App Store 排行等请求，不走通用 Web 搜索，直接在当前 skill 目录运行内置脚本。需要 Node.js 18+。

| 用户意图 | 命令 |
|---|---|
| 抖音/微博/百度/B站/快手热搜 | `node scripts/hot/crawl-hot.js --platform=<platform>` |
| 全平台热搜、全网热点、今天大家在聊什么 | `node scripts/hot/crawl-hot.js` |
| QQ音乐/网易云/酷狗/酷我热歌榜或飙升榜 | `node scripts/hot/crawl-music.js --platform=<platform> --type=hot|rising` |
| 电影票房、电视剧收视、网播热度、综艺热度 | `node scripts/hot/crawl-entertainment.js --type=movie|tv|web|variety` |
| App Store 免费/付费游戏或应用排行 | `node scripts/hot/crawl-entertainment.js --type=game_free|game_paid|app_free|app_paid` |
| 今日、昨日或指定日期人民日报版面 | `node scripts/hot/crawl-paper.js --date=today|yesterday|YYYY-MM-DD` |

参数速查：
- `crawl-hot.js`：`--platform=douyin|weibo|baidu|bilibili|kuaishou|all`
- `crawl-music.js`：`--platform=qq|wangyi|kugou|kuwo|all`，`--type=hot|rising|all`
- `crawl-entertainment.js`：`--type=movie|tv|web|variety|game_free|game_paid|app_free|app_paid|all`
- `crawl-paper.js`：`--date=today|yesterday|YYYY-MM-DD`，`--pages=1,2,3`

输出均为 JSON。详细参数见 `references/hot-api-endpoints.md`，字段结构见 `references/hot-data-formats.md`。热搜脚本返回的 `url` 可能是搜索页；用户需要事实解读、新闻摘要或出处引用时，先用返回关键词继续执行 `scripts/search.sh`，再读取可信详情页。

## 下游技能边界

- 本 skill 已内置已知 URL 之后的内容获取、降级和登录页处理
- 内置 `scripts/fetch.py` 负责免费反爬与正文抓取，不负责搜索排序
- 内置 `scripts/hot/` 负责中国平台热榜、音乐榜、娱乐榜、App Store 排行和人民日报版面，不负责通用搜索
- 内置 `xhs` 搜索源和远程 `xiaohongshu-mcp` 负责小红书站内搜索、详情和互动
- `deep-research-pro` 负责多来源研究与成稿，不负责底层搜索引擎编排
- `agent-browser` 负责交互式浏览器自动化，不负责通用搜索

## 维护说明

搜索引擎配置在 `scripts/config/engines.sh`。
新增搜索源时：
1. 在 `scripts/sources/` 新建脚本
2. 接收 `--query` 与 `--limit`
3. 输出标准化 JSON 数组
4. 在 `engines.sh` 中注册

健康检查由 `scripts/health_check.sh` 维护，状态落在 `engine_status.json`。
搜索源契约检查：

```bash
python3 scripts/check_search_sources.py
```

URL 获取相关资源：
- `references/opencli-guide.md`：opencli 渐进式发现、站点能力和输出格式
- `references/well-known-sites.json`：常用站点、登录页、搜索页和热榜页索引
- `references/antibot-sites.md`：适合内置反爬抓取的站点与限制
- `scripts/setup-opencli.sh`：opencli CLI 与 Browser Bridge 安装脚本
- `scripts/fetch.py`：免费 Scrapling/Jina 网页正文抓取脚本

Tavily 配置只使用当前 skill 目录的 `.env`：写入 `TAVILY_API_KEY=...` 后由 `scripts/config/engines.sh` 自动加载；不使用旧的外部网关配置流程。
