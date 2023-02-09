---
title: Matplotlib 数据可视化（二）
date: 2020-01-31 19:19
updated: 2020-01-31 19:19
tags: 小课堂, 数据可视化
keywords: Python, Matplotlib, 数据, 可视化, 数据可视化, 丁丁の店, 丁丁
top: true
cover: true
summary: Python 学习日记之 matplotlib 数据可视化（二）：生成随机漫步数据并绘制图形
index_img: /media/posts_img/matplotlib_l2_index.jpg
banner_img: /media/posts_img/matplotlib_l2.jpg
categories: 写代码
mathjax: false
---
# Matplotlib 数据可视化（二）

## 引入

这一篇做的其实是上一篇的练习。

想象有一个小人，每一回合随机移动一次，我们想记录下小人每次移动后的位置，并用 matplotlib 以散点图的形式绘制出来。
下面我们做的就是模拟这个过程。

## 生成数据

要生成随机数据，先导入一个函数：
```python
from random import choice
```
这里附上一段简单的介绍：

> `random` 模块有大量的函数用来产生随机数和随机选择元素。 比如，要想从一个序列中随机的抽取一个元素，可以使用 `random.choice()`
> ```python
> >>> import random
> >>> values = [1, 2, 3, 4, 5, 6]
> >>> random.choice(values)
> 2
> >>> random.choice(values)
> 3
> ```
> [Python3 Cookbook 3.0.0 文档](https://python3-cookbook.readthedocs.io/zh_CN/latest/c03/p11_pick_things_at_random.html)

当然这里我们只导入了 `choice` 函数，直接使用就好了。
这里先写一个 `RandomWalk` 类

**`random_walk.py`**
```python
--snip--
class RandomWalk():
	"""一个生成随机漫步数据的类"""

	def __init__(self, num_points=5000):
		"""初始化随机漫步的属性"""
		self.num_points = num_points

		self.x_values = [0]
		self.y_values = [0]

	def fill_walk(self):
		"""计算随机漫步包含的所有点"""

		# 不断漫步，直到列表达到指定的长度
		while len(self.x_values) < self.num_points:
			# 决定前进方向以及沿这个方向前进的距离
			x_direction = choice([1, -1])
			x_distance = choice([0, 1, 2, 3, 4])
			x_step = x_direction * x_distance

			y_direction = choice([1, -1])
			y_distance = choice([0, 1, 2, 3, 4])
			y_step = x_direction * y_distance

			# 拒绝原地踏步
			if x_step == 0 and y_step == 0:
				continue

			# 计算下一个点的 x 和 y 值
			next_x = self.x_values[-1] + x_step
			next_y = self.y_values[-1] + y_step

			self.x_values.append(next_x)
			self.y_values.append(next_y)
```
这个类接收一个参数 `num_points` 表示漫步/随机生成数据的数量。我们把它的默认值定为 5000。
然后先来看这个 `fill_walk()` 函数。
#### `fill_walk()` 函数
首先这个循环很容易理解，只要 `x_values` 的长度没有到达预定的数量就一直生成数据，于是我们可以获得指定数量的随机数据。

生成的数据包含两个数字，`x_step` 和 `y_step`，即漫步的纵横方向。先从 ±1 中随机挑选一个，指定了移动的方向是正方向还是负方向，然后再从 `distance` 中随机选一个数，指定了移动距离。两个数字相乘就是移动的量。

但是有一种可能是，x 和 y 同时选中了 0，我们不想让它原地踏步，所以如果出现这种情况，就不写入数据，而是再随机一轮。

但在这里我们要画出的并不是位置的变化量，而是位置本身，所以我们要计算出，这次移动之后，我们漫步到了什么位置。
`next_x` 和 `next_y` 的值就是上一次 x 和 y 的位置，加上变化量。

看到这里，`x_values` 和 `y_values` 的功能也就明了了，他们记录的是小人每次移动后的位置。 
然后我们把这个移动的量分别存入 `x_values` 和 `y_values` 中，两个相同位置的 x 和 y 值一一对应，就是小人每次移动后的位置。

因为我们想让小人从原点出发，所以这里我们初始化 `x_values` 和 `y_values` 中的第一个值为 0。

## 绘制图像
### 基础图像

首先导入需要的模块。
**`rw_visual.py`**
```python
import matplotlib.pyplot as plt

from random_walk import RandomWalk
```

**`rw_visual.py`**
```python
rw = RandomWalk()
rw.fill_walk()

plt.scatter(rw.x_values, rw.y_values, s=10, c='blue', edgecolor='none')

plt.show()
```
首先创建一个 `RandomWalk` 类的实例，并运行 `fill_walk()` 函数来生成数据。

然后绘制散点图，x 和 y 的数据即 `RandomWalk` 中的 `x_values` 和 `y_values`。
![我的效果图](https://tva1.sinaimg.cn/large/006tNbRwly1gbfit0o8orj30zk0twtbu.jpg)

### 进阶图像
既然是随机漫步，我们就想知道开始的位置和结束的位置，以及行走的方向。

**`rw_visual.py`**
```python
rw = RandomWalk()
rw.fill_walk()

--snip--

plt.figure(figsize=(10, 6))

point_numbers = list(range(rw.num_points))
plt.scatter(rw.x_values, rw.y_values, s=10, c=point_numbers, cmap=plt.cm.Blues,
	edgecolor='none')

# 突出起点和终点
plt.scatter(0, 0, c='green', edgecolor='none', s=100)
plt.scatter(rw.x_values[-1], rw.y_values[-1], c='red', edgecolor='none', s=100)

--snip--
plt.show()
```
`plt.figure(figsize=(10, 6))` 设置了绘图窗口的尺寸，`figure()` 是用来指定图表的一些参数的，例如尺寸、分辨率、颜色，这里我们制定尺寸，所以需要给形参 `figsize` 一个**元组**，规定绘图窗口的尺寸，单位是**英寸**。

这里 Python 默认你的屏幕分辨率是 80 PPI（像素/英寸），如果想设定的话，可以使用形参 `dpi`，如 `plt.figure(dpi=128, figsize(10, 6))`。[^1]

然后我们想按照漫步的顺序来给点上色，先走到的点颜色浅，后走到的点颜色深，于是我们创建一个列表，内容是 `[1,2,3,..., rw.numpoints]`，这个列表的长度刚好与漫步的次数相同。

此外，我们还想突出起点和终点，于是使用了额外的两行，重新定义了起点和终点的属性。起点就是 `(rw.x_values[0], rw.y_values[0])` 点，也就是 `(0, 0)` 点，我们用绿色标出；终点就是最后一组数据，即 `(rw.x_values[-1], rw.y_values[-1])` 点，用红色标出。

![我的效果图](https://tva1.sinaimg.cn/large/006tNbRwly1gbfjzmvyexj319l0u0dlw.jpg)

除此之外还可以隐藏坐标轴：
**`rw_visual.py`**
```python
plt.axes().get_xaxis().set_visible(False)
plt.axes().get_yaxis().set_visible(False)
```
但是我这里会报两个 Warning:
```bash
MatplotlibDeprecationWarning: Adding an axes using the same arguments as a previous axes currently reuses the earlier instance.  In a future version, a new instance will always be created and returned.  Meanwhile, this warning can be suppressed, and the future behavior ensured, by passing a unique label to each axes instance.
  plt.axes().get_xaxis().set_visible(False)

MatplotlibDeprecationWarning: Adding an axes using the same arguments as a previous axes currently reuses the earlier instance.  In a future version, a new instance will always be created and returned.  Meanwhile, this warning can be suppressed, and the future behavior ensured, by passing a unique label to each axes instance.
  plt.axes().get_yaxis().set_visible(False)
```

意思似乎是，现在这个版本可以这样写，但以后可能会有问题，如果你不打算更新版本的话也没问题。
![我的效果图](https://tva1.sinaimg.cn/large/006tNbRwly1gbfka9ln6fj319l0u0jwu.jpg)

[^1]: 这个 DPI 的概念感觉不是很清楚，在这里应该就认为屏幕上的 Dots per inch 就是 Pixels per inch 了。
