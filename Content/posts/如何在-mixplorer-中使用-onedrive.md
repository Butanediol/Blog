---
title: 如何在 Mixplorer 中使用 OneDrive？
keywords: onedrive, business, mixplorer, azure, office, a1, e3, for
cover: true
top: true
author: Butanediol 丁二
date: 2020-02-15 21:51
updated: 2020-02-15 21:51
tags: 小课堂, Android, 玩机
index_img: /media/posts_img/8c00e6b8913054472bba6e240ab48e4c5c78ab_index.jpg
banner_img: /media/posts_img/8c00e6b8913054472bba6e240ab48e4c5c78ab.jpg
summary: 把你的 OneDrive 添加到 Mixplorer
categories: 瞎折腾
---

## 打开 Azure

### 注册应用

[点击这里](https://portal.azure.com/?l=zh-hans.zh-cn#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)打开 Azure，登陆你的 OneDrive 账号。点击**新注册**。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxecuych5j30zm0f040w.jpg)

名称随意填写，这里我填写的是 Mixplorer，受支持的账户类型选择**任何组织目录（任何 Azure AD 目录 - 多租户）中的账户和个人 Microsoft 账户（例如，Skype、Xbox）**，重定向 URI 填写 `https://sharepoint.com`。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxedi2oj4j315k0u0791.jpg)

### 应用设置

#### API 权限

进入应用设置后，先点击左边的 **API 权限**，点击**添加权限**，选择**常用 Microsoft API** 中的 **Microsoft Graph**，然后选择**委托的权限**。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxeiauusaj31ik0pmq7l.jpg)

在选择权限中搜索 `file`，然后选择 `Files.ReadWrite` 和 `Files.ReadWriteAll` 两项。添加权限。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxejcl4klj30po10m0w0.jpg)

### 证书和密码

在左边的管理中选择**证书和密码**，点击**新客户端密码**，说明随意填写，截止期限选择**1 年内**[^1]。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxeny9zptj30ys0laacj.jpg)

然后点击**添加**。

你将会看到一个**值**，**请务必**将其复制下来，保存好！

#### 应用 ID

现在返回**概述**，将**应用程序（客户端）ID** 保存下来。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxfzbxx46j313s0bijt9.jpg)

## 打开 Mixplorer

点击左上角的汉堡菜单，再点击菜单右上角的列表。点击 **Add storage**。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxeuck3ndj30oe18m42i.jpg)

选择 **OneDrive**。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxew3d56zj30oe18mgto.jpg)

Display name 可以随意填写

在 **client_id** 的等号后填写**应用程序 ID**，**client_secret** 的等号后填写密钥，也就是之前说到的**值**，最后，**redirect_uri** 的等号后填写 `https://sharepoint.com`。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxfzprey6j30oe18mgvf.jpg)

然后点击保存。

之后会出现一个九宫格，这是一个可选的密码，我不需要，直接点击下一步。你也可以绘制一个九宫格密码，增强安全性。

之后，等待加载完成，会弹出 Office 的登陆界面，这里登陆你刚刚用于注册 Azure 的账户，即你的 OneDrive 账户。

完成登陆后，Mixplorer 会自动获取 token，然后就可以正常使用你的 OneDrive 了。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxf3gmdh4j30oe18mjz9.jpg)

> 注，你的 OneDrive 文件应该储存在 Files 文件夹中，而非 Mixplorer 中的根目录。

## 测试

随意选择一个文件点击，在打开方式窗口中，你可以选择**保存在临时文件夹** 或 **获取直链**，这里我选择**获取直链**。然后使用 ADM 下载。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxf5w26yjj30oe18mgsf.jpg)

这个方法是不支持断点续传的，所以 AMD 可能会报一个错误，忽略即可。

![](https://tva1.sinaimg.cn/large/0082zybpgy1gbxf76yv7qj30oe18mjwu.jpg)

我的梯子开的是**绕过中国大陆和局域网**模式，所以这里走了代理，我的宽带是 100 M 广电网，属于墙中墙类型，因此这个速度还算不错了，如果不走代理的话我这里的速度可能只有 200 KiB/s 左右。裸连速度与你的 ISP、带宽、OneDrive 服务位置等因素相关，我这里只作为参考。

## 最后

我这个方法适用于 OneDrive for Business，对于个人版本的 OneDrive 我没有进行测试，但应该可用。希望有进行测试的朋友可以把你的结果和经验分享到评论区中。

[^1]: 也可以选择 **2 年内**或**从不**，我不进行测试了
