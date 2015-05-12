## Kali 安装

0x01、到官方下载[kali](https://www.kali.org/downloads/)最新版本的系统。
需要使用[Universal-USB-Installer](http://www.pendrivelinux.com/universal-usb-installer-easy-as-1-2-3/)刻U盘，用它制作u盘启动。


0x02、UEFI模式安装
我最开始也在这里卡了很久，根据不同的主板设置步骤可能不一样，我的机器是acer vn7-591g默认是不能修改uefi的secure boot的，需要设置BIOS的超级密码才行。默认是可以使用legacy这个模式的，但是secure boot没有disable，一样装不了。这里需要设置secure boot = disable。
然后选择U盘启动即可。

0x03、显卡驱动安装
系统安装完成后，需要安装显卡，比如NVIDIA GTX960M的驱动，去[官方](http://www.geforce.cn/drivers)找到最新的。
首先，进入命令模式，注意安装这个不要安装kali默认的要出问题，我就是因为这个原因重装了好几次系统（主要有系统洁癖）。
ctrl+alt+f1进入命令模式，这里可以设置init 3重启进入命令模式。
如果是用第一种方式需要关闭gdm3，kali默认是gnome的桌面环境。需要关闭它，命令：
`/etc/init.d/gdm3 stop`然后安装内核源代码`apt-get install linux-headers-$(uname -r)`注意这里需要配置源默认是没有的。

