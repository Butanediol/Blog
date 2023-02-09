---
title: Matplotlib 数据可视化（一）
date: 2020-01-22 16:00
updated: 2020-01-22 16:00
tags:  小课堂, 数据可视化
keywords: Python, Matplotlib, 数据, 可视化, 数据可视化, 丁丁の店, 丁丁
top: true
cover: true
summary: Python 学习日记之 matplotlib 数据可视化（一）：折线图和散点图
index_img: /media/posts_img/matplotlib_l1_index.jpg
banner_img: /media/posts_img/matplotlib_l1.jpg
categories: 写代码
mathjax: false
---
# Matplotlib 数据可视化（一）

由于 macOS 中用 Homebrew 安装的 pygame 似乎有点小问题，Python 的学习就先跳过 pygame 啦，直接到数据可视化。

学一个第三方库需要了解许多这个模块的函数，这里把容易记的、不容易记得统统记一下。

## 折线图

本章惯例，先导入模块。

```python
import matplotlib.pyplot as plt
```

先来看看基本用法。

```python
x_values = [1, 2, 3, 4]
y_values = [1, 4, 9, 16]
plt.plot(x_values, y_values, linewidth=5)

plt.title("Title")
plt.xlabel("x_value", fontsize=14)
plt.ylabel("y_value", fontsize=14)

plt.tick_params(axis='both', labelsize=14)

plt.show()
```

这里 `plt.plot()` 函数接受的前两个参数分别是 `x` 坐标值和 `y` 坐标值，类型是两个列表。后面的参数 `linewidth` 是线条粗细。

`plt.xlabel` 和 `plt.ylabel` 比较相似，都是先接受了一个字符串作为 x 轴或 y 轴的轴标题，后面的 `fontsize` 是一个 `int` 确定了字体大小。

最后用一个 `plt.show` 来让 matplotlib 进行绘图并显示。

![](https://tva1.sinaimg.cn/large/006tNbRwly1gb4at9c9s8j30zk0twtae.jpg)

## 散点图

```python
import matplotlib.pyplot as plt

x_values = list(range(1,1001))
y_values = [x**2 for x in x_values]

plt.scatter(x_values, y_values, c=(0, 0, 0.8), edgecolor='none', s=40)
plt.title("Title", fontsize=24)
plt.xlabel("x_label", fontsize=14)
plt.ylabel("y_label", fontsize=14)

plt.tick_params(axis='both', which='major', labelsize=14)
plt.axis([0, 1100, 0, 1100000])

plt.show()
```

这里的 `x_values` 和 `y_values` 我们让 Python 自己进行计算，而不是写好的数据。因为数据比较多，点比较密集，在 ` plt.scatter()` 中我们指定 `s` 参数为 `40`，这是点的大小；`edgecolor` 设定了数据点的轮廓颜色，取消轮廓就填写 `none`。

---

### 小提示

1. 2.0.0 版本的 matplotlib 中 `scatter()` 的参数 edgecolor 默认就是 `none`。

2. 这里的颜色值使用的是 RGB 值，但取值范围是 0-1，越接近 1，指定的颜色越**浅**。

3. 书上的代码中，参数 `c` 是这样写的，但是我这样写的时候会报错：

 ``` plain
 'c' argument looks like a single numeric RGB or RGBA sequence, which should be avoided as value-mapping will have precedence in case its length matches with 'x' & 'y'.  
 Please use a 2-D array with a single row if you really want to specify the same RGB or RGBA value for all points.
 ```

 似乎是因为书上的版本比较旧，从 3.0.3 的 matplotlib 开始，参数 `c` 应该用一个二维数组。所以参数 `c` 改为 `c=np.array([[0, 0, 0.8]])` 就没问题了，注意是两层中括号，而且别忘记 `import numpy as np`。

 [参考链接 - StackOverflow](https://stackoverflow.com/questions/55109716/c-argument-looks-like-a-single-numeric-rgb-or-rgba-sequencp)

---

或者想要更 fancy 的效果，也可以这样写:

```python
plt.scatter(x_values, y_values, c=y_values, cmap=plt.cm.Blues,
	edgecolor='none', s=40)
```

这里把参数 `c` 设置成了一个 y 值列表，使用参数 cmap (colormap) 告诉 pyplot 使用哪个颜色映射，这里用的是 'blue'，y 值较小的显示为浅蓝色，较大的为深蓝色。
(其实有许多预制的很有意思的色彩映射，等我整明白了再写一篇文章 ww)

`plt.axis` 接受一个列表，其中含有四个数字，分别是：x 轴的起始数值，x 轴的终止数值，y 轴的起始数值，和 y 轴的终止数值。即，x、y 轴的取值范围。

![](https://tva1.sinaimg.cn/large/006tNbRwly1gb4as4oyl1j31dg0u0go2.jpg)

~~吐槽~~疑问：为什么 `plt.scatter` 的参数里 `edgecolor` 不是驼峰命名呢？

---

## 保存图表

要想看到生成的图表除了可以用 `plt.show()` 之外，还可以用 `plt.savefig`
例如：
```python
plt.savefig('squares_plot.png')
```
这样就可以在目录里生成一个 `squares_plt.png` 图片文件，相当于用 `plt.show()` 显示然后手动点击保存。
不过书中给出的参数还有一个，`bbox_inches='tight'`。书中给出的解释是，这个参数可以帮助去除图表中多余的空白区域，但是我第一次加上之后直接生成了一张空白图片，后来发现不是参数的锅，而是要**替换掉 `plt.show()`**而不是再加一行。（没看清书犯低级错误）

![这个色彩映射名称是 rainbow](https://img.vim-cn.com/3a/53d9d18db1c169d2015ff427b59fe63b425a8f.png)

## QUIZ

1. 绘制一个图形，显示前 5 个和前 5000 个数字的立方。
2. 给前面绘制的立方图指定颜色映射。

![交个作业](https://img.vim-cn.com/a9/cb1eb62b4578e94130e8db5a564ec2a0689128.png)
