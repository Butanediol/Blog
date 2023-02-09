---
title: Hexo 改良版知乎“外链卡片”
date: 2020-06-03 20:57
updated: 2020-06-03 20:57
description: 给 Hexo 博客添加知乎样式的外链卡片。
tags: Hexo, 美化, 折腾, 知乎, 转载
categories: 瞎折腾
index_img: /media/posts_img/hexo_zhihu_share_card_index.jpg
banner_img: /media/posts_img/hexo_zhihu_share_card.jpg
---

{% note info %}
本文转载自 [长弓不是弓长](https://www.52chang.wang/post/2802a56)，并略作修改。
{% endnote %}

## 配置

由于主题可能需要更新，我建议**下列操作均在博客的 `/source` 目录下进行。**

在 `/source` 目录中新建一个 `js` 文件，例如 `/source/js/linkcard.js`。内容如下：

```javascript
window.onload=function(){
		var LinkCards=document.getElementsByClassName('LinkCard');
		if(LinkCards.length != 0){
		var LinkCard=LinkCards[0];
		var link=LinkCard.href;
		var title=LinkCard.innerText;
		var logourl=LinkCard.name;
		LinkCard.innerHTML="<style type=text/css>.LinkCard,.LinkCard:hover{text-decoration:none;border:none!important;color:inherit!important}.LinkCard{position:relative;display:block;margin:1em auto;width:390px;box-sizing:border-box;border-radius:12px;max-width:100%;overflow:hidden;color:inherit;text-decoration:none}.ztext{word-break:break-word;line-height:1.6}.LinkCard-backdrop{position:absolute;top:0;left:0;right:0;bottom:0;background-repeat:no-repeat;-webkit-filter:blur(20px);filter:blur(20px);background-size:cover;background-position:center}.LinkCard,.LinkCard:hover{text-decoration:none;border:none!important;color:inherit!important}.LinkCard-content{position:relative;display:flex;align-items:center;justify-content:space-between;padding:12px;border-radius:inherit;background-color:rgba(246,246,246,0.88)}.LinkCard-text{overflow:hidden}.LinkCard-title{display:-webkit-box;-webkit-line-clamp:2;overflow:hidden;text-overflow:ellipsis;max-height:calc(16px * 1.25 * 2);font-size:16px;font-weight:500;line-height:1.25;color:#1a1a1a}.LinkCard-meta{display:flex;margin-top:4px;font-size:14px;line-height:20px;color:#999;white-space:nowrap}.LinkCard-imageCell{margin-left:8px;border-radius:6px}.LinkCard-image{display:block;width:60px;height:auto;border-radius:inherit;margin-bottom:0!important}</style><span class=LinkCard-backdrop style=background-image:url(/images/logo.svg)></span><span class=LinkCard-content><span class=LinkCard-text><span class=LinkCard-title>"+title+"</span><span class=LinkCard-meta><span style=display:inline-flex;align-items:center><svg class="+"'Zi Zi--InsertLink'"+" fill=currentColor viewBox="+"'0 0 24 24'"+" width=17 height=17><path d="+"'M6.77 17.23c-.905-.904-.94-2.333-.08-3.193l3.059-3.06-1.192-1.19-3.059 3.058c-1.489 1.489-1.427 3.954.138 5.519s4.03 1.627 5.519.138l3.059-3.059-1.192-1.192-3.059 3.06c-.86.86-2.289.824-3.193-.08zm3.016-8.673l1.192 1.192 3.059-3.06c.86-.86 2.289-.824 3.193.08.905.905.94 2.334.08 3.194l-3.059 3.06 1.192 1.19 3.059-3.058c1.489-1.489 1.427-3.954-.138-5.519s-4.03-1.627-5.519-.138L9.786 8.557zm-1.023 6.68c.33.33.863.343 1.177.029l5.34-5.34c.314-.314.3-.846-.03-1.176-.33-.33-.862-.344-1.176-.03l-5.34 5.34c-.314.314-.3.846.03 1.177z'"+" fill-rule=evenodd></path></svg></span>"+link+"</span></span><span class=LinkCard-imageCell><img class=LinkCard-image alt=logo src="+logourl+"></span></span>";

		for (var i = LinkCards.length - 1; i >= 1; i--) {
		LinkCard=LinkCards[i];
		title=LinkCard.innerText;
		link=LinkCard.href;
		LinkCard.innerHTML="<span class=LinkCard-backdrop style=background-image:url(/images/logo.svg)></span><span class=LinkCard-content><span class=LinkCard-text><span class=LinkCard-title>"+title+"</span><span class=LinkCard-meta><span style=display:inline-flex;align-items:center><svg class="+"'Zi Zi--InsertLink'"+" fill=currentColor viewBox="+"'0 0 24 24'"+" width=17 height=17><path d="+"'M6.77 17.23c-.905-.904-.94-2.333-.08-3.193l3.059-3.06-1.192-1.19-3.059 3.058c-1.489 1.489-1.427 3.954.138 5.519s4.03 1.627 5.519.138l3.059-3.059-1.192-1.192-3.059 3.06c-.86.86-2.289.824-3.193-.08zm3.016-8.673l1.192 1.192 3.059-3.06c.86-.86 2.289-.824 3.193.08.905.905.94 2.334.08 3.194l-3.059 3.06 1.192 1.19 3.059-3.058c1.489-1.489 1.427-3.954-.138-5.519s-4.03-1.627-5.519-.138L9.786 8.557zm-1.023 6.68c.33.33.863.343 1.177.029l5.34-5.34c.314-.314.3-.846-.03-1.176-.33-.33-.862-.344-1.176-.03l-5.34 5.34c-.314.314-.3.846.03 1.177z'"+" fill-rule=evenodd></path></svg></span>"+link+"</span></span><span class=LinkCard-imageCell><img class=LinkCard-image alt=logo src="+logourl+"></span></span>";
		}
	}
}
```

然后在主题中引入自定义 JS，这里以咱的 [Fluid](https://github.com/fluid-dev/hexo-theme-fluid) 主题为例。

```yaml
custom_html: '<script type="text/javascript" src="/js/linkcard.js"></script>'
```

{% note warning %}
你的主题的自定义 HTML/JS 功能设置方法可能不同，也可能没有自定义功能，需要手动修改主题文件，请自行探索。
{% endnote %}

## 使用

```html
<a href="" name="" class="LinkCard">标题</a>
```

在 Markdown 中插入上面的 HTML 代码即可。
其中 `href` 是外链地址，`name` 是右侧预览图链接，标题处填写标题。

下面是一个样例

```html
<a href="https://blog.butanediol.me" name="https://blog.butanediol.me/media/avatar.png" class="LinkCard">一个测试链接</a>
```

<a href="https://blog.butanediol.me" name="https://blog.butanediol.me/media/avatar.png" class="LinkCard">一个测试链接</a>
<script type="text/javascript" src="/js/linkcard.js"></script>

{% note warning %}
由于我这里出现了自定义 `js` 与评论功能冲突的问题，这篇文章中的 `js` 引入是写在 `Markdown` 中的，如果你也出现了这个问题，不妨尝试一下。
毕竟一篇文章只需引入一次，而且也不一定所有文章都会用到外链分享，所以也不算太麻烦。
{% endnote %}
