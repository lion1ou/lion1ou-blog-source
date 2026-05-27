#!/usr/bin/env bash
# Auto-generated path setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_DIR="${SKILL_ROOT_DIR}/scripts/config"
# shellcheck source=../../scripts/config/engines.sh
source "${CONFIG_DIR}/engines.sh"

usage() {
  cat <<EOF
用法: github.sh --query "关键词" [--limit 5] [--timeout <ms>]

示例:
  github.sh --query "machine learning" --limit 5
  github.sh --query "AI coding agent" --limit 5
EOF
  exit 1
}

# --------------- 参数解析 ---------------
QUERY=""
LIMIT="${DEFAULT_LIMIT}"
TIMEOUT_MS="${TIMEOUT_GITHUB:-5000}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --query) QUERY="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    --timeout) TIMEOUT_MS="$2"; shift 2 ;;
    *) echo "未知参数: $1"; usage ;;
  esac
done

if [ -z "$QUERY" ]; then
  usage
fi

# --------------- GitHub API 搜索 ---------------
search_github_api() {
  local query="$1"
  local limit="$2"
  local token="${GITHUB_TOKEN:-}"

  local url="https://api.github.com/search/repositories?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${query}'))")&per_page=${limit}&sort=stars&order=desc"

  local response
  if [ -n "$token" ]; then
    response=$(curl -sfLm $((TIMEOUT_MS/1000)) \
      -H "Authorization: token $token" \
      -H "Accept: application/vnd.github.v3+json" \
      "$url" 2>/dev/null)
  else
    response=$(curl -sfLm $((TIMEOUT_MS/1000)) \
      -H "Accept: application/vnd.github.v3+json" \
      "$url" 2>/dev/null)
  fi

  if [ -z "$response" ]; then
    echo "[]"
    return
  fi

  python3 - <<PYEOF
import json, sys, re
from datetime import datetime

response = """$response"""
limit = ${limit}

try:
    data = json.loads(response)
    items = data.get('items', [])
except:
    print("[]")
    sys.exit(0)

results = []
for item in items[:limit]:
    # 清理 description
    desc = item.get('description') or ""
    desc = re.sub(r'<[^>]+>', '', desc).strip()
    
    # 获取 stars 和 language
    stars = item.get('stargazers_count', 0)
    language = item.get('language') or ""
    full_name = item.get('full_name', "")
    
    # 构建摘要
    snippet = f"{desc}" if desc else f"⭐ {stars:,} | {language}"
    if not desc and language:
        snippet = f"⭐ {stars:,} stars | {language}"
    elif not desc:
        snippet = f"⭐ {stars:,} stars"
    
    results.append({
        "source": "github",
        "title": f"{full_name}",
        "url": item.get('html_url', ''),
        "snippet": snippet,
        "published": item.get('created_at', '')[:10] if item.get('created_at') else '',
        "score": min(1.0, 0.5 + (stars / 100000) * 0.5) if stars > 0 else 0.5
    })

print(json.dumps(results, ensure_ascii=False))
PYEOF
}

# --------------- GitHub Web 搜索（降级方案）---------------
search_github_web() {
  local query="$1"
  local limit="$2"
  local timeout_ms="${3:-5000}"

  local encoded_query
  encoded_query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${query}'))")
  local url="https://github.com/search?q=${encoded_query}&type=repositories&s=stars"

  local html
  html=$(curl -sfLm $((timeout_ms/1000)) \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" \
    -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
    -H "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8" \
    "$url" 2>/dev/null) || {
    echo "[]"
    return
  }

  python3 - <<PYEOF
import re, json, sys, html as html_mod

html = sys.stdin.read()
limit = ${limit}

results = []
seen = set()

# GitHub 搜索结果格式: <a href="/owner/repo">repo-name</a>
# 和 <p class="pr-4">描述...</p>
repo_pattern = re.compile(r'<a[^>]+href="(/[^/]+/[^"]+)"[^>]*class="[^"]*v-align-middle[^"]*"[^>]*>([^<]+)</a>')
desc_pattern = re.compile(r'<p[^>]*class="[^"]*color-fg-muted[^"]*"[^>]*>(.*?)</p>', re.DOTALL)

descs = []
for match in desc_pattern.finditer(html):
    text = re.sub(r'<[^>]+>', '', match.group(1))
    text = html_mod.unescape(text).strip()
    if len(text) > 10:
        descs.append(text[:200])

for idx, match in enumerate(repo_pattern.finditer(html)):
    repo_path = match.group(1)
    repo_name = html_mod.unescape(match.group(2).strip())
    
    url = f"https://github.com{repo_path}"
    
    if url not in seen and len(repo_name) > 0:
        seen.add(url)
        snippet = descs[idx] if idx < len(descs) else ""
        
        results.append({
            "source": "github",
            "title": repo_name,
            "url": url,
            "snippet": snippet,
            "published": "",
            "score": round(0.80 - len(results) * 0.02, 2)
        })

    if len(results) >= limit:
        break

print(json.dumps(results[:limit], ensure_ascii=False))
PYEOF
}

simplify_query() {
  python3 - "$1" <<'PY'
import re
import sys

raw = sys.argv[1]
tokens = re.findall(r"[A-Za-z0-9_\-\u4e00-\u9fff]+", raw)
drop = {
    "latest", "best", "new", "today", "frontend", "developer", "workflow",
    "tools", "tool", "2024", "2025", "2026", "2027",
}
kept = []
for token in tokens:
    lowered = token.lower()
    if lowered in drop or re.fullmatch(r"20\d{2}", token):
        continue
    if token not in kept:
        kept.append(token)
priority = [t for t in kept if t.lower() in {"ai", "coding", "cursor", "claude", "mcp", "agent", "skill"}]
rest = [t for t in kept if t not in priority]
print(" ".join((priority + rest)[:4]))
PY
}

# --------------- 主程序 ---------------
# 优先使用 API，失败则降级到 Web
result=$(search_github_api "$QUERY" "$LIMIT")
if [ "$result" = "[]" ]; then
  FALLBACK_QUERY="$(simplify_query "$QUERY")"
  if [ -n "$FALLBACK_QUERY" ] && [ "$FALLBACK_QUERY" != "$QUERY" ]; then
    result=$(search_github_api "$FALLBACK_QUERY" "$LIMIT")
  fi
fi
if [ "$result" = "[]" ]; then
  search_github_web "$QUERY" "$LIMIT" "$TIMEOUT_MS"
else
  echo "$result"
fi
