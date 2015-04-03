## Ettercap 参数选项详解

Ettercap是一个非常强大的中间人攻击工具；本博客之前日志也有多次涉猎，这里详细了解下ettercap的参数，算是入门篇。
参考下：
```text
    Ettercap结合sslstrip对ssl/https进行攻击
    记录利用ettercap进行简单的arp欺骗和mitm攻击过程
    Kali下使用ettercap+msf渗透WindowsXP
```

关于界面：
ettercap提供 4 种运行界面：
```text
    Text            #文本模式，参数 -T ，一般配合 -q（安静模式）使用
    Curses/GTK         #图形模式，参数 -C/-G
    Daemonize          #守护模式（后台模式），参数 -D
```

运行模式：

两种模式（UNIFIED和BRIDGED）
```text
    Unified                   #中间人模式，即两台终端间进行欺骗，参数 -M
    Bridged                  #双网卡之间进行欺骗，参数 -B
```

目标写法：
目标的写法为 MAC/IPs/PORTs ，或 MAC/IPs/IPv6/PORTs，即 mac地址，ip地址，端口号中间用 "/" 符号隔开，留空不写表示 “ANY”，即所有；如 /192.168.1.1/ 表示 192.168.1.1 的所有端口号，aa:bb:cc:dd:ee:ff//80 表示 aa:bb:cc:dd:ee:ff 的80端口；其中多个mac地址用英文符号逗号 ';' 隔开，多个ip地址和端口号可以用符号 '-' 表示连续和英文符号分号 ';' 隔开；如 /192.168.1.100-120;192.168.2.130/ 表示 /192.168.1.100,101,102,103,～～120;192.168.12.130/
 
参数介绍：
攻击和嗅探类
```text
    -M, --mitm

        ARP欺骗，参数 -M arp

            remote  #双向模式，同时arp欺骗通信的双方，参数 -M arp:remote
            oneway       #单向模式，只arp欺骗第一个目标到第二个目标的通信，参数 -M arp:oneway

        icmp欺骗，参数 -M icmp:(MAC/IP)
        DHCP欺骗，参数 -M dhcp:(ip_pool/netmask/dns)，如 -M dhcp:192.168.0.30,35,50-60/255.255.255.0/192.168.0.1是给新接入的主机提供ip地址，子网掩码和网关，-M dhcp:/255.255.255.0/192.168.0.1则不提供ip地址，只欺骗子网掩码和网关
        Port Stealing，这个没搞懂～

    -o, --only-mitm   #只进行中间人攻击，不进行嗅探
    -f , --pcapfilter     #加载过滤器
    -B, --bridge    #Bridged sniffing
```
离线类参数
```text
    -r, --read       #读取本地文件
    -w, --write      #将嗅探数据保存到本地
```
界面显示类
```text
    -T, --text       #文本模式显示  
    -q, --quiet        #安静模式，不显示嗅探数据
    -s, --script        #加载脚本
    -C, --curses       #curses-UI模式
    -G, --gtk       #GTK-UI模式
    -D, --daemonize       #daemonize后台模式
```
普通选项：
```text
    -b, --broadcast        #嗅探广播地址
    -i, --iface         #选择网卡
    -I, --iflist            #列出可用网卡
    -Y, --secondary         #后备网卡
    -A, --address          #ip地址，针对一网卡多ip的情况
    -n, --netmask             
    -R, --reversed
    -z, --silent              #不进行arp毒化和主机扫描
    -p, --nopromisc
    -S, --nosslmitm                 #不使用ssl中间人攻击
    -t, --proto         #协议，tcp/udp/all，默认为all
    -u, --unoffensive
    -j, --load-hosts                #加载保存的主机地址
    -k, --save-hosts                #保存扫描到的主机地址
    -P, --plugin                 #载入插件
    -F, --filter                     #载入过滤器文件
    -W, --wifi-key            #载入wifi密码：

      --wifi-key wep:128:p:secret
      --wifi-key wep:128:s:ettercapwep0
      --wifi-key 'wep:64:s:\x01\x02\x03\x04\x05'
      --wifi-key wpa:pwd:ettercapwpa:ssid
      --wifi-key wpa:psk:663eb260e87cf389c6bd7331b28d82f5203b0cae4e315f9cbb7602f3236708a6

    -a, --config                #载入并使用一个非默认配置文件
    --certificate              #ssl攻击使用指定的 证书文件
    --private-key            #ssl攻击使用指定的私钥文件
```
可视化参数
```text
    -e, --regex         #使用一个正则表达式
    -V, --visual           #显示方式
        hex            #16进制
        ascii           #ASCII码
        text            
        ebcdic
        html
        utf8
    -d, --dns           #把ip地址转化为主机名
    -E, --ext-headers
    -Q, --superquiet          #超级安静模式，啥信息都不显示，只保存
```
日志记录选项
```text
    -L, --log             #把所有数据包保存log文件
    -l, --log-info           #读取离线log文件信息
    -m, --log-msg              #显示存储在log文件里所有用户用ettercap抓取的信息
    -c, --compress            #通过gzip算法压缩log文件
    -o, --only-local           #只存储本地局域网主机配置信息
    -O, --only-remote           #只存储远程主机配置信息

```
常见的参数组合：
```text
ettercap -Tqi eth0 -M ARP // //           #arp毒化eth0所在的网段，安静模式文本显示

ettercap -Tzq /10.0.0.1/21,22,23  -w hack.pcap          #监听10.0.0.1的ftp，ssh，telnet信息,并保存到本地

ettercap -Tq -P dns_spoof -M arp /192.168.1.120/ //        #对192.168.1.120进行dns欺骗，使用默认网卡eth0,文本模式安静显示

ettercap -Tqi eth0 -L sniffed_data -F filter.ef -M arp:remote /10.0.0.2/80 //     #使用过滤并监听10.0.0.2在80端口的所有通信，安静模式文本显示，保存数据到本地
```