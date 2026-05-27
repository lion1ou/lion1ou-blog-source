---
name: deep-research-pro
description: "多来源深度研究工作流。用于把一个主题拆成子问题、调用 `lion1ou-search-tools` 收集来源、深读关键页面，并输出带引用的研究报告。适用于行业研究、方案比较、市场分析、技术综述和需要结论与来源同时交付的任务。"
metadata: {"clawdbot":{"emoji":"🔬","category":"research"}}
---

# Deep Research Pro

把本 skill 视为“研究编排层”，不是底层搜索引擎。

检索入口统一走已安装的 `lion1ou-search-tools` skill。
正文抓取统一走 `lion1ou-search-tools` 的 `read-url` /「URL 内容获取」流程，遇到反爬时使用其内置免费抓取脚本。

## How It Works

当用户要求“深度研究”“做报告”“做对比分析”“给出带来源结论”时，按下面流程执行。

### Step 1: Understand the Goal

先问 1-2 个澄清问题：
- "目标是学习、做决策，还是要产出一份内容？"
- "有没有特别关注的角度、地区、时间范围或深度？"

如果用户说“你直接研究”，用合理默认值继续。

### Step 2: Plan the Research

把主题拆成 3-5 个研究子问题。例如：
- Topic: "Impact of AI on healthcare"
  - What are the main AI applications in healthcare today?
  - What clinical outcomes have been measured?
  - What are the regulatory challenges?
  - What companies are leading this space?
  - What's the market size and growth trajectory?

### Step 3: Execute Multi-Source Search

对每个子问题，都先使用 `lion1ou-search-tools` 的统一入口，不要直接调用旧的 DDG 脚本。

按 `lion1ou-search-tools` 的搜索执行说明运行其 `scripts/search.sh` 入口。

搜索策略：
- 每个子问题用 2-3 组关键词变体
- 当前事件类主题，把“最新”“今年”“2026”“news”等词并入查询
- 目标是 15-30 个唯一来源
- 优先级：学术、官方、权威媒体 > 博客 > 论坛

### Step 4: Deep-Read Key Sources

对最有价值的 URL，不要只看 snippet。

先使用 `lion1ou-search-tools`，按它的 `read-url` 规则获取正文：
- 静态页面优先 `web_fetch`
- `web_fetch` 失败时先尝试 `opencli`
- 反爬、公众号、Cloudflare 站点使用 `lion1ou-search-tools` 内置的 `scripts/fetch.py`
- 必须登录、点击或截图时转 `agent-browser`

如果只需要轻量正文抓取，可使用类似流程：

```bash
python3 - <<'PY'
import re
from pathlib import Path

text = Path("page.txt").read_text()
text = re.sub(r"\s+", " ", text).strip()
print(text[:5000])
PY
```

至少深读 3-5 个关键来源。

### Step 5: Synthesize & Write Report

报告结构：

```markdown
# [Topic]: Deep Research Report
*Generated: [date] | Sources: [N] | Confidence: [High/Medium/Low]*

## Executive Summary
[3-5 sentence overview of key findings]

## 1. [First Major Theme]
[Findings with inline citations]
- Key point ([Source Name](url))
- Supporting data ([Source Name](url))

## 2. [Second Major Theme]
...

## 3. [Third Major Theme]
...

## Key Takeaways
- [Actionable insight 1]
- [Actionable insight 2]
- [Actionable insight 3]

## Sources
1. [Title](url) — [one-line summary]
2. ...

## Methodology
Searched [N] queries across web and news. Analyzed [M] sources.
Sub-questions investigated: [list]
```

### Step 6: Save & Deliver

保存完整报告：
```bash
REPORT_DIR="${DEEP_RESEARCH_REPORT_DIR:-${TMPDIR:-/tmp}/deep-research-[slug]}"
mkdir -p "$REPORT_DIR"
# Write report to "$REPORT_DIR/report.md"
```

交付方式：
- 主题较短：聊天里直接给完整报告
- 主题较长：先给摘要和要点，再说明完整报告位置

## Quality Rules

1. **Every claim needs a source.** No unsourced assertions.
2. **Cross-reference.** If only one source says it, flag it as unverified.
3. **Recency matters.** Prefer sources from the last 12 months.
4. **Acknowledge gaps.** If you couldn't find good info on a sub-question, say so.
5. **No hallucination.** If you don't know, say "insufficient data found."
6. **Search through `lion1ou-search-tools`.** Do not bypass the unified search entry.

## Examples

```
"Research the current state of nuclear fusion energy"
"Deep dive into Rust vs Go for backend services in 2026"
"Research the best strategies for bootstrapping a SaaS business"
"What's happening with the US housing market right now?"
```

## Requirements

- `lion1ou-search-tools` search entry
- `lion1ou-search-tools` read-url content-fetch workflow
- Optional: `lion1ou-search-tools/scripts/fetch.py` for antibot pages
