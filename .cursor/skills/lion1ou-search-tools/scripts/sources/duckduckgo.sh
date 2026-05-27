#!/usr/bin/env bash
# ==============================================================================
# duckduckgo.sh - DuckDuckGo 搜索
# 输入: --query "关键词" [--limit 5]
# 输出: JSON 结果数组
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_DIR="${SKILL_ROOT_DIR}/scripts/config"
# shellcheck source=../../scripts/config/engines.sh
source "${CONFIG_DIR}/engines.sh"

QUERY=""
LIMIT="${DEFAULT_LIMIT:-5}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --query) QUERY="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$QUERY" ]; then
  echo "Usage: $0 --query <keyword> [--limit 5]" >&2
  exit 1
fi

ENCODED_QUERY=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$QUERY'))")
DDG_URL="https://duckduckgo.com/html/?q=${ENCODED_QUERY}"

python3 - "$DDG_URL" "$LIMIT" << 'PYEOF'
import sys, re, json, urllib.request, urllib.parse

url = sys.argv[1]
limit = int(sys.argv[2])

req = urllib.request.Request(url, headers={
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
})
try:
    with urllib.request.urlopen(req, timeout=10) as r:
        html = r.read().decode('utf-8', errors='ignore')
except:
    print("[]")
    sys.exit(0)

results = []
seen_urls = set()
pattern = r'<a[^>]*class="result__a"[^>]*href="([^"]+)"[^>]*>([^<]+)</a>'
for match in re.finditer(pattern, html):
    raw_url = match.group(1)
    title = re.sub(r'<[^>]+>', '', match.group(2)).strip()
    
    # 解析 DuckDuckGo 的重定向 URL
    final_url = raw_url
    if '/l/?uddg=' in raw_url:
        # 提取 uddg 参数中的真实 URL
        try:
            parsed = urllib.parse.urlparse(raw_url)
            params = urllib.parse.parse_qs(parsed.query)
            if 'uddg' in params:
                final_url = params['uddg'][0]
        except:
            pass
    
    # 跳过广告 URL
    if 'y.js' in final_url or 'aclk' in final_url:
        continue
    
    # URL 去重
    if final_url in seen_urls:
        continue
    seen_urls.add(final_url)
    
    # 找 snippet
    snippet = ''
    # 使用转义后的 URL 找 snippet
    escaped = re.escape(final_url)
    snippet_pattern = escaped + r'[^<]*</a>.*?<a class="result__snippet"[^>]*>([^<]+)</a>'
    snippet_match = re.search(snippet_pattern, html, re.DOTALL)
    if snippet_match:
        snippet = re.sub(r'<[^>]+>', '', snippet_match.group(1)).strip()
    if len(snippet) < 10:
        snippet = f"DuckDuckGo result for {title}"
    
    results.append({
        'source': 'duckduckgo',
        'title': title,
        'url': final_url,
        'snippet': snippet,
        'published': '',
        'score': 0.7
    })

print(json.dumps(results[:limit], ensure_ascii=False))
PYEOF
