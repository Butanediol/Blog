---
title: 意外找到一个解决 macOS 邮件不显示插件的方案
keywords: macOS, 邮件, mail, 解决, 插件, 显示, SIP
cover: false
top: false
author: Butanediol 丁二
date: 2020-03-30 13:56
updated: 2022-02-15 14:56
tags: macOS
index_img: /media/posts_img/c756481a7db7d504c0995dd42409bbed60f0d7_index.jpg
banner_img: /media/posts_img/c756481a7db7d504c0995dd42409bbed60f0d7.jpg
summary: 解决了 macOS 的邮件 app 找不到插件的问题（废话）。
categories: 瞎折腾

---

最近在寻找 [Cydia Impactor](http://www.cydiaimpactor.com/) 的替代品 ~~用来装 Ehentai-Viewer 看本子~~，找到了 [AltDeploy](https://github.com/pixelomer/AltDeploy) 这款软件。

AltDeploy 与 Cydia Impactor 外观和使用上几乎一模一样，区别是 AltDeploy 需要借助 macOS 自带的 mail.app 来完成应用签名。

按照正常的操作流程，在 AltDeploy 中点击安装插件之后，mail.app 的插件列表中应该会出现一个 AltServer，但咱这里却是空空如也，上网查找了许多解决方法都无效。

意外的，咱从一个商业软件的 FAQ 中找到了解决方法。

## 注意

{% note warning %}
   在阅读这篇方案之前，请先确保你的安装操作没有问题，并且你已经尝试了网上许多的方法但仍然无效。
{% endnote %}

### 确保你的安装过程没有出错

你可以通过在终端中启动 AltDeploy 并安装插件，查看日志并确保安装过程没有报错。

方法如下：

```sh
sudo AltDeploy.app/AltDeploy.app/Contents/MacOS/AltDeploy
```

### 确保你已经自行尝试了许多解决方案

如果没有，点击[这里](https://www.google.com/search?sxsrf=ALeKk00dhujs6vBf58OazJ8kyZCb9TXXsg:1585549594198&q=mac+mail+app+extensions+not+shown&spell=1)。

## 开始

在开始之前，根据咱的解决经验，如果你曾经操作过 macOS 的 SIP，可以考虑先查看下面的第二条。

如果你不知道 SIP 是什么，那么你大概率没有操作过，按照下面的顺序阅读即可。

### 1. 沙盒机制问题

处于沙盒的原因，mail.app 创建了一个符号链接文件夹 `~/Library/Containers/com.apple.mail/Data/Library/Mail`，它指向用户文件夹 `~/Library/Mail`。

但是 mail.app 却从 `~/Library/Containers/com.apple.mail/Data/Library/Mail` 中读取数据，而不是用户文件夹。

这个问题**多半**是由于手动或使用迁移助手更新系统，`~/Library/Containers/com.apple.mail/Data/Library/Mail` 文件夹被创建成了一个真实的文件夹，而不是一个符号链接。

通过下面两个方法来检查这个问题：

#### 检查问题
##### 用终端命令检查

```sh
ls -lad ~/Library/Containers/com.apple.mail/Data/Library/Mail
```

正常的话会返回

```sh
/Users/Username/Library/Containers/com.apple.mail/Data/Library/Mail -> ../../../../Mail
```

看不懂就用下面的方法

##### 在图形界面中检查

打开 finder.app，按下 {% kbd Command %} + {% kbd Shift %} + {% kbd G %}， 

输入 `~/Library/Containers/com.apple.mail/Data/Library` 并回车。

正常情况下，Mail 文件夹的图标上会有一个小箭头。

![](https://tva1.sinaimg.cn/large/00831rSTly1gdby8f2um7j316s0o8jxw.jpg)

#### 解决方法

如果这里出了问题，可以直接下载 [SANDBOX UTILITY APP](https://s3.amazonaws.com/media.smallcubed.com/images/support/Repair_Mail_Sandbox.zip)。
以防万一，咱在咱的 OneDrive 中也保存了一份，[点击下载](https://warehouse.butanediol.me/%E5%BA%94%E7%94%A8/Mac/Repair_Mail_Sandbox.zip?raw)。

1. 退出 mail.app
2. 解压 下载的文件
3. 授予 Repair Mail Sandbox.zip 完全硬盘访问权限。
> 打开系统偏好设置 - 安全与隐私，解锁设置，选择完全硬盘访问权限，将 Mail Sandbox.app 拖入右边的列表中，然后上锁。

![](https://tva1.sinaimg.cn/large/00831rSTly1gdbyerpzcjj31vv0u0k06.jpg)

4. 右键打开 Repair Mail Sandbox.app，按照指示进行操作。
5. 打开 mail.app 并查看插件是否出现。

如果仍然没有解决问题请继续尝试下面的方法。

---

其他两个原因与 mail.app 的 DataVaults 文件夹有关，该文件夹是在 macOS Mojave 中与 SIP 一起引入的。

DataVaults 文件夹是在首次启动时由 mail.app 创建。启用 SIP 后，这是一个隐藏文件夹，安装插件时，mail.app 会将插件的副本放入 DataVaults 文件夹中，如果该文件夹中的插件版本与 `~/Library/Mail/Bundles` 的不一致，mail.app 就不会加载这些插件，插件管理中也就不会显示这些插件。

### 2. 无法访问 DataVults 文件夹

有时从备份或通过迁移助手还原用户数据时，也会还原 DataVaults 文件夹。 但是，由于它是一个复制的文件夹，而不是由 mail.app 直接创建的文件夹，mail.app 无权访问它。 
发生这种情况时，需要删除 DataVaults 文件夹，以便下次打开邮件时可以重新创建它。

#### 操作方法

##### 关闭 SIP

重新启动你的 Mac，并在开机的时候按下 {% kbd Command%} + {% kbd R%} 进入恢复模式。

等待恢复模式加载完毕后，点击实用工具，选择终端。

在终端中输入：

```sh
csrutil disable
```

然后重新启动电脑。

##### 删除 DataVaults

打开 finder.app，按下 {% kbd Command%} + {% kbd Shift%} + {% kbd G%}， 输入

`~/Library/Containers/com.apple.mail/Data/` 并回车。

选择文件夹 `DataVaults`，然后按下 {% kbd Command%} + {% kbd Option%} + {% kbd Delete%}。

**注意：不要使用一般的删除方法，否则重新开启 SIP 时会出现问题。**

##### 重新开启 SIP

重新启动你的 Mac，并在开机的时候按下 {% kbd Command%} + {% kbd R%} 进入恢复模式。

等待恢复模式加载完毕后，点击实用工具，选择终端。

在终端中输入：

```sh
csrutil enable
```

然后重新启动电脑。

---

到这一步，咱的问题就已经解决了，但是如果你没有找到 DataVaults 文件夹，看看下面的步骤。

### 3. 没有找到 DataVaults 文件夹

在 Catalina 中，如果用户的 home 文件夹在一个单独的分区/硬盘，而不是标准的 /Users/username 文件夹中，mail.app 找不到隐藏的 DataVaults 文件夹。

那么你就需要把你的插件手动添加到 `~/Library/Containers/com.apple.mail/Data/DataVaults/MailBundles/Library/Mail/Bundles` 文件夹中。

#### 操作方法

##### 关闭 SIP

略，见上文。

##### 复制你的插件

重启 Mac 之后，打开 finder.app，按下 {% kbd Command%} + {% kbd Shift%} + {% kbd G%} 然后输入 `~/Library/Mail/Bundles`。

复制你的插件文件到 `~/Library/Containers/com.apple.mail/Data/DataVaults/MailBundles/Library/Mail/Bundles` 文件夹中。

##### 重新开启 SIP

略，见上文。

**注意，如果你的用户文件夹在一个单独的分区，每次更新插件时你都需要重复这个步骤。**
~~希望 macOS 10.16 可以修复这个问题。~~
悲报：没有 macOS 10.16 了。
喜报：有 macOS 11 和 12 了！

---

来源: [SmallCubed](https://smallcubed.com/support/scs/troubleshooting.html#no-plugin-visible)




