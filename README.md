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
5. 将theme_config.yml的配置内容替换next里_config.yml的内容（不要把最后的theme版本替换掉）

然后就可以使用了
