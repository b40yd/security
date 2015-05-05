## 参数篡改
客户端验证不应该被认为是一种安全的参数验证方法。这种验证方式只能帮那些不知道
所需输入的用户缩短服务器处理时间。攻击者可以用各种方法轻易的绕过这种机制。任何客
户端验证都应该复制到服务器端。这将大大减少不安全的参数在应用程序中使用的可能性。

### 使用场景
数据提交，web应用API访问、URL访问等。

### 漏洞分析
数据合法性，有效性和完整性未检测，在篡改后会正常执行。
```
<form>
    <input type="text" value="123" name="disable" disabled="disabled" />
    <input type="submit" value="submit" name="submit" />
</form>
```
本来数据是不允许修改的，如果把`disabled`属性去掉，就可以修改数据提交了。这样就是造成参数篡改。
```
http://example.com/user.php?gid=1
```
篡改`gid`数据,改为`' or 1=1 --'`这样的数据，如果可能存在sql注入，就会查询出所有数据，也就是成功的执行SQL注入。
篡改hidden字段，比如有一个发送邮件给朋友的功能，如果没做合法性检测就可以利用网站给对方发送垃圾邮件了。如果存在xss可以发送
xss攻击邮件给对方。
例如：
```
<form>
    <input type="hidden" value="example@example.com" name="email" />
    <input type="text" value="" name="subject" />
    <textarea name="content"></textarea>
    <!-- ... -->
</form>
```
篡改email的hidden字段的值为其他邮件地址，就可以发送垃圾邮件给该邮件。
还可以篡改数据，绕过客户端验证机制破坏这些规则，输入不允许输入的字符。


### 危害
会篡改数据库的数据，执行SQL注入等，造成不可预料的后果。

### 解决方案
做数据完整性和有效性、合法性的安全检测。客户端验证是可篡改的，所以数据安全验证主要应该放在后端。