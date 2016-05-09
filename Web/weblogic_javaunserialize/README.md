### shellcode生成
远程调用的RemoteObject需要使用JDK1.6版本编译生成，这样才能保证通用性，亲测！
### 生成十六进制的python脚本
把远程调用的jar包，生成十六进制，脚本[hex.py](../../hex.py)和[toHex.py](../../toHex.py)
```
#!/usr/bin/env python
import binascii

#convert string to hex
def toHex(s):
    lst = []
    for ch in s:
        hv = hex(ord(ch)).replace('0x', '')
        if len(hv) == 1:
            hv = '0'+hv
        lst.append(hv)
   
    return reduce(lambda x,y:x+y, lst)

with open("RemoteObject.jar", 'rb') as f:
	s=f.read()
	print toHex(s)
```
使用内嵌解析，避免多个jar包的存在，这样的好处就是，只需要发布主程序包即可。

### 使用
1、RemoteObject shellcode，远程调用对象。

2、commons-collections-3.2.1 反序列化存在漏洞的版本，使用里面的
```
import org.apache.commons.collections.Transformer;
import org.apache.commons.collections.functors.ChainedTransformer;
import org.apache.commons.collections.functors.ConstantTransformer;
import org.apache.commons.collections.functors.InvokerTransformer;
import org.apache.commons.collections.map.TransformedMap;
```
3、weblogic 程序包
