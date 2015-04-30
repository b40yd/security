## 跨站脚本攻击(XSS)
XSS又叫CSS  (Cross Site Script) ，跨站脚本攻击。它指的是恶意攻击者往Web页面里插入恶意html代码，当用户浏览该页之时，嵌入其中Web里面的html代码会被执行，从而达到恶意用户的特殊目的。

### 使用场景
Web页面里用户可控输入的数据，向数据里面插入恶意html代码。

### 漏洞分析
一般xss类型有反射型，存储型,跨站请求伪造,跨站跟踪攻击等。
具有xss漏洞的代码，如：
```php
<form action="/">
    <input type="text" name="xss" value="">
    <button name="submit">submit</button>
</form>

<?php
    if(isset($_POST["xss"])){
        echo $_POST["xss"]; 
    }
?>
```
以上代码具有XSS反射型攻击。
XSS存储型，一般具有持久化特性，一般都隐藏在用户数据提交保存的功能上。
```php
<?php
    if(isset($_POST["xss"])){
        $fd = fopen("xss.html", "rw");
        fwrite($fd, $_POST["xss"]);
        fclose($fd);
    }
?>
```
把用户提交的xss攻击代码保存到一个html静态文件里面去，持久化数据。然后就可以通过重新访问`http://example.com/xss.html`去执行xss攻击了。
跨站伪造请求，一般就是劫持到用户的认证信息，然后通过伪造去请求数据。例如：
```
<img src="http://example.com/user/info?id=1&sid=xxxx" width="1"height="1" />
```
这样会通过img标签去请求这个地址。这样就是跨站请求，通过恶意的html代码，伪造一些敏感的请求就造成了攻击。
跨站跟踪攻击,TRACE是HTTP（超文本传输）协议定义的一种协议调试方法，该方法会使服务器原样返回任意客户端请求的任何内容，
由于该方法会原样返回客户端提交的任意数据，因此可以用来进行跨站脚本简称XSS攻击，这种攻击方式又称为跨站跟踪攻击简称XST。
例如：
```js
<script type="text/javascript">if ( navigator.appName.indexOf("Microsoft") !=-1) {var xmlHttp = new
ActiveXObject("Microsoft.XMLHTTP");xmlHttp.open("TRACE", "./", false);
xmlHttp.send();str1=xmlHttp.responseText; while (str1.indexOf("\n") > -1) str1 = str1.replace("\n","<br>");
document.write(str1);}</script>
```
这样就会造成XSS攻击了。

### 危害
根据情况不同，危害的级别也不相同，如果是蠕虫病毒，传染性太强的xss危害是相当大的。

### 解决方案
使用白名单等方式过滤所有用户输入的数据。
防御跨站跟踪攻击，需要在Web Server上关闭TRACE功能。比如Apache 在httpd.conf的尾部添加：`TraceEnable off`