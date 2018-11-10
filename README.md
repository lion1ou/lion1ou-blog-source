关于Hexo备份问题，该git只备份

* source
* scaffolds
* _config.yml
* package.json
* README.md
* .npmignore
* .gitignore

安装顺序：

1. 在其他系统上使用，需要先安装hexo
2. git clone https://git.coding.net/418120186/lion1ou.git
3. 再通过 `npm install`安装所需要的插件
4. 安装主题 git clone https://github.com/iissnan/hexo-theme-next themes/next
或安装主题 git clone https://github.com/iissnan/hexo-theme-material themes/hexo-theme-material
5. 将source内的配置信息，复制粘贴到相应的配置文件中

然后就可以使用了

```shell
Usage: hexo <command>

Commands:
  clean     Remove generated files and cache.
  config    Get or set configurations.
  deploy    Deploy your website.
  generate  Generate static files.
  help      Get help on a command.
  init      Create a new Hexo folder.
  list      List the information of the site
  migrate   Migrate your site from other system to Hexo.
  new       Create a new post.
  publish   Moves a draft post from _drafts to _posts folder.
  render    Render files with renderer plugins.
  server    Start the server.
  version   Display version information.

Global Options:
  --config  Specify config file instead of using _config.yml
  --cwd     Specify the CWD
  --debug   Display all verbose messages in the terminal
  --draft   Display draft posts
  --safe    Disable all plugins and scripts
  --silent  Hide output on console
```