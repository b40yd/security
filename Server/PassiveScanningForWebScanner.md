## [Web扫描器]-被动扫描原理,实现
为Web扫描器实现被动扫描。

#### 使用场景
在特定的情况下对单个页面进行SQL注入,XSS等漏洞进行渗透检测。
例如,需要验证`http://www.example.com/query.php?id=1&uname=7ym0n`,中的GET参数和POST表单。HTML代码如下：
```html
<html>
	<head>
		<meta charset="utf-8">
		<title>我是一个测试</title>
		<base href="/">
		<meta name="description" content="测试被动式扫描">
	</head>
	<body>
		<form action="/" id="check_post" method="POST">
			<input type="text" value="" name="mobile" id="mobile">
			<input type="submit" value="提交" name="check_submit" id="check_submit">
		</form>
	</body>
</html>
```
另一种场景,就是对自己访问过的网站页面进行测试,这样的应用场景下,如果手工检测,工作量太大,而且可能遗忘某方式去测试验证（比如绕狗,畸形的参数变化多端）,导致准确率低,效率低。
如果只需人工编写好验证方式的规则,让程序自己去进行验证,就会方便很多。而且重用性高,准确率高,效率高。

btw: 当然,有很多自动化工具提供给安全研究员使用,比如Sqlmap,Openvas等强大工具,但是我这里主要是说明场景和自己实现被动扫描。

#### 设计原理与思路
被动模式实现方式有很多种,比如使用代理(proxy),或者(wireshark/Fiddler)抓包分析,为了能简单描述流程,采用代理方式做被动扫描,这种在某些时候可能更方便,更好维护。
```text
					|------------------------|
					|      请求提交数据      |← ← ← ← ←↑
					|------------------------|         ↑
							    ↓                      ↑
	     	                   / \                     ↑
							  /   \                    ↑
							 /     \                   ↑
							/ 数据  \                  ↑
							\  转发 /                  ↑
							 \     /                   ↑
							  \   /                    ↑
							   \ /                     ↑
							    ↓                      ↑
				    |------------------------|         ↑
					|     处理URL/Body数据   |         ↑
					|------------------------|         ↑
								↓                      ↑
					|------------------------|         ↑
					| 对GET参数和POST表单数  |         ↑
					|      据进行篡改        |         ↑
					|------------------------|         ↑
								↓                      ↑
					|------------------------|         ↑
					|	  建立socket通信     |         ↑
					|------------------------|         ↑
								↓                      ↑
							    /\                     ↑
							   /  \                    ↑
							  /    \                   ↑
							 /      \                  ↑
							/        \                 ↑ N
						   / 提交串改 \                ↑
                           \ 后的请求 /                ↑
						    \        /                 ↑
						     \      /                  ↑
							  \    /                   ↑
							   \  /                    ↑
                                \/                     ↑
								↓                      ↑
					|-------------------------|        ↑
					|	    验证结果          |        ↑
					|-------------------------|        ↑
								↓                      ↑
							   /\                      ↑
							  /  \             N       ↑
							 / Y/ \  → → → → → → → → → →
							 \  N /
							  \  /
							   \/
							   ↓
					|-------------------------|
					|        输出结果         |
					|-------------------------|
							
							图(1) 原理图
		
```	
##### 代理(Proxy)服务器介绍
一个既做服务器又做客户端的中介程序.其用途是代表其他客户发送请求.请求在内部得到服务,或者经过一定的翻译转至其他服务器.一个代理服务器必须能同时履行本说明中客户端和服务器要求.

"透明代理"(transparent proxy)是一种除了必需的验证和鉴定外不修改请求或相应的代理.

"非透明代理"(non-transparent proxy)是一种修改请求或应答以便为用户代理提供附加服务的代理,附加服务包括类注释服务,媒体类型转换,协议简化,或者匿名滤除等.
除非经明确指出,HTTP代理要求对两种代理都适用.

##### 代理(Proxy)服务器实现
首先实现代理服务,类似nc工具一样,在请求数据后,需要截获请求的URL和数据,分析数据后进行篡改。然后发送TCP数据包。
代码实现采用的nodejs,可以自行使用熟悉的语言去实现,比如C、Java、Python或Ruby。

`nodejs`网络操作,所以需要使用`nodejs`中的`net`包,`var net = require('net');`

需要转发端口,定义`proxy`端口`var local_port = 3000;`。

需要解析完整的URI资源定位路径,通用URI定义：
```text
scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]
```
使用一个`request_options`对象存放,URI的数据结构。
```nodejs
var request_options = {
	hostname: 'www.example.com',
	port: 80,
	path: '',
	method: 'GET',
	version: 0,
	headers: [],
	query: [],
	fragment: '',
	data: [],
	https:false
}
```
POST数据是以两个`\r\n`or`0x0d 0x0a`区分HTTP头和传输数据的。所以以两个换行符分割传输数据和HTTP头。

定义一个`buffer_find_body`:
```nodejs
function buffer_find_body(b){
	for(var i=0,len=b.length-3;i < len;i++){
		if (b[i] == 0x0d && b[i+1] == 0x0a && b[i+2] == 0x0d && b[i+3] == 0x0a){
			return i+4;
		}
	}
	return -1;
}
```

通过`buffer_find_body`找到HTTP头结束位置,开始解析HTTP头数据,每一个头属性定义都以一个`\r\n`or`0x0d 0x0a`区分,定义`parse_request`以换行符分割,使用正则匹配`scheme://host:port/path?query`等:
```
function parse_request(buffer){
	var buf = buffer.toString('utf8');
	var method = buf.split('\n')[0].match(/^([A-Z]+)\s/)[1];
	if (method == 'CONNECT'){ //支持HTTPS
		var _bufArr = buf.match(/^([A-Z]+)\s([^:\s]+):(\d+)\sHTTP\/(\d.\d)/);
		if (_bufArr && _bufArr[1] && _bufArr[2] && _bufArr[3] && _bufArr[4]){
			request_options.method = _bufArr[1];
			request_options.hostname = _bufArr[2];
			request_options.port = _bufArr[3];
			request_options.version = _bufArr[4];
			request_options.https = _bufArr[2].indexOf("https")!=-1?true:false;
		}
		return request_options;
	}
	else
	{
		var _bufArr = buf.match(/^([A-Z]+)\s([^\s]+)\sHTTP\/(\d.\d)/);
		if (_bufArr && _bufArr[1] && _bufArr[2] && _bufArr[3]){
			var host = buf.match(/Host:\s+([^\n\s\r]+)/)[1];
			if (host){
				var _op = host.split(':',2);
				request_options.method = _bufArr[1];
				request_options.hostname = _op[0];
				request_options.port = _op[1]?_op[1]:80;
				request_options.path = _bufArr[2];
				request_options.version = _bufArr[3];
				request_options.https = _bufArr[0].indexOf("https")!=-1?true:false;
				return request_options;
			}
		}
	}
	return false;
}
```
使用`net`的`createServer`方法创建服务,使用刚定义的几个函数进行数据解析:
```
net.createServer(function (client){
	client.on("data",function(req){
		buf = new Buffer(data.length);
		data.copy(buf);
		var req = parse_request(buf);
		client.removeAllListeners('data');
		//建立socket发送数据,返回数据。
		//if(req)
		//	http_req(req);
	});
});
```
创建socket连接,请求并返回数据,修改请求头`Connection: Keep-Alive`为`Connection: close`：
```nodejs
function http_req(req){
	console.log(req.method+' '+req.hostname+':'+req.port);
	if (req.method != 'CONNECT'){
		var _body_pos = buffer_find_body(buf);
		if (_body_pos < 0) _body_pos = buf.length;
		var _header = buf.slice(0,_body_pos).toString('utf8');
		_header = _header.replace(/(proxy-)?connection:.+\r\n/ig,'')
				.replace(/Keep-Alive:.+\r\n/i,'')
				.replace("\r\n",'\r\nConnection: close\r\n');
		if (req.httpVersion == '1.1'){
			var url = req.path.replace(/http[s?]:\/\/[^/]+/,'');
			if (url.path != url) _header = _header.replace(req.path,url);
		}
		var _buf_1 = new Buffer(_header,'utf8');
		var _buf_2 = buf.slice(_body_pos);
		var re = new Buffer(_buf_1.length + _buf_2.length);
		_buf_1.copy(re);
		_buf_2.copy(re,_buf_1.length);
		buf = re;
		for(v in _buf_2.split('&')){
			req.data.push(v.split('='));
		}
	}
	var server = net.createConnection(req.port,req.hostname);
	server.on("data", function(data){ client.write(data); });
	if (req.method == 'CONNECT')
		client.write(new Buffer("HTTP/1.1 200 Connection established\r\nConnection: close\r\n\r\n"));
	else
		server.write(buf);
	
}

```
这样就完成了一个简单的代理服务器。现在能获取到GET和POST表单数据,剩下的需要做的就是拆分数据进行自动化渗透测试。
#### 使用第三方渗透检测工具
##### 使用SQLmap测试SQL注入。
使用`sqlmap`需要用到系统命令行调用,加载`child_process`。
```var exec = require('child_process').exec;```
在`http_req`最后面加入
```nodejs
//注意sqlmap在我系统中/usr/bin下所以直接调用。
var cmd = 'sqlmap -u "'+request_options.hostname+'" --data="'+buf.slice(buffer_find_body(buf))+'" --param-del="&" -f --banner --dbs --users';
exec(cmd, function (error, stdout, stderr) {
    console.log(stdout);
  });
```
需要什么策略,就加上即可,很方便的进行测试神马的,到此处基本就完成了图1中的被动扫描的整个流程，该代码没有优化，只是演示整个流程,当作生产环境需要优化。


附上[proxy代码地址](https://github.com/7ym0n/security/blob/master/Server/http_proxy.js),注意该源码没有实现被动扫描。
