#!/usr/bin/env bash
# Auto-generated path setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_DIR="${SKILL_ROOT_DIR}/scripts/config"
# shellcheck source=../../scripts/config/engines.sh
source "${CONFIG_DIR}/engines.sh"
source "${CONFIG_DIR}/engines.sh"

TAVILY_API_KEY="${TAVILY_API_KEY:-${TAVILY_KEY:-}}"

usage() {
  cat <<EOF
用法: tavily.sh --query "搜索内容" [--limit 5] [--type general|news|tech]

选项:
  --query <text>    搜索关键词（必需）
  --limit <num>     返回结果数量（默认 5）
  --type <type>     搜索类型: general|news|tech（默认 general）
  --timeout <ms>    超时毫秒数（默认 ${TIMEOUT_TAVILY}）

示例:
  tavily.sh --query "AI最新进展" --limit 5 --type news
EOF
  exit 1
}

# --------------- 参数解析 ---------------
QUERY=""
LIMIT="${DEFAULT_LIMIT}"
TYPE="general"
TIMEOUT_MS="${TIMEOUT_TAVILY}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --query) QUERY="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    --type)  TYPE="$2"; shift 2 ;;
    --timeout) TIMEOUT_MS="$2"; shift 2 ;;
    *) echo "未知参数: $1"; usage ;;
  esac
done

if [ -z "$QUERY" ]; then
  usage
fi

if [ -z "$TAVILY_API_KEY" ]; then
  echo '[]'
  exit 0
fi

# --------------- 映射搜索类型 ---------------
case "$TYPE" in
  news)   TOPIC="news" ;;
  tech|ai|ai-tech) TOPIC="news" ;;
  general) TOPIC="general" ;;
  *) TOPIC="general" ;;
esac

# --------------- 执行 Tavily 搜索 ---------------
run_tavily() {
  local query="$1"
  local max_results="$2"
  local topic="$3"

  # 使用 python 处理 API 请求（更可靠的 JSON 处理）
  python3 - <<PYEOF
import urllib.request, urllib.error, json, sys, ssl

api_key = "${TAVILY_API_KEY}"
url = "https://api.tavily.com/search"

payload = {
    "api_key": api_key,
    "query": "${query}",
    "search_depth": "basic",
    "topic": "${topic}",
    "max_results": ${max_results},
    "include_answer": False,
    "include_raw_content": False,
}

data = json.dumps(payload).encode("utf-8")

# 忽略 SSL 证书验证
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

req = urllib.request.Request(
    url,
    data=data,
    headers={"Content-Type": "application/json"},
    method="POST"
)

try:
    with urllib.request.urlopen(req, timeout=${TIMEOUT_MS}/1000, context=ctx) as resp:
        result = json.loads(resp.read().decode("utf-8"))
        results = result.get("results", [])
        output = []
        for r in results:
            output.append({
                "source": "tavily",
                "title": r.get("title", ""),
                "url": r.get("url", ""),
                "snippet": r.get("content", ""),
                "published": r.get("published_date", ""),
                "score": r.get("score", 0.8)
            })
        print(json.dumps(output, ensure_ascii=False))
except Exception as e:
    print("[]")
    sys.exit(0)
PYEOF
}

# --------------- 主程序 ---------------
run_tavily "$QUERY" "$LIMIT" "$TYPE"
