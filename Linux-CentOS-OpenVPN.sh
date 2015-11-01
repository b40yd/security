#!/bin/sh

if [ $UID != 0 ];then
    echo "not root";
    exit;
fi
cd /root/
yum install autoconf automake
yum install openssl openssl-devel
yum install lzo lzo-devel
yum install pam-devel
git clone https://github.com/OpenVPN/openvpn.git
cd openvpn;
autoreconf -i -v -f
./configure 
make -j8 && make install 
mkdir -pv /etc/openvpn/
wget -c https://github.com/OpenVPN/easy-rsa/archive/master.zip -o master.zip
unzip master.zip
mv -v easy-rsa-mater/ easy-rsa/
cp -R easy-rsa/ /etc/openvpn/
cd /etc/openvpn/easy-rsa/easyrsa3/
cp vars.example vars -rfv

#set_var EASYRSA_REQ_COUNTRY "CN" //根据自己情况更改
#set_var EASYRSA_REQ_PROVINCE "Beijing"
#set_var EASYRSA_REQ_CITY "Beijing"
#set_var EASYRSA_REQ_ORG "scanbuf Certificate"
#set_var EASYRSA_REQ_EMAIL "bb.qnyd@gmail.com"
#set_var EASYRSA_REQ_OU "Scanbuf OpenVPN"
./easyrsa init-pki
./easyrsa build-ca #生成证书
./easyrsa gen-req server nopass #创建服务器端证书
./easyrsa sign server server #签约服务器端证书
./easyrsa gen-dh #创建Diffie-Hellman，确保key穿越不安全网络的命令

mkdir -pv /root/client && cd /root/client
cp -R /root/openvpn/easy-rsa/ /root/client/
cd /root/client
./easyrsa init-pki
./easyrsa gen-req yourname
cd /etc/openvpn/easy-rsa/easyrsa3/
./easyrsa import-req /root/client/easy-rsa/easyrsa3/pki/reqs/yourname.req yourname
./easyrsa sign client yourname
#拷贝server配置/etc/openvpn目录下
cp /etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt /etc/openvpn/
cp /etc/openvpn/easy-rsa/easyrsa3/pki/private/server.key /etc/openvpn/
cp /etc/openvpn/easy-rsa/easyrsa3/pki/issued/server.crt /etc/openvpn/
cp /etc/openvpn/easy-rsa/easyrsa3/pki/dh.pem /etc/openvpn/
#拷贝client配置/root/client目录下
cp /etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt /root/client/
cp /etc/openvpn/easy-rsa/easyrsa3/pki/issued/yourname.crt /root/client/
cp /root/client/easy-rsa/easyrsa3/pki/private/yourname.key /root/client/

cp /root/openvpn/sample/sample-config-files/server.conf /etc/openvpn/

####### client.ovpn #############
# client
# dev tun
# proto udp
# remote 192.227.161.xx 1194 #主要这里修改成自己vps ip
# resolv-retry infinite
# nobind
# persist-key
# persist-tun
# ca ca.crt #这里需要证书
# cert yourname.crt
# key yourname.key
# comp-lzo
# verb 3
##################################
exit 0
