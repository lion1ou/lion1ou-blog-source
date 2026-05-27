#!/usr/bin/env bash
# bing.sh - Bing 搜索

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_DIR="${SKILL_ROOT_DIR}/scripts/config"
source "${CONFIG_DIR}/engines.sh"

usage() {
  cat <<EOF
用法: bing.sh --query "关键词" [--limit 5] [--timeout <ms>]
EOF
  exit 1
}

QUERY=""
LIMIT="${DEFAULT_LIMIT:-20}"
TIMEOUT_MS="${TIMEOUT_BING:-8000}"

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

search_bing() {
  local query="$1"
  local limit="$2"
  local timeout_ms="${3:-8000}"

  local encoded_query
  encoded_query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${query}'))")
  local bing_url="https://www.bing.com/search?q=${encoded_query}&count=${limit}&setlang=zh-CN"

  local html
  html=$(curl -sfLm $((timeout_ms/1000)) \
    --compressed \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" \
    -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
    -H "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8" \
    -H "Connection: keep-alive" \
    "$bing_url" 2>/dev/null | tr -d '\0') || {
    echo "[]"
    return
  }

  # 检测 bot 保护
  if echo "$html" | grep -qi "blocked\|captcha\|unusual traffic\|prove you are human\|403 Forbidden"; then
    echo "[]"
    return
  fi

  python3 - <<PYEOF
import re, json, sys, html as html_mod, base64
from urllib.parse import unquote

import base64 as _b64
html = _b64.b64decode("""$(echo "$html" | base64)""").decode('utf-8', errors='replace')
limit = ${limit}

results = []
seen = set()

def clean_text(text):
    text = re.sub(r'<[^>]+>', '', text)
    text = html_mod.unescape(text)
    text = re.sub(r'\s+', ' ', text).strip()
    return text

def is_blocked(html_text):
    if re.search(r'captcha|unusual traffic|prove you are human|Access Denied', html_text, re.I):
        return True
    return False

if is_blocked(html):
    print("[]")
    sys.exit(0)

# Bing 结果在 <li class="b_algo"> 块内
count = 0
for block in re.finditer(r'<li[^>]*class="[^"]*b_algo[^"]*"[^>]*>(.*?)</li>', html, re.DOTALL):
    block_html = block.group(1)
    
    # 先尝试从 b_tpcn div 获取 RedirectUrl（真实 URL）
    redirect_m = re.search(r'RedirectUrl="([^"]+)"', block_html)
    real_url = html_mod.unescape(unquote(redirect_m.group(1))) if redirect_m else ""
    
    # h2 内的链接：Bing 的属性顺序经常变化，先宽松提取再清洗。
    h2_m = re.search(r'<h2[^>]*>(.*?)</h2>', block_html, re.DOTALL)
    if not h2_m:
        continue
    h2c = h2_m.group(1)
    
    link_m = re.search(r'<a[^>]+href="([^"]+)"[^>]+h="ID=SERP[^"]*"[^>]*>([^<]+)</a>', h2c, re.DOTALL)
    if not link_m:
        link_m = re.search(r'<a[^>]+href="([^"]+)"[^>]*>(.*?)</a>', h2c, re.DOTALL)
    
    if not link_m:
        continue
    
    raw_url = link_m.group(1)
    title = clean_text(link_m.group(2))
    
    if not title or len(title) < 5:
        continue
    
    # 优先用 RedirectUrl，其次尝试解码 bing 内部重定向
    if not (real_url and real_url.startswith('http')):
        real_url = raw_url
        if 'bing.com/ck' in raw_url:
            u_m = re.search(r'[?&]u=([^&]+)', raw_url)
            if u_m:
                try:
                    decoded = base64.b64decode(u_m.group(1)).decode('utf-8', errors='ignore')
                    if decoded.startswith('http'):
                        real_url = decoded
                except:
                    pass
    
    if real_url.startswith('http') and real_url not in seen:
        snippet = ""
        snippet_m = re.search(r'<p[^>]*>(.*?)</p>', block_html, re.DOTALL)
        if snippet_m:
            snippet = clean_text(snippet_m.group(1))
        if len(snippet) < 10:
            snippet = f"Bing result for {title}"
        seen.add(real_url)
        results.append({
            "source": "bing",
            "title": title,
            "url": real_url,
            "snippet": snippet,
            "published": "",
            "score": round(0.80 - len(results) * 0.02, 2)
        })
        count += 1
        if count >= limit:
            break

print(json.dumps(results, ensure_ascii=False))
PYEOF
}

search_bing "$QUERY" "$LIMIT" "$TIMEOUT_MS"
