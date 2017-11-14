FROM debian:jessie
MAINTAINER 7ym0n.q6e<7ym0n.q6e@gmail.com>

RUN echo "deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib" >> /etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib" >> /etc/apt/sources.list && \
echo "deb-src http://mirrors.aliyun.com/debian/ jessie main non-free contrib" >> /etc/apt/sources.list && \
echo "deb-src http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib" >> /etc/apt/sources.list

RUN set -xe && apt-get update && apt-get install -y libreadline-dev libncurses5-dev libssl-dev perl make build-essential libpcre3 libpcre3-dev libtool autoconf apache2-dev libxml2 libxml2-dev libcurl4-openssl-dev gcc g++ flex bison curl doxygen libyajl-dev libgeoip-dev dh-autoreconf libpcre++-dev wget git

RUN cd /opt && wget 'http://nginx.org/download/nginx-1.12.2.tar.gz' && git clone https://github.com/SpiderLabs/ModSecurity && cd ModSecurity && git checkout -b v3/master origin/v3/master && sh build.sh && git submodule init && git submodule update && ./configure --prefix=/opt/modsecurity && make -j8 && make install && echo "/opt/modsecurity/lib/" >> /etc/ld.so.conf.d/libc.conf && ln -s /opt/modsecurity /usr/local/modsecurity

RUN cd /opt && git clone https://github.com/SpiderLabs/ModSecurity-nginx.git modsecurity-nginx && tar xzvf nginx-1.12.2.tar.gz && cd nginx-1.12.2 && ./configure --prefix=/opt/nginx --add-module=/opt/modsecurity-nginx && make -j8 && make install && cd /opt/ModSecurity && git checkout v2/master  && cp /opt/ModSecurity/unicode.mapping /opt/nginx/conf/

RUN cd /opt && git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git && cd owasp-modsecurity-crs && cp crs-setup.conf.example  crs-setup.conf && cp /opt/ModSecurity/modsecurity.conf-recommended /opt/nginx/conf/modsecurity.conf && cp rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf && cp rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf

RUN echo "include /opt/owasp-modsecurity-crs/crs-setup.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-901-INITIALIZATION.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-903.9001-DRUPAL-EXCLUSION-RULES.conf">> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-903.9002-WORDPRESS-EXCLUSION-RULES.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-905-COMMON-EXCEPTIONS.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-910-IP-REPUTATION.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-911-METHOD-ENFORCEMENT.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-912-DOS-PROTECTION.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-913-SCANNER-DETECTION.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-920-PROTOCOL-ENFORCEMENT.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-921-PROTOCOL-ATTACK.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-930-APPLICATION-ATTACK-LFI.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-931-APPLICATION-ATTACK-RFI.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-932-APPLICATION-ATTACK-RCE.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-933-APPLICATION-ATTACK-PHP.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-942-APPLICATION-ATTACK-SQLI.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/REQUEST-949-BLOCKING-EVALUATION.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/RESPONSE-950-DATA-LEAKAGES.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/RESPONSE-951-DATA-LEAKAGES-SQL.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/RESPONSE-952-DATA-LEAKAGES-JAVA.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/RESPONSE-953-DATA-LEAKAGES-PHP.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/RESPONSE-954-DATA-LEAKAGES-IIS.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/RESPONSE-959-BLOCKING-EVALUATION.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/RESPONSE-980-CORRELATION.conf" >> /opt/nginx/conf/modsecurity.conf && \
echo "include /opt/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf" >> /opt/nginx/conf/modsecurity.conf

RUN mkdir -pv /var/log/modsecurity && rm -rfv /opt/Modsecurity /opt/modsecurity-nginx /opt/nginx-1.12.2 /opt/nginx-1.12.2.tar.gz
ADD modsecurity.conf /opt/nginx/conf/
ADD nginx.conf /opt/nginx/conf/
#RUN mkdir -pv /opt/nginx/conf/vhost 
#ADD default.conf /opt/nginx/conf/vhost/
RUN mv /opt/nginx/conf/modsecurity.conf /opt/nginx/conf/modsecurity.conf.backup && mv /opt/nginx/conf/nginx.conf /opt/nginx/conf/nginx.conf.backup

WORKDIR /var/www/html

ENTRYPOINT [ "/opt/nginx/sbin/nginx", "-g", "daemon off;" ]
EXPOSE 80 443
