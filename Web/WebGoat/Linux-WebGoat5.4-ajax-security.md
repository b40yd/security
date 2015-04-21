## Ajax 安全
AJAX 技术的一项关键元素是XMLHttpRequest（XHR），该技术允许客户端向服务端发起异步调用。

### 使用场景
目前ajax的应用无处不在，当年ajax的刚出现可是占尽了风头，局部刷新的动态请求。目前特别是评论、文章内容的提交等应用程序对它的应用。

### 漏洞分析
Ajax中没有固有的安全漏洞。
Ajax的实现：
```js
function ajaxFunction() {
    var xmlHttp;
    try {
        // Firefox, Opera 8.0+, Safari
        xmlHttp=new XMLHttpRequest();
    } catch (e) {
        // Internet Explorer
        try {
            xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {
                alert("Your browser does not support AJAX!");
                return false;
            }
        }
    }
    xmlHttp.onreadystatechange=function() {
  
        var result = xmlHttp.responseText;
        if(xmlHttp.readyState==4){   
            document.getElementById("responseTitle").innerHTML="Response from: " 
                + document.getElementById("requestedURL").value ;
                
            document.getElementById("responseArea").innerHTML=result;           

            document.getElementById("requestedURL").value=""; 
        
        }
    }
  
    xmlHttp.open("GET",document.getElementById("requestedURL").value,true);
    xmlHttp.send(null);
}
```
常见的几个可能存在安全的漏洞有：

- 0x01 基于DOM的跨站点访问

文档对象模型（DOM）从安全的角度展现了一个有趣的问题。它允许动态修改网页内容，但是这可以被攻击者用来进行恶意代码注入攻击。
XSS是一种恶意代码注入，一般会发生在未经验证的用户的输入直接修改了在客户端的页面内容的情况下。HTML DOM 实体中可随时插入新的HTML语句或JavaScript语句，因此很容易被恶意代码利用，从而用来改变页面显示内容或执行恶意代码。
HTML标记语言中很多标签的特殊属性参数中允许插入JS代码，如：IMG/IFRAME等。
例如下面的实现：
```javascript
function displayGreeting(name) {
    if (name != ''){
        document.getElementById("greeting").innerHTML="Hello, " + name+ "!";
    }
}
```
当用户传递name的值是
```javascript
<img src="x" onerror="alert(1)" />
```
或
```javascript
<iframe src="javascript:alert(0)"></iframe>
```
这样的参数，就会直接造成XSS攻击。
其他可能基于DOM的XSS攻击API还有以下几个：
```javascript
document.location
document.URL
document.referrer
window.location
document.write()
document.writeln()
document.boby.innerHtml
eval()
window.setInterval()
window.setTimeout()
document.open()
window.location.href
window.navigate()
window.open
```

- 0x02 DOM注入

一些应用程序专门使用AJAX操控和更新在DOM中能够直接使用的JavaScript、DHTML和eval()方法。攻击者可能会利用这一点，通过拦截答复，注入一些JavaScript命令，实施攻击。 

- 0x03 XML注入

 AJAX应用程序使用XML与服务端进行信息交互。但该XML内容能够被非法用户轻易拦截并篡改。
 如同HTML脚本注入一样，在输出中包含攻击者提供的数据的地方，XML是容易受到攻击的。三种最常见的XML注入攻击是：XML数据注入、可扩展样式表语言转换（Extensible Stylesheet Language Transformation，XSLT）注入和XPath/XQuery 注入。
 XML数据注入（XML Data Injection）XML通常用于存储数据，如果用户提供的数据是以XML的方式进行存储，那么对攻击者来说，注入额外的、攻击者可能不能正常控制的XML是有可能的。考虑下述XML，在这个XML中，攻击者仅仅能够控制Attacker Text文本：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<USER role="guest">Attacker Text</USER>
```
解析xml文件时允许加载外部实体，没有过滤用户提交的参数。
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!DOCTYPE root [
<!ELEMENT copyright (#PCDATA)>
<!ENTITY file SYSTEM "file:///etc/passwd">
]>
<root version="2.0">
<data>
Here is the file content: &file;
</data>
</root>
```
服务端解析XML文件的时候请求实体file指定的URI（这里为file:///etc/passwd），并用请求结果替换file实体的引用锚，导致文件读取。

可扩展样式表语言（XSL）除了注入数据到XML之外，作为XML注入的结果，使代码运行也是可能的。XSL由XSL转换（XSL Transform，XSLT）、XML路径语言（XML Path Language，XPath）表达式和XSL格式化对象（Formatting Object，XSL-FO）组成，并且允许在XML文件中使用样式表。这种样式表能够把已有的XML数据转换成新的XML数据。
例如:
<link>http://example.com/attacker.xml</link>
为了表示上述XML，应用XSLT将上述XML转换为如下的HTML，并传送给Web浏览器：
<A HREF="http://example.com/attacker.xml">http://example.com/attacker.xml</A>

XPath/XQuery注入,XPath和XQuery是能够查询XML文档的语言，类似于结构化查询语言（SQL）。事实上，许多流行的数据库允许利用XPath和XQuery来查询数据库。在许多情况下，攻击者不能够直接访问XML数据，但是，攻击者可以用部分数据来创建XPath和XQuery语句，而这些语句能够用来查询XML。这样，攻击者就能够通过精心构造的输入来注入任意的查询，以此来获得数据，而这些数据在正常情况下是不允许攻击者访问的。

- 0x04 JSON注入

JavaScript Object Notation (JSON)是一种简单的轻量级的数据交换格式，JSON可以以很多形式应用，如：数组，列表，哈希表和
其他数据结构。JSON广泛应用于AJAX和web2.0应用。相比XML，JSON得到程序员的更多的青睐，因为它使用更简单，速度更快。
但是与XML一样容易受到注入攻击，恶意攻击者可以通过在请求响应中注入任意值。
例如：
```javascript
var jsonData = {
  "username":"Q6E79D",
  "passwd":"123456"  
};
```
json参数污染
```javascript
var jsonData = {
  "username":"Q6E79D",
  "passwd":"123456",
  "passwd":alert('xss')
};
```
直接转换json为object也会导致注入的问题
如：
```javascript
var jsonData = {
    "s":alert('xss')
};
eval(jsonData);
```
Json劫持
json劫持在JS里可以为对象定义一些setter函数，这样的话就存在了可以利用的漏洞。
```javascript
window.__defineSetter__('x', function() {  
    alert('xss!');  
});  
window.x='xss';  
```
现在的最新版本的浏览器都已经修复了。目前的浏览器在解析JSON Array字符串的时候，不再去触发setter函数了。但对于object.xxx 这样的设置，还是会触发。

- 0x05 JSONP回调函数注入

JSONP函数回调注入一般由回调函数未做严格的检测或过滤，比如jquery是这样子实现的:
```javascript
var url = 'http://localhost:8080/testJsonp?callback=?';  
$.getJSON(url, function(data){  
    alert(data)  
});  
```
jquery自动把?转成了一个带时间戳特别的函数（防止缓存）:
```text
http://localhost:8080/testJsonp?callback=jsonp1429642406300
```
服务器返回
```js
jsonp1429642406300({
  "username":"Q6E79D",
  "passwd":"chinaxxx"  
});
```
如果在callback函数的名字上做点手脚，就可以执行任意的JS代码

- 0x06 静默交易攻击

对客户端来说，任何一个静默交易攻击，使用单一提交的系统都是有危险的。举例来说，如果一个正常的web 应用允许一个简单的URL 提交，一个预设会话攻击将允许攻击者在没有用户授权的情况下完成交易。在Ajax 里情况会变得更糟糕：交易是不知不觉的，不会在页面上给用户反馈，所以注入的攻击脚本可以在用户未授权的情况下从客户端把钱偷走。

- 0x07 危险指令使用

如果未验证的用户输入直接通过`HTTP`响应返回给客户端的话，往往会触发`XSS`攻击。HTML 网页有一系列的HTML 编辑语言和字符组合完成。在源代码中任意位置添加一定
的代码都有可能被浏览器解析，特别是HTML 中的标记字符和属性等信息，如：
```html
<input id="text" type="text" value=""/>
<script type="text/javascript">
    function submit(){
        alert(eval("'"+document.getElementById("text").value+"'"));
    }
</script>
```
当输入`123');alert(document.cookie);('`畸形的代码时就会造成`XSS`攻击。

- 0x08 不安全的客户端存储

客户端进行的任何验证信息都存在被逆向分析的脆弱性。

### 危害
- 0x01 基于DOM的跨站点访问

导致可能执行任意的XSS攻击代码

- 0x02 DOM注入

同样可能执行任意XSS攻击或者可能出现越权访问

- 0x03 XML注入

可以导致信息泄露、任意文件读取、DOS攻击和代码执行等问题。

- 0x04 JSON注入

同样可能执行任意XSS攻击,同时可能会出现越权修改实际的数据

- 0x05 JSONP回调函数注入

如果在callback函数的名字上做点手脚，达到执行XSS攻击

- 0x06 静默交易攻击

危险指数很高的一个攻击，会造成在用户不知情的情况下进行交易。

- 0x07 危险指令使用

如果使用危险的指令，可能会造成`XSS`攻击。

- 0x08 不安全的客户端存储

用户可以进行逆向分析随意篡改客户端存储的数据。

### 解决方案
- 0x01 基于DOM的跨站点访问防御 

和传统的XSS预防几乎是相同的，输入验证：严格检查什么是允许的,什么不是在用户输入。正确过滤白名单允许的字符，
输出验证：这意味着，所有的输出必须正确编码，然后呈现给用户如HTMLEncoding。
也可以自己实现这样的避免HTML代码：
```javascript
function escapeHTML (str) {
   var div = document.createElement('div');
   var text = document.createTextNode(str);
   div.appendChild(text);
   return div.innerHTML;
}
```

- 0x02 DOM注入防御

DOM注入防御在服务端进行数据保护防御。

- 0x03 XML注入防御

数据提交到服务器上端，在服务端正式处理数据之前，对提交数据的合法性进行验证。
检查提交的数据是否包含特殊字符，对特殊字符进行编码转换或替换、删除敏感字符或字符串。
对于系统出现的错误信息，错误编码信息替换，屏蔽系统本身的出错信息。
参数化XPath查询，将需要构建的XPath查询表达式，以变量的形式表示，变量不是可以执行的脚本。
通过MD5、SSL等加密算法，对于数据敏感信息和在数据传输过程中加密，即使某些非法用户通过非法手法获取数据包，看到的也是加密后的信息。

- 0x04 JSON注入防御

避免手动拼接JSON字符串，一律应当用JSON库输出。
json请求要判断合法性。
转换json对象时分割出json里包含的特殊字符，然后再解析为对象。

- 0x05 JSONP回调函数注入防御

jsonp请求的callback要严格过滤，只允许"_"，0到9，a-z, A-Z，即合法的javascript函数的命名，并且使用白名单，只允许执行白名单的回调函数。
jsonp请求也要判断合法性。设置好Content-Type，保证数据类型合法性。

- 0x06 静默交易攻击防御

在执行交易的时候必须验证用户的交易认证，保证交易的合法性。不允许默认直接执行URL提交。

- 0x07 危险指令使用防范

避免使用危险的指令，对用户输入的数据进行过滤和正确编码

- 0x08 不安全的客户端存储防御

在服务端验证所有的用户输入信息总是不错的做法，所以需要验证提交数据的合法性。