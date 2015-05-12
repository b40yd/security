## 安装mate桌面

本来想安装cinnamon桌面的结果启动不了，需要解决一堆问题，果断的换mate了。
由于mate已经被debian官方源收录，mate-desktop.org的源中已经移除了debian和ubuntu的安装包，添加debian的backports源即可。
```
echo "deb http://http.debian.net/debian wheezy-backports main contrib non-free" >> /etc/apt/sources.list

apt-get update
apt-get install mate-archive-keyring
```
打开终端直接执行
```
apt-get install kali-defaults kali-root-login desktop-base mate-core mate-desktop-environment mate-desktop-environment-extra
```
安装MATE的好处是可以使用原始GNOME下的kail 工具菜单，这是其它桌面环境没有的，方法：
```
vim /etc/xdg/menus/mate-applications.menu
```
找到Internet 节点，在`</Menu> <!-- End Internet -->`下面加入：
```
<!-- Kali Linux  -->
<MergeFile type="path">applications-merged/kali-applications.menu</MergeFile>
```
保存，之后就可以在应用程序里看到“kali linux”的工具菜单了
