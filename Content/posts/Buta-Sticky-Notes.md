---
title: Buta Sticky Notes
date: 2020-10-13 14:30
updated: 2020-10-31 03:32
description: 日常解决问题基本靠 Google，拿来水博客跟 Copy&Paste 也没啥区别，但是又想把这些方法记录下来，万一以后需要用还方便查看，于是打算全部写在这一篇文章里了。
tags: Linux, Raspberry Pi, Docker
categroy: 杂谈
index_img: /media/posts_img/buta_sticky_notes_index.jpg
banner_img: /media/posts_img/buta_sticky_notes.jpg
---

当然，为了防止未来的我忘记当时写的是什么东西，咱尽量将一些因人而异、因机而异的东西标注出来（比如每段的 Replacement），但难免有疏漏，**如果有读者能够看到，并感到疑惑，请不要吝啬你的留言**。

## 为 Docker 设置代理

> 2020-10-13T06:59:27UTC

1. 在这个文件夹 `/etc/systemd/system/docker.service.d` （没有就新建一个）里创建一个 `http-proxy.conf` 文件。

2. 内容这样写：

   ```ini
   [Service]
   Environment="HTTP_PROXY=http://proxy.example.com:80/"
   ```

3. 然后刷新 `systemd` 配置：

   ```sh
   sudo systemctl daemon-reload
   ```

4. 检查一下：

   ```sh
   systemctl show --property=Environment docker
   ```

5. 重启 docker

   ```sh
   sudo systemctl restart docker
   ```

## Systemd 配置 clash service
> 2020-10-13T06:59:27UTC

1. 编辑 `/usr/lib/systemd/system/clash.service`：

   ```ini
   # edit and save this file to /usr/lib/systemd/system/clash.service
   [Unit]
   Description=clash
   After=network.target
   
   [Service]
   WorkingDirectory=[your home directory]/.config/clash
   ExecStart=[your home directory]/.config/clash/start-clash.sh
   ExecStop=[your home directory]/.config/clash/stop-clash.sh
   Environment="HOME=[your home directory]"
   Environment="CLASH_URL=[your subscription url]"
   
   [Install]
   WantedBy=multi-user.target
   ```

   > Replacement: `[your home directory]`,`[your subscription url]`

2. Clash 启动脚本:

   编辑 `[your home directory]/.config/clash/start-clash.sh`

   ```sh
   #!/bin/bash
   # save this file to ${HOME}/.config/clash/start-clash.sh
   
   # save pid file
   echo $$ > ${HOME}/.config/clash/clash.pid
   
   diff ${HOME}/.config/clash/config.yaml <(curl -s ${CLASH_URL})
   if [ "$?" == 0 ]
   then
       /usr/bin/clash
   else
       TIME=`date '+%Y-%m-%d %H:%M:%S'`
       cp ${HOME}/.config/clash/config.yaml "${HOME}/.config/clash/config.yaml.bak${TIME}"
       curl -L -o ${HOME}/.config/clash/config.yaml ${CLASH_URL}
       /usr/bin/clash
   fi
   ```

3. Clash 停止脚本

   编辑 `[your home directory]/.config/clash/stop-clash.sh`

   ```bash
   #!/bin/bash
   # save this file to ${HOME}/.config/clash/stop-clash.sh
   
   # read pid file
   PID=`cat ${HOME}/.config/clash/clash.pid`
   kill -9 ${PID}
   rm ${HOME}/.config/clash/clash.pid
   ```

4. 上面几个文件给个权限（`chmod`）

5. 
	```bash
   systemctl enable clash
   systemctl start clash
   ```

### 编辑订阅文件

> 2020-10-14T04:41:20UTC

```
sed -e '6cexternal-controller: :9090' config.yaml -i
```

例如订阅里写的外部控制为 localhost:9090，而我想改为 :9090，可以用 `sed` 来替换。然后写到 `start-clash.sh` 里。

`6c` 代表第六行。

## 自用 Shell 小脚本：配置代理

> 2020-10-13T06:59:27UTC

```bash
function proxy() {
	if [[ -n $1 ]]; then
		if [[ $1 == 'localhost' ]]; then
			addr='localhost'
		elif [[ $1 == 'pi' ]]; then
			addr='10.0.0.2'
		elif [[ $1 == 'router' ]]; then
			addr='10.0.0.1'
		else
			addr=$1
		fi
	else
			addr='localhost'
		fi

	if [[ -n $2 ]]; then
		export https_proxy=http://$addr:$2 http_proxy=http://$addr:$2 all_proxy=socks5://$addr:$2
	else
		export https_proxy=http://$addr:7890 http_proxy=http://$addr:7890 all_proxy=socks5://$addr:7890
	fi
}
```
用法：


`proxy` 设置置本地代理，端口为 HTTP 7890
`proxy <address>` 设置代理，可以选择预设的地址或者输入其他地址
`proxy <address> <port>` 设置代理，地址和端口



## Linux 开机挂载 SMB

> 2020-10-13T06:59:27UTC
>
> Replacement: `[]`

1. 用 `id [USERNAME]`(`[USERNAME]` 为本机用户名) 为用户名查看 `uid` 和 `gid`。

2. 编辑 `cred` 文件，例如 `~/.smbcredential` （名字、位置随意）：

   ```
   username=[SMB_USERNAME]
   password=[SMB_PASSWORD]
   ```

   

3. 编辑 `/etc/fstab`：

   ```txt
   //[Addredd]/[Path]	/[MountPoint]	cifs	uid=[UID],gid=[GID],cred=[PathToCredential]
   ```

   例如

   ```txt
   //10.0.0.1/Files        /media/router   cifs    uid=1000,gid=1000,cred=/home/ubuntu/.smbcredential
   ```

### 问题

#### mount error(2): No such file or directory

```txt
mount error(2): No such file or directory
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel log messages (dmesg)
```

尝试给挂载命令加个版本（默认 SMB 为 3.0），尝试更改到 2.0。`vers=2.0`

```txt
//10.0.0.1/Files        /media/router   cifs    uid=1000,gid=1000,vers=2.0,cred=/home/ubuntu/.smbcredential
```

## zsh_history 不记录错误命令

> 2020-10-31T03:32:11UTC

`.zshrc` 中：

```bash
zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }
```




