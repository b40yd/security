## Testing WAF for Docker
在docker中测试WAF，主要测试开源WAF引擎modsecurity，使用nginx作为前端服务器，反向代理后端app；

#### 配置文件
nginx.conf 配置文件：
```
user www-data;
worker_processes  1;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;



    sendfile        on;

    keepalive_timeout  65;

    modsecurity  on;
    modsecurity_rules_file /opt/nginx/conf/modsecurity.conf;

    #include vhost/*.conf;
    
    server {
    	listen       80;
    	server_name  localhost;
    	root   /var/www/html;
    	location / {
        	index  index.php index.html index.htm;
    	}
    	location ~ \.php$ {
        	fastcgi_pass  172.17.0.3:9000;
        	fastcgi_index index.php;
        	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        	include fastcgi_params;
        	fastcgi_intercept_errors on;
    	}
    }


}
```

modsecurity.conf 配置文件：
```

SecRuleEngine On

SecRequestBodyAccess On

SecRule REQUEST_HEADERS:Content-Type "(?:application(?:/soap\+|/)|text/)xml" \
     "id:'200000',phase:1,t:none,t:lowercase,pass,nolog,ctl:requestBodyProcessor=XML"

SecRule REQUEST_HEADERS:Content-Type "application/json" \
     "id:'200001',phase:1,t:none,t:lowercase,pass,nolog,ctl:requestBodyProcessor=JSON"

SecRequestBodyLimit 13107200
SecRequestBodyNoFilesLimit 131072
SecRequestBodyLimitAction Reject

SecRule REQBODY_ERROR "!@eq 0" \
"id:'200002', phase:2,t:none,log,deny,status:400,msg:'Failed to parse request body.',logdata:'%{reqbody_error_msg}',severity:2"

SecRule MULTIPART_STRICT_ERROR "!@eq 0" \
"id:'200003',phase:2,t:none,log,deny,status:400, \
msg:'Multipart request body failed strict validation: \
PE %{REQBODY_PROCESSOR_ERROR}, \
BQ %{MULTIPART_BOUNDARY_QUOTED}, \
BW %{MULTIPART_BOUNDARY_WHITESPACE}, \
DB %{MULTIPART_DATA_BEFORE}, \
DA %{MULTIPART_DATA_AFTER}, \
HF %{MULTIPART_HEADER_FOLDING}, \
LF %{MULTIPART_LF_LINE}, \
SM %{MULTIPART_MISSING_SEMICOLON}, \
IQ %{MULTIPART_INVALID_QUOTING}, \
IP %{MULTIPART_INVALID_PART}, \
IH %{MULTIPART_INVALID_HEADER_FOLDING}, \
FL %{MULTIPART_FILE_LIMIT_EXCEEDED}'"

SecRule MULTIPART_UNMATCHED_BOUNDARY "!@eq 0" \
"id:'200004',phase:2,t:none,log,deny,msg:'Multipart parser detected a possible unmatched boundary.'"

SecPcreMatchLimit 1000
SecPcreMatchLimitRecursion 1000

SecRule TX:/^MSC_/ "!@streq 0" \
        "id:'200005',phase:2,t:none,deny,msg:'ModSecurity internal error flagged: %{MATCHED_VAR_NAME}'"

SecResponseBodyAccess On
SecResponseBodyMimeType text/plain text/html text/xml
SecResponseBodyLimit 524288
SecResponseBodyLimitAction ProcessPartial
SecTmpDir /tmp/
SecDataDir /tmp/
SecAuditEngine On
SecAuditLogRelevantStatus "^(?:5|4(?!04))"
SecAuditLogParts ABIJDEFHZ
SecAuditLogType Serial
SecAuditLog /var/log/modsecurity/modsec_audit.log
SecArgumentSeparator &
SecCookieFormat 0
SecUnicodeMapFile unicode.mapping 20127
SecStatusEngine On

include /opt/owasp-modsecurity-crs/crs-setup.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-901-INITIALIZATION.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-903.9001-DRUPAL-EXCLUSION-RULES.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-903.9002-WORDPRESS-EXCLUSION-RULES.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-905-COMMON-EXCEPTIONS.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-910-IP-REPUTATION.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-911-METHOD-ENFORCEMENT.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-912-DOS-PROTECTION.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-913-SCANNER-DETECTION.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-920-PROTOCOL-ENFORCEMENT.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-921-PROTOCOL-ATTACK.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-930-APPLICATION-ATTACK-LFI.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-931-APPLICATION-ATTACK-RFI.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-932-APPLICATION-ATTACK-RCE.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-933-APPLICATION-ATTACK-PHP.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-942-APPLICATION-ATTACK-SQLI.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf
include /opt/owasp-modsecurity-crs/rules/REQUEST-949-BLOCKING-EVALUATION.conf
include /opt/owasp-modsecurity-crs/rules/RESPONSE-950-DATA-LEAKAGES.conf
include /opt/owasp-modsecurity-crs/rules/RESPONSE-951-DATA-LEAKAGES-SQL.conf
include /opt/owasp-modsecurity-crs/rules/RESPONSE-952-DATA-LEAKAGES-JAVA.conf
include /opt/owasp-modsecurity-crs/rules/RESPONSE-953-DATA-LEAKAGES-PHP.conf
include /opt/owasp-modsecurity-crs/rules/RESPONSE-954-DATA-LEAKAGES-IIS.conf
include /opt/owasp-modsecurity-crs/rules/RESPONSE-959-BLOCKING-EVALUATION.conf
include /opt/owasp-modsecurity-crs/rules/RESPONSE-980-CORRELATION.conf
include /opt/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf


```

#### 编译命令
```shell
    cd nginx_modsecurity
    docker build -t nginx_modsecurity .
```
#### 启动命令
动态加载配置文件和应用程序目录（以PHP程序为例）；
```shell
    docker run -v $(pwd)/modsecurity.conf:/opt/nginx/conf/modsecurity.conf -v $(pwd)/nginx.conf:/opt/nginx/conf/nginx.conf -v /var/log/modsecurity:/var/log/modsecurity -d nginx_modsecurity:latest
    docker run -v /var/www/html/:/var/www/html/ -d webdevops/php:latest
```

