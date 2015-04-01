##Nmap 工具使用详解
####扫描类型
```text
    -sP                 #只探测主机在线情况
    -sS                 #SYN扫描（隐身扫描）
    -sT                 #TCP扫描
    -sU                 #UDP扫描
    -sV                 #系统版本检测
    -O                   #操作系统识别
     –scanflags    #指定TCP标识位（设置URG, ACK, PSH,RST,SYN,FIN位）
```
####扫描目标格式
```text
    IPv4 地址： 192.168.1.1
    IPv6 地址：AABB:CCDD::FF%eth0
    主机名：www.target.tgt
    IP 地址范围：192.168.0-255.0-255
    掩码格式：192.168.0.0/16
    使用列表文件：-iL <filename>
```
####脚本引擎
```text
    -sC 运行默认脚本
    –script=<ScriptName>
    运行个人脚本或批量脚本
    –script-args=<Name1=value1,…>
    使用脚本参数列表
    –script-updatedb
    更新脚本数据库
```
####值得关注的脚本

[完整版nmap脚本引擎的脚本](http://nmap.org/nsedoc/)

####一些特别有用的脚本包括：
```text
    dns-zone-transfer：尝试从dns服务器上拖一个AXFR请求的区域文件
    $nmap –script dns-zone-transfer.nse –script-args dns-zone-transfer.domain=<domain> -p53 <hosts>
    http-robots.txt:在发现的web服务器中获取robots.txt文件
    $nmap –script http-robots.txt <hosts>
    smb-brute:通过自动猜解尝试爆破username 和password组合
    $nmap –script smb-brute.nse -p445 <hosts>
    smb-psexec: 用登陆凭据作为脚本参数，在目标机器上运行一系列程序
    $nmap –script smb-psexec.nse –script-args=smbuser=<username>,smbpass=<password>[,config=<config>] -p445 <hosts>
```
####脚本种类
```text
nmap 的脚本种类包括但不限于下面种类：

    auth：利用或绕过目标主机的访问控制
    broadcast：通过本地网络广播发觉不包含在命令行内的主机
    brute：针对目标主机猜解密码，支持各类协议，包括：http，SNMP， IAX，MySQL,VNC等。
    default：当出现“-sC”或“-A”命令时此脚本自动运行
    discovery：通过公开的资源信息，SNMP协议，目录服务等获取更多目标主机信息。
    dos：会造成目标主机拒绝服务
    exploit：尝试exploit目标
    external：与不在目标列表的第三方系统交互
    fuzzer： 在网络协议的规定内发送意想不到的请求
    intrusive：可能会使目标崩溃，消耗过度的资源，或者通过恶意行为冲击目标系统
    malware：在目标主机上寻找恶意软件感染迹象
    safe：尽量不用负面的方式影响目标
    version：估计目标主机显示的软件或协议版本
    vul：判断目标主机是否存在一个已知漏洞
```
####扫描端口,无端口范围时扫描1000 个常用端口:
```text
    -F 扫描100个最常用端口
    -p<port1>-<port2> 指定端口范围
    -p<port1>,<port2>,…. 端口列表
    -pU:53,U:110,T20-445 TCP&UDP结合
    -r 线性扫描（不是随机扫描）
    –top-ports <n> 扫描n个最常用端口
    -p-65535 忽略初始端口，nmap从端口1开始扫描
    -p0- 忽略结束端口，nmap扫描至65535端口
    -p- 扫描0-65535端口
```
####深入扫描命令
```text
    -Pn 不探测扫描（假定所有主机都存活）
    -PB 默认探测扫描（探测端口：TCP 80，445&ICMP）
    -PS<portlist> tcp探测扫描
    -PE ICMP Echo Request
    -PP ICMP Timestamp Request
    -PM ICMP Netmask Request
```
####细粒度的时间选项
```text
    –min-hostgroup/max-hostgroup <size> 平行的主机扫描组的大小
    –min-parallelism/max-parallelism <numprobes> 并行探测
    –min-rtt-timeout/max-rtttimeout/initial-rtt-timeout <time> 指定每轮探测的时间
    –max-retries <tries> 扫描探测的上限次数设定
    –host-timeout <time> 设置timeout时间
    –scan-delay/–max-scan-delay <time> 调整两次探测之间的延迟
    –min-rate <number> 每秒发送数据包不少于<number>次
```
####时序选项
```text
    -T0 偏执的：非常非常慢，用于IDS逃逸
    -T1 猥琐的：相当慢，用于IDS逃逸
    -T2 有礼貌的：降低速度以消耗更小的带宽，比默认慢十倍
    -T3 普通的：默认，根据目标的反应自动调整时间模式
    -T4 野蛮的：假定处在一个很好的网络环境，请求可能会淹没目标
    -T5 疯狂的：非常野蛮，很可能会淹没目标端口或是漏掉一些开放端口
```
####输出格式
```text
    -oN 标准输出
    -oG 好理解的格式
    -oX xml格式
    -oA<basename> 用<basename>生成以上格式的文件 
```
####misc选项
```text
    -n 禁止反向IP地址查找
    -6 只是用 IPv6
    -A 是用几个命令：OS 探测，版本探测，脚本扫描，traceroute
    –reason 列出nmap的判断：端口开放，关闭，被过滤。
```

案例1：
nmap -v -n -sP 172.16.58.129
-v          #显示结果
-n          #不做dns解析
nmap -A -n 172.16.58.129
-A          #扫描所有信息