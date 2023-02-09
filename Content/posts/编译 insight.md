---
title: 编译 insight
description: 编译一个老项目有许多依赖上的问题，防止我下次用到的时候忘记，把过程记在这里。
keywords: insight, gdb, arm-none-eabi-insight, debugger
cover: false
top: false
author: Butanediol 丁二
date: 2022-02-25 11:03
updated: 2022-02-25 11:03
tags: 笔记, Linux, 踩坑
index_img: /media/posts_img/compile_insight_index.jpg
banner_img: /media/posts_img/compile_insight.jpg
summary: 如何构建 insight。
categories: 瞎折腾
---

环境：`Ubuntu 20.04.3 LTS`

### 安装依赖

`sudo apt install autoconf autogen texinfo flex bison python2.7-dev tcl-dev tk-dev itcl3-dev itk3-dev iwidgets4`

为了运行，你至少需要安装 `tcl-dev tk-dev itcl3-dev itk3-dev iwidgets4`

### 获取源码

`git clone --recursive git://sourceware.org/git/insight.git`

### 宿主机（包含模拟器）
```bash
autoconf
./configure --prefix=/opt/insight/. --disable-binutils --disable-elfcpp --disable-gas --disable-gold --disable-gprof --disable-ld --disable-rpath --disable-zlib --enable-sim --with-expat --with-python=/usr/bin/python2 --without-libunwind --with-tcl=/usr/lib/ --with-tk=/usr/lib/
make
sudo make install
```

该选项编译出的 insight 是与编译机相同架构，支持模拟器的版本。

{% note warning %}
这里主要的问题就是找不到 python，必须手动指定 python 的位置。
{% endnote %}

### Target
```bash
./configure --prefix=/opt/arm-none-eabi-insight/. --target=arm-none-eabi --disable-binutils --disable-elfcpp --disable-gas --disable-gold --disable-gprof --disable-ld --disable-rpath --disable-zlib --enable-sim --with-expat --with-python --without-libunwind --with-tcl=/usr/lib/ --with-tk=/usr/lib/
```

编译完成后，就可以在 `/opt/insight/` 或者 `/opt/arm-none-eabi-insight/` 找到编译好的 insight 了。