---
title: 折腾一下自定义 CSS
keywords: CSS, pyone, onedrive, html, 博客, 美化, live2d
cover: false
top: false
author: Butanediol 丁二
date: 2020-03-28 17:36
updated: 2020-03-28 17:36
tags: 折腾, 美化, 代码, 分享
banner_img: /media/posts_img/96412aa08d0b44e90ed3780da934c279c5bb6e.jpg
index_img: /media/posts_img/96412aa08d0b44e90ed3780da934c279c5bb6e_index.jpg
summary: 许多网站例如 PyOne 和 WordPress 提供的自定义选项不多，如何在只允许修改或添加 css 和 html 代码的限制下玩出更多花样？
categories: 瞎折腾
---

学 CSS 是不可能学的，这辈子都不可能学的，只能靠 Google 和 CV 维持一下生活这样子。

<!-- more -->

## 自定义 CSS

### 修改原有样式

方法非常简单，打开你的浏览器的调试工具（我使用的是 Safari，但 Chrome 和 Firefox 的应该也差不多），可以点击网页元素选择按钮（Safari 在元素上右键，点击选择元素；Chrome 在开发者工具里点击左上角的图标）来浏览对应的 HTML 代码，也可以在 HTML 代码上滑动光标，对应的元素会随之高亮。

![](https://tva1.sinaimg.cn/large/00831rSTly1gd9soe00x4j31bg0u0e4a.jpg)

在右侧的**样式**中就可以看到对应的 CSS 代码。双击就可以修改对应的值，或者添加新的标签。

![](https://tva1.sinaimg.cn/large/00831rSTly1gd9srpz8i2j30ho0eq0va.jpg)

全部复制下来，粘贴到自定义 CSS 中即可。

### Dark Mode

现在 iOS 13、Android Q、macOS 10.15 都原生支持了 Dark Mode，只要搭配一个同样支持此功能的浏览器就可以跟随系统状态变化。

在自定义 CSS 中添加如下代码:

```CSS
@media screen and (prefers-color-scheme: dark) {
	<!-- 此处填写自定义代码 -->
}
```

把深色模式所需要变化的样式统统粘贴到大括号里，就可以实现网页深色模式跟随系统变化。

## 自定义 HTML

### Live2D 看板娘

如果你用的是 WordPress 或者 Hexo，可以通过直接安装插件的方法来获取。

但如果是 PyOne 这种比较简单的，手动安装十分麻烦。

这里我们用 iframe 的方法通过链接其他网页来实现。

#### 直接使用

个人使用的是这个 [Live2D Widget](https://github.com/stevenjoezhang/live2d-widget)

如果不需要自定义的话，只需要加入这两行自定义 HTML 代码:

```HTML
&lt;link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome/css/font-awesome.min.css">
&lt;script src="https://cdn.jsdelivr.net/gh/stevenjoezhang/live2d-widget@latest/autoload.js">&lt;/script>
```

#### 自定义

如果需要对效果进行一些更改的话，需要有一个能够保存和获取 `autoreload.js` 的地址，例如 GitHub pages 或者其他 pages 服务。

然后修改 `script` 的地址到你的文件即可。
