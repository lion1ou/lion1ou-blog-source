#!/usr/bin/env bash
# ==============================================================================
# health_check.sh - 搜索引擎健康状态检测
# 检测每个引擎是否可用，输出 JSON 状态报告
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_DIR="${SKILL_ROOT_DIR}/scripts/config"
SOURCES_DIR="${SKILL_ROOT_DIR}/scripts/sources"

# shellcheck source=../../scripts/config/engines.sh
source "${CONFIG_DIR}/engines.sh"

REPORT_FILE="${SKILL_ROOT_DIR}/engine_status.json"
TEST_QUERY="AI coding agent MCP"
TEST_LIMIT=2
TIMEOUT_MS=8000

current_ms() {
  python3 - <<'PY'
import time
print(int(time.time() * 1000))
PY
}

run_with_timeout() {
  local timeout_seconds="$1"
  shift

  if command -v timeout >/dev/null 2>&1; then
    timeout "$timeout_seconds" "$@"
    return
  fi

  python3 - "$timeout_seconds" "$@" <<'PY'
import subprocess
import sys

timeout_seconds = int(sys.argv[1])
cmd = sys.argv[2:]
try:
    completed = subprocess.run(cmd, timeout=timeout_seconds)
    sys.exit(completed.returncode)
except subprocess.TimeoutExpired:
    sys.exit(124)
PY
}

# --------------- 单引擎检测 ---------------
check_engine() {
  local engine="$1"
  local start_ms end_ms latency_ms result
  local source_file="${SOURCES_DIR}/${engine}.sh"
  local timeout_ms="${TIMEOUT_MS}"

  if [ ! -f "$source_file" ]; then
    echo "{\"engine\":\"$engine\",\"status\":\"missing\",\"latency_ms\":0,\"sample\":null}"
    return
  fi

  start_ms=$(current_ms)
  case "$engine" in
    tavily) timeout_ms="${TIMEOUT_TAVILY:-$TIMEOUT_MS}" ;;
    duckduckgo) timeout_ms="${TIMEOUT_DUCKDUCKGO:-$TIMEOUT_MS}" ;;
    google) timeout_ms="${TIMEOUT_GOOGLE:-$TIMEOUT_MS}" ;;
    github) timeout_ms="${TIMEOUT_GITHUB:-$TIMEOUT_MS}" ;;
    baidu) timeout_ms="${TIMEOUT_BAIDU:-$TIMEOUT_MS}" ;;
    bing) timeout_ms="${TIMEOUT_BING:-$TIMEOUT_MS}" ;;
    web_search) timeout_ms="${TIMEOUT_WEB_SEARCH:-$TIMEOUT_MS}" ;;
    xhs) timeout_ms="${TIMEOUT_XHS:-$TIMEOUT_MS}" ;;
  esac
  result=$(run_with_timeout $(((timeout_ms + 999) / 1000)) bash "${source_file}" --query "$TEST_QUERY" --limit "$TEST_LIMIT" --timeout "$timeout_ms" 2>/dev/null || echo "[]")
  end_ms=$(current_ms)
  latency_ms=$((end_ms - start_ms))

  local sample
  sample=$(echo "$result" | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d) if isinstance(d,list) else -1)" 2>/dev/null || echo "-2")

  if [ "$sample" = "-2" ]; then
    echo "{\"engine\":\"$engine\",\"status\":\"error\",\"latency_ms\":${latency_ms},\"sample\":null}"
  elif [ "$sample" = "0" ] || [ "$sample" = "-1" ]; then
    echo "{\"engine\":\"$engine\",\"status\":\"empty\",\"latency_ms\":${latency_ms},\"sample\":0}"
  else
    echo "{\"engine\":\"$engine\",\"status\":\"ok\",\"latency_ms\":${latency_ms},\"sample\":${sample}}"
  fi
}

# --------------- 主程序 ---------------
main() {
  local tmp_report
  tmp_report=$(mktemp "${REPORT_FILE}.XXXXXX")
  echo "[" > "$tmp_report"

  first=true
  for engine in "${ENGINES[@]}"; do
    [ -n "$engine" ] || continue
    $first && first=false || echo "," >> "$tmp_report"
    check_engine "$engine" | tr -d '\n' >> "$tmp_report"
  done

  echo "]" >> "$tmp_report"
  mv "$tmp_report" "$REPORT_FILE"

  # 输出到 stdout
  cat "$REPORT_FILE"
}

main
