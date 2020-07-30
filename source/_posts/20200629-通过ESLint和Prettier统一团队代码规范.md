---
title: 通过ESLint和Prettier统一团队代码规范.
toc: true
comments: true
categories: 前端技术
tags: JavaScript
date: 2020-06-23 12:56:08
---

随着业务的需求的增加，前端项目也越来越多，项目之间的代码风格也不尽相同。如果一个项目涉及多个同学维护的话，那这个项目的代码风格就会比较糟糕了。而且有的同学本地可能用了格式化插件，所以保存之后会造成整个文件的代码被格式化，其实可能只修改了一行代码。这样在做合并代码 review 时，很容易就会被忽略，也失去了 review 的意义。

<!--more-->

另外每个项目的创建时间不同，所以也造成了各个项目之间的 eslint 规范配置也不同。有的项目验证了结尾带“;”，有的项目验证了使用单引号，所以同一个人在开发不同项目时也很难使用一些快捷的格式化插件。还有因为有的项目 eslint 的缺失，也隐藏了很多低级错误在代码中。这无形之中给项目埋下了不定时炸弹。

其实之前也做过一次代码规范统一的事情，其实只是做了一些配置的改变，没有做到一些限制的措施，这样其实提高了开发同学的开发成本，也很难通过开发同学自觉遵守规范，而做到比较好的效果。

接下来我会从以下几个方面来讲讲：

1. eslint 包之间的依赖介绍
2. 怎么解决，通过 prettier 美化代码格式，通过 eslint 规范代码风格，避免低级 bug
3. eslint 版本规范选择，各类项目(vue/vue cli3、rn、react)需要的 eslint 依赖和插件，eslintrc 的配置
4. 如何降低各个项目配置 eslint 成本？
5. vscode 配置，支持保存时自动格式化
6. 避免未格式化代码被提交到代码库，提交前自动执行 fix 和校验

## ESLint 生态依赖包

### 基础

- eslint: lint 代码的主要工具，所以的一切都是基于此包

  - eslint 可以安装在当前项目中，局部安装：`npm install eslint --save-dev`，使用`./node_modules/.bin/eslint *.js`命令本地运行，插件安装在项目目录（推荐）
  - eslint 可以安装在根目录下，全局安装：`npm install eslint --global`，使用`eslint *.js` 命令全局运行，所有的插件都是要安装在根目录

### 解析器

- Esprima
- Babel-ESLint - 一个对 Babel 解析器的包装，使其能够与 ESLint 兼容。
- @typescript-eslint/parser - 将 TypeScript 转换成与 estree 兼容的形式，以便在 ESLint 中使用。

### 扩展的配置

- eslint-config-airbnb: 该包提供了所有的 Airbnb 的 ESLint 配置，作为一种扩展的共享配置，你是可以修改覆盖掉某些不需要的配置的，该工具包包含了 react 的相关 Eslint 规则(eslint-plugin-react 与 eslint-plugin-jsx-a11y)，所以安装此依赖包的时候还需要安装刚才提及的两个插件

- eslint-config-airbnb-base: 与上一个包的区别是，此依赖包不包含 react 的规则，一般用于服务端检查。

- eslint-config-prettier: 将会禁用掉所有那些非必须或者和 prettier 冲突的规则。这让您可以使用您最喜欢的 shareable 配置，而不让它的风格选择在使用 Prettier 时碍事。请注意该配置只是将规则 off 掉,所以它只有在和别的配置一起使用的时候才有意义。

- eslint-config-standard: 是一个标准配置，旨在让所有开发者不需要维护 .eslintrc, .jshintrc, or .jscsrc

### 插件

- eslint-plugin-babel: 和 babel-eslint 一起用的一款插件.babel-eslint 在将 eslint 应用于 Babel 方面做得很好，但是它不能更改内置规则来支持实验性特性。eslint-plugin-babel 重新实现了有问题的规则，因此就不会误报一些错误信息

- eslint-plugin-import: 该插件想要支持对 ES2015+ (ES6+) import/export 语法的校验, 并防止一些文件路径拼错或者是导入名称错误的情况

- eslint-plugin-promise：promise 规范写法检查插件，附带了一些校验规则。

- eslint-plugin-jsx-a11y: 该依赖包专注于检查 JSX 元素的可访问性。

- eslint-import-resolver-webpack: 可以借助 webpack 的配置来辅助 eslint 解析，最有用的就是 alias，从而避免 unresolved 的错误

- eslint-import-resolver-typescript：和 eslint-import-resolver-webpack 类似，主要是为了解决 alias 的问题

- eslint-plugin-react: React 专用的校验规则插件.

- eslint-plugin-jest: Jest 专用的 Eslint 规则校验插件.

- eslint-plugin-prettier: 该插件辅助 Eslint 可以平滑地与 Prettier 一起协作，并将 Prettier 的解析作为 Eslint 的一部分，在最后的输出可以给出修改意见。这样当 Prettier 格式化代码的时候，依然能够遵循我们的 Eslint 规则。如果你禁用掉了所有和代码格式化相关的 Eslint 规则的话，该插件可以更好得工作。所以你可以使用 eslint-config-prettier 禁用掉所有的格式化相关的规则(如果其他有效的 Eslint 规则与 prettier 在代码如何格式化的问题上不一致的时候，报错是在所难免的了)

- @typescript-eslint/eslint-plugin：Typescript 辅助 Eslint 的插件。

### Prettier

- prettier：是一个代码格式化工具，相比于 ESLint 中的代码格式规则，它提供了更少的选项，但是却更加专业。

几个工具之间的关系是：prettier 是最基础的，然后你需要用 eslint-config-prettier 去禁用掉所有和 prettier 冲突的规则，这样才可以使用 eslint-plugin-prettier 去以符合 eslint 规则的方式格式化代码并提示对应的修改建议。

### 辅助优化流程

- Husky 能够帮你阻挡住不好的代码提交和推送。是一个 git 钩子工具，我们这里主要用 pre-commit 钩子。通俗点讲就是 husky 可以在你 commit 之前帮你做一些事情。

- lint-staged：在你提交的文件中，执行自定义的指令。自定义指令可以是你 eslint 相关，也可以是其他命令

```bash
npm i -D husky lint-staged
```

注： 安装的时候要注意下版本，本人就是没有注意版本，在安装 0.14.3 的 husky，造成一直不能成功调用，配置文件信息。后来才发现，husky 之后的版本才可以用，之前的版本是使用 script 配置中的 percommit 来调用的。

- 配置 husky、lint-staged，在`package.json`文件中添加如下配置：

```json
"husky": {
  "hooks": {
    "pre-commit": "lint-staged"
  }
},
"lint-staged": {
  "**/*": [
    "eslint --fix",
    "git add"
  ]
}
```

然后就可以修改一个文件，再去 commit 代码。这个时候在 commit 之前，命令行就会执行 lint-staged 指令，去 eslint --fix 刚刚修改的文件。

注：这里也要注意，只会修改你当前发生修改的文件，没有发生修改的文件是不会执行 eslint --fix 命令的。 再安装后，想首次全部 eslint --fix，那只能先手动执行`./node_modules/.bin/eslint --fix --ext .js ./src`

问题记录：按照上述步骤安装完之后，发现还是执行不成功。不会根据配置文件完成预定目标。

后来找了很久才发现，是因为他的原理造成的。

通过查看源码可以看到，在安装 husky 的时候，husky 会根据 package.json 里的配置，在.git/hooks 目录生成所有的 hook 脚本（如果你已经自定义了一个 hook 脚本，husky 不会覆盖它）问题就出在这里，因为我之前安装过老版本的 husky，所以在 .git/hooks/ 文件夹内保留了之前的 hooks 配置。

这里有两个办法解决：

1. 通过 `npm uninstall -D husky` 卸载后，重新安装 `npm i -D husky`
2. 手动删除 .git/hooks/\* 目录下的所有文件，在重新安装 `npm i -D husky`

## ESLint 配置说明

使用 JavaScript、JSON 或者 YAML 文件为整个目录（处理你的主目录）和它的子目录指定配置信息。可以配置一个独立的 .eslintrc.js 文件，或者直接在 package.json 文件里的 eslintConfig 字段指定配置，ESLint 会查找和自动读取它们，再者，你可以在命令行运行时指定一个任意的配置文件。

### env

指定脚本的运行环境。每种环境都有一组特定的预定义全局变量。

- browser - 浏览器环境中的全局变量。
- node - Node.js 全局变量和 Node.js 作用域。
- commonjs - CommonJS 全局变量和 CommonJS 作用域 (用于 Browserify/WebPack 打包的只在浏览器中运行的代码)。
- shared-node-browser - Node.js 和 Browser 通用全局变量。
- es6 - 启用除了 modules 以外的所有 ECMAScript 6 特性（该选项会自动设置 ecmaVersion 解析器选项为 6）。

更多配置：[specifying-environments](https://cn.eslint.org/docs/user-guide/configuring#specifying-environments)

### extends

用于指定需要配置文件的路径、可配置模块的名称、 eslint:recommended 或 eslint:all

ESLint 递归地扩展配置，因此基本配置也可以具有 extends 属性。extends 属性值可以省略包名的前缀 `eslint-config-`。

可配置模块 是一个 npm 包，它输出一个配置对象。要确保这个包安装在 ESLint 能请求到的目录下。

### plugins

插件 是一个 npm 包，通常输出规则。一些插件也可以输出一个或多个命名的 配置。要确保这个包安装在 ESLint 能请求到的目录下。

plugins 属性值 可以省略包名的前缀 `eslint-plugin-`。

### parser

默认 ESlint 使用 Espree 作为解析器，但是一旦我们使用 babel 的话，我们需要用 babel-eslint。

### parserOptions

ESLint 允许你指定你想要支持的 JavaScript 语言选项。默认情况下，ESLint 支持 ECMAScript 5 语法。

可用的选项有：

- ecmaVersion - 默认设置为 3，5（默认）， 你可以使用 6、7、8、9 或 10 来指定你想要使用的 ECMAScript 版本。你也可以用使用年份命名的版本号指定为 2015（同 6），2016（同 7），或 2017（同 8）或 2018（同 9）或 2019 (same as 10)
- sourceType - 设置为 "script" (默认) 或 "module"（如果你的代码是 ECMAScript 模块)。
- ecmaFeatures - 这是个对象，表示你想使用的额外的语言特性:
  - globalReturn - 允许在全局作用域下使用 return 语句
  - impliedStrict - 启用全局 strict mode (如果 ecmaVersion 是 5 或更高)
  - jsx - 启用 JSX
  - experimentalObjectRestSpread - 启用实验性的 object rest/spread properties 支持。(重要：这是一个实验性的功能,在未来可能会有明显改变。 建议你写的规则 不要 依赖该功能，除非当它发生改变时你愿意承担维护成本。)

### rules

自定义规则，可以覆盖掉 extends 的配置。

- "off" 或 0 - 关闭规则
- "warn" 或 1 - 开启规则，使用警告级别的错误：warn (不会导致程序退出)
- "error" 或 2 - 开启规则，使用错误级别的错误：error (当被触发的时候，程序会退出)

### globals

当访问当前源文件内未定义的变量时，no-undef 规则将发出警告。如果你想在一个源文件里使用全局变量，推荐你在 ESLint 中定义这些全局变量，这样 ESLint 就不会发出警告了。你可以使用注释或在配置文件中定义全局变量。

## 不同项目配置

### 基础配置

因为我们使用 prettier 作为默认格式化工具，所以每种项目都需要安装 prettier 相关依赖：

```
npm i -D -E prettier eslint-plugin-prettier  eslint-config-prettier
```

- 推荐配置项，新建 `.prettierrc.js` 文件

```js
module.exports = {
  // 一行最多 200 字符
  printWidth: 200,
  // 使用 2 个空格缩进
  tabWidth: 2,
  // 不使用缩进符，而使用空格
  useTabs: false,
  // 行尾不需要分号
  semi: false,
  // 使用单引号
  singleQuote: true,
  // 对象的 key 仅在必要时用引号
  quoteProps: "as-needed",
  // jsx 不使用单引号，而使用双引号
  jsxSingleQuote: false,
  // 末尾不需要逗号
  trailingComma: "none",
  // 大括号内的首尾需要空格
  bracketSpacing: true,
  // jsx 标签的反尖括号不需要换行
  jsxBracketSameLine: true,
  // 箭头函数，只有一个参数的时候，也需要括号
  arrowParens: "always",
  // 每个文件格式化的范围是文件的全部内容
  rangeStart: 0,
  rangeEnd: Infinity,
  // 不需要写文件开头的 @prettier
  requirePragma: false,
  // 不需要自动在文件开头插入 @prettier
  insertPragma: false,
  // 使用默认的折行标准
  proseWrap: "preserve",
  // 根据显示样式决定 html 要不要折行
  htmlWhitespaceSensitivity: "css",
  // 换行符使用 lf
  endOfLine: "lf",
};
```

执行 `npx prettier --write src/index.js` 测试是否可用

因为这里我们选择统一为 standard 规范，所以需要安装 standard 相关依赖

- 安装 eslint standard 相关

```
npm i -D eslint babel-eslint eslint-config-standard eslint-plugin-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise
```

### react-native 项目

- 安装 eslint 相关

```
npm i -D eslint-plugin-jsx-a11y eslint-plugin-react eslint-plugin-react-native
```

- eslint 配置

```json
module.exports = {
  "env": {
    "browser": true,
    "es6": true,
    "amd": true
  },
  "extends": ["eslint:recommended", "standard", "plugin:prettier/recommended", "plugin:react-native/all"],
  "parser": "babel-eslint",
  "parserOptions": {
    "ecmaFeatures": {
      "experimentalObjectRestSpread": true,
      "jsx": true
    },
    "sourceType": "module"
  },
  "plugins": [
    "react",
    "react-native"
  ],
  "rules": {
    'no-prototype-builtins': 0,
    'prefer-promise-reject-errors': 0,
    'no-async-promise-executor': 0,
    'no-misleading-character-class': 0,
    'no-useless-catch': 0,
    "no-console": 0,
    "react/jsx-uses-react": 0,
    "react/jsx-uses-vars": 0,
    "react-native/no-inline-styles": 0,
    "react-native/sort-styles": 0
  }
};
```

### Vue 项目

- 安装 eslint 相关

```
npm i -D  eslint-plugin-vue
```

- eslint 配置

```json
"eslintConfig": {
  "root": true,
  "env": {
    "node": true,
    "browser": true,
    "es6": true,
  },
  "extends": [
    // 顺序有关系，层层覆盖
    "eslint:recommended",
    "plugin:vue/strongly-recommended",
    "standard",
    "plugin:prettier/recommended"
  ],
  "rules": {
    "vue/max-attributes-per-line": 0,
    "vue/singleline-html-element-content-newline": 0,
    "vue/html-self-closing": 0,
    "no-console": 0,
    "no-undef": 0
  },
  "parserOptions": {
    "parser": "babel-eslint"
  }
}
```

## 配置 VSCode

1. 安装插件 Prettier - Code formatter

2. 修改配置项

```json
"[javascript]": {
 "editor.defaultFormatter": "esbenp.prettier-vscode"
},
"[vue]": {
 "editor.defaultFormatter": "esbenp.prettier-vscode"
},
"editor.codeActionsOnSave": null,
"editor.formatOnSave": true
```

3. 这样就可以在保存代码时，进行自动格式化了

## 排除特定文件

有时候我们还是会存在一些文件是不需要格式化和 eslint 验证的，比如外部 js 文件，图片文件，其他静态资源文件。

这样大家可以在文件目录下添加 ignore 文件：

.prettierignore

```
src/assets/*
```

.eslintignore

```
src/assets/*
```

## Vue 项目 统一配置方式

```bash
npm i -D -E prettier eslint-plugin-prettier  eslint-config-prettier
npm i -D eslint babel-eslint eslint-config-standard eslint-plugin-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise eslint-plugin-vue husky lint-staged
```

```json
 "eslintConfig": {
    "root": true,
    "env": {
       "node": true,
       "browser": true,
       "es6": true,
    },
    "extends": [
      "eslint:recommended",
      "plugin:vue/strongly-recommended",
      "standard",
      "plugin:prettier/recommended"
    ],
    "rules": {
      "vue/max-attributes-per-line": 0,
      "vue/singleline-html-element-content-newline": 0,
      "vue/html-self-closing": 0,
      "no-console": 0,
      "no-undef": 0
    },
    "parserOptions": {
      "parser": "babel-eslint"
    }
  },
  "prettier": {
    "printWidth": 200,
    "tabWidth": 2,
    "useTabs": false,
    "semi": false,
    "singleQuote": true,
    "quoteProps": "as-needed",
    "jsxSingleQuote": false,
    "trailingComma": "none",
    "bracketSpacing": true,
    "jsxBracketSameLine": true,
    "arrowParens": "always",
    "requirePragma": false,
    "insertPragma": false,
    "proseWrap": "preserve",
    "htmlWhitespaceSensitivity": "css",
    "endOfLine": "lf"
  },
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged"
    }
  },
  "lint-staged": {
    "src/**/*": [
      "prettier --write",
      "eslint --fix",
      "git add"
    ]
  }
```
