#!/usr/bin/env bash
# ==============================================================================
# engines.sh - Smart Search Router 搜索源配置
# 纯搜索引擎聚合器配置：启用/禁用 + 权重 + 超时
# ==============================================================================

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT_DIR="$(cd "${CONFIG_DIR}/../.." && pwd)"

load_env_file() {
  local env_file="$1"
  [ -f "$env_file" ] || return 0
  set -a
  # shellcheck disable=SC1090
  source "$env_file"
  set +a
}

load_env_file "${SKILL_ROOT_DIR}/.env"

# --------------- 可用引擎列表 ---------------
ENGINES=(
  "tavily"
  "duckduckgo"
  "google"
  "github"
  "baidu"
  "bing"
  "web_search"
  "xhs"
)

# --------------- 默认启用的引擎（逗号分隔） ---------------
ENABLED_ENGINES="tavily,duckduckgo,google,github,baidu,bing,web_search,xhs"

# --------------- 引擎权重（用于 score 计算） ---------------
WEIGHT_TAVILY=0.95
WEIGHT_DUCKDUCKGO=0.70
WEIGHT_GITHUB=0.80
WEIGHT_BING=0.75
WEIGHT_WEB_SEARCH=0.70
WEIGHT_XHS=0.85

# --------------- 超时配置（毫秒） ---------------
TIMEOUT_TAVILY=8000
TIMEOUT_DUCKDUCKGO=5000
TIMEOUT_GITHUB=5000
TIMEOUT_BING=8000
TIMEOUT_WEB_SEARCH=5000
TIMEOUT_XHS=60000

# --------------- 默认数量限制 ---------------
DEFAULT_LIMIT=20

# --------------- API Keys（可选） ---------------
TAVILY_API_KEY="${TAVILY_API_KEY:-${TAVILY_KEY:-}}"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"  # 可选，有 token 避免 rate limit
XIAOHONGSHU_MCP_URL="${XIAOHONGSHU_MCP_URL:-${XHS_MCP_URL:-https://xhs.n.lion1ou.tech:16666/mcp}}"
