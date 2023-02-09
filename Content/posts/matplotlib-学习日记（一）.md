---
title: Matplotlib 学习日记（一）
keywords: Python, Matplotlib, 数据, 可视化, 数据可视化, 丁丁の店, 丁丁
cover: false
top: false
author: Butanediol 丁二
date: 2020-02-09 21:24
updated: 2020-02-09 21:24
tags: 笔记, 踩坑, 数据可视化
index_img: /media/posts_img/matplotlib_d1_index.jpg
banner_img: /media/posts_img/matplotlib_d1.jpg
summary: plt.figure 是个什么东西？
categories: 写代码
---

## 前言
如果有看过我之前几篇 matplotlib 学习笔记的读者，会发现我们用的是 `plt.scatter()` `plt.plot()` 这些函数进行图像的生成，然后再用 `plt.show()` 来绘制图像。

但是**有且仅有一个**地方出现了 `plt.figure` 这样的一个类，然后我们就再也没有动过这个叫 `figure` 的东西。

对于我这样的 Python （或者说编程）初学者来说，这就相当于声明了一个变量后就再也没有使用过一样。

下面是我的一些理解。

## 从文档中来
### plt.figure 是个什么东西？

当然，如果没有指定别名的话，这个东西叫 `matplotlib.pyplot.figure`。

先来粘贴一段[官方文档](http://matplotlib.org/3.1.1/api/_as_gen/matplotlib.pyplot.figure.html)中的说明：
```python
matplotlib.pyplot.figure(num=None, figsize=None, dpi=None, facecolor=None, 
	edgecolor=None, frameon=True, FigureClass=<class 'matplotlib.figure.Figure'>, 
	clear=False, **kwargs)
```
它可以被理解为一个画布，那么 `fig = plt.figure()` 就相当于我们创建了一个画布。

那么，在我们创建画布之后，所有的作画内容都会被画在这个画布上，直到 `plt.show()` 把这幅画展示出来。

或者，官方也提供了这样一条提示：

> Notes
>
> If you are creating many figures, make sure you explicitly call [`pyplot.close()`](http://matplotlib.org/3.1.1/api/_as_gen/matplotlib.pyplot.close.html#matplotlib.pyplot.close) on the figures you are not using, because this will enable pyplot to properly clean up the memory.

意思是说，如果你用了太多的画布，别忘记用 `pyplot.close()` 关闭一些不用的画布，这样就可以让 pyplot 正确地清理出一些内存。

这种写法看似迷惑，但理解后我认为还是有很大好处的。毕竟，我们在写代码的时候，最重要的就是头脑清晰，同时在多个 figure 上编辑图表是很难保证头脑清晰的，这样的设计，简化了代码，还增强了可读性。

### 但凡事都有例外

如果你就是想编辑好几个图像，那我们也有办法。

翻回上面官方文档中的定义，其中第一个参数是 `num`，这是一个可选参数，默认值为 `none`，类型可以是整形，字符串，如果留空，系统会自动创建一个普通的 figure，这个 figure 的 `num` 顺次加一（取决于你之前创建了多少），并将这个 `num` 保存在新建 figure 的属性中。如果你指定了这个参数 `num` 的值，这就会分成下面几种情况：

- 你之前用过这个值：系统会将之前的 figure 激活，然后你就可以继续在这张图表上编辑。
- 你之前没用过这个值：系统会创建一个新的 figure，同样，新的 figure 也会将这个值保存到自己的属性中，方便你下次使用。

除此之外，如果你传入的是一个 `string`，系统还会将这个 `string` 作为图表窗口的标题。

---

## 官方文档

如果你不方便浏览官方文档（或者只是懒得点开另外的链接）：

### 参数

![](https://tva1.sinaimg.cn/large/0082zybply1gbqjhwlzt8j30zq0u0dni.jpg)

### 返回值

![](https://tva1.sinaimg.cn/large/0082zybply1gbqjj3d086j31aq06uq46.jpg)
