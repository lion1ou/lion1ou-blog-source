#!/usr/bin/env bash
# ==============================================================================
# search.sh - Smart Search Router 唯一入口（含输入校验）
# 用法: bash search.sh --query "关键词" --limit 5
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARALLEL_SCRIPT="${SCRIPT_DIR}/parallel_search.sh"

# --------------- 参数校验 ---------------
QUERY=""
LIMIT=""
MAX_QUERY_LEN=200
MAX_LIMIT=100

while [[ $# -gt 0 ]]; do
  case "$1" in
    --query) QUERY="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    -h|--help) ;;
    *) shift ;;
  esac
done

if [ -z "${QUERY:-}" ]; then
  echo '{"error": "缺少 --query 参数"}' >&2
  exit 1
fi

if [[ -z "${QUERY// }" ]]; then
  echo '{"error": "搜索关键词不能为空"}' >&2
  exit 1
fi

# 执行
exec bash "$PARALLEL_SCRIPT" --query "$QUERY" --limit "${LIMIT:-20}"
