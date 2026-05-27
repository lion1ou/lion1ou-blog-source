# xiaohongshu-mcp 下载渠道

`xhs` 搜索源依赖 `mcporter` 调用 `xiaohongshu-mcp` 服务。优先选择官方仓库；GitHub 访问慢或下载失败时，可切换到以下镜像渠道。

当前默认使用远程 MCP 端点：`https://xhs.n.lion1ou.tech:16666/mcp`。如需切换环境，在当前 skill 目录的 `.env` 中设置 `XIAOHONGSHU_MCP_URL`。

登录态检查：

```bash
mcporter call https://xhs.n.lion1ou.tech:16666/mcp.check_login_status --timeout 30000 --output json
```

获取登录二维码：

```bash
mcporter call https://xhs.n.lion1ou.tech:16666/mcp.get_login_qrcode --timeout 30000 --output json
```

## 推荐顺序

1. 官方 GitHub 仓库：<https://github.com/xpzouying/xiaohongshu-mcp>
2. 官方 GitHub Releases：<https://github.com/xpzouying/xiaohongshu-mcp/releases>
3. SourceForge 镜像：<https://sourceforge.net/projects/xiaohongshu-mcp.mirror/>
4. Gitee 镜像：<https://gitee.com/boomer001/xiaohongshu-mcp>

## 选择建议

- 需要预编译二进制包时，优先使用 GitHub Releases；下载不稳定时使用 SourceForge 镜像的文件页。
- 需要在国内网络查看源码或克隆仓库时，可以使用 Gitee 镜像。
- Gitee 镜像页面说明其来源为 `https://github.com/xpzouying/xiaohongshu-mcp`，使用前仍应以官方仓库的 README 和 release 说明为准。
- 项目 README 还提到 `xpzouying/x-mcp` 浏览器插件方案，适合不想部署 `xiaohongshu-mcp` 服务的环境。
