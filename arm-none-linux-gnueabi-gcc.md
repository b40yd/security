## arm-none-linux-gnueabi
#### arm-none-linux-gnueabi 工具链，命令执行的错误：
#### -bash: /root/gcc/arm-2011.03/bin/arm-none-linux-gnueabi-gcc: No such file or directory
#### 解决办法：
```bash
$ sudo apt-get install build-essential automake autoconf libtool
$ sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0
```
安装 `IA32-LIBS`这个包即可。
