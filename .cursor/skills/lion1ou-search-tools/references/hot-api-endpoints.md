# 脚本参数参考

## crawl-hot.js

```bash
node scripts/hot/crawl-hot.js [--platform=<platform>]
```

| 参数 | 可选值 | 默认值 | 说明 |
|------|--------|--------|------|
| `--platform` | `douyin`, `weibo`, `baidu`, `bilibili`, `kuaishou`, `all` | `all` | 指定采集的平台 |

### 示例

```bash
# 只获取抖音热搜
node scripts/hot/crawl-hot.js --platform=douyin

# 获取全部平台热搜
node scripts/hot/crawl-hot.js
```

---

## crawl-music.js

```bash
node scripts/hot/crawl-music.js [--platform=<platform>] [--type=<type>]
```

| 参数 | 可选值 | 默认值 | 说明 |
|------|--------|--------|------|
| `--platform` | `qq`, `wangyi`, `kugou`, `kuwo`, `all` | `all` | 指定音乐平台 |
| `--type` | `hot`, `rising`, `all` | `all` | 热歌榜 / 飙升榜 |

### 示例

```bash
# QQ音乐热歌榜
node scripts/hot/crawl-music.js --platform=qq --type=hot

# 网易云飙升榜
node scripts/hot/crawl-music.js --platform=wangyi --type=rising

# 全部平台全部榜单
node scripts/hot/crawl-music.js
```

---

## crawl-entertainment.js

```bash
node scripts/hot/crawl-entertainment.js [--type=<type>]
```

| 参数 | 可选值 | 默认值 | 说明 |
|------|--------|--------|------|
| `--type` | `movie`, `tv`, `web`, `variety`, `game_free`, `game_paid`, `app_free`, `app_paid`, `all` | `all` | 指定数据类型 |

### 示例

```bash
# 电影票房
node scripts/hot/crawl-entertainment.js --type=movie

# App Store 免费游戏
node scripts/hot/crawl-entertainment.js --type=game_free

# 全部数据
node scripts/hot/crawl-entertainment.js
```

---

## crawl-paper.js

```bash
node scripts/hot/crawl-paper.js [--date=<date>] [--pages=<pages>]
```

| 参数 | 可选值 | 默认值 | 说明 |
|------|--------|--------|------|
| `--date` | `today`, `yesterday`, `YYYY-MM-DD` | `today` | 指定人民日报日期 |
| `--pages` | `1,2,3` | 全部 | 指定版面编号 |

### 示例

```bash
# 今日人民日报全部版面
node scripts/hot/crawl-paper.js

# 昨日人民日报
node scripts/hot/crawl-paper.js --date=yesterday

# 指定日期头版
node scripts/hot/crawl-paper.js --date=2026-03-10 --pages=1
```

## 通用输出格式

所有脚本输出 JSON 到 stdout：

```json
{
  "status": "ok",
  "results": {
    "<key>": {
      "success": true,
      "label": "描述文本",
      "data": {
        "sj": [...],
        "time": "YYYY-MM-DD HH:mm:ss"
      },
      "count": 50
    }
  }
}
```

错误时：

```json
{
  "status": "error",
  "message": "错误描述"
}
```
