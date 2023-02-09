---
title: 删除 MongoDB 和 Linux Journal 日志
date: 2020-07-08 20:13
updated: 2020-07-08 20:13
tags: Linux, MongoDB, Log, VPS
categoires: 瞎折腾
index_img: /media/posts_img/clean_log_index.jpg
banner_img: /media/posts_img/clean_log.jpg
---

咱的 PyOne 服务器空间越来越小，是谁膨胀了？

<!-- more -->

## MongoDB

PyOne 使用了 MongoDB 数据库，这东西的日志文件在 `/var/log/mongodb` 下。

一个月下来，MongoDB 的日志文件竟然有 `4.6 GiB`！

![MongoDB 日志文件](/media/article_img/clean_log/1.jpg)

要安全删除这个文件，首先要切割日志（`logrotate`）。

### 切割日志

先进入 mongo 命令行：

```sh
mongo
```

然后用下面的命令切割日志：

```mongo
> use admin
> db.adminCommand( { logRotate: 1 } )
```

如果输出是这样的：

```mongo
{ "ok" : 1 }
```

就切割成功了。

### 删除

去到 `/var/log/mongodb` 下，删除 `mongod.log.xxxx-xx-xxxxx-xx-xx` 文件即可。

## Journal 日志

Journal 日志服务生成的日志文件在 `/var/log/journal` 文件夹下。

但可以通过 `journalctl --disk-usage` 命令直接查看日志大小。

比如：

```sh
journalctl --disk-usage
# Archived and active journals take up 16.0M in the file system.
```

### 删除

可以先直接删除日志文件：

```sh
ls /var/log/journal/
# e49796b61b294856bb739446b8ba124d

sudo rm -rf /var/log/journal/e49796b61b294856bb739446b8ba124d/
```

### 自动维护文件大小

#### 按时间

保留最近两周的日志：

```sh
journalctl --vacuum-time=2w
```

#### 按大小

保留 `128 MB` 大小的日志：

```sh
journalctl --vacuum-size=128M
```
