## 配置apt仓库源

### 配置源
```text
# 

# deb cdrom:[Debian GNU/Linux 7.0 _Kali_ - Official Snapshot amd64 LIVE/INSTALL Binary 20150312-17:50]/ kali contrib main non-free

#deb cdrom:[Debian GNU/Linux 7.0 _Kali_ - Official Snapshot amd64 LIVE/INSTALL Binary 20150312-17:50]/ kali contrib main non-free

deb http://mirrors.aliyun.com/kali kali main non-free contrib
deb-src http://mirrors.aliyun.com/kali kali main non-free contrib
deb http://mirrors.aliyun.com/kali-security kali/updates main contrib non-free

deb http://mirrors.aliyun.com/debian wheezy main
#deb http://mirrors.aliyun.com/debian jessie main

deb http://http.kali.org/kali kali main non-free contrib
deb-src http://http.kali.org/kali kali main non-free contrib

deb http://security.kali.org/ kali/updates main contrib non-free
# Line commented out by installer because it failed to verify:
#deb-src http://security.kali.org/ kali/updates main contrib non-free

#中科大kali源
deb http://mirrors.ustc.edu.cn/kali kali main non-free contrib
deb-src http://mirrors.ustc.edu.cn/kali kali main non-free contrib
deb http://mirrors.ustc.edu.cn/kali-security kali/updates main contrib non-free
 
#新加坡kali源
deb http://mirror.nus.edu.sg/kali/kali/ kali main non-free contrib
deb-src http://mirror.nus.edu.sg/kali/kali/ kali main non-free contrib
deb http://security.kali.org/kali-security kali/updates main contrib non-free
deb http://mirror.nus.edu.sg/kali/kali-security kali/updates main contrib non-free
deb-src http://mirror.nus.edu.sg/kali/kali-security kali/updates main contrib non-free
 
#debian_wheezy国内源
 
deb http://ftp.sjtu.edu.cn/debian wheezy main non-free contrib
deb-src http://ftp.sjtu.edu.cn/debian wheezy main non-free contrib 
deb http://ftp.sjtu.edu.cn/debian wheezy-proposed-updates main non-free contrib 
deb-src http://ftp.sjtu.edu.cn/debian wheezy-proposed-updates main non-free contrib 
deb http://ftp.sjtu.edu.cn/debian-security wheezy/updates main non-free contrib 
deb-src http://ftp.sjtu.edu.cn/debian-security wheezy/updates main non-free contrib 
deb http://mirrors.163.com/debian wheezy main non-free contrib 
deb-src http://mirrors.163.com/debian wheezy main non-free contrib 
deb http://mirrors.163.com/debian wheezy-proposed-updates main non-free contrib 
deb-src http://mirrors.163.com/debian wheezy-proposed-updates main non-free contrib 
deb-src http://mirrors.163.com/debian-security wheezy/updates main non-free contrib 
deb http://mirrors.163.com/debian-security wheezy/updates main non-free contrib
deb http://http.debian.net/debian wheezy-backports main
```

需要注意的是
```
#deb http://mirrors.aliyun.com/debian jessie main
```
这个被我注释掉了，原因就是这个是最新的debian包，如果打开后，需要更新很多东西，在非必要的情况下最好不要使用，就怕出问题。不过，在安装某些包的时候可以用它，比如emacs24就需要用到。
