# lion1ou Skills 初始化指南

## 快速开始

```bash
# 1. 检查依赖状态
bash .claude/skills/init.sh --check-only

# 2. 安装所有依赖
bash .claude/skills/init.sh

# 3. 配置 API Keys
bash .claude/skills/init.sh --setup-env
```

## 文件说明

| 文件 | 用途 |
|------|------|
| `init.sh` | 初始化脚本，检查和安装依赖 |
| `init-config.json` | 配置文件，定义依赖和 API Keys |
| `.cursor/skills/.env` | 非 baoyu skills 的统一本地环境变量文件 |
| `.cursor/skills/.env.example` | 非 baoyu skills 的环境变量模板，随 Git 同步 |
| `.baoyu-skills/.env` | baoyu-skills 统一本地环境变量文件 |
| `.baoyu-skills/.env.example` | baoyu-skills 的环境变量模板，随 Git 同步 |

## 依赖清单

### 系统依赖

| 依赖 | 最低版本 | 用途 | 安装命令 |
|------|----------|------|----------|
| Node.js | 22.0+ | web-access、opencli、baoyu scripts | `brew install node` |
| Python | 3.9+ | PDF处理、网页抓取 | `brew install python3` |
| bun | - | baoyu skills 脚本运行 | `curl -fsSL https://bun.sh/install \| bash` |
| opencli | - | 智能搜索、浏览器自动化 | `npm install -g @jackwener/opencli` |
| mcporter | - | 小红书 MCP 调用 | `npm install -g mcporter` |

### 系统工具

| 工具 | 用途 | 安装命令 |
|------|------|----------|
| poppler | PDF 文本提取 | `brew install poppler` |
| qpdf | PDF 合并分割 | `brew install qpdf` |
| tesseract | OCR 文字识别 | `brew install tesseract` |

### Python 包

```bash
pip3 install pypdf pdfplumber reportlab pytesseract pdf2image 'scrapling[all]' pandas
```

### Playwright Chromium

```bash
python3 -m playwright install chromium
```

## API Keys 配置

本项目按 skill 读取习惯分流配置：

- 除 baoyu-skills 外，统一使用 `.cursor/skills/.env`。
- baoyu-skills 相关配置统一使用 `.baoyu-skills/.env`。
- 所有 `.env` 只保留本地，不随 Git 同步；Git 同步对应的 `.env.example`。

初始化脚本会在缺失时从 `.env.example` 创建本地 `.env`：

```bash
bash .claude/skills/init.sh --setup-env
```

非 baoyu 配置写入 `.cursor/skills/.env`：

```env
TAVILY_API_KEY=
TAVILY_KEY=
GITHUB_TOKEN=
XIAOHONGSHU_MCP_URL=https://xhs.n.lion1ou.tech:16666/mcp
XHS_MCP_URL=
DDG_GOOGLE_KEY=
GROQ_API_KEY=
OPENAI_API_KEY=
CDP_PROXY_PORT=3456
```

编辑 `.baoyu-skills/.env` 文件，填入 baoyu 相关 API Keys：

```env
# 生图后端任选一个或多个
GOOGLE_API_KEY=xxxxxxxxxx
OPENAI_API_KEY=sk-xxxxxxxxxx
AZURE_OPENAI_API_KEY=xxxxxxxxxx
OPENROUTER_API_KEY=xxxxxxxxxx
DASHSCOPE_API_KEY=xxxxxxxxxx
ZAI_API_KEY=xxxxxxxxxx
MINIMAX_API_KEY=xxxxxxxxxx
REPLICATE_API_TOKEN=xxxxxxxxxx
JIMENG_ACCESS_KEY_ID=xxxxxxxxxx
JIMENG_SECRET_ACCESS_KEY=xxxxxxxxxx
ARK_API_KEY=xxxxxxxxxx

# 微信公众号 API (用于 baoyu-post-to-wechat)
# 获取地址: 微信公众平台 -> 开发 -> 基本配置
WECHAT_APP_ID=wxXXXXXXXXXX
WECHAT_APP_SECRET=xxxxxxxxxx
```

## Skill 依赖关系

```
deep-research-pro
  └── lion1ou-search-tools
        ├── TAVILY_API_KEY
        ├── .cursor/skills/.env
        ├── scrapling
        └── playwright-chromium

pdf
  ├── pypdf
  ├── pdfplumber
  ├── reportlab
  ├── poppler (pdftotext)
  └── qpdf

web-access
  ├── Node.js 22+
  └── Chrome 远程调试

smart-search / opencli-*
  └── opencli

baoyu-skills
  ├── bun
  └── .baoyu-skills/.env

baoyu-image-gen
  ├── .baoyu-skills/.env
  ├── .baoyu-skills/baoyu-image-gen/EXTEND.md
  └── 至少一个生图后端:
      ├── GOOGLE_API_KEY
      ├── OPENAI_API_KEY
      ├── AZURE_OPENAI_API_KEY
      ├── OPENROUTER_API_KEY
      ├── DASHSCOPE_API_KEY
      ├── ZAI_API_KEY / BIGMODEL_API_KEY
      ├── MINIMAX_API_KEY
      ├── REPLICATE_API_TOKEN
      ├── JIMENG_ACCESS_KEY_ID + JIMENG_SECRET_ACCESS_KEY
      ├── ARK_API_KEY
      └── codex-cli: codex + bun + codex login

baoyu-post-to-wechat
  └── WECHAT_APP_ID + WECHAT_APP_SECRET
```

## 常用命令

```bash
# 检查依赖状态
bash .claude/skills/init.sh --check-only

# 完整初始化（安装依赖 + 创建配置）
bash .claude/skills/init.sh

# 只创建配置文件
bash .claude/skills/init.sh --setup-env

# 运行健康检查
bash .claude/skills/init.sh --health

# 显示帮助
bash .claude/skills/init.sh --help
```

## 首次使用流程

1. **克隆项目后**，运行初始化脚本：
   ```bash
   bash .claude/skills/init.sh
   ```

2. **配置 API Keys**：
   ```bash
   vim .cursor/skills/.env
   vim .baoyu-skills/.env
   ```

3. **验证配置**：
   ```bash
   bash .claude/skills/init.sh --check-only
   ```

4. **开始使用 skills**

## 常见问题

### Q: 如何获取 Tavily API Key？

访问 https://tavily.com 注册账号，在 Dashboard 中获取 API Key。

### Q: Chrome 远程调试如何启用？

1. 打开 Chrome
2. 地址栏输入 `chrome://inspect/#remote-debugging`
3. 勾选 "Allow remote debugging for this browser instance"
4. 可能需要重启浏览器

### Q: 如何更新依赖？

```bash
# 更新 Python 包
pip3 install --upgrade pypdf pdfplumber reportlab scrapling

# 更新 Node.js 包
npm update -g opencli mcporter

# 更新系统工具
brew upgrade poppler qpdf tesseract
```

### Q: 脚本运行失败怎么办？

1. 检查网络连接
2. 确保有足够的权限
3. 查看错误信息，手动安装失败的依赖
4. 运行 `bash .claude/skills/init.sh --check-only` 查看具体问题

## 跨环境使用

`.env` 文件不随 Git 同步。新环境下：

1. 克隆项目
2. 运行 `bash .claude/skills/init.sh`
3. 按 `.cursor/skills/.env.example` 和 `.baoyu-skills/.env.example` 填写本地密钥
4. 运行 `bash .claude/skills/init.sh --check-only` 确认依赖、登录态和 key 状态
