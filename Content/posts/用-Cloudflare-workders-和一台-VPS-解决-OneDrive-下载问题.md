---
title: 用 Cloudflare workers 和一台 VPS 解决 OneDrive 下载问题
date: 2020-05-05 10:26
updated: 2020-05-05 10:26
tags: 折腾, OneDrive, VPS, Cloudflare, 网盘
categories: 瞎折腾
index_img: /media/posts_img/cloudflare_fodi_index.jpg
banner_img: /media/posts_img/cloudflare_fodi.jpg
---

哪个男孩不想要一个大容量不限速网盘呢？但是百度云是不可能百度云的，这辈子都不可能百度云的，只能白嫖 OneDrive 维持一下生活这样子。

<!-- more -->

{% note info %}
为了使用这个方法，你需要有一个域名，一台可以顺畅访问 OneDrive 的 VPS（只对带宽有要求，对性能、硬盘大小几乎无要求），和一颗能折腾的心。
{% endnote %}

{% note danger%}
为了避免不必要的麻烦，所有代码段请务必看仔细！
{% endnote %}

据说在 2020 年初，OneDrive 在香港的服务器已经停用了，全部下载都走美国服务器，导致国内的下载速度几乎不能看。

如果是自己用的话，用这台 VPS 搭建一个代理就可以解决问题，但如果你想要分享文件给别人，让其他人用代理真的是非常麻烦，所以不如直接给 OneDrive 做一个反向代理，速度也是可以接受的范围。

这里你可以使用 Cloudflare 的 CDN 来加速反向代理，这样 VPS 对国内的线路就不用特别好，只要在海外速度足够快就可以了。

> 实测，打包下载时的链接虽然写的是 `eastasia1-mediap.svc.ms`，似乎是东亚服务器，但仍然被解析到美国。
> ```sh
> ❯ nslookup eastasia1-mediap.svc.ms
> Server:		223.6.6.6
> Address:	223.6.6.6#53
> 
> Non-authoritative answer:
> eastasia1-mediap.svc.ms	canonical name = svc-ms.spo-0008.spo-msedge.net.
> svc-ms.spo-0008.spo-msedge.net	canonical name = spo-0008.spo-msedge.net.
> Name:	spo-0008.spo-msedge.net
> Address: 13.107.136.13
>
> ❯ curl cip.cc/13.107.136.13
> IP	: 13.107.136.13
> 地址	: 美国  美国
>
> 数据二	: 美国 | Microsoft公司
>
> 数据三	: 美国华盛顿雷德蒙德 | 微软
>
> URL	: http://www.cip.cc/13.107.136.13
> ```

最近看到了许多用 Cloudflare workers 的骚操作，比如网页套娃科学上网、免代理 Google drive 等。

刚好 OneDrive 也有 Fodi，同样可以做到。

# 部署 Fodi

关于 Fodi 的部署，官方已经讲的很明白了，直接贴上官方链接好了。

<a class='btn' href="https://github.com/vcheckzen/FODI" title="Fast OneDrive Index，OneDrive 秒级列表程序"> GitHub </a> <a class='btn' href="https://logi.im/back-end/fodi-on-cloudflare.html" title="在 Cloudflare 部署 Fodi 后端"> LOGI 的博客 </a>

# 反向代理

## DNS

由于我们要使用 Cloudflare 的 CDN 来加速，所以需要把你的域名解析托管给 Cloudflare，没什么难度，有问题自行 Google。

先把域名和解析到你的服务器，例如你的域名是 `yourdomain.com`：

|类型|名称|内容|TTL|代理状态|
|---|---|---|---|---|
|A|d|123.456.78.9|自动|已代理|
|CNAME|fodi|xxx.github.io|自动|已代理|

即 `d.yourdomain.com` 解析到 `123.456.78.9`。
即 `fodi.yourdomain.com` 解析到你配置好的 Fodi。

当然你也可以使用 Coding pages 和/或不使用自定义域名。

## 反向代理

咱使用的是 Caddy，这样可以不用费心整 SSL，当然你也可以用 Nginx。

```caddy
https://d.yourdomain.com {
 gzip
 tls mail@example.com
 proxy / https://xxx-my.sharepoint.com
}

http://d.yourdomain.com {
 redir https://d.yourdomain.com
}
```


{% note warning %}
`d.yourdomain.com` 换成你 VPS 的域名。

`mail@example.com` 换成你的邮箱

`https://xxx-my.sharepoint.com` 只是一个参考，如果你的也是这个形式，那么就把 xxx 换成你自己的，当然也有可能你使用了自定义域名，总之，哪个能访问到你的 OneDrive 就用哪个。
{% endnote %}

配置好之后，你登录 `d.yourdomain.com` 应该会打开 OneDrive 的登陆页面（已经登陆的话就直接进入 OneDrive 了）。

# 再次配置 Workers

在第 9 行和第 10 行（或者说定义完 TOKEN 的下一行）插入：

```js
const ORIGIN_URL = "https://xxx-my.sharepoint.com"
const PROXY_URL = "https://d.yourdomain.com"
```

在倒数几行，你应该能看到这样的代码：

```js
    if (encrypted) {
      return JSON.stringify({ parent: parent, files: [], encrypted: true })
    } else {
      return JSON.stringify({ parent: parent, files: files })
    }
```


在第二个 return 行的最后面加上 `.replace(RegExp(ORIGIN_URL,"g"),PROXY_URL)`，最终效果：

```js
    if (encrypted) {
      return JSON.stringify({ parent: parent, files: [], encrypted: true })
    } else {
      return JSON.stringify({ parent: parent, files: files }).replace(RegExp(ORIGIN_URL,"g"),PROXY_URL)
    }
```

保存并部署。

# 测试

打开你的 Fodi，关闭你的代理，随便找个文件点击下载。

你的下载地址应该已经是 `d.yourdomain.com` 了。
