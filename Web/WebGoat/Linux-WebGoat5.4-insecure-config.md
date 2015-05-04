## 不安全配置
描述配置不当，参数错误的配置。

### 使用场景
服务的配置文件，配置参数，权限配置等。

### 漏洞分析
一般配置出现的缺陷是开启不当的功能或者是参数设置错误。比如apache开启trace功能会造成trace相关的攻击。
PHP disable_functions禁用的函数不彻底。当前工作用户权限过高，上传目录可执行脚本，sh执行权限。
例如：
```text
#nginx.conf
user root;

#php-fpm.conf
user root
group root

#work path
drwxrwxrwx www /var/www/upload 

#php.ini
disable_functions=
#需要禁用的函数
#disable_functions=phpinfo,eval,passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_alter,ini_restore,dl,pfsockopen,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,fsockopen 
```
以上就会造成一些漏洞存在，比如，存在上传脚本漏洞，就可以执行任何命令操作，权限为root。

### 危害
根据配置情况决定安全系数高度。如果有严重的不安全配置，就会造成整个系统沦陷。

### 解决方案
一般web工作环境的解决方案。

0x01. 让木马上传后不能执行

针对上传目录，如在nginx配置文件中加入配置，使此目录无法解析php。

0x02. 让木马执行后看不到非当前目录文件

如php-fpm，取消php-fpm运行账户对于其他目录的读取权限。

0x03. 木马执行后命令不能执行

如php-fpm，取消php-fpm账户对于sh的执行权限。

0x04. 命令执行后权限不能过高

如php-fpm不要用root或者加入root组。