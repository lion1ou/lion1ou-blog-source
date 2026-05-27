#!/usr/bin/env bash
# ==============================================================================
# baidu.sh - 百度搜索
# 依赖: 无需 API Key，直接抓取
# ==============================================================================

set -euo pipefail

QUERY=""
LIMIT=20

while [[ $# -gt 0 ]]; do
  case "$1" in
    --query) QUERY="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$QUERY" ]; then
  echo "[]"
  exit 0
fi

# 百度搜索（通过 RSSHub/代理，避免直接抓取）
if [ -n "${BAIDU_SEARCH_API:-}" ]; then
  result=$(curl -s --max-time 8 \
    "${BAIDU_SEARCH_API}?query=${QUERY}&limit=${LIMIT}" \
    2>/dev/null || echo "")
elif [ -n "${RSSHUB_URL:-}" ]; then
  # 通过 RSSHub 走百度
  encoded=$(echo -n "$QUERY" | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))")
  result=$(curl -s --max-time 8 \
    "${RSSHUB_URL}/baidu/${encoded}" \
    -H "Accept: application/rss+xml, application/json" \
    2>/dev/null || echo "")
fi

if [ -n "${result:-}" ] && [ -n "$(echo "$result" | tr -d '[:space:]')" ]; then
  echo "$result" | python3 - "${LIMIT}" <<'PYEOF'
import json, sys
limit = int(sys.argv[2])
try:
    data = json.loads(sys.stdin.read())
    results = []
    items = data if isinstance(data, list) else data.get("items", data.get("results", []))
    for item in items[:limit]:
        if isinstance(item, dict):
            results.append({
                "source": "baidu",
                "title": item.get("title", ""),
                "url": item.get("url", item.get("link", "")),
                "snippet": item.get("description", item.get("snippet", item.get("content", "")))[:300],
                "score": 0.80
            })
    print(json.dumps(results, ensure_ascii=False))
except:
    print("[]")
PYEOF
else
  # 降级：用 bing 代替
  echo "[]"
fi
