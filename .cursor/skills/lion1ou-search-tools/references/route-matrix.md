# Route Matrix

## 目标

把搜索类请求稳定分到正确的下游能力，避免 `lion1ou-search-tools` 抢走所有网页任务。

## 一级判断

| 输入特征 | 路由 | 说明 |
|---|---|---|
| 关键词、问题、最新消息、资料检索 | `search` | 直接运行 `scripts/search.sh` |
| 已知 URL，需要读取、总结、提取正文 | `read-url` | 使用 `SKILL.md` 的「URL 内容获取」流程 |
| 热搜、热榜、票房、音乐榜、人民日报版面 | `hot-data` | 使用 `scripts/hot/` 内置脚本 |
| 小红书笔记、用户、话题搜索或互动 | `xhs-mcp` | 使用内置 `xhs` 搜索源或远程 `xiaohongshu-mcp` |
| 行业研究、方案对比、带引用报告 | `deep-research` | 转 `deep-research-pro` |
| 登录、点击、滚动、截图、表单 | `interactive-web` | 转 `agent-browser` |

## 二级判断

### `search`

适用问法：
- “查一下 X”
- “X 最新进展”
- “帮我找文章/资料/官网”
- “看看最近关于 X 的讨论”

在当前 skill 目录执行：

```bash
bash scripts/search.sh \
  --query "<query>" \
  --limit 10
```

### `read-url`

适用问法：
- “总结这个链接”
- “帮我读一下这篇文章”
- “提取这个网页正文”

**若 URL 为 `https://…yuque.com/…`（语雀）**：**不要**在 `read-url` 下直接当普通站走 `web_fetch` 为首选。改用 `yuque-read`：Hellobike 语雀链接（如 `hellobike.yuque.com`）使用 MCP 读取；其他语雀链接直接使用该 skill 的 `scripts/fetch.py` 与对应 `YUQUE_*` 变量。与下面通用 `read-url` 分支互斥、优先语雀技能。

非语雀的后续判断：
- 静态文章、文档、API 页面 → `web_fetch`
- `web_fetch` 失败、403、空白、骨架 HTML → `opencli`
- 公众号、Cloudflare、Medium/Substack、强反爬 → 内置免费抓取脚本 `python3 scripts/fetch.py <url>`
- 必须登录、点击、滚动、截图 → `agent-browser` 或 browser
- 常用站点入口查 `references/well-known-sites.json`
- `opencli` 详细用法查 `references/opencli-guide.md`；反爬站点查 `references/antibot-sites.md`；缺少 CLI 时运行 `scripts/setup-opencli.sh`

### `hot-data`

适用问法：
- “今天微博热搜”
- “抖音/B站/百度/快手上什么最火”
- “QQ 音乐热歌榜”
- “电影票房排行”
- “今天人民日报头版”

执行入口：
- 热搜：`node scripts/hot/crawl-hot.js --platform=douyin|weibo|baidu|bilibili|kuaishou|all`
- 音乐榜：`node scripts/hot/crawl-music.js --platform=qq|wangyi|kugou|kuwo|all --type=hot|rising|all`
- 娱乐榜：`node scripts/hot/crawl-entertainment.js --type=movie|tv|web|variety|game_free|game_paid|app_free|app_paid|all`
- 人民日报：`node scripts/hot/crawl-paper.js --date=today|yesterday|YYYY-MM-DD --pages=1,2,3`

### `xhs-mcp`

适用问法：
- “搜一下小红书上的 X”
- “看这个小红书笔记详情/评论”
- “分析小红书某个话题”
- “发布/点赞/收藏/评论小红书内容”

执行入口：
- 搜索候选笔记：`bash scripts/sources/xhs.sh --query "<关键词>" --limit 10`
- 登录态检查：`mcporter call "${XIAOHONGSHU_MCP_URL:-https://xhs.n.lion1ou.tech:16666/mcp}.check_login_status" --timeout 30000 --output json`
- 查看可用 MCP 工具：`mcporter list "${XIAOHONGSHU_MCP_URL:-https://xhs.n.lion1ou.tech:16666/mcp}" --brief`
- 笔记详情、用户资料、点赞、收藏、评论等使用同一远程 MCP 端点；写操作必须先获得用户明确确认

### `deep-research`

适用问法：
- “深度研究一下 X”
- “做一份带来源的对比分析”
- “给我一份研究报告”

执行要求：
1. 先拆成 3-5 个子问题
2. 每个子问题都先走 `lion1ou-search-tools`
3. 对关键 URL 再走 `read-url`
4. 最后按 `deep-research-pro` 的报告结构综合

### `interactive-web`

适用问法：
- “打开网站并点一下按钮”
- “帮我登录并截图”
- “填写表单并提交”

执行入口：
- 使用 `agent-browser`
- 如果只是为了取页面内容，不要误用交互式浏览器

## 优先级规则

1. 有明确小红书站内任务时，`xhs-mcp` 优先于通用搜索。
2. 有明确热榜、榜单、报纸等资讯采集意图时，`hot-data` 优先于通用搜索。
3. 有明确 URL 时，`read-url` 优先于再次搜索。
4. 研究型任务优先走 `deep-research`，不要只返回裸搜索结果。
5. 只有在需要真实交互时才走 `interactive-web`。
6. 任何不确定的搜索/网页任务，先从 `lion1ou-search-tools` 入口分类，不要直接跳下游。
