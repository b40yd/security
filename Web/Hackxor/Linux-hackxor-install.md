## 安装Hackxor
hackxor的[主页地址](http://hackxor.sourceforge.net/cgi-bin/index.pl)里面有详细介绍。

### 下载VM压缩包
0x00 首先，下载VM镜像的压缩包。
[下载地址](http://sourceforge.net/projects/hackxor/files/hackxor11.7z/download)

0x01 解压hackxor和启动，在虚拟机的/usr/share/tomcat6目录中可以看到所有渗透平台的代码（/home/hackxor/allSites目录下是应用程序代码的备份）。该目录下的start.sh程序是用于启动服务，install.sh是安装渗透平台，update.sh是升级tomcat6和mysql的脚本，切记千万不要升级，升级之后由于tomcat版本和相关java类库不同，程序会报500 Error错误，修改起来很麻烦，而且对于单纯的测试网站的性能完全没有必要升级。

0x02 运行start.sh脚本开启tomcat6和mysqld服务，fedora下查看 进程命令是：
```shell
$ ps aux | grep mysql  
#或者
$ service mysqld status
```

0x03 修改主机中的hosts文件，win7是在C:\Windows\System32\drivers\etc目录下，虚拟机的网络适配器应该设为自定义模式(此模式下虚拟机和主机在一个特定的虚拟网络下)，如将主机的host 文件中添加如下内容:
```text
192.168.199.149 wraithmail   
192.168.199.149 wraithbox  
192.168.199.149 cloaknet  
192.168.199.149 GGHB  
192.168.199.149  hub71  
192.168.199.149  utrack   
```

注意，镜像里面启动的服务端口是8080，所以在访问的时候需要使用http://wraithbox:8080这样的方式。