---
name: lion1ou-article-publish
description: >-
  当用户要发布或准备发布已经完成的渠道文章包到 Hexo 博客、微信公众号、小红书或类似渠道时使用，尤其是博客发布、Hexo 预览、deploy、公众号草稿、小红书发布包、发布前校验。不要用于写作或渠道改写，前置使用 lion1ou-article-editor 和 lion1ou-article-channel。
---

# Article Publish

发布执行 skill。它接收 `lion1ou-article-channel` 生成的渠道成品包，完成发布前校验、预览、创建草稿或确认发布。它不重写正文，不改变事实结论，不补做渠道改写。

## 安全门禁

默认行为：不公开发布。

以下动作必须在当前对话获得用户明确确认：

- 执行博客 deploy，例如 `hexo deploy` 或 `npm run d`。
- 公众号发布、群发、定时发布或任何公开可见动作。
- 小红书或其他社交平台公开发帖。
- 任何会改变远端状态的动作。

没有确认时，只能停在本地构建、预览、创建草稿或人工发布清单。

确认语必须包含目标和影响，例如：

```text
确认要将 <path> 发布到 <channel/account> 吗？这会 <具体影响>。
```

只有用户明确回复同意后才能继续。

## 边界

适用场景：

- 发布已经准备好的渠道包。
- 对博客运行构建、预览或确认后 deploy。
- 通过 `baoyu-post-to-wechat` 创建公众号草稿。
- 准备小红书发布包和人工发布清单。
- 记录发布结果。

不适用场景：

- 创建原始文章。使用 `lion1ou-article-editor`。
- 渠道改写。使用 `lion1ou-article-channel`。
- 从零生成封面图或卡片图，除非只是发布前检查发现缺失并经用户确认补齐。

## 渠道默认动作

| 渠道 | 默认动作 | 需要确认的动作 |
| --- | --- | --- |
| `blog` | `npm run b` 构建，必要时本地预览 | `npm run d` 或任何 deploy |
| `wechat` | 创建草稿或准备草稿输入 | 发布、群发、定时发布 |
| `xhs` | 输出发布包和人工清单 | 公开发帖 |

## 目录结构规范

`lion1ou-article-publish` 只处理标准文章工作区中的渠道包，除非用户明确指定其他路径。

标准工作区：

```text
articles/<YYYYMMDD>-<topic-slug>/
├── channels/
│   ├── blog/article.md
│   ├── wechat/article.md
│   ├── wechat/article.html
│   └── xhs/copy.md
├── assets/
└── publish/
```

发布阶段允许写入的位置：

```text
source/_posts/<YYYY-MM>/<YYYYMMDD>-<topic-slug>.md
articles/<YYYYMMDD>-<topic-slug>/publish/
```

路径约束：

- `articles/` 是文章生产工作区；`source/` 是 Hexo 工作目录，发布阶段只写入最终博客 Markdown。
- 图片内容只保存在生产工作区，例如 `articles/<YYYYMMDD>-<topic-slug>/assets/` 或 `channels/<channel>/assets/`，不写入 `source/`。
- 博客发布前，将 `channels/blog/article.md` 处理后写入 `source/_posts/<YYYY-MM>/<YYYYMMDD>-<topic-slug>.md`，不要直接从工作区 deploy。
- 博客 Markdown 中的本地图片必须先上传 CDN，再替换为 CDN URL；最终 `source/_posts/` 文章不引用本地工作区图片路径。
- 公众号和小红书发布记录写到工作区 `publish/` 下，不写到 `docs/` 或仓库根目录。
- 发布记录文件名使用 `publish-record-<channel>.md`。
- 覆盖最终文章、图片或发布记录前，先备份为 `<name>.backup-YYYYMMDD-HHMMSS.<ext>`。

## 博客图片 CDN 规则

博客发布必须把本地图片上传到 CDN 后再引用。默认使用七牛 Kodo 官方 Node.js SDK 的表单上传：

```text
new qiniu.rs.PutPolicy({ scope: "<bucket>:<key>" }).uploadToken(mac)
qiniu.form_up.FormUploader(config).putFile(uploadToken, key, localFile, putExtra)
```

SDK 文档：[七牛对象存储 Node.js SDK 表单上传](https://developer.qiniu.com/kodo/1289/nodejs#form-upload-file)。

### CDN 配置读取

从项目统一环境变量文件读取配置：

```text
.cursor/skills/.env
```

不要从真实 `.env` 中回显密钥值。只报告变量是否存在。

必填变量：

| 变量 | 说明 |
| --- | --- |
| `QINIU_KODO_ACCESS_KEY` | 七牛 AccessKey，用于创建 `qiniu.auth.digest.Mac` |
| `QINIU_KODO_SECRET_KEY` | 七牛 SecretKey，用于创建 `qiniu.auth.digest.Mac` |
| `QINIU_KODO_BUCKET` | Bucket 名称，用于生成上传凭证 scope |
| `QINIU_KODO_CDN_BASE_URL` | CDN 访问域名，用于拼接最终图片 URL；未写协议时按 HTTPS 处理 |

缺少任一必填变量时，停止博客发布并提示用户补齐 `.cursor/skills/.env`。不要尝试上传，也不要写入 `source/_posts/`。

上传实现要求：

| 项目 | 必填 | 说明 |
| --- | --- | --- |
| `qiniu` SDK | 是 | 必须使用官方 Node.js SDK，不手写 multipart 上传 |
| `Mac` | 是 | 使用 `qiniu.auth.digest.Mac(accessKey, secretKey)` |
| `PutPolicy` | 是 | 使用 `qiniu.rs.PutPolicy({ scope: "<bucket>:<key>" })` 生成上传凭证 |
| `FormUploader` | 是 | 使用 `qiniu.form_up.FormUploader` |
| `PutExtra` | 是 | 使用 `qiniu.form_up.PutExtra`，至少设置 `fname` |
| `putFile` | 是 | 使用 `putFile(uploadToken, key, localFile, putExtra)` 上传本地文件 |
| `key` | 是 | 显式指定 CDN 对象 Key，保持发布结果可追踪 |

Key 命名规范：

```text
articles/<YYYYMMDD>-<topic-slug>/<asset-type>/<filename>
```

CDN 映射记录写入：

```text
articles/<YYYYMMDD>-<topic-slug>/publish/cdn-map.json
```

格式：

```json
{
  "provider": "qiniu-kodo",
  "uploadedAt": "",
  "items": [
    {
      "localPath": "assets/cover/cover.png",
      "key": "articles/<YYYYMMDD>-<topic-slug>/cover/cover.png",
      "url": "https://cdn.example.com/articles/<YYYYMMDD>-<topic-slug>/cover/cover.png",
      "hash": ""
    }
  ]
}
```

发布前必须完成：

- 找出博客 Markdown 中所有本地图片引用。
- 上传缺失 CDN URL 的本地图片。
- 用 CDN URL 替换 Markdown 图片引用。
- 保存 `cdn-map.json`。
- 确认最终写入 `source/_posts/` 的 Markdown 不再引用 `articles/`、`assets/` 或本地相对图片路径。

### 上传脚本

博客图片上传和 Markdown 替换必须使用当前 skill 自带脚本，不要临时拼接 `curl`、手写 multipart 或一次性脚本：

```bash
node .cursor/skills/lion1ou-article-publish/scripts/upload_blog_images.js \
  --workspace articles/<YYYYMMDD>-<topic-slug> \
  --markdown articles/<YYYYMMDD>-<topic-slug>/channels/blog/article.md \
  --output source/_posts/<YYYY-MM>/<YYYYMMDD>-<topic-slug>.md \
  --env .cursor/skills/.env \
  --topic-slug <YYYYMMDD>-<topic-slug>
```

脚本职责：

- 读取 `.cursor/skills/.env` 中的七牛配置。
- 识别 Markdown 本地图片引用，忽略 `http`、`https`、`data:` 等远程图片。
- 使用 `QINIU_KODO_ACCESS_KEY`、`QINIU_KODO_SECRET_KEY`、`QINIU_KODO_BUCKET` 通过 SDK 生成上传凭证，不读取预生成 token。
- 通过七牛官方 Node.js SDK 的 `FormUploader.putFile` 上传本地图片到 Kodo。
- 生成或更新 `articles/<YYYYMMDD>-<topic-slug>/publish/cdn-map.json`。
- 输出已经替换为 CDN URL 的博客 Markdown。
- 如果缺少配置、图片不存在、上传失败或仍残留本地图片引用，直接失败，不写不完整结果。

验证配置和路径时可以先运行 dry-run：

```bash
node .cursor/skills/lion1ou-article-publish/scripts/upload_blog_images.js \
  --workspace articles/<YYYYMMDD>-<topic-slug> \
  --markdown articles/<YYYYMMDD>-<topic-slug>/channels/blog/article.md \
  --output /tmp/lion1ou-article-publish-preview.md \
  --env .cursor/skills/.env \
  --topic-slug <YYYYMMDD>-<topic-slug> \
  --dry-run
```

## 流程

开始后复制并维护这个进度：

```markdown
Article Publish 进度：
- [ ] 第 1 步：识别渠道包
- [ ] 第 2 步：发布前校验
- [ ] 第 3 步：选择发布模式
- [ ] 第 4 步：执行安全动作
- [ ] 第 5 步：记录结果
```

### 第 1 步：识别渠道包

可接受输入：

- `channels/blog/article.md`
- `channels/wechat/article.md`
- `channels/wechat/article.html`
- `channels/xhs/copy.md`
- 包含 `channel-meta.json` 的渠道目录。
- 用户提供的明确最终渠道成品路径。

如果输入是标准工作区根目录，自动识别其中的 `channels/`。如果输入不符合目录结构规范，先询问用户是要按原路径发布，还是整理成标准工作区后再发布。

如果存在 `channel-meta.json`，先读取：

```json
{
  "channel": "blog",
  "account": "",
  "title": "",
  "summary": "",
  "source": "../../master.md",
  "cover": "",
  "assets": [],
  "status": "adapted",
  "publishChecks": []
}
```

如果渠道不明确，先让用户选择渠道。不要猜测后直接发布。

### 第 2 步：发布前校验

通用检查：

- 标题存在且与内容匹配。
- 渠道需要摘要时，摘要存在。
- 必需图片存在，或明确标记为不需要。
- 链接、引用和二维码等元素适合目标渠道。
- 不包含草稿批注、未替换占位符、`TODO`、`待定`。
- 渠道包来自已确认母版文章，或用户明确指定当前输入就是最终版。
- 不存在明显敏感信息、密钥、内部链接或不应公开的路径。

博客检查：

- frontmatter 包含 `title`、`date`、`categories`、`tags`。
- `toc` 和 `comments` 存在，或明确不需要。
- 除非用户明确不需要，否则必须有 `<!--more-->`。
- 图片引用必须是 CDN URL，不允许引用本地生产工作区图片。
- 最终文件位于 `source/_posts/<YYYY-MM>/<YYYYMMDD>-<topic-slug>.md`。
- 本地图片仍位于 `articles/<YYYYMMDD>-<topic-slug>/` 工作区，且已有 `publish/cdn-map.json`。
- 运行构建前确认没有正在运行的重复 dev server。

公众号检查：

- 标题、摘要、作者、封面满足所选发布方式要求。
- Markdown 或 HTML 输入与 `baoyu-post-to-wechat` 的发布方式匹配。
- 本地图片存在。
- 外链处理符合渠道包设定，必要时已经转为底部引用。
- 明确是创建草稿，还是执行公开发布。

小红书检查：

- 标题候选、正文文案、标签、卡片脚本存在。
- 卡片图片存在，或人工发布清单明确说明图片顺序和缺失项。
- 文案长度适合目标发布方式。
- 不包含无法验证的功效承诺、夸大收益或平台敏感表达。

### 第 3 步：选择发布模式

根据渠道选择模式：

| 渠道 | 模式 | 说明 |
| --- | --- | --- |
| `blog` | `build` | 运行 `npm run b`，只验证生成 |
| `blog` | `preview` | 本地预览，不公开发布 |
| `blog` | `deploy` | 公开部署，必须确认 |
| `wechat` | `draft` | 创建草稿，默认推荐 |
| `wechat` | `publish` | 公开动作，必须确认 |
| `xhs` | `checklist` | 输出人工发布清单，默认推荐 |
| `xhs` | `post` | 公开发帖，必须确认 |

如果用户只说“发布”，默认先执行最安全有用的模式：博客构建、公众号草稿、小红书清单。公开动作需再次确认。

### 第 4 步：执行安全动作

#### 博客

项目脚本：

```bash
npm run b
npm run dev
npm run d
```

推荐流程：

1. 从标准工作区读取 `channels/blog/article.md`。
2. 确认或创建 `source/_posts/<YYYY-MM>/`。
3. 识别 Markdown 中的本地图片引用，并在工作区内解析真实文件路径。
4. 调用 `scripts/upload_blog_images.js` 读取七牛配置、上传图片、生成 `cdn-map.json` 并输出替换后的 Markdown。
5. 确认输出 Markdown 不包含本地图片引用。
6. 确认博客最终版已写入 `source/_posts/<YYYY-MM>/<YYYYMMDD>-<topic-slug>.md`。
7. 运行 `npm run b` 验证生成。
8. 用户需要预览时运行 `npm run dev`，并报告本地 URL。
9. 只有用户明确确认 deploy 后，才运行 `npm run d`。

存在发布前校验问题或构建失败时，不允许 deploy。

#### 公众号

使用 `baoyu-post-to-wechat`。

规则：

- 默认创建草稿，不直接发布。
- 遵守 `baoyu-post-to-wechat` 的 API、browser、remote-api 选择规则。
- 所选发布方式需要 Markdown 时，不要提前把 Markdown 转成 HTML 再传入。
- 不点击或触发公开发布按钮，除非用户明确确认。

根据下游输出报告草稿结果、media ID、草稿位置或下一步。

#### 小红书

第一版默认行为：

1. 校验 `channels/xhs/copy.md` 和卡片资产。
2. 输出最终人工发布清单，包含标题、正文、标签、图片顺序、可选 alt 文案。
3. 如果存在稳定的小红书发布自动化，使用前必须询问。
4. 未确认前不公开发帖。

人工发布清单模板：

```markdown
# 小红书发布清单

## 标题
...

## 正文
...

## 标签
...

## 图片顺序
1. ...

## 发布前确认
- [ ] 图片顺序正确
- [ ] 标签符合账号定位
- [ ] 文案没有未确认事实
```

### 第 5 步：记录结果

在工作区 `publish/` 下创建或更新发布记录：

```markdown
# 发布记录

## 目标
- 渠道：
- 账号：
- 渠道包：

## 动作
- 模式：
- 用户确认：
- 时间：

## 结果
- 状态：
- URL：
- 草稿 ID：
- 备注：

## 后续
- [下一步]
```

不适合写文件时，在完成报告中提供同样信息。

## 失败处理

- 构建失败：报告命令和第一个可行动错误，不 deploy。
- 缺少凭证或登录：停止并说明需要配置什么。
- 缺少资产：停止发布，列出具体缺失路径。
- 七牛上传缺少上传凭证、上传域名或 CDN 域名：停止博客发布，说明缺少配置。
- 图片上传失败：不要写入 `source/_posts/`，列出失败文件和错误。
- 下游 skill 只创建草稿：只能说草稿已创建，不能说已发布。
- 用户没有确认公开动作：停止在安全模式。

## 完成报告

结束时报告：

- 渠道和渠道包路径。
- 发布前校验结果。
- 实际执行动作：构建、预览、草稿、清单或发布。
- 外部动作是否获得确认。
- 可用时给出 URL、草稿 ID 或本地预览地址。
- 未解决的后续事项。

## 稳定产出检查

完成前逐项确认：

- 已识别渠道和渠道包。
- 渠道包符合目录结构规范，或用户明确确认使用非标准路径。
- 已完成通用检查和对应渠道检查。
- 未在无确认情况下执行公开发布。
- 博客最终文件写入了规范路径。
- 博客图片没有写入 `source/`，已上传 CDN 并替换为 CDN URL。
- 已生成或更新 `publish/cdn-map.json`。
- 博客 deploy 前已构建通过。
- 公众号公开动作前已二次确认。
- 小红书公开动作前已二次确认。
- 已记录结果或在报告中给出等价信息。
