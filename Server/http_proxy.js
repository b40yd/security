var net = require('net');
var local_port = 3000;

var options = {
	hostname: 'www.example.com',
	port: 80,
	path: '',
	method: 'GET',
	version: 0,
	headers: [],
	https:false
}

function buffer_find_body(b)
{
	for(var i=0,len=b.length-3;i < len;i++)
	{
		if (b[i] == 0x0d && b[i+1] == 0x0a && b[i+2] == 0x0d && b[i+3] == 0x0a)
		{
			return i+4;
		}
	}
	return -1;
}

net.createServer(function (client)
{
	
	function parse_request(buffer)
	{
		var buf = buffer.toString('utf8');
		var method = buf.split('\n')[0].match(/^([A-Z]+)\s/)[1];
		if (method == 'CONNECT')
		{
			var _bufArr = buf.match(/^([A-Z]+)\s([^:\s]+):(\d+)\sHTTP\/(\d.\d)/);
			if (_bufArr && _bufArr[1] && _bufArr[2] && _bufArr[3] && _bufArr[4]){
				options.method = _bufArr[1];
				options.hostname = _bufArr[2];
				options.port = _bufArr[3];
				options.version = _bufArr[4];
				options.https = _bufArr[2].indexOf("https")!=-1?true:false;
			}
			return options;
		}
		else
		{
			var _bufArr = buf.match(/^([A-Z]+)\s([^\s]+)\sHTTP\/(\d.\d)/);
			//console.log(_bufArr);
			if (_bufArr && _bufArr[1] && _bufArr[2] && _bufArr[3])
			{
				var host = buf.match(/Host:\s+([^\n\s\r]+)/)[1];
				if (host)
				{
					var _op = host.split(':',2);
					options.method = _bufArr[1];
					options.hostname = _op[0];
					options.port = _op[1]?_op[1]:80;
					options.path = _bufArr[2];
					options.version = _bufArr[3];
					options.https = _bufArr[0].indexOf("https")!=-1?true:false;
					return options;
				}
			}
		}
		return false;
	}
	var buf;
	client.on('data',function(data)
	{
		buf = new Buffer(data.length);
		data.copy(buf);
		var req = parse_request(buf);
		client.removeAllListeners('data');
		if(!options.https){
			http_req(options);
		}
		//console.log(options);
		
	});
	function http_req(req){
		console.log(req.method+' '+req.hostname+':'+req.port);
		console.log("\r\nfirst buf:\r\n"+buf);
		if (req.method != 'CONNECT')
		{
			var _body_pos = buffer_find_body(buf);
			if (_body_pos < 0) _body_pos = buf.length;
			var _header = buf.slice(0,_body_pos).toString('utf8');
			_header = _header.replace(/(proxy-)?connection:.+\r\n/ig,'')
					.replace(/Keep-Alive:.+\r\n/i,'')
					.replace("\r\n",'\r\nConnection: close\r\n');
			if (req.httpVersion == '1.1')
			{
				var url = req.path.replace(/http[s?]:\/\/[^/]+/,'');
				if (url.path != url) _header = _header.replace(req.path,url);
			}
			var _buf_1 = new Buffer(_header,'utf8');
			var _buf_2 = buf.slice(_body_pos);
			var re = new Buffer(_buf_1.length + _buf_2.length);
			_buf_1.copy(re);
			_buf_2.copy(re,_buf_1.length);
			buf = re;
			console.log("\r\nreplace buf:\r\n"+buf);
		}
		var server = net.createConnection(req.port,req.hostname);
		server.on("data", function(data){ console.log("\r\nServer Data:\r\n"+data);client.write(data); });
		console.log("\r\nwrite buf:\r\n"+buf);
		if (req.method == 'CONNECT')
			client.write(new Buffer("HTTP/1.1 200 Connection established\r\nConnection: close\r\n\r\n"));
		else
			server.write(buf);
		
	}
	
}).listen(local_port);
console.log('Proxy server running at localhost: '+local_port);

process.on('uncaughtException', function(err)
{
	console.log("\nError:");
	console.log("\t"+err);
});
