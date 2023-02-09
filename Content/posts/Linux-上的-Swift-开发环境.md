---
title: Linux 上的 Swift 开发环境
date: 2021-08-24 20:50
updated: 2021-08-24 20:50
description: 最近用 Swift 重写了 TelegramBot，发现写起来比 Python 版的爽太多。
---

其实想要在 Linux 上写 Swift 的话，装一个 toolchain 就完事了，毕竟有记事本和一个 terminal 就够了，但只是安装 toolchain 的话就没什么意思了，不光要写，还要写得爽才行！

## 安装 toolchain

这不是本文的重点，所以就写得简略一点。

### 官方网站下载，手动安装

你可以直接按照[官方网站](https://swift.org)上的 [Getting Started](https://swift.org/getting-started/) 安装。官方支持了 Ubuntu 16.04/18.04/20.04，CentOS 7/8，和 Amazon Linux 2。

### 安装脚本

官方给的平台比较少，如果你是 Debian 或者 Rasbian，还可以用 [Swiftlang.xyz](https://swiftlang.xyz/public/) 的脚本来安装。

这个脚本支持 Ubuntu 18.04/20.04/21.04，Debian 10，Raspbian(buster)。

### AUR

~~众所周知，AUR 啥都有。~~

就贴两个链接，或者你也可以自己搜（

[Swift-bin](https://aur.archlinux.org/packages/swift-bin/)
[Swift-bin-development](https://aur.archlinux.org/packages/swift-bin-development/)

---

下面我默认你的 swift binary 位于 /usr/bin/ 下，并已经配置好了环境变量，如果不是，请自行替换。

## Desktop

那我当然是选择世界第一 GUI 编辑器 Sublime Text！

### 安装插件

- 首先安装代码高亮插件。Swift 的代码高亮插件有两个，个人推荐 `Decent Swift Syntax`，另一个在字符串模板高亮中会有问题。

- 然后是代码提示插件 `LSP`。

这个插件需要稍微配置一下。打开 Package Settings 中的 `LSP.sublime-settings`：

```json
// Settings in here override those in "LSP/LSP.sublime-settings"
{
    "clients": {
        "sourcekit-lsp": {
            "enabled": true,
            "command": ["/usr/bin/sourcekit-lsp"],
            "selector": "source.swift"
        },
        "clangd": {
        	"enabled": true,
        	"command": [
        		"/usr/bin/clangd"
        	]
        }
    }
}
```

这样在打开单个 `.swift` 文件和包含 `package.swift` 的 SPM 管理项目文件夹的时候，`sourcekit-lsp` 应该会自动检查代码。后者可能需要你手动 build 一次，把依赖项下载下来。

## Remote Headless Server

这里我是用的是 ~~`VSCode`~~ `Codeserver`。虽然 `VSCode` 是 #rubbish，但后端跑在服务器上，前端随便找个浏览器就行的 `Codeserver` 我还是可以接受的。

### 安装

自己装！[Codeserver](https://github.com/cdr/code-server)

### 插件

#### Swift Language

代码高亮

#### Maintained Swift Development Environment

这个插件包括了打断点（Linux 上似乎不太好所以）和代码补全，需要修改的设置如下：

**Sde > Enable Tracing: LSPServer** Enable

**Sde: Language Server Mode** sourcekit-lsp

**Sourcekit-lsp: Server Path** /usr/bin/sourcekit-lsp

**Sourcekit-lsp: Toolchain Path** /usr/bin

#### SourceKit-LSP

如果你不想用上面那个，你还可以使用这个[苹果官方的插件](https://github.com/apple/sourcekit-lsp/blob/main/Editors/vscode/README.md)，需要自行编译。

或者你可以下载我[编译好的版本](https://warehouse.butanediol.me/Miscellaneous/Share/sourcekit-lsp-development.vsix)，但估计你看到的时候已经不是最新版了。

## 测试

来一发紧张刺激的 http 请求测试一下！

![测试图片](/media/article_img/swift_server/1.jpg)
