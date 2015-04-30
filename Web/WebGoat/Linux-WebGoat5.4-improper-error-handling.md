## 不当的错误处理
在出现错误的情况下，却正常执行。

### 使用场景
主要在处理异常说的时候，对错误处理不当造成的问题。

### 漏洞分析
比如在认证缺陷里面提到过的登录认证错误逻辑处理不当造成的无密码登录等问题。
代码如下：
```php
<?php    
    
    var $username = $passwd = "";
    var $sql = "select * from users where ";
    if(isset($_GET['username']) && $_GET['username'] =='admin'){
        $username = "`users.username`='admin'";
    }else{
        die("username is empty!");
    }

    if(isset($_GET['passwd']) && $_GET['passwd'] == '123'){
        $passwd = "and `users.passwd`='123'";
    }

    $sql .= $username . $passwd;
    $sql .= " limit 0,1";
    $query = mysql_query($sql);
    //...
?>
```
在没处理没有输入密码的情况下直接执行数据查询了。结果就会是任意存在的账号任何人都可以登录。
这个是当有错误需要处理不处理的情况，还有的情况是不应该处理却处理了，也会造成问题。


### 危害
可能存在一些高风险的操作。

### 解决方案
对错误的处理一定要严谨，根据错误等级不同做不同的处理。