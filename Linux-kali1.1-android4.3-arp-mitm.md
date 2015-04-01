##利用ettercap进行简单的arp欺骗和mitm攻击过程  

0、环境工具
- 操作系统kali1.1
- ettercap
- driftnet

1、利用ettercap进行arp欺骗：
打开ettercap：`ettercap -C` （curses UI） or  `ettercap -G` （GTK+ GUI）

2、打开ettercap之后，选择Sniff--Unified-sniffing，然后选择网卡(eth0)
然后Hosts--Scan for hosts--Hosts list，此时可以看到目标主机ip(192,168.199.106,我的安卓手机)

3、选定目标主机，然后点add to target 1,将目标主机添加到目标1;选定路由，点add to target 2,将路由添加到目标2。

4、然后点mitm--arp posoning ，勾选sniff remote connections。

5、之后start--start sniffing开始监听～

6、点view--connections开始查看连接，双击链接查看详细信息

7、自动截获目标机的网络数据，账号和明文密码

8、利用ettercap+driftnet截获目标主机的图片数据流
```bash
#打开一个终端窗
[root@kali: ~#] ettercap -i eth0 -Tq -M arp:remote /192.168.199.106/ /192.168.199.1/ 
#新建一个终端窗口，执行：
driftnet -i eth0        #监听eth0
```

ps: 实时的监控着你的手机！！！！