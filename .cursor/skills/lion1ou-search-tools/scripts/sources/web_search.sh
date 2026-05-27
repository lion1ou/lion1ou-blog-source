#!/usr/bin/env bash
# web_search.sh - 通用 Web 搜索兼容源
# 直接复用 duckduckgo 搜索逻辑，避免依赖外部服务配置

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_DIR="${SKILL_ROOT_DIR}/scripts/config"
source "${CONFIG_DIR}/engines.sh"

usage() {
  cat <<EOF
用法: web_search.sh --query "关键词" [--limit 5]

说明: 兼容 web_search 来源名称，实际复用 DuckDuckGo 搜索
EOF
  exit 1
}

QUERY=""
LIMIT="${DEFAULT_LIMIT:-20}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --query) QUERY="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    --timeout) shift 2 ;; # Accepted for compatibility with parallel_search.sh.
    *) echo "未知参数: $1"; usage ;;
  esac
done

if [ -z "$QUERY" ]; then
  usage
fi

# 直接复用 duckduckgo 逻辑
exec bash "${SCRIPT_DIR}/duckduckgo.sh" --query "$QUERY" --limit "$LIMIT"
