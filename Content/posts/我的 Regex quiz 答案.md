---
title: 我的 Regex quiz 答案
keywords: 正则表达式, Regex, Regex101, Regex quiz answer
description: 正则表达式写起来比看别人的难，所以把我的过程也放在这里。
cover: false
top: false
author: Butanediol 丁二
date: 2022-02-18 15:43
updated: 2022-02-18 15:43
tags: 笔记, 代码
index_img: /media/posts_img/my_regex_101_answer_index.jpg
banner_img: /media/posts_img/my_regex_101_answer.jpg
summary: 我的 regex101.com quiz 答案与总结。
categories: 写代码
---

```note.info
在哪里可以做到题目？[Regex101.com](https://regex101.com)
endnote
```

## TASK 1 WORD BOUNDARIES

> Check if a string contains the word `word` in it (case insensitive). If you have no idea, I guess you could try /word/.

```note.success
我的答案 (11/11)：
```regexp
/\bword\b/i
```
endnote
```

`\b` 表示单词的边界。
`/i` 标记大小写不敏感。

## TASK 2 CAPITIALIZING I

> Use substitution to replace every occurrence of the word `i` with the word `I` (uppercase, I as in me). E.g.: `i'm replacing it. am i not?` -> `I'm replacing it. am I not?`. A regex match is replaced with the text in the `Substitution` field when using substitution.
> 就是把单独的 i 换成 I。（将英语里应该是「我」的 i 都改成大写。）

{% note success %}
我的答案 (9/9)：
REGULAR EXPRESSION
```regexp
/\bi\b/g
```

SUBSTITUTION
```
I
```
{% endnote %}

`\b` 表示单词的边界。
`/g` 表示全局替换，不加就只替换第一个，提交会有如下提示：

> Test 7/9: You are not replacing all occurrences of i. I think I would very much like to capitalize every "I" in my sentences! Remember, the engine will only match the first occurrence unless you tell it otherwise!

## TASK 3 UPPERCASE CONSONANTS

> With regex you can count the number of matches. Can you make it return the number of uppercase consonants (B,C,D,F,..,X,Y,Z) in a given string? E.g.: it should return 3 with the text ABcDeFO!. Note: Only ASCII. We consider Y to be a consonant! Example: the regex /./g will return 3 when run against the string abc.
> 找到所有的大写辅音字母： `BCDFGHJKLMNPQRSTVWXYZ`

{% note warning %}
我的答案 (32/16)：
```regexp
/[B-D]|[F-H]|[J-N]|[P-T]|[V-Z]/g
```
{% endnote %}

这个我真不会（。

{% note warning %}
更靠谱的答案 (19/16)：
```regexp
/(?![AEIOU])[A-Z]/g
```
{% endnote %}

没想到可以这么简单，先用 `{?!}` 排除掉 `AEIOU` 再匹配 `[A-Z]` 就可以了。`[^]` 的话只能排除单个字符。

`{?!}` 这个东西叫 Negative Lookahead，有的翻译成**否定式向前查找**，我感觉这个**向前**太具有迷惑性了，不若改成**否定式正向查找**。例如 `hello{?!world}` 就是指 `hello 后面不能有 world`。

所以上面的本题答案的意思就是**不能是`AEIOU`但还要属于[A-Z]**。

但是！虽然很接近，但这仍不是本题最短解。从哪里还可以再扣掉三个字符呢？

{% note warning %}
更更短的答案 (18/16)：
```regexp
/(?![EIOU])[B-Z]/g
```
{% endnote %}

But hey! 你这也只少了一个字符啊，16 怎么来的呢？

{% note success %}
最短的答案 (16/16)：
```regexp
[^U+0001-AEIOU[-ÿ]
```
{% endnote %}

下面是抄来的解释：

- `U+000` 匹配了所有在 `U+0` 列表里的单个字符（大小写敏感）[^1]
- `1-A` 匹配了 `1` 到 `A` 之间的所有单个字符
- EIOU 匹配了 `E` `I` `O` `U` （废话）
- `[-ÿ` 匹配了 `[` 到 `ÿ` 之间的所有字符

其中后三条应该都是指的 ASCII 和 Extended ASCII 中的顺序，第一条应该是 Unicode。

注意，上面的四条全部是**要被排除的字符**！所以剩下的就只有要求的字母了。 

## TASK 4 RETRIEVE NUMBERS

> Count the number of integers in a given string. Integers are, for example: 1, 2, 65, 2579, etc.
> 别被这个 Count 迷惑了，它其实只是让你匹配整数一下而已。

{% note success %}
我的答案 (6/6)：
```regexp
/\d+/g
```
{% endnote %}

为什么这题不放在 TASK 1？

## TASK 5 WHITE SPACE

> Find all occurrences of 4 or more whitespace characters in a row throughout the string.

{% note success %}
我的答案 (9/9)：
```regexp
/\s{4,}/g
```
{% endnote %}

这个没什么好说的，用 `{3,}` 就可以了

## TASK 6 BROKEN KEYBOARD

> Oh no! It seems my friends spilled beer all over my keyboard last night and my keys are super sticky now. Some of the time whennn I press a key, I get two duplicates. Can you ppplease help me fix thhhis?
> 简单来说就是有三个连续相同字符就替替换成单个字符。例如：
> ```txt
> aaa -> a
> aaaa -> aa
> aaaaa -> aaa
> aaaaaa -> aa
>```

{% note warning %}
我的答案 (11/11)：
```regexp
/(.)\1{2}/g
```
{% endnote %}

匹配任意一个字符非常简单，但如果用 `(.){3}` 匹配并用 `$1` 替换的话，你会发现所有连续的字符都会被判定为替换，例如 `abcdefg`
会被替换成 `adg`，所以需要加上一个 `\1`，意思是只有相同的才行。

## TASK 7 VALIDATE AN IP

> Validate an IPv4 address. The addresses are four numbered separated by three dots, and can only have a maximum value of 255 in either octet. Start by trying to validate `172.16.254.1`.
> TLDR：匹配一个 IP 地址

虽然读者应该都知道一个 IPv4 地址长啥样，但还是要特别提一句，`1.01.1.1` 是不合法的。

{% note warning %}
我的答案 (85/39)：
```regexp
/^(?:(?:25[0-5]|2[0-4]\d|1\d{2}|\d{2}|\d)\.){3}(?:25[0-5]|2[0-4]\d|1\d{2}|\d{2}|\d)$/
```
{% endnote %}

首先每一位不可能大于 `255`，但正则没有办法直接比较数字的大小，所以只能拆开了判断。

- 如果是三位数
  - 如果第一位是 2
    - 如果第二位是 5，第三位就可以是 `[0-5]`
      ```regexp
      (?:25[0-5])
      ```
    - 如果第二位是 `[0-4]`，第三位就可以是 `\d`
      ```regexp
      (?:2[0-4]\d)
      ```
  - 如果第二位是 1，后 `2` 位就可以是 `\d`
    ```regex
    (?:1\d{2})
    ```
- 如果是 2 位数，那么这 `2` 位都可以是 `\d`
  ```regexp
  (?:\d{2})
  ```
- 如果是一位数，那就只能是 `\d`，因此可以和 2 位数结合起来
  ```regexp
  (?:\d{1,2})
  ```
{% note info %}
这里确实有个小问题就是，`\d{1,2}` 是可以匹配到 `01` 的，在 IPv4 地址中并不合法，但题目并没有针对这一点的测试，所以如果在意的话就不要放在一起了。
{% endnote %}

把上面结合起来就是「一个」数字（下面我会用 `NUM` 来代替）：
```regexp
(?:25[0-5]|2[0-4]\d|1\d{2}|\d{2}|\d)
```

然后前三「个」数字后都会跟一个点 `.`：
```regexp
(?:NUM\.){3}
```

最后再附上一「个」数字，并标注开头和结尾：
```regexp
^(?:NUM\.){3}NUM$
```

突然想到，数字后面可以是点 `.`，也可以是结尾 `$`，那我就可以把这两者合并：

{% note warning %}
我的优化后答案 (57/39)：
```regexp
/^(?:(?:25[0-5]|2[0-4]\d|1\d{2}|\d{2}|\d)(?:\.|$)){4}\b$/
```
{% endnote %}

注意这个 `\b`，如果不加的话 `1.1.1.1.` 也会被匹配到，报错：

> Test 24/139: There should be only three periods.

{% note warning %}
优化后的答案也还跟最短答案有很大差距，好想知道只用 39 个字符是怎么匹配的。
{% endnote %}

## TASK 8 HTML TAGS(OPTIONAL)

> Strip all HTML tags from a string. HTML tags are enclosed in < and >. The regex will be applied on a line-by-line basis, meaning partial tags will need to be handled by the regex. Don't worry about opening or closing tags; we just want to get rid of them all. Note: This task is meant to be a learning exercise, and not necessarily the best way to parse HTML.
> 把所有 HTML 标签删掉（用空字符串替代）。这里的 HTML 标签范围比较广，形如 `<body>` `</br>` 甚至 `<html + 行尾` `行首 + script>` 这种不闭合的都算在内。
> 至于标签的名字无所谓，题目保证 `<` `>` 不算在内。

{% note warning %}
我的答案 (26/14)：
REGULAR EXPRESSION
```regexp
/(?:^|<)[^<>]*>|<[^<>]*/mg
```

SUBSTITUTION
```

```
{% endnote %}

首先想到的就是左右一个 `<>`，然后中间用 `.`填充。前面再加上一个可选的 `/`。（关于这里要不要加上对 `/` 的判断不能确定，毕竟标签内部的内容只要不是 `<` `>` 什么都行，所以暂时存疑）

```regexp
<\/?(?:.)+>
```

提交一下会有如下报错：
> Test 3/15: Your pattern is too greedy, and it is consuming the text between two tags. You're incorrectly consuming the string foo in the following example: `<div>foo</div>`.

经过测试会发现，`<html>foo</html>` 确实会被整段替换掉。那就

所以打开 Ungreedy 开关再试试：
> Test 11/15: Also remove empty tags: <>.

没有考虑到空标签，好吧，这个好解决，把 `.` 也用 `*` 标记为可选或多个：
```regexp
<\/?(?:.*)+>
```

依旧报错：
> Test 12/15: Tags can sometimes span multiple lines. For that reason you should also remove `partial` tags, which may be missing either `<` or `>` if they occur at the start or end of the string, respectively. For example, `body>text</body`

看来我没有考虑到未闭合标签的情况，但是直接给 `<` `>` 都加上 `?` 也是不可行的，这样的话，模式中的每一项都成了可选的，即空也会被匹配到，所以我只能用笨办法，复制一份，然后用 `|` 连接，此外直接用 `?` 标记也是不可行的，因为未闭合的标签只能在行首或行尾：
```regexp
(?:^|<)\/?.*>|<\/?.*(?:$|>)
```

结果分数还更低了：
>Test 5/15: Your pattern is not working. I believe it's stripping more than it should when applied to the text `before<br>after`. You can read about negated character classes here.

报错给出了一个例子 `before<br>after`，这个例子会把 `before<br>` 都匹配到，看来是标签的内容匹配出了问题，把左边这个 `<` 当做了标签名字的一部分，然后整体变成了左边未闭合的标签，那我就把匹配标签名称的 `.` 扣掉 `<>` 这两个符号：
```regexp
(?:^|<)\/?[^<>]*>|<\/?[^<>]*(?:$|>)
```

其实这样已经通过了，但还可以再优化，因为我们已经规定了标签的内部不能是 `<>`，所以可以把 Ungreedy 关掉，并且把用来匹配 `/` 的也删掉。
```regexp
(?:^|<)[^<>]*>|<[^<>]*(?:$|>)
```

以及其实 `|` 的前半部分已经把完整的标签匹配到了，后面可以只考虑位于行尾的右开标签：
```regexp
(?:^|<)[^<>]*>|<[^<>]*
```

不过我的分数依然距离最短长度有不小差距。

[^1]: [Unicode 字符列表](https://zh.wikipedia.org/wiki/Unicode字符列表)