---
title: 使用 restic 备份 Minecraft 存档
description: 果然，还是让 git 做它的本职工作就好了。
keywords: restic, Minecraft, rclone, backup
cover: false
top: false
author: Butanediol 丁二
date: 2022-08-09 12:00
updated: 2022-08-09 12:00
tags: 笔记, Linux, 踩坑
index_img: /media/posts_img/restic_backup_mc_index.jpg
banner_img: /media/posts_img/restic_backup_mc.jpg
summary: 使用 restic 备份 Minecraft 存档。
categories: 瞎折腾
---

最近开始玩 AOF5，为了开服方便，就把服务端的文件放在了一个 exFAT 的硬盘上，这样无论哪个系统都可以访问，而且因为 Minecraft 运行在 Java 虚拟机中，各 OS 下也都可以直接运行，方便极了——

——直到存档损坏之前。

当然我早就料到这一天，提前做了备份，但也促使我寻求一个持续备份的方法。

首先想到的就是 git

## Git 的问题

老实说，Git 啥毛病妹有，它可以追踪每一个版本的变化、可以不停服提交、可以增量备份，简直是备份 Minecraft 存档的完美工具。但是，正因为它要追踪每个版本，导致仓库体积膨胀十分迅速。

![快速膨胀的仓库](/media/article_img/restic_backup_mc/1.png)

这个大小显然不能用在线的 git 托管服务了，无论是 GitHub、GitLab 还是 Gitea 都限制仓库大小，通常不超过 500 MB。

所以我自建了 Git 托管服务，但如上图所见，这个膨胀速度也不是我服务器的小硬盘可以承受的。
~~可恶，最终还是败给了钱~~。

但我备份 Minecraft 存档的目的其实是为了防止存档损坏丢失，版本追踪以方便回档只是附加作用，其实我并不需要保留那么多版本。

那我们是不是只需要删除旧的 commit 就可以了？Git 删除旧提交的操作较为繁琐，并且也不一定会删除旧有记录的文件，仓库的体积并不会缩小太多。

于是我找到了 restic。

## Restic 好在哪？

- 支持本地和多种云端存储
- 可以轻松删除旧版本

## Get Started

### Installation

Restic 在各大 Linux 发行版的包管理器中基本都可以直接下载，如果你用的 Windows 或包管理器中真的没找到，查看 [restic 官方手册](https://restic.readthedocs.io/en/latest/020_installation.html)。

### Init repo

Restic 中，备份是保存在一个 repo 里的。所以我们需要先初始化一个 repo。

Repo 可以保存在许多地方，本机或远程均可。它支持多种协议，甚至可以通过 rclone 来创建 repo，极大扩充了可选项。

这里因为我刚好有运行一个 aliyun 的 webdav，并且添加到了 rclone，所以就使用 rclone 作为存储。

```bash
# 使用 restic -r rclone:<REMOTE>:<PATH> init 创建 repo
restic -r rclone:aliyun:/restic init
```

接下来会提示你输入仓库的密码，请牢记这个密码，否则所有数据将会永久丢失。

{% note info %}
关于如何使用 rclone 不是本文的重点，所以略过。
{% endnote %}

### Backup

仓库创建后，备份就很简单了：

```bash
# 使用 restic -r <REPO> backup <LOCAL_PATH> 来备份本地目录到 repo
restic -r rclone:aliyun:/restic backup ~/AOF5-server
```

稍等一会

```txt
butanediol@minecraft ~ % restic -r rclone:aliyun:/restic --verbose backup ~/AOF5-server
open repository
enter password for repository:
repository 36058ab2 opened successfully, password is correct
created new cache in /home/butanediol/.cache/restic
lock repository
rclone: 2022/08/09 11:35:11 ERROR : locks: error listing: directory not found
load index files
rclone: 2022/08/09 11:35:12 ERROR : index: error listing: directory not found
rclone: 2022/08/09 11:35:12 ERROR : snapshots: error listing: directory not found
start scan on [/home/butanediol/AOF5-server]
start backup on [/home/butanediol/AOF5-server]
scan finished in 1.687s: 4849 files, 1.355 GiB
uploaded intermediate index ac109866

Files:        4849 new,     0 changed,     0 unmodified
Dirs:            2 new,     0 changed,     0 unmodified
Data Blobs:   3950 new
Tree Blobs:      3 new
Added to the repo: 1.352 GiB

processed 4849 files, 1.355 GiB in 3:53
snapshot f94532ca saved
```

备份完成了！

### Scheduled Backup

如果你愿意，你当然可以每次手动运行备份。但我们更希望它自动定期运行。

Restic 本身并没有提供定时运行的方法，我们可以借助 `cron` 等来定时运行备份。（Windows 可以用 Task Scheduler）

最简单的方法就是创建一个脚本

```bash
export RESTIC_REPOSITORY=<REPO>
export RESTIC_PASSWORD="<YOUR_PASSWORD>"
restic backup <LOCAL_PATH>
```

然后添加到 cron 就可以了。

### Restore from Backup

首先查看可用的快照

```bash
restic snapshots -r <REPO>
```

然后选择一个快照进行恢复

```bash
restic -r <REPO> restore <ID> --target <LOCAL_PATH>
```

### Remove old snapshots

要在 restic 中删除一份快照有两步。

1. `forget`

```bash
restic -r <REPO> forget <ID>
```

“忘记”一份快照之后，它将不在快照列表中出现，但是这份文件还在 repo 中，要删除这份文件则需要进行第二歩

2. `prune`

```bash
restic -r <REPO> prune
```

当然你也可以进行二合一操作：

```bash
restic -r <REPO> forget <ID> --prune
```

#### Removing snapshots according to a policy

restic 提供了很多删除快照的策略，正是这一功能让我选择了 restic。

要选用一种策略，只需要在运行 `forget` 的时候加上一个参数。例如：

- `--keep-last n` 可以保留最近的 `n` 次快照。
- `--keep-daily n` 可以保留最近 `n` 天内的快照。

手册内还提供了[更多策略](https://restic.readthedocs.io/en/latest/060_forget.html#removing-snapshots-according-to-a-policy)，此处不一一列举。