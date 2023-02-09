---
title: Hello World
math: true
date: 2020-01-20 12:30
updated: 2020-01-20 12:30
top: false
summary: 丁二的开博感言
tag: Hexo,闲聊
categroy: 杂谈
---

## 正文

今天捣鼓了一中午，用 [Hexo](https://hexo.io/) 搭建了自己的博客。高中毕业之后，有许多以前想做的事情都有时间做了，比如学习 Python，还有制作一款图标包，特别是放假回家后比较无聊，最近想学着做点好恰的，于是想把做的过程记录下来，打造一个集学习、生活于一体的个人 blog，于是就有了这样的一个写博客的想法。

建好了之后，看着只有一篇 Hello World 的主页，不禁感到一阵空虚，但想一次写好几篇文章的确不太现实，所以我打算先把之前写过的一些小文章重新排版一下，转移到 hexo 博客来。~充一下门面~

所以，虽然说这篇~由 Hello World 改成的~开博感言是博客里的第一篇文章，但在时间线中可以看到还有更早的文章出现。鉴于你现在阅读的这篇感言并不怎么重要，~而且隔一段时间之后再来看说不定会很羞耻，~就让它埋没在其他的文章中吧。

顺便，由于对 hexo 和这个主题的使用还不是很熟练，为了方便之后的编辑，我把一些相关的代码片段备注在下方，这样在编辑的时候就不需要询问 Google 和查阅主题的文档了。

## 代码片段

### Hexo

```bash
hexo clean # 清除 hexo 缓存
hexo g # 等价于 hexo generate
hexo d # 等价于 hexo deploy
hexo g -d # 等价于上面两条命令
hexo new [post_name] # 新建一篇 post
hexo new page [page_name] # 新建一个 page
```

### Matery 主题

#### Front-matter 选项

| 配置选项   | 默认值                      | 描述                                                         |
| ---------- | --------------------------- | ------------------------------------------------------------ |
| title      | `Markdown` 的文件标题        | 文章标题，强烈建议填写此选项                                 |
| date       | 文件创建时的日期时间          | 发布时间，强烈建议填写此选项，且最好保证全局唯一             |
| author     | 根 `_config.yml` 中的 `author` | 文章作者                                                     |
| img        | `featureImages` 中的某个值   | 文章特征图，推荐使用图床(腾讯云、七牛云、又拍云等)来做图片的路径.如: `http://xxx.com/xxx.jpg` |
| top        | `true`                      | 推荐文章（文章是否置顶），如果 `top` 值为 `true`，则会作为首页推荐文章 |
| cover      | `false`                     | `v1.0.2`版本新增，表示该文章是否需要加入到首页轮播封面中 |
| coverImg   | 无                          | `v1.0.2`版本新增，表示该文章在首页轮播封面需要显示的图片路径，如果没有，则默认使用文章的特色图片 |
| password   | 无                          | 文章阅读密码，如果要对文章设置阅读验证密码的话，就可以设置 `password` 的值，该值必须是用 `SHA256` 加密后的密码，防止被他人识破。前提是在主题的 `config.yml` 中激活了 `verifyPassword` 选项 |
| toc        | `true`                      | 是否开启 TOC，可以针对某篇文章单独关闭 TOC 的功能。前提是在主题的 `config.yml` 中激活了 `toc` 选项 |
| mathjax    | `false`                     | 是否开启数学公式支持 ，本文章是否开启 `mathjax`，且需要在主题的 `_config.yml` 文件中也需要开启才行 |
| summary    | 无                          | 文章摘要，自定义的文章摘要内容，如果这个属性有值，文章卡片摘要就显示这段文字，否则程序会自动截取文章的部分内容作为摘要 |
| categories | 无                          | 文章分类，本主题的分类表示宏观上大的分类，只建议一篇文章一个分类 |
| tags       | 无                          | 文章标签，一篇文章可以多个标签                              |
| keywords   | 文章标题                     | 文章关键字，SEO 时需要                              |
| reprintPolicy | cc_by                    | 文章转载规则， 可以是 cc_by, cc_by_nd, cc_by_sa, cc_by_nc, cc_by_nc_nd, cc_by_nc_sa, cc0, noreprint 或 pay 中的一个 |

> **注意**:
> 1. 如果 `img` 属性不填写的话，文章特色图会根据文章标题的 `hashcode` 的值取余，然后选取主题中对应的特色图片，从而达到让所有文章都的特色图**各有特色**。
> 2. `date` 的值尽量保证每篇文章是唯一的，因为本主题中 `Gitalk` 和 `Gitment` 识别 `id` 是通过 `date` 的值来作为唯一标识的。
> 3. 如果要对文章设置阅读验证密码的功能，不仅要在 Front-matter 中设置采用了 SHA256 加密的 password 的值，还需要在主题的 `_config.yml` 中激活了配置。有些在线的 SHA256 加密的地址，可供你使用：[开源中国在线工具](http://tool.oschina.net/encrypt?type=2)、[chahuo](http://encode.chahuo.com/)、[站长工具](http://tool.chinaz.com/tools/hash.aspx)。
> 4. 您可以在文章md文件的 front-matter 中指定 reprintPolicy 来给单个文章配置转载规则

## 插件推荐

### hexo-permalink-pinyin

#### 描述

将博客永久链接中的中文编码替换为拼音。

#### 安装

```bash
npm install hexo-permalink-pinyin --save
```

#### 配置

在博客设置 `_config.yml` 中：

```yml
permalink_pinyin:
	enable: true
	seperator: '-'
```

> `enbable` 启用开关
> `seperator` 分隔符，默认为`-`

### hexo-reference

#### 描述

为 Hexo 的 Markdown 渲染器添加脚注功能。

#### 安装

```bash
npm install hexo-reference --save
```

无需额外配置

### hexo-filter-flowchart

#### 描述

为 Hexo 的 Markdown 渲染器添加流程图功能。

#### 安装

```bash
npm install hexo-filter-flowchart --save
```

无需额外配置

例子：

```flow
st=>start: 闹钟响起
op=>operation: 与床板分离
cond=>condition: 分离成功?
e=>end: 快乐的一天

st->op->cond
cond(yes)->e
cond(no)->op
```

### hexo-tag-kbd

#### 描述

为 Hexo 的 Markdown 渲染器添加 keyboard 渲染功能。

#### 安装 

```bash
npm install hexo-tag-kbd@latest --save
```

无需额外配置

例子：

```markdown
Press {% kbd Command%} + {% kbd Q%} to quit.
```

Press {% kbd Command%} + {% kbd Q%} to quit.


{% note primary %}

{% endnote %}




