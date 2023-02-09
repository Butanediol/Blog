---
title: 基于 Cloudflare Workers 的随机图
date: 2020-06-02 16:40
updated: 2020-06-02 16:40
tags: Cloudflare, 代码, 分享, 折腾
categories: 写代码
index_img: /media/posts_img/cloudflare_random_pic_index.jpg
banner_img: /media/posts_img/cloudflare_random_pic.jpg
---

一个私人的随机图服务。

<!-- more -->

![一个样例图片](https://picture.butanediol.workers.dev)

随机图的轮子其实网上有不少了，但基本都需要一台服务器，或者用别人提供的服务。

但其实托管图片获取直链还是比较简单的，所以想着用 Cloudflare Workers 在直链中随机选一个，来搭建一个私人的随机图片服务。

## 你需要

 - 一个 Cloudflare 账号
 - 一堆图片直链

## 图片直链

不少图床都提供直链服务，比如 [sm.ms](https://sm.ms)（免费版单文件上限 5MB，速度很快），或者 [img.vim-cn.com](https://img.vim-cn.com)（单文件上限 50MB，国内速度一般）。

或者，如果你对这些公共的服务不太放心的话，一个 GitHub Repo 也是不错的选择。

总之，只需要一个直链，方法很多，自己灵活选择。

## 部署 Workers

方法不多说，网上一大堆，下面直接贴代码。

``` javascript
addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {

	var background_urls = [
	'https://w.wallhaven.cc/full/ey/wallhaven-eymzjk.jpg',
	'https://w.wallhaven.cc/full/j8/wallhaven-j8rk95.png'
	]
	var index = Math.floor((Math.random()*background_urls.length));
	res = await fetch(background_urls[index])
    return new Response(res.body, {
        headers: { 'content-type': 'image/jpeg' },
    })
}
```

`background_urls` 是一个保存直链的数组，将所有你想随机的图片加入进去即可。

{% note info%}
P.S. 没有学过 Javascript，临时拼凑而成，希望有大佬可以优化地更好。
{% endnote %}
