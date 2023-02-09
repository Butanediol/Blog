---
title: 提升国内 Apple Music 体验的代理规则
date: 2020-05-07 10:39
updated: 2021-08-31 10:39
description: 国内访问 Apple Music 内容基本没什么大问题，但是对与自己上传的内容，访问性就很差。
---
```
# keywords:
#   - Quantumult X
#   - iOS
#   - Clash
#   - Music
#   - Apple

# updated: 2021-8-31 10:39:25
# tags:
#  - Apple Music
#  - 代理
#  - 分流规则
#  - Clash
#  - Quantumult
# cover: false
# top: true
# categories: 瞎折腾
# index_img: /media/posts_img/apple_music_index.jpg
# banner_img: /media/posts_img/apple_music.jpg
```

<!-- more -->

{% note success %}
2021-8-31 更新
{% endnote %}

如果是为了听自己上传的歌曲，把 `blobstore.apple.com` 加入代理列表就差不多了。

{% note success %}
2020-12-28 更新
{% endnote %}

`amp-api.music.apple.com` 猜测是搜索相关，我学校这边的垃圾网络访问性很差，所以加到代理列表里了。

还有 `amp-api-edge.music.apple.com`，有个 `edge` 估计是边缘 CDN，不太需要代理。

附上一段 clash 的脚本代理规则

``` python
Apple_Special = ['aod.itunes.apple.com', 'mvod.itunes.apple.com', 'music.apple.com', 'amp-api.music.apple.com']
if(metadata['host'] in Apple_Special):
	ctx.log("[Apple Music] " + metadata['host'])
	return "Apple"
```

## 域名列表

### 已知功能

这里是确定功能的域名。

|功能|访问域名|连接情况|
|---|---|---|
|页面：歌曲、歌单、艺人、专辑、MV - 国区|`music.apple.com/cn`|✅正常|
|页面：歌曲、歌单、艺人、专辑、MV - 外区|`music.apple.com/[country_code]`|✅视运营商情况而定|
|Apple Music 歌曲播放|`aod.itunes.apple.com`|✅正常|
|MV 播放|`mvod.itunes.apple.com`|✅正常|
|Beats 1 直播|`itsliveradio.apple.com`|⚠️可能无法访问|
|Beats 1 视频|`aodp-ssl.apple.com`|⚠️可能无法访问|
|电视、电影预告片|`video-ssl.itunes.apple.com`  `mvod.itunes.apple.com`|⚠️可能无法访问|
|电视、电影正片|`hls-amt.itunes.apple.com`  `mvod.tiunes.apple.com`|⚠️可能无法访问|
|iTunes Store 音乐试听|`audio-ssl.itunes.apple.com`|⚠️可能无法访问|
|iTunes Store 购买后播放|`streamingaudio.itunes.apple.com`|⚠️可能无法访问|
|iCloud 资料库上传|`amazonaws.com`|⚠️访问缓慢|
|播放上传歌曲|`blobstore.apple.com`  `audio.itunes.apple.com`|⚠️访问缓慢|

```note.success
带有 ✅ 标记的建议使用直连策略。
```

{% note warning %}
带有 ⚠️ 标记的建议使用代理策略。
{% endnote %}

### 未知功能

这里是一些不能确定功能的域名，建议走直连。

|疑似功能|访问域名|
|---|---|
||`pXX-buy.itunes.apple.com`[^1]|
||`radio-activity.itunes.apple.com`|
|macOS、iOS 和 iTunes 使用|`xp.apple.com`|
|Siri、听写功能|`guzzoni.apple.com`|

## 分流策略

你可以直接使用下面的分流策略。

### Clash

```yaml
Rule:
- DOMAIN-SUFFIX,blobstore.apple.com,Proxy
- DOMAIN-SUFFIX,itsliveradio.apple.com,Proxy
- DOMAIN-SUFFIX,aodp-ssl.apple.com,Proxy
- DOMAIN-SUFFIX,video-ssl.itunes.apple.com,Proxy
- DOMAIN-SUFFIX,mvod.itunes.apple.com,Proxy
- DOMAIN-SUFFIX,hls-amt.itunes.apple.com,Proxy
- DOMAIN-SUFFIX,audio-ssl.itunes.apple.com,Proxy
- DOMAIN-SUFFIX,streamingaudio.itunes.apple.com,Proxy
- DOMAIN-SUFFIX,amazonaws.com,Proxy
- DOMAIN-SUFFIX,audio.itunes.apple.com,Proxy

- DOMAIN-SUFFIX,xp.apple.com,DIRECT
- DOMAIN-SUFFIX,guzzoni.apple.com,DIRECT
```

### Quantumult

```conf
host-suffix,blobstore.apple.com,proxy
host-suffix,itsliveradio.apple.com,proxy
host-suffix,aodp-ssl.apple.com,proxy
host-suffix,video-ssl.itunes.apple.com,proxy
host-suffix,mvod.itunes.apple.com,proxy
host-suffix,hls-amt.itunes.apple.com,proxy
host-suffix,audio-ssl.itunes.apple.com,proxy
host-suffix,streamingaudio.itunes.apple.com,proxy
host-suffix,amazonaws.com,proxy
host-suffix,audio.itunes.apple.com,proxy

host-suffix, xp.apple.com, direct
host-suffix, guzzoni.apple.com, direct
```

[^1]: 这里的域名是 `pXX-buy.itunes.apple.com`，其中的 `XX` 是从 1 到 100 的数字。