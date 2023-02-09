---
title: Python TelegramBot 实时输出与 Flush
date: 2020-06-06 14:29
updated: 2020-06-06 14:29
tags: Python, Telegram, Bot, 踩坑, 笔记, Linux, macOS
categories: 写代码
index_img: /media/posts_img/python_flush_index.jpg
banner_img: /media/posts_img/python_flush.jpg
---

在 macOS 下运行 Python Telegram Bot 的时候，没有实时的命令行输出。发现是 flush 的锅。

<!-- more -->

## 现象

我用的 Python Telegram Bot 库是 [python-telegram-bot](https://github.com/python-telegram-bot/python-telegram-bot)，个人感觉文档写的还是蛮好的。

用这条命令就可以安装：

```bash
pip install python-telegram-bot --upgrade
```

由于我一直都是用 Sublime Text 写代码，然后在命令行里运行，所以只会简单的输出调试。~~`print(everything)`~~

但是出现了一个问题，在 macOS 上，运行 telegram bot 时没有输出，只有 `Ctrl+C` 停止运行之后，输出才会一次性全部显示出来。

但在部署 bot 的 Ubuntu 服务器上，就可以实时输出。

可以尝试运行下面这段代码

```python
import sys
import time

for i in range(5):
	print(i+1)
	time.sleep(1)
```

<details>
	<summary>
		<span class="summary-title">
			点击运行代码。
		</span>
	</summary>
	<div class="summary-content">
		<br>
		<iframe class="code-runner" src="https://trinket.io/embed/python/c48ddb7e5b" width="100%" height="356" frameborder="0" marginwidth="0" marginheight="0" allowfullscreen></iframe>
	</div>
</details>

在这个网页嵌入的解释器中，数字是每秒钟输出一个的。这正是我们想要的样式。但在我的设备上，它是这样的。

{% raw %}
<video src='/media/article_video/python_flush/1.mp4' type='video/mp4' controls='controls' width='100%' height='100%'></video>
{% endraw %}

## 为什么？

Python 的 stdout 带有缓冲区，输出的内容要先呆在缓冲区，然后再输出到终端中。

而这个缓冲区的策略，在不同平台，甚至同一平台不同解释器中都不一样。（这样说似乎不太正确，但我是用 homebrew 安装的 Python3.7，据说用官网的安装器就没问题）

通常来讲，当 `print` 的结尾为 `\n` 换行符的时候，会自动刷新缓冲区（`print` 的 `end` 参数默认就是 `\n`），但鉴于我并没有手动指定别的结尾，它还是没有自动刷新缓冲区，我们可以手动让它刷新一下。

## 解决：手动刷新缓冲

有好几个方法可以做到

### 使用 sys

首先 `import sys`。

然后在你想要刷新缓冲区的地方写上一句：

```python
sys.stdout.flush()
```

### 使用 print

其实 `print` 自带了一个参数 `flush`，默认值为 `False`，将其指定为 `True` 即可。

```python
print(i, flush=True)
```

