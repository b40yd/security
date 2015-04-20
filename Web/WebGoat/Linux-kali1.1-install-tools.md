## 安装工具和环境
由于，我目前的环境都是现成的，所以，我直接用的kali1.1和OWASPBWA的VM环境。
如果没有，需要按照以下步骤安装自己的环境。

### 安装Webgoat
0x000 下载[Webgoat](https://www.owasp.org/index.php/Proyecto_WebGoat_OWASP)程序

0x010 Windows系统上安装

    需要安装好java环境，tomcat，apache等web服务器，自行安装

0x011 将Webgoat解压至你的工作目录

    如：tar zxvf Webgoat5.4.tar.gz -C /var/www/ (注意，tar命令，我本地windows是装了cygwin的)

0x012 启动Webgoat

    注意，如果启动了apache，80端口是已经被占用了
    若是webgoat.bat窗口一闪就没了，这里需要检查一下80端口是否被占用。如果被占用双击webgoat_8080.bat
    启动8080端口，如果嫌这样启动麻烦，可以把webgoat配置到apache服务器中！（建议这样做，这样可以运行多个web应用）

0x020 Linux系统上安装

    跟上面的步骤一样，不再赘述，操作都基本一样，只是环境的区别。

0x030 测试Webgoat是否正常运行

    启动浏览器，在地址栏输入http://localhost/WebGoat/attack（注意，URI是区分大小写的）
    5.2是 http://localhost/WebGoat/attack
    5.3的是 http://localhost/webgoat/attack 
    输入用户名：guest  密码：guest （webgoat/webgoat 也能登录）

### 安装Webscarab
0x01. 下载[WebScarab](https://www.owasp.org/index.php/WebScarab)

0x02. 解压执行安装。

0x03. 启动WebScarab (注意，在linux下中文环境，按钮的文字可能显示乱码，解决办法修改系统环境语言为英语就可以了。)

### 使用Webscarab拦截http请求
0x01 设置浏览器代理。

    我用的firefox，步骤是，工具->选项->高级->网络->设置连接，手动设置代理，HTTP Proxy: locahost Port: 8008

0x02 设置代理拦截

    选择Proxy->Manual Edit勾选Intercept requests,选择需要拦截的请求方式，默认GET,POST。按住CTRL选择多个。

0x03 测试拦截

    启动firefox，随便输入http://www.baidu.com 查看summary请求的http，双击表中的一行，这时会弹出一个显示请求和响应的详细信息的窗口。
    启动webgoat，在浏览器地址栏输入http://localhost/WebGoat/attack，然后输入账号密码，进去后是一个欢迎页面，点击webgoat start，选择左边的导航General HTTP Basics，输入一个name，按go按钮，拦截到此请求，然后修改person的值提交，最后页面上的值就会变成拦截提交后的反转值。

### 总结
webgoat可以算是一个hacked游戏，即可以学习安全知识，又可以当做一个游戏来玩！
Webscarab是一个强大的http拦截工具，作为web开发安全测试工具，非常方便。

