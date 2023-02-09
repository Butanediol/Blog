---
title: Hexo 中 Markdown 的一些小问题
keywords: Hexo, Markdown, 转义
cover: false
top: false
author: Butanediol 丁二
date: 2020-02-10 10:13
updated: 2020-02-10 10:13
toc: false
tags: Hexo, 踩坑, 小课堂
index_img: /media/posts_img/edc115f77421e0b2735b3a491a1efe9b_index.jpg
banner_img: /media/posts_img/edc115f77421e0b2735b3a491a1efe9b.jpg
summary:
categories: 写代码
---

更新：

结果发现这个并不是插件的问题。

如果代码块的语言是「存在的」，就不会有这个问题。但因为我写的语言是 'Python3'（由于我在 Mac 里是这样区分 Python 2 和 3 的），但 「Python3」 并不是 Markdown 渲染器认可的语言，所以一直出问题。

如果改为 「Python」 就能够正常渲染了。

---

昨天写 [Matplotlib 学习日记（一）](https://butanediol.github.io/2020/02/09/matplotlib-xue-xi-ri-ji-yi/) 的时候，遇到了一点小问题。

官方文档中的定义有一段用了类似 HTML 格式的标记：

```html
<class 'matplotlib.figure.Figure'>
```

Markdown 是兼容 HTML 的，这就导致浏览器将这段代码当成 HTML 来解析了。

一般来说，写在代码块里的 HTML 是不会被解析的，在[炎忍](https://blog.endureblaze.cn/)大佬的博客中测试也确实是这样，但我的博客安装了[Hexo Prism Plugin](https://github.com/ele828/hexo-prism-plugin)代码高亮插件，我推测是这个插件导致的这个问题。

于是我用转义字符的方法，将 `<` 替换成了 `&lt;`，`>` 替换成 `&gt;` 即可，就可以正常显示了。

注意，这个问题仅在大代码块（[Hexo Prism Plugin](https://github.com/ele828/hexo-prism-plugin)高亮的代码块）中会出现，行内代码则没有这个问题。
