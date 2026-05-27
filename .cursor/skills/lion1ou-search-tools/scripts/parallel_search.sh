#!/usr/bin/env bash
# ==============================================================================
# parallel_search.sh - 多引擎并发搜索，汇总去重 + 完整校验
# 输入: --query "关键词" --limit 5
# 输出: 统一 JSON 格式（含错误检测）
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_DIR="${SKILL_ROOT_DIR}/scripts/config"
SOURCES_DIR="${SKILL_ROOT_DIR}/scripts/sources"

# shellcheck source=../config/engines.sh
source "${CONFIG_DIR}/engines.sh"

current_ms() {
  python3 - <<'PY'
import time
print(int(time.time() * 1000))
PY
}

# --------------- 校验常量 ---------------
MAX_QUERY_LEN=200
MAX_LIMIT=100
MIN_SNIPPET_LEN=10
MIN_TITLE_LEN=1

# --------------- 参数解析 + 校验 ---------------
QUERY=""
LIMIT="${DEFAULT_LIMIT:-20}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --query) QUERY="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# --- 输入校验 ---
if [ -z "${QUERY:-}" ] || [[ -z "${QUERY// }" ]]; then
  echo '{"error": "搜索关键词不能为空"}' >&2
  exit 1
fi

# 去除前后空白 + 截断长度
QUERY=$(echo "$QUERY" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | cut -c1-${MAX_QUERY_LEN})

# limit 范围限制
LIMIT=$(echo "$LIMIT" | tr -d '[:space:]')
if ! [[ "$LIMIT" =~ ^[0-9]+$ ]] || [ "$LIMIT" -lt 1 ]; then
  LIMIT="${DEFAULT_LIMIT:-20}"
fi
[ "$LIMIT" -gt "$MAX_LIMIT" ] && LIMIT="$MAX_LIMIT"

# --------------- 单引擎执行函数 ---------------
run_engine() {
  local engine="$1"
  local query="$2"
  local limit="$3"
  local timeout_ms

  case "$engine" in
    tavily)
      timeout_ms="${TIMEOUT_TAVILY:-8000}"
      if [ -n "${TAVILY_API_KEY:-}" ]; then
        bash "${SOURCES_DIR}/tavily.sh" --query "$query" --limit "$limit" --type "general" --timeout "$timeout_ms" 2>/dev/null || echo "[]"
      else
        echo "[]"
      fi
      ;;
    duckduckgo)
      timeout_ms="${TIMEOUT_DUCKDUCKGO:-5000}"
      bash "${SOURCES_DIR}/duckduckgo.sh" --query "$query" --limit "$limit" --timeout "$timeout_ms" 2>/dev/null || echo "[]"
      ;;
    google)
      timeout_ms="${TIMEOUT_GOOGLE:-5000}"
      bash "${SOURCES_DIR}/google.sh" --query "$query" --limit "$limit" --timeout "$timeout_ms" 2>/dev/null || echo "[]"
      ;;
    github)
      timeout_ms="${TIMEOUT_GITHUB:-5000}"
      bash "${SOURCES_DIR}/github.sh" --query "$query" --limit "$limit" --timeout "$timeout_ms" 2>/dev/null || echo "[]"
      ;;
    baidu)
      timeout_ms="${TIMEOUT_BAIDU:-5000}"
      bash "${SOURCES_DIR}/baidu.sh" --query "$query" --limit "$limit" --timeout "$timeout_ms" 2>/dev/null || echo "[]"
      ;;
    bing)
      timeout_ms="${TIMEOUT_BING:-8000}"
      bash "${SOURCES_DIR}/bing.sh" --query "$query" --limit "$limit" --timeout "$timeout_ms" 2>/dev/null || echo "[]"
      ;;
    web_search)
      timeout_ms="${TIMEOUT_WEB_SEARCH:-5000}"
      bash "${SOURCES_DIR}/web_search.sh" --query "$query" --limit "$limit" --timeout "$timeout_ms" 2>/dev/null || echo "[]"
      ;;
    xhs)
      timeout_ms="${TIMEOUT_XHS:-60000}"
      bash "${SOURCES_DIR}/xhs.sh" --query "$query" --limit "$limit" --timeout "$timeout_ms" 2>/dev/null || echo "[]"
      ;;
    *)
      echo "[]"
      ;;
  esac
}

# --------------- 结果校验函数（Python）---------------
validate_and_dedup() {
  local merged_file="$1"
  local final_file="$2"
  local limit="$3"
  local query="$4"

  python3 - "${merged_file}" "${final_file}" "${limit}" "${query}" <<'PYEOF'
import json, sys, re

infile  = sys.argv[1]
outfile = sys.argv[2]
limit   = int(sys.argv[3])
query   = sys.argv[4] if len(sys.argv) > 4 else ""

try:
    with open(infile) as f:
        results = json.load(f)
except:
    results = []

def is_valid_url(url):
    if not url or not isinstance(url, str):
        return False
    return bool(re.match(r"^https?://", url.strip()))

def is_valid_result(item):
    if not isinstance(item, dict):
        return False
    title = (item.get("title") or "").strip()
    snippet = (item.get("snippet") or "").strip()
    url = (item.get("url") or "").strip()
    # title 至少 1 字符
    if len(title) < 1:
        return False
    # snippet 至少 MIN_SNIPPET_LEN 字符
    if len(snippet) < 10:
        return False
    # url 必须是有效 http/https
    if not is_valid_url(url):
        return False
    return True

# 过滤 + URL 去重
seen = set()
valid = []
for r in results:
    if not is_valid_result(r):
        continue
    url = r["url"].strip()
    if url in seen:
        continue
    seen.add(url)
    valid.append(r)

# score 范围校验 + 相关度重排
query_terms = set(query.lower().split()) if query else set()

def calc_score(item):
    raw = item.get("score") or 0.5
    # clamp 到 0.0-1.0
    s = float(raw)
    if s < 0: s = 0.5
    if s > 1: s = 1.0
    # 相关度加成
    if query_terms:
        text = ((item.get("title") or "") + " " + (item.get("snippet") or "")).lower()
        matches = sum(1 for t in query_terms if t in text)
        boost = min(0.5, (matches / max(len(query_terms), 1)) * 0.5)
        s = min(1.0, s + boost)
    item["score"] = round(s, 3)
    return s

valid.sort(key=calc_score, reverse=True)
valid = valid[:limit]

with open(outfile, "w") as f:
    json.dump(valid, f, ensure_ascii=False)
PYEOF
}

# --------------- 主程序 ---------------
main() {
  local start_ms
  start_ms=$(current_ms)

  # 解析启用的引擎列表（静默跳过未知引擎）
  IFS=',' read -ra ENGINES_ARRAY <<< "$ENABLED_ENGINES"

  local tmpdir
  tmpdir=$(mktemp -d)
  local pids=()
  local engine_count=0

  for i in "${!ENGINES_ARRAY[@]}"; do
    local engine
    engine=$(echo "${ENGINES_ARRAY[$i]}" | tr -d '[:space:]')
    [ -z "$engine" ] && continue

    # 验证引擎是否在可用列表中
    local valid=false
    for e in "${ENGINES[@]}"; do
      [ "$e" = "$engine" ] && valid=true && break
    done
    "$valid" || continue

    local outfile="${tmpdir}/result_${engine}.json"
    run_engine "$engine" "$QUERY" "$LIMIT" > "$outfile" &
    pids+=("$!")
    engine_count=$((engine_count + 1))
  done

  # 等待所有完成
  for pid in "${pids[@]}"; do
    wait "$pid" 2>/dev/null || true
  done

  # 合并所有结果
  local merged_file="${tmpdir}/merged.json"
  echo "[]" > "$merged_file"

  for engine in "${ENGINES_ARRAY[@]}"; do
    engine=$(echo "$engine" | tr -d '[:space:]')
    [ -z "$engine" ] && continue

    local outfile="${tmpdir}/result_${engine}.json"
    if [ -f "$outfile" ] && [ -s "$outfile" ]; then
      python3 - "${outfile}" "${merged_file}" <<'PYEOF'
import json, sys
try:
    with open(sys.argv[1]) as f:
        new_data = json.load(f)
    with open(sys.argv[2]) as f:
        merged = json.load(f)
except:
    sys.exit(0)
if isinstance(new_data, list):
    merged.extend(new_data)
with open(sys.argv[2], "w") as f:
    json.dump(merged, f, ensure_ascii=False)
PYEOF
    fi
  done

  # 校验 + 去重 + 排序
  local final_file="${tmpdir}/final.json"
  validate_and_dedup "$merged_file" "$final_file" "$LIMIT" "$QUERY"

  local end_ms
  end_ms=$(current_ms)
  local latency_ms=$((end_ms - start_ms))

  # 空结果检测
  local final_count
  final_count=$(python3 -c "import json; f=open('${final_file}'); d=json.load(f); print(len(d))" 2>/dev/null || echo "0")

  if [ "$final_count" -eq 0 ] && [ "$engine_count" -gt 0 ]; then
    # 所有引擎都失败了
    python3 - "${QUERY}" "${latency_ms}" <<'PYEOF'
import json, sys

query = sys.argv[1]
latency = int(sys.argv[2])
output = {
    "error": "所有搜索源均失败，请稍后重试",
    "query": query,
    "total": 0,
    "latency_ms": latency,
}
print(json.dumps(output, ensure_ascii=False))
PYEOF
  else
    python3 - "${final_file}" "${latency_ms}" "${QUERY}" <<PYEOF
import json, sys
infile = sys.argv[1]
latency = int(sys.argv[2])
query = sys.argv[3]
try:
    with open(infile) as f:
        results = json.load(f)
except:
    results = []
output = {"query": query, "results": results, "total": len(results), "latency_ms": latency}
print(json.dumps(output, ensure_ascii=False, indent=2))
PYEOF
  fi

  rm -rf "$tmpdir"

  # 自动更新引擎健康状态（静默后台运行，不影响搜索结果输出）
  bash "${SCRIPT_DIR}/health_check.sh" >/dev/null 2>&1 &
}

main
