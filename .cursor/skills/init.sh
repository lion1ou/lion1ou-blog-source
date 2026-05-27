#!/bin/bash
# lion1ou Skills 初始化脚本
# 用法: bash .claude/skills/init.sh [--check-only] [--skip-python] [--skip-node]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_FILE="$SCRIPT_DIR/init-config.json"
SKILLS_ENV_FILE="$SCRIPT_DIR/.env"
SKILLS_ENV_EXAMPLE_FILE="$SCRIPT_DIR/.env.example"
BAOYU_ENV_FILE="$PROJECT_DIR/.baoyu-skills/.env"
BAOYU_ENV_LINK_TARGET="../.cursor/skills/.env"
BAOYU_ENV_EXAMPLE_FILE="$PROJECT_DIR/.baoyu-skills/.env.example"
BAOYU_ENV_EXAMPLE_LINK_TARGET="../.cursor/skills/.env.example"
BAOYU_IMAGE_EXTEND_FILE="$PROJECT_DIR/.baoyu-skills/baoyu-image-gen/EXTEND.md"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 标志
CHECK_ONLY=false
SKIP_PYTHON=false
SKIP_NODE=false

# 解析参数
for arg in "$@"; do
  case $arg in
    --check-only)
      CHECK_ONLY=true
      shift
      ;;
    --skip-python)
      SKIP_PYTHON=true
      shift
      ;;
    --skip-node)
      SKIP_NODE=true
      shift
      ;;
  esac
done

# 打印函数
print_header() {
  echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
  echo -e "${RED}✗ $1${NC}"
}

print_info() {
  echo -e "  $1"
}

ensure_symlink() {
  local link_path="$1"
  local target="$2"

  if [ -L "$link_path" ]; then
    local current_target
    current_target="$(readlink "$link_path")"
    if [ "$current_target" = "$target" ]; then
      return 0
    fi
    rm "$link_path"
  elif [ -e "$link_path" ]; then
    rm "$link_path"
  fi

  ln -s "$target" "$link_path"
}

merge_env_file() {
  local source_file="$1"
  local target_file="$2"

  [ -f "$source_file" ] || return 0
  [ ! -L "$source_file" ] || return 0

  python3 - "$source_file" "$target_file" <<'PY'
from pathlib import Path
import sys

source = Path(sys.argv[1])
target = Path(sys.argv[2])

def parse(path):
    data = {}
    order = []
    if not path.exists():
        return data, order
    for line in path.read_text().splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        if key and key not in data:
            data[key] = value
            order.append(key)
    return data, order

source_data, source_order = parse(source)
target_data, target_order = parse(target)
changed = False
for key in source_order:
    value = source_data[key]
    if key not in target_data or not target_data[key]:
        target_data[key] = value
        if key not in target_order:
            target_order.append(key)
        changed = True

if not changed:
    raise SystemExit(0)

lines = []
for line in target.read_text().splitlines() if target.exists() else []:
    if line.strip() and not line.lstrip().startswith("#") and "=" in line:
        key = line.split("=", 1)[0].strip()
        if key in target_data:
            line = f"{key}={target_data[key]}"
    lines.append(line)

existing_keys = {
    line.split("=", 1)[0].strip()
    for line in lines
    if line.strip() and not line.lstrip().startswith("#") and "=" in line
}
missing = [key for key in target_order if key not in existing_keys]
if missing:
    if lines and lines[-1] != "":
        lines.append("")
    lines.append("# 从旧 baoyu .env 迁移的变量")
    lines.extend(f"{key}={target_data[key]}" for key in missing)

target.write_text("\n".join(lines).rstrip() + "\n")
PY
}

# 检查命令是否存在
check_command() {
  if command -v "$1" &> /dev/null; then
    return 0
  else
    return 1
  fi
}

mark_missing() {
  all_ok=false
}

# 检查 Node.js 版本
check_node_version() {
  if check_command node; then
    local version=$(node --version | sed 's/v//')
    local major=$(echo "$version" | cut -d. -f1)
    if [ "$major" -ge 22 ]; then
      return 0
    fi
  fi
  return 1
}

# 检查 Python 版本
check_python_version() {
  if check_command python3; then
    local version=$(python3 --version | awk '{print $2}')
    local major=$(echo "$version" | cut -d. -f1)
    local minor=$(echo "$version" | cut -d. -f2)
    if [ "$major" -ge 3 ] && [ "$minor" -ge 9 ]; then
      return 0
    fi
  fi
  return 1
}

# 主检查函数
check_dependencies() {
  local all_ok=true

  print_header "检查系统依赖"

  # Node.js
  if check_node_version; then
    print_success "Node.js $(node --version)"
  else
    print_error "Node.js 22+ 未安装"
    print_info "安装命令: brew install node 或 https://nodejs.org"
    mark_missing
  fi

  # Python
  if check_python_version; then
    print_success "Python $(python3 --version | awk '{print $2}')"
  else
    print_error "Python 3.9+ 未安装"
    print_info "安装命令: brew install python3"
    mark_missing
  fi

  # bun
  if check_command bun; then
    print_success "bun $(bun --version)"
  else
    print_error "bun 未安装 (baoyu skills 需要)"
    print_info "安装命令: curl -fsSL https://bun.sh/install | bash"
    mark_missing
  fi

  # opencli
  if check_command opencli; then
    print_success "opencli $(opencli --version 2>/dev/null || echo 'installed')"
  else
    print_error "opencli 未安装 (smart-search / opencli-* 需要)"
    print_info "安装命令: npm install -g @jackwener/opencli"
    mark_missing
  fi

  # mcporter
  if check_command mcporter; then
    print_success "mcporter"
  else
    print_error "mcporter 未安装 (lion1ou-search-tools 的 xhs 搜索源需要)"
    print_info "安装命令: npm install -g mcporter"
    mark_missing
  fi

  # 系统工具
  print_header "检查系统工具"

  if check_command pdftotext; then
    print_success "poppler (pdftotext)"
  else
    print_error "poppler 未安装 (PDF 文本提取)"
    print_info "安装命令: brew install poppler"
    mark_missing
  fi

  if check_command qpdf; then
    print_success "qpdf"
  else
    print_error "qpdf 未安装 (PDF 合并分割)"
    print_info "安装命令: brew install qpdf"
    mark_missing
  fi

  if check_command tesseract; then
    print_success "tesseract (OCR)"
  else
    print_error "tesseract 未安装 (OCR 文字识别)"
    print_info "安装命令: brew install tesseract"
    mark_missing
  fi

  # Python 包
  print_header "检查 Python 包"

  local python_packages=(
    "pypdf:pypdf"
    "pdfplumber:pdfplumber"
    "reportlab:reportlab"
    "pytesseract:pytesseract"
    "pdf2image:pdf2image"
    "scrapling:scrapling"
    "pandas:pandas"
    "playwright:playwright.sync_api"
  )
  for item in "${python_packages[@]}"; do
    local pkg="${item%%:*}"
    local import_name="${item#*:}"
    if python3 -c "import ${import_name}" 2>/dev/null; then
      print_success "$pkg"
    else
      print_error "$pkg 未安装"
      print_info "安装命令: pip3 install $pkg"
      mark_missing
    fi
  done

  # Playwright Chromium
  if python3 -c "from playwright.sync_api import sync_playwright" 2>/dev/null; then
    if [ -d "$HOME/Library/Caches/ms-playwright/chromium-"* ] 2>/dev/null; then
      print_success "Playwright Chromium"
    else
      print_error "Playwright Chromium 未安装"
      print_info "安装命令: python3 -m playwright install chromium"
      mark_missing
    fi
  else
    print_error "Playwright 未安装"
    print_info "安装命令: pip3 install playwright && python3 -m playwright install chromium"
    mark_missing
  fi

  # API Keys
  print_header "检查 API Keys 配置"

  if [ -f "$SKILLS_ENV_FILE" ]; then
    print_success ".cursor/skills/.env 文件存在"
    if grep -Eq '^TAVILY_API_KEY=.+' "$SKILLS_ENV_FILE" 2>/dev/null; then
      print_success "TAVILY_API_KEY 已配置"
    else
      print_warning "TAVILY_API_KEY 未配置，Tavily 搜索源不可用"
    fi
  else
    print_warning ".cursor/skills/.env 不存在；运行 'bash .claude/skills/init.sh --setup-env' 创建"
  fi

  if [ -f "$BAOYU_ENV_FILE" ]; then
    if [ -L "$BAOYU_ENV_FILE" ]; then
      print_success ".baoyu-skills/.env 软链存在"
    else
      print_warning ".baoyu-skills/.env 不是软链；运行 'bash .claude/skills/init.sh --setup-env' 修正"
    fi
    if grep -Eq '^(GOOGLE_API_KEY|OPENAI_API_KEY|AZURE_OPENAI_API_KEY|OPENROUTER_API_KEY|DASHSCOPE_API_KEY|ZAI_API_KEY|BIGMODEL_API_KEY|MINIMAX_API_KEY|REPLICATE_API_TOKEN|JIMENG_ACCESS_KEY_ID|ARK_API_KEY)=.+' "$BAOYU_ENV_FILE" 2>/dev/null; then
      print_success "至少一个 baoyu-image-gen 生图后端已配置"
    else
      print_warning "未配置任何 baoyu-image-gen 生图后端 API key"
    fi
  else
    print_warning ".baoyu-skills/.env 不存在"
    print_info "运行 'bash .claude/skills/init.sh --setup-env' 创建 baoyu 配置文件"
  fi

  if [ -f "$BAOYU_IMAGE_EXTEND_FILE" ]; then
    print_success "baoyu-image-gen EXTEND.md 已配置"
  else
    print_warning "baoyu-image-gen EXTEND.md 不存在，将使用 skill 默认/交互配置"
  fi

  # Chrome 远程调试
  print_header "检查浏览器配置"

  if pgrep -f "Google Chrome" > /dev/null 2>&1; then
    print_success "Chrome 正在运行"
    print_info "请确保已启用远程调试: chrome://inspect/#remote-debugging"
  else
    print_warning "Chrome 未运行"
  fi

  if [ "$all_ok" = true ]; then
    return 0
  fi
  return 1
}

# 安装函数
install_dependencies() {
  print_header "安装依赖"

  if ! check_command brew; then
    print_error "Homebrew 未安装，无法自动安装系统工具"
    print_info "安装地址: https://brew.sh"
    return 1
  fi

  # 安装 bun
  if ! check_command bun; then
    print_info "安装 bun..."
    curl -fsSL https://bun.sh/install | bash
  fi

  # 安装 opencli
  if [ "$SKIP_NODE" = false ] && ! check_command opencli; then
    print_info "安装 opencli..."
    npm install -g @jackwener/opencli
  fi

  # 安装 mcporter
  if [ "$SKIP_NODE" = false ] && ! check_command mcporter; then
    print_info "安装 mcporter..."
    npm install -g mcporter
  fi

  # 安装系统工具
  if ! check_command pdftotext || ! check_command qpdf || ! check_command tesseract; then
    print_info "安装系统工具..."
    brew install poppler qpdf tesseract
  fi

  # 安装 Python 包
  if [ "$SKIP_PYTHON" = false ]; then
    print_info "安装 Python 包..."
    pip3 install pypdf pdfplumber reportlab pytesseract pdf2image 'scrapling[all]' pandas playwright
  fi

  # 安装 Playwright Chromium
  print_info "安装 Playwright Chromium..."
  python3 -m playwright install chromium
}

# 创建 .env 文件
setup_env() {
  print_header "配置环境变量"

  mkdir -p "$(dirname "$BAOYU_ENV_FILE")" "$(dirname "$BAOYU_IMAGE_EXTEND_FILE")"

  if [ -f "$SKILLS_ENV_FILE" ]; then
    print_success ".cursor/skills/.env 已存在，保留原有配置"
  elif [ -f "$SKILLS_ENV_EXAMPLE_FILE" ]; then
    cp "$SKILLS_ENV_EXAMPLE_FILE" "$SKILLS_ENV_FILE"
    print_success ".cursor/skills/.env 文件已从 .env.example 创建"
  else
    cat > "$SKILLS_ENV_FILE" << 'EOF'
# lion1ou skills 统一环境变量配置
TAVILY_API_KEY=
GITHUB_TOKEN=
XIAOHONGSHU_MCP_URL=https://xhs.n.lion1ou.tech:16666/mcp
XHS_MCP_URL=
DDG_GOOGLE_KEY=
GROQ_API_KEY=
CDP_PROXY_PORT=3456

# 生图后端：任选一个或多个配置。baoyu-image-gen 会按配置和可用 key 自动选择。
GOOGLE_API_KEY=
GEMINI_API_KEY=
GOOGLE_BASE_URL=
OPENAI_API_KEY=
OPENAI_BASE_URL=
AZURE_OPENAI_API_KEY=
AZURE_OPENAI_BASE_URL=
AZURE_API_VERSION=2025-04-01-preview
OPENROUTER_API_KEY=
OPENROUTER_BASE_URL=
DASHSCOPE_API_KEY=
DASHSCOPE_BASE_URL=
ZAI_API_KEY=
BIGMODEL_API_KEY=
ZAI_BASE_URL=
BIGMODEL_BASE_URL=
MINIMAX_API_KEY=
MINIMAX_BASE_URL=
REPLICATE_API_TOKEN=
REPLICATE_BASE_URL=
JIMENG_ACCESS_KEY_ID=
JIMENG_SECRET_ACCESS_KEY=
JIMENG_REGION=cn-north-1
JIMENG_BASE_URL=
ARK_API_KEY=
SEEDREAM_BASE_URL=

# OpenRouter 可选 attribution
OPENROUTER_HTTP_REFERER=
OPENROUTER_TITLE=

# Codex CLI 生图后端
BAOYU_CODEX_IMAGEGEN_BIN=
BAOYU_CODEX_IMAGEGEN_CACHE_DIR=
BAOYU_CODEX_IMAGEGEN_TIMEOUT_MS=
BAOYU_CODEX_IMAGEGEN_RETRIES=
BAOYU_CODEX_IMAGEGEN_LOG_FILE=

# Gemini Web 反向 API
GEMINI_WEB_DATA_DIR=
GEMINI_WEB_COOKIE_PATH=
GEMINI_WEB_CHROME_PROFILE_DIR=
GEMINI_WEB_CHROME_PATH=
BAOYU_CHROME_PROFILE_DIR=
HTTP_PROXY=
HTTPS_PROXY=

# X / Twitter 反向 API
X_AUTH_TOKEN=
X_CT0=
X_GUEST_TOKEN=
X_TWID=

# 微信公众号 API（baoyu-post-to-wechat API 模式）
WECHAT_APP_ID=
WECHAT_APP_SECRET=

# 微信公众号多账号配置示例：WECHAT_<ALIAS>_APP_ID / WECHAT_<ALIAS>_APP_SECRET
WECHAT_ALIAS_APP_ID=
WECHAT_ALIAS_APP_SECRET=
EOF
    print_success ".cursor/skills/.env 文件已创建"
  fi

  merge_env_file "$BAOYU_ENV_FILE" "$SKILLS_ENV_FILE"
  ensure_symlink "$BAOYU_ENV_FILE" "$BAOYU_ENV_LINK_TARGET"
  print_success ".baoyu-skills/.env 已软链到 .cursor/skills/.env"

  ensure_symlink "$BAOYU_ENV_EXAMPLE_FILE" "$BAOYU_ENV_EXAMPLE_LINK_TARGET"
  print_success ".baoyu-skills/.env.example 已软链到 .cursor/skills/.env.example"

  if [ -f "$BAOYU_IMAGE_EXTEND_FILE" ]; then
    print_success "baoyu-image-gen EXTEND.md 已存在，保留原有配置"
  else
    cat > "$BAOYU_IMAGE_EXTEND_FILE" << 'EOF'
---
version: 1
default_provider: google
default_quality: 2k
default_aspect_ratio: "16:9"
default_image_size: 2K
default_image_api_dialect: null
default_model:
  google: "gemini-3-pro-image-preview"
  openai: "gpt-image-2"
  azure: null
  openrouter: "google/gemini-3.1-flash-image-preview"
  dashscope: "qwen-image-2.0-pro"
  zai: "glm-image"
  minimax: "image-01"
  replicate: "google/nano-banana-2"
  jimeng: null
  seedream: null
  codex-cli: "codex-image-gen"
batch:
  max_workers: 10
  provider_limits:
    google:
      concurrency: 3
      start_interval_ms: 1100
    openai:
      concurrency: 3
      start_interval_ms: 1100
    azure:
      concurrency: 3
      start_interval_ms: 1100
    openrouter:
      concurrency: 3
      start_interval_ms: 1100
    dashscope:
      concurrency: 3
      start_interval_ms: 1100
    zai:
      concurrency: 3
      start_interval_ms: 1100
    minimax:
      concurrency: 3
      start_interval_ms: 1100
    replicate:
      concurrency: 5
      start_interval_ms: 700
    codex-cli:
      concurrency: 1
      start_interval_ms: 2000
---
EOF
    print_success "baoyu-image-gen EXTEND.md 文件已创建"
  fi

  print_info "统一配置文件位置: $SKILLS_ENV_FILE"
  print_info "baoyu 配置软链位置: $BAOYU_ENV_FILE"
}

# 运行健康检查
health_check() {
  print_header "运行健康检查"

  if [ -f "$SCRIPT_DIR/lion1ou-search-tools/scripts/health_check.sh" ]; then
    bash "$SCRIPT_DIR/lion1ou-search-tools/scripts/health_check.sh"
  else
    print_warning "健康检查脚本不存在"
  fi
}

# 显示帮助
show_help() {
  echo "lion1ou Skills 初始化脚本"
  echo ""
  echo "用法:"
  echo "  bash .claude/skills/init.sh [选项]"
  echo ""
  echo "选项:"
  echo "  --check-only    只检查依赖，不安装"
  echo "  --skip-python   跳过 Python 包安装"
  echo "  --skip-node     跳过 Node.js 包安装"
  echo "  --setup-env     创建 .env 配置文件"
  echo "  --health        运行健康检查"
  echo "  --help          显示此帮助信息"
  echo ""
  echo "示例:"
  echo "  bash .claude/skills/init.sh              # 完整初始化"
  echo "  bash .claude/skills/init.sh --check-only # 只检查依赖"
  echo "  bash .claude/skills/init.sh --setup-env  # 创建配置文件"
}

# 主函数
main() {
  echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║    lion1ou Skills 初始化脚本 v1.0.0    ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"

  case "${1:-}" in
    --help|-h)
      show_help
      exit 0
      ;;
    --setup-env)
      setup_env
      exit 0
      ;;
    --health)
      health_check
      exit 0
      ;;
    *)
      local check_result=0
      check_dependencies || check_result=$?

      if [ "$CHECK_ONLY" = true ]; then
        if [ $check_result -eq 0 ]; then
          print_success "所有依赖检查通过"
        else
          print_warning "部分依赖缺失"
        fi
        exit $check_result
      fi

      if [ $check_result -ne 0 ]; then
        echo ""
        read -p "是否自动安装缺失的依赖? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          install_dependencies
        fi
      fi

      # 创建配置文件（如果不存在）
      if [ ! -f "$SKILLS_ENV_FILE" ] || [ ! -f "$BAOYU_ENV_FILE" ] || [ ! -f "$BAOYU_IMAGE_EXTEND_FILE" ]; then
        setup_env
      fi

      print_header "初始化完成"
      print_success "请按需编辑 .cursor/skills/.env 配置 API Keys"
      print_info "统一配置文件位置: $SKILLS_ENV_FILE"
      print_info "baoyu 配置文件位置: $BAOYU_ENV_FILE"
      ;;
  esac
}

main "$@"
