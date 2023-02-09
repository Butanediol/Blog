---
title: 分享一个 Sublime Text 的 Quantumult X 语法高亮
date: 2020-05-17 21:48
updated: 2020-05-17 21:48
tags: Quantumult, Sublime Text, iOS
categories: 瞎折腾
index_img: /media/posts_img/6fc40dd62e7dc2f97042e31d7e8bfeb5.jpg
banner_img: /media/posts_img/6fc40dd62e7dc2f97042e31d7e8bfeb5.jpg
---

给 Sublime Text 添加 Quantumult X 的语法高亮。

<!-- more -->

下面是代码：

```yaml
%YAML 1.2
---
name: Quantumult Conf
file_extensions: [conf]
scope: source.c

contexts:
  main:
    - match: '([\w|-]+(|\s)+(?=([\=][\-]?)))'
      scope: keyword.other
    - match: '^\[.+\]'
      scope: entity.name.section
    - match: '\\/|\^|\?'
      scope: entity.name
    - match: '((https|http)?:\/\/)[^(\s)|(,)]+'
      scope: constant.character.escape
    - match: '(\#|;)(.+|$)'
      scope: comment.number-sign
```

## 用法

在 `/Users/butanediol/Library/Application Support/Sublime Text 3/Packages/User`[^1] 中新建一个 `Quantumult.sublime-syntax` 文件。

将上面的代码复制进去。

打开你的 quantumult.conf 应该就自动应用这个高亮语法了，如果没有，点击右下角的语法，选择 `Quantumult Conf`。

[^1]: 这是 macOS 的位置，Windows 或者 Linux 的在其他地方。点击设置中的 `Browse Packages...`，在打开的文件夹中双击进入 `User` 文件夹。

## 效果图

没有！
