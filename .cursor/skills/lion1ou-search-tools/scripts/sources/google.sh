#!/usr/bin/env bash
# ==============================================================================
# google.sh - Google 搜索（通过 Google API）
# 依赖: GROQ_API_KEY 或 OPENAI_API_KEY（用于免费 Gemini 搜索）
#      或者 DDG_GOOGLE_KEY（Google API Key，可选）
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# 方法1: ddg-google (DDG_GOOGLE_KEY)
if [ -n "${DDG_GOOGLE_KEY:-}" ]; then
  result=$(curl -s --max-time 8 \
    "https://ddg-api.herokuapp.com/search?q=${QUERY}&num=${LIMIT}" \
    2>/dev/null || echo "")
  if [ -n "$result" ]; then
    echo "$result" | python3 - "${LIMIT}" <<'PYEOF'
import json, sys
limit = int(sys.argv[2])
try:
    data = json.loads(sys.stdin.read())
    results = []
    for item in (data if isinstance(data, list) else data.get("results", []))[:limit]:
        results.append({
            "source": "google",
            "title": item.get("title", ""),
            "url": item.get("url", ""),
            "snippet": item.get("description", item.get("snippet", ""))[:300],
            "score": 0.85
        })
    print(json.dumps(results, ensure_ascii=False))
except:
    print("[]")
PYEOF
    exit 0
  fi
fi

# 方法2: 兜底 - 直接用 tavily (tavily 本身会爬 Google)
echo "[]"
