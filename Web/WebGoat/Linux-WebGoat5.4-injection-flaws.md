## 注入缺陷
注入缺陷大概有命令注入、数字型SQL 注入、日志欺骗、XPATH 型注入、字符串型注入、数据库后门、数字型盲注入、字符串型盲注入等类型。

### 使用场景
篡改url参数，用户数据提交等地方。

### 漏洞分析
命令注入一般都是系统调用，执行系统命令造成的。比如：
```php
<?php
    //cmdinject.php
    echo "current dirs:<br />"; 
    system("ls -l ".$_GET['dir']);
?>
```
如果用户执行`http://example.com/cmdinject.php?dir=/%20%26%26%20cat%20/etc/passwd`这样就会造成命令注入。
数字型SQL注入，一般体现在根据多个条件查询数据时，使用`or 1=1`条件查询。例如：
```sql
SELECT * FROM user WHERE username = [username]
```
PHP代码：
```php
    //sqlinject.php
    $sql = "SELECT * FROM user WHERE username = '" . $_POST['username'] ."'";
    $query = mysql_query($sql);
    //...
```
如果执行`POST http://example.com/sqlinject.php?username=admin%20or%201=1`就会把所有用户都会被查出来，而不是只有admin用户。这样就是sql注入。
日志欺骗，主要是达到欺骗管理员查看日志的时候的错觉。记录日志的源代码可能像这样的：
```php
    //log.php
    const NOTICE = 0x01;
    $log = new Log();
    $log->write(NOTICE,$_POST['username']);
```
在执行提交log.php时，用户输入像`test%0d%0a<NOTICE> Login Succeeded for username: admin`这样的数据时就会写入log，最后的结果可能就是：
```
<NOTICE> Login failed for username: test
<NOTICE> Login Succeeded for username: admin
```
这样还可以写入xss代码（`admin <script>alert(document.cookie)</script>`），如果管理员用管理后台去查看log很有可能触发xss，进而劫持到管理员账号的session。
xpath注入和字符串型、数据库后门、数字型盲注入、字符串型盲注入都是sql注入的方式。
比如执行`POST http://example.com/sqlinject.php?username='%20or%201=1%20--`这样的数据时就是根据情况而选择注释后面的sql语句。
通过SQL注入做修改增加数据操作,实例代码如下：
```php
//sqlinject.php
$mysqli = new mysqli("localhost","root","","test");
$mysqli->query("set names 'utf8");
//多条sql语句，1';UPDATE user SET username='testinject' WHERE id = '1
$sql = "select id,name from `user` where `id`='".$_POST['id']."'";
echo $sql;
if ($mysqli->multi_query($sql)){//multi_query()执行一条或多条sql语句
    do{
        if ($rs = $mysqli->store_result()){//store_result()方法获取第一条sql语句查询结果
            while ($row=$rs->fetch_row()){
                var_dump($row);
                echo "<br>";
            }
            $rs->Close(); //关闭结果集
            if ($mysqli->more_results()){  //判断是否还有更多结果集
                echo "<hr>";
            }
        }
    }while($mysqli->next_result());//next_result()方法获取下一结果集，返回bool值
}
$mysqli->close();  //关闭数据库连接

```
执行`POST http://example.com/sqlinject.php?id=1';UPDATE%20user%20SET%20username='testinject'%20WHERE%20id='1`就会执行两次sql。

### 危害
可以通过绕过程序检测，做一些额外的事情。比如用户登陆，使用数字型SQL 注入无密码登录。危害程度非常高，根据SQL注入可以拿到整个数据库表的数据，也就是会被拖库。

### 解决方案
参数数据使用白名单等方式过滤。