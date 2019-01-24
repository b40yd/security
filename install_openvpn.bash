#!/bin/bash

OPENVPN_TAR="openvpn-2.4.6.tar.gz"
OPENVPN_DIR="openvpn-2.4.6"

env_install(){
    local lz4=`rpm -qa | grep lz4-devel`
    if [ -z "$lz4" ];then
        yum install -y lz4-devel
    fi
    
    local lzo=`rpm -qa | grep lzo-devel`
    if [ -z "$lzo" ];then
        yum install -y lzo-devel
    fi
    
    local pam=`rpm -qa | grep pam-devel`
    if [ -z "$lzo" ];then
        yum install -y pam-devel
    fi
    
    local unzip=`rpm -qa | grep unzip`
    if [ -z "$unzip" ];then
        yum install -y unzip
    fi
    
    local openssl=`rpm -qa | grep openssl-devel`
    if [ -z "$openssl" ];then
        yum install -y openssl openssl-devel
    fi
    
    local net_tools=`rpm -qa | grep net-tools`
    if [ -z "$net_tools" ];then
        yum install -y net-tools
    fi
}


download_openvpn(){
    if [ -f "$OPENVPN_TAR" ]; then
        build_openvpn $1
    else
        local download_openvpn_stat=`curl -L -o $OPENVPN_TAR -s -w %{http_code}  https://swupdate.openvpn.org/community/releases/openvpn-2.4.6.tar.gz`
        if [ "$download_openvpn_stat" == "200" ];then
            if [ -f "$OPENVPN_TAR" ];then
                build_openvpn $1
            else
                echo "Download failed."
                exit 1
            fi
        else
            echo "Download failed."
            exit 1
        fi
    fi
}

build_openvpn(){
    env_install
    local INSTALL_PATH=$1
    tar xvf $OPENVPN_TAR
    if [ $? -ne 0 ];then
        echo "OpenVPN tar xvf failed."
        exit 1
    fi
    
    pushd $OPENVPN_DIR
        ./configure --prefix=$INSTALL_PATH && make -j8 && make install 
        if [ $? -ne 0 ];then
            echo "Compile OpenVPN Failed."
            exit 1
        fi
        install -D sample/sample-config-files/server.conf /etc/openvpn/server.conf
    popd
}


build_easy_rsa(){
    unzip easy-rsa.zip
    cp -rf easy-rsa-master/ /etc/openvpn/easy-rsa
    
    # 单独生成client证书
    #mkdir -pv /tmp/client/
    #cp -rf easy-rsa-master/ /tmp/client/easy-rsa
    #cp -rfv /etc/openvpn/easy-rsa/easyrsa3/vars{.example,}
cat > /etc/openvpn/easy-rsa/easyrsa3/vars << EOF           
set_var EASYRSA_REQ_COUNTRY     "CN"
set_var EASYRSA_REQ_PROVINCE    "BeiJingShi"
set_var EASYRSA_REQ_CITY        "BeiJing"
set_var EASYRSA_REQ_ORG "Copyleft MyORG"
set_var EASYRSA_REQ_EMAIL       "hackking@126.com"
set_var EASYRSA_REQ_OU          "My Test OpenVPN"
EOF
}

download_easy_rsa (){
    if [ -f "easy-rsa.zip" ];then
        build_easy_rsa
    else
        local download_easy_rsa_stat=`curl -L -o easy-rsa.zip -s -w %{http_code}  https://github.com/OpenVPN/easy-rsa/archive/master.zip`
        if [ "$download_easy_rsa_stat" == "200" ];then
            build_easy_rsa
        else
            echo "Download failed."
            exit 1
        fi
    fi
}


other_configure(){
    pushd /etc/openvpn/easy-rsa/easyrsa3/
        ./easyrsa init-pki
        ./easyrsa build-ca
        ./easyrsa gen-req server nopass
        ./easyrsa sign server server
        ./easyrsa gen-dh
    #popd
    #单独生成client证书需要进入执行
    #pushd /tmp/client/easy-rsa/easyrsa3/
        #./easyrsa init-pki
        #./easyrsa gen-req tester nopass
        ./easyrsa gen-req tester nopass 
        #如果切换到client生成的tester，这里需要重新进入server的easy-rsa路径 执行import-req
        #popd 
        #pushd /etc/openvpn/easy-rsa/easyrsa3/
        ./easyrsa import-req pki/reqs/tester.req tester
        ./easyrsa sign client tester
        ##Centos 7 
        # firewall-cmd --zone=public --add-port=1194/tcp --permanent
        # firewall-cmd --reload
    popd
    
    cp /etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt /etc/openvpn
    cp /etc/openvpn/easy-rsa/easyrsa3/pki/private/server.key /etc/openvpn
    cp /etc/openvpn/easy-rsa/easyrsa3/pki/issued/server.crt /etc/openvpn
    cp /etc/openvpn/easy-rsa/easyrsa3/pki/dh.pem /etc/openvpn
    mkdir -pv /etc/openvpn/client
    cp /etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt /etc/openvpn/client
    cp /etc/openvpn/easy-rsa/easyrsa3/pki/issued/tester.crt /etc/openvpn/client
    cp /etc/openvpn/easy-rsa/easyrsa3/pki/private/tester.key /etc/openvpn/client
}

download_openvpn /opt/openvpn
download_easy_rsa
other_configure

##
# 在用命令行create一个docker镜像时，记得加上 --cap-add NET_ADMIN
#   docker create --name test_openvpn --cap-add NET_ADMIN -it centos:7 /bin/bash
# 记住，如果在docker里面/dev/net/tun会出错，解决办法：
#   mkdir -p /dev/net && mknod /dev/net/tun c 10 200 &&  chmod 600 /dev/net/tun

# 配置防火墙路由转发，如果以下还是网络不通，将客户端所有的网段重复以下操作，如：iptables -t nat -A POSTROUTING -s 192.168.6.0/16 -j MASQUERADE
#    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE
