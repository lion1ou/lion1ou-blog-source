#!/usr/bin/env bash
#
# xhs.sh - 小红书搜索源
# 依赖: xiaohongshu-mcp 服务 + mcporter
# 下载渠道: 见 references/xiaohongshu-mcp-download.md
# 默认端点: https://xhs.n.lion1ou.tech:16666/mcp
# 前置条件: xhs-mcp 服务已登录
#
# 用法:
#   xhs.sh --query "关键词" [--limit 5] [--sortby 综合、最新、最多点赞...]
#
# 输出: JSON 数组，格式与 smart-search-router 其他引擎一致
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_DIR="${SKILL_ROOT_DIR}/scripts/config"
# shellcheck source=../../scripts/config/engines.sh
source "${CONFIG_DIR}/engines.sh"

# mcporter 调用超时（xhs-mcp 搜索依赖浏览器，较慢）
MCP_TIMEOUT=50

usage() {
  cat <<EOF
用法: xhs.sh --query "搜索内容" [--limit 5] [--sortby 综合|最新|最多点赞|最多收藏|最多评论]

选项:
  --query <text>     搜索关键词（必需）
  --limit <num>     返回结果数量（默认 5）
  --sortby <type>   排序: 综合(默认)|最新|最多点赞|最多收藏|最多评论
  --timeout <ms>    mcporter 超时毫秒（默认 ${MCP_TIMEOUT}000）

前置条件:
  1. xiaohongshu-mcp 服务可访问（默认 ${XIAOHONGSHU_MCP_URL}）
  2. 小红书账号已登录（cookies 有效）

示例:
  xhs.sh --query "福鼎白茶" --limit 5 --sortby 最多点赞
EOF
  exit 1
}

# --------------- 参数解析 ---------------
QUERY=""
LIMIT="${DEFAULT_LIMIT:-5}"
SORTBY="综合"
TIMEOUT_SEC="${MCP_TIMEOUT}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --query)   QUERY="$2"; shift 2 ;;
    --limit)   LIMIT="$2"; shift 2 ;;
    --sortby)  SORTBY="$2"; shift 2 ;;
    --timeout) TIMEOUT_SEC="$(( $2 / 1000 ))"; shift 2 ;;
    --help)    usage ;;
    *) echo "未知参数: $1"; usage ;;
  esac
done

if [ -z "$QUERY" ]; then
  usage
fi

if ! command -v mcporter >/dev/null 2>&1; then
  echo "[]"
  exit 0
fi

# --------------- 执行搜索 ---------------
run_xhs_search() {
  local query="$1"
  local max_results="$2"
  local sortby="$3"
  local timeout_sec="$4"

  python3 - <<PYEOF
import subprocess, json, sys, os, re

query = """${query}"""
max_results = ${max_results}
sortby = """${sortby}"""
timeout_sec = ${timeout_sec}
mcp_url = os.environ.get("XIAOHONGSHU_MCP_URL", "https://xhs.n.lion1ou.tech:16666/mcp").rstrip("/")
selector = f"{mcp_url}.search_feeds"

# 构造 mcporter 命令
cmd = [
    "mcporter", "call", selector,
    f"keyword={query}",
    "--timeout", str(timeout_sec * 1000),
    "--output", "json",
]

# 如果指定了排序，添加到 filters
if sortby and sortby != "综合":
    cmd.append(f"filters=sort_by={sortby}")

try:
    status_cmd = [
        "mcporter", "call", f"{mcp_url}.check_login_status",
        "--timeout", str(min(timeout_sec * 1000, 10000)),
        "--output", "json",
    ]
    status = subprocess.run(
        status_cmd,
        capture_output=True,
        text=True,
        timeout=min(timeout_sec, 10),
        env={**os.environ}
    )
    status_text = (status.stdout or "") + (status.stderr or "")
    if status.returncode != 0:
        print("[]")
        sys.exit(0)
    if "未登录" in status_text or "not logged" in status_text.lower():
        print("[]")
        sys.exit(0)

    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        timeout=timeout_sec,
        env={**os.environ}
    )
    stdout = result.stdout.strip()

    if result.returncode != 0 or not stdout:
        print("[]")
        sys.exit(0)

    # 解析响应：mcporter 输出 JSON 对象包装在 "content" 字段里
    try:
        wrapper = json.loads(stdout)
        # mcporter 返回格式: { "content": [ ... actual JSON array ... ] }
        # 或直接返回 { "feeds": [...] }
        if isinstance(wrapper, dict):
            if "feeds" in wrapper:
                data = wrapper["feeds"]
            elif "content" in wrapper:
                # 嵌套格式: content 是 JSON 字符串
                inner = wrapper["content"]
                if isinstance(inner, str):
                    inner = json.loads(inner)
                if isinstance(inner, dict) and "feeds" in inner:
                    data = inner["feeds"]
                elif isinstance(inner, list):
                    data = inner
                else:
                    data = []
            else:
                data = []
        elif isinstance(wrapper, list):
            data = wrapper
        else:
            data = []
    except json.JSONDecodeError:
        # 尝试从原始文本中提取
        match = re.search(r'\{.*\}', stdout, re.DOTALL)
        if match:
            try:
                obj = json.loads(match.group(0))
                data = obj.get("feeds", []) if isinstance(obj, dict) else []
            except:
                data = []
        else:
            data = []

    # 转换为统一格式
    results = []
    if not isinstance(data, list):
        data = []

    for item in data:
        # 跳过无效条目（hot_query 等无内容类型）
        model_type = item.get("modelType", "")
        if model_type == "hot_query":
            continue

        # 笔记数据在 noteCard 下
        note_card = item.get("noteCard", {})
        if not note_card:
            continue

        feed_id = item.get("id", "")
        if not feed_id:
            continue

        title = note_card.get("displayTitle", "")
        interact = note_card.get("interactInfo", {})
        user = note_card.get("user", {})
        cover = note_card.get("cover", {})

        # 解析互动数据（可能是字符串）
        def parse_num(v):
            if isinstance(v, int):
                return v
            if isinstance(v, str):
                v = v.strip().replace(",", "")
                return int(v) if v.isdigit() else 0
            return 0

        liked = parse_num(interact.get("likedCount", 0))
        collected = parse_num(interact.get("collectedCount", 0))
        commented = parse_num(interact.get("commentCount", 0))
        shared = parse_num(interact.get("sharedCount", 0))

        nickname = user.get("nickname", "")

        # 封面图
        cover_url = ""
        if isinstance(cover, dict):
            cover_url = cover.get("urlDefault", "") or cover.get("url", "")

        # 构建小红书笔记 URL
        url = f"https://www.xiaohongshu.com/explore/{feed_id}"

        entry = {
            "source": "xiaohongshu",
            "title": title[:200] if title else "无标题",
            "url": url,
            "snippet": f"👍{liked}  ⭐{collected}  💬{commented}",
            "published": "",
            "score": 0.9,
            "extra": {
                "liked_count": liked,
                "collected_count": collected,
                "comment_count": commented,
                "shared_count": shared,
                "author": nickname,
                "cover": cover_url,
                "feed_id": feed_id,
                "type": note_card.get("type", "")
            }
        }
        results.append(entry)

    # 限制数量
    results = results[:max_results]
    print(json.dumps(results, ensure_ascii=False))

except subprocess.TimeoutExpired:
    print("[]")
    sys.exit(0)
except Exception as e:
    print("[]")
    sys.exit(0)
PYEOF
}

# --------------- 主程序 ---------------
run_xhs_search "$QUERY" "$LIMIT" "$SORTBY" "$TIMEOUT_SEC"
