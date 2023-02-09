---
title: 记一次用服务器转发 OneDrive 的尝试
keywords: OneDrive, Business, Linux, VPS, 代理, WebDAV
cover: false
top: false
author: Butanediol 丁二
date: 2020-03-04 18:54
updated: 2020-03-04 18:54
tags: Linux
index_img: /media/posts_img/d5eed7edd3634a2992ecdeb7ae543fd0_index.jpg
banner_img: /media/posts_img/d5eed7edd3634a2992ecdeb7ae543fd0.jpg
summary: 白嫖的 E5 订阅所包含的 OneDrive 服务器对于大部分国内网络并不友好，恰好最近找到了一家价格低廉，性能、带宽尚可的 VPS，突发奇想，尝试用一台海外服务器转发一下，提高下载速度。
categories: 瞎折腾
---

{% note warning %}
  经过求证，rclone 挂载并不能实现流量转发，只是让文件先下载到服务器，再从服务器发送到用户，无法解决延迟和服务器空间问题。
   
  如果想用流量转发的话可以不用继续看了，不过如果你只是想在服务器上使用 rclone，你也可以参考下面的方法（虽然在 rclone 的官方文档中也有给出）。
{% endnote %}

{% note info %}
  原理类似，但效果更好的解决办法可以查看 {% btn https://blog.butanediol.me/2020/05/05/用-Cloudflare-workers-和一台-VPS-解决-OneDrive-下载问题/, 这里, 用 Cloudflare workders 和一台 VPS 解决 OneDrive 下载问题 %} 。
{% endnote %}

## 想法

尝试过了 PyOne、Onindex、OLAINDEX 等软件，其中 PyOne 带有流量转发功能，但不知道为什么，`50 MiB` 左右的小文件还能够正常转发，上百 MiB 甚至几 GiB 的文件在下载的时候均只有几十 MiB。

我猜测是 PyOne 要先将文件下载，然后再转发，这会导致两个问题：

1. 对本地空间有要求，由于 OneDrive 限制单文件大小最大为 `15 GiB`，因此你可能需要至少有 `15 GiB` 的硬盘可用空间。
2. 对网络速度有要求，`15 GiB` 的文件难道要等服务器下载完成之后才能开始下载吗？这肯定是不现实的。假设 `1 Gbps` 的理论带宽全部跑满，一个 `4 GiB` 的文件就要等待 30 秒，这个时间怕是浏览器都判定为响应超时了。

而 Onindex 和 OLAINDEX 暂时不支持流量转发。

所以我的想法是：
用 [rclone](rclone.org)[^1] 将文件夹挂载到本地，然后再用 WebDAV 或是其他的网页文件管理器来下载这个文件夹中的文件，或者导出直链来分享。

## 尝试

由于我连接到 VPS 的通道不是特别稳定，所以先在本地虚拟机上进行测试。

这里我选用的系统是 Ubuntu 18.04.4 LTS。

### rclone

#### 安装

先安装 Rclone，安装步骤在[官网](https://rclone.org/install/)上就有，现成脚本，非常简单。当然你也可以选择编译安装或者 Docker。

```bash
curl https://rclone.org/install.sh | sudo bash
```
不仅服务器需要安装，你的电脑也需要安装，这里就省略了，官网的方法十分简单。

然后在本地电脑的终端中输入:

```bash
rclone authorize "onedrive"
```

然后会自动打开一个浏览器窗口，登陆你要绑定的 OneDrive 账户。之后返回终端窗口，会看到一大段文字，找到用`{}`包裹的开头和结尾，连带 `{}` 一起复制下来，备用。

这时候返回你的服务器，按照我下面的步骤进行操作:
```bash
sudo rclone config
```
输入你的账户密码，然后会弹出这个：
```bash 
No remotes found - make a new one
n) New remote
s) Set configuration password
q) Quit config
n/s/q>
```
这里我们输入 `n` 回车，意思是添加一个远端云服务。
```bash
name> 
```
出现这个，输入一个名称，后面需要用到，**请记住**，我这里记为 `od`。

然后会弹出一大段选项，选择其中的 `OneDrive`，在我这个版本，OneDrive 是 23。
```bash
Type of storage to configure.
Enter a string value. Press Enter for the default ("").
Choose a number from below, or type in your own value
 1 / 1Fichier
   \ "fichier"
 2 / Alias for an existing remote
   \ "alias"
 3 / Amazon Drive
   \ "amazon cloud drive"
 4 / Amazon S3 Compliant Storage Provider (AWS, Alibaba, Ceph, Digital Ocean, Dreamhost, IBM COS, Minio, etc)
   \ "s3"
 5 / Backblaze B2
   \ "b2"
 6 / Box
   \ "box"
 7 / Cache a remote
   \ "cache"
 8 / Citrix Sharefile
   \ "sharefile"
 9 / Dropbox
   \ "dropbox"
10 / Encrypt/Decrypt a remote
   \ "crypt"
11 / FTP Connection
   \ "ftp"
12 / Google Cloud Storage (this is not Google Drive)
   \ "google cloud storage"
13 / Google Drive
   \ "drive"
14 / Google Photos
   \ "google photos"
15 / Hubic
   \ "hubic"
16 / In memory object storage system.
   \ "memory"
17 / JottaCloud
   \ "jottacloud"
18 / Koofr
   \ "koofr"
19 / Local Disk
   \ "local"
20 / Mail.ru Cloud
   \ "mailru"
21 / Mega
   \ "mega"
22 / Microsoft Azure Blob Storage
   \ "azureblob"
23 / Microsoft OneDrive
   \ "onedrive"
24 / OpenDrive
   \ "opendrive"
25 / Openstack Swift (Rackspace Cloud Files, Memset Memstore, OVH)
   \ "swift"
26 / Pcloud
   \ "pcloud"
27 / Put.io
   \ "putio"
28 / QingCloud Object Storage
   \ "qingstor"
29 / SSH/SFTP Connection
   \ "sftp"
30 / Sugarsync
   \ "sugarsync"
31 / Transparently chunk/split large files
   \ "chunker"
32 / Union merges the contents of several remotes
   \ "union"
33 / Webdav
   \ "webdav"
34 / Yandex Disk
   \ "yandex"
35 / http Connection
   \ "http"
36 / premiumize.me
   \ "premiumizeme"
Storage> 23
```
接下来的几个选项，前三个都可以使用默认，第四个我们选择 `no`:
```bash
Microsoft App Client Id
Leave blank normally.
Enter a string value. Press Enter for the default ("").
client_id> 
Microsoft App Client Secret
Leave blank normally.
Enter a string value. Press Enter for the default ("").
client_secret> 
Edit advanced config? (y/n)
y) Yes
n) No (default)
y/n> 
Remote config
Use auto config?
 * Say Y if not sure
 * Say N if you are working on a remote or headless machine
y) Yes (default)
n) No
y/n> n
```
接下来，请输入你刚刚从本地电脑上获得的一大串文字，包括 `{}`。这里我就不演示了。

```bash
Choose a number from below, or type in an existing value
 1 / OneDrive Personal or Business
   \ "onedrive"
 2 / Root Sharepoint site
   \ "sharepoint"
 3 / Type in driveID
   \ "driveid"
 4 / Type in SiteID
   \ "siteid"
 5 / Search a Sharepoint site
   \ "search"
Your choice> 1
```

这个地方我们选择 1。
然后稍等片刻，等待程序获取信息。之后你会看到这样一段文字：
```bash
0: OneDrive (business) id=*************
```
然后输入 `0`，回车。

如果出现这样的文字，直接回车即可：
```bash
Found drive 'root' of type 'business', URL: https://butanediol-my.sharepoint.com/personal/admin_butanediol_onmicrosoft_com/Documents
Is that okay?
y) Yes (default)
n) No
y/n>
```

最后会确认你刚刚输入的信息，直接回车，选择 `y`：
```bash
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d> 
```

接下来 rclone 会展示现有的 remotes，一般没问题，输入 `q` 回车退出即可。

#### 测试

使用下面这条命令新建一个文件夹[^2]：
```bash
mkdir onedrive
```

这里我将其命名为 `onedrive`。

这时候你可以选择再开一个 SSH 窗口，或者使用 tmux、screen 等软件（如果你熟悉 Linux），执行一下下面这条命令：

```bash
sudo rclone mount od:folder onedrive --copy-links --no-gzip-encodi --no-check-certificate --allow-other --allow-non-empty --umask 000
```
这里的 `od` 就是最初输入的名字，需要替换。

冒号后面的 `folder` 是你 OneDrive 中的文件夹名，例如你的 OneDrive 根目录中有一个叫 Share 的文件夹，那么这里就填写 `:Share`。

后面的 `onedrive` 是服务器硬盘中文件夹，这里我就用刚刚创建的文件夹。

然后在另一个窗口中进入这个文件夹：

```bash
cd onedrive
```

如果你的 OneDrive 文件夹中原本有文件，可以使用 `ls` 命令，查看原有文件。

如果你的 OneDrive 文件夹为空，可以使用 `touch filename` 命令，创建一个名为 `filename` 的新文件。不出意外的话，你的 OneDrive 中也会同步出现一个同名文件。

至此，rclone 绑定账号已经完成了。

#### 开机自启

下面这段命令，先将除去注释的第一行换成刚刚测试的那一行。

再将其中
```bash
#将后面修改成你上面手动运行命令中，除了rclone的全部参数
command="mount od:folder onedrive --copy-links --no-gzip-encoding --no-check-certificate --allow-other --allow-non-empty --umask 000"
command="mount Butanediol:Share /home/butanediol/Onedrive --copy-links --no-gzip-encoding --no-check-certificate --allow-other --allow-non-empty --umask 000"
#以下是一整条命令，一起复制到SSH客户端运行
cat > /etc/systemd/system/rclone.service <<EOF
[Unit]
Description=Rclone
After=network-online.target

[Service]
Type=simple
ExecStart=$(command -v rclone) ${command}
Restart=on-abort
User=root

[Install]
WantedBy=default.target
EOF
```

### Caddy

对 Caddy 指定一个目录，Caddy 可以自动生成一个简易的页面，相当于一个文件服务器。

那么配置 Caddy 指定这个挂载 OneDrive 的路径就可以了。

```
https://yourdomain.com {
  gzip
  tls example@yourdomain.com
  browse /onedrive-mount-path
}
```

[^1]:rclone 是一个命令行软件，它可以同步许多云储存服务。
[^2]:你可以起任意名字，或者使用其他可用的文件夹。









