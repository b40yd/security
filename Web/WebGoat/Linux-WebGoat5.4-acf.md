## 访问控制缺陷
主要是一个用户角色能访问该角色不能访问的资源。常见的有基于角色的访问控制，基于路径的访问控制。

### 使用场景
基于角色的访问控制应用于各种资源的访问权限分配管理,要求要有严格的保密措施。
基于路径的访问控制一般这种漏洞存在于文件浏览，写内容到文件，查看文件内容。比如上面的实例就是一个文件查看，在整个操作过程不当的时候就会出现这样的缺陷。
比如PHP臭名昭著的include，require等也是基于路径访问的。

### 漏洞分析
- 0x01 基于角色的访问控制

一般基于角色的访问控制缺陷就是用户权限越权访问，一般都是逻辑错误。
一个基于角色的访问控制方案通常有两个部分组成：角色权限管理 和 角色分配。一个错误的基于角色的访问控制方案可能允许用户执行未分配角色的权限项（平行权限漏洞），或允许特权升级到未授权的角色。

平行权限漏洞：用户 A 可以利用来访问用户 B 的敏感资源的漏洞。通常，平行权限漏洞产生的原因是在展现用户信息时，使用了较易被伪造的身份依据。

比如使用Cookie验证用户身份当然要比利用页面或URL验证用户身份的安全性更好，但事实是这两者都不安全。

- 0x02 基于路径的访问控制

一般Linux，windows路径目录的访问方式。
Linux：
```text
/etc/passwd
~/.ssh
./configure
./../../../etc/passwd
```
Windows：
```text
c:\boot.ini
.\test.txt
..\..\..\boot.ini
file:///c:\bbot.ini
c:\test~1.txt
```
这种漏洞，一般都是目录路径访问未得到严格限制，会造成跨站执行CGI脚本。更严重的CGI执行用户是root的权限，会让用户能查看系统文件的内容。
就像下面的错误代码：
```php
<?php
    //test.php
    $filename = $_GET['file'];
    $fd = fopen($filename,"r");
    $fcontent = fread($fd,filesize($filename));
    fclose($file);
    echo $fcontent;
?>
```
在正常的情况下访问`http://exmaple.com/test.php?file=test.txt`会打开读取当前php的工作目录下`test.txt`文件。
如果访问`http://exmaple.com/test.php?file=/etc/passwd`就会读取到系统的密码文件等，这样其实等于把整个系统都暴露在网络上！

### WebGoat的Access Control Flaws
- 0x01 Using an Access Control Matrix
- 0x02 Bypass a Path Based Access Control Scheme
- 0x03 Stage 1: Bypass Business Layer Access Control
- 0x04 Stage 2: Add Business Layer Access Control
- 0x05 Stage 3: Bypass Data Layer Access Control
- 0x06 Stage 4: Add Data Layer Access Control
- 0x07 Remote Admin Access

#### 工具
- [WebScarab](https://www.owasp.org/index.php/WebScarab)
- [Tamper Data](#)Firefox插件

#### 操作流程
- 0x01 一个基于角色的访问方案
- 0x02 绕过基于路径访问
使用`[Tamper Data]`工具，选择选择框里面一个文件，按`View File`按钮提交。修改`file`参数：
```text
../../../../../../../../../var/lib/tomcat6/conf/tomcat-users.xml
```
使用`[WebScarab]`工具一样，提交后修改`file`参数,和上面一样。（注意，我这里的环境是OWASPBWA的路径）

- 0x03 绕过业务层访问。
使用`Tom Cat`账号登陆，密码`tom`
使用`[WebScarab]`工具,按`ViewProfile`提交，修改`action`参数的`ViewProfile`为`DeleteProfile`提交。
使用`[Tamper Data]`工具同上一样。

- 0x04 添加业务层的访问控制
这个需要使用Webgoat的开发环境修改源代码。

- 0x05 绕过数据层访问控制
使用`[WebScarab]`工具,按`ViewProfile`提交，修改`employee_id`参数的`employee_id`为其他账户的ID提交。
使用`[Tamper Data]`工具同上一样。

- 0x06 添加数据层访问控制
这个需要使用Webgoat的开发环境修改源代码。
- 0x07 远程管理访问
在`url`后面加上`&admin=true`，然后就可以访问`Admin Functions`下的`User Information`和`Product Information`功能，访问两个url时需要加上`&admin=true`

以上就是这一课的操作流程。

### 危害
基于角色的访问控制的缺陷，安全系数高，角色权限分配不当或者整个角色权限系统设计有缺陷，会造成用户拥有的角色权限访问不应该能访问的数据。
基于路径的访问控制的缺陷，安全系数非常高,稍微不慎就会造成整个服务器沦陷。只要能查看系统文件就能做很多事情了。

### 解决方案
基于角色的访问控制的缺陷的解决方案，设计角色权限系统时严格的验证测试，确保权限系统不会越权访问。
基于路径的访问控制的缺陷的解决方案，需要指定程序的工作目录路径，比如PHP在配置时指定php脚本所在目录为当前根目录，不允许夸目录操作文件。在操作一个文件时使用绝对路径，
尽量避免相对路径，对用户输入的文件名进行路径检测，进行转义。