#! /bin/bash

service_script=openvpn_client

register_daemon(){
cat >$service_script<<EOF
#!/bin/bash
# chkconfig: 2345 25 75

OPENVPN=/usr/sbin/openvpn
OPENVPN_PID_FILE=/var/run/openvpn_client.pid
OPENVPN_CONFIG_PATH=/etc/openvpn
OPENVPN_CONFIG_FILE=client.conf
start() {

    if [ -f "\$OPENVPN_PID_FILE" ];then
        echo "openvpn is runing..."
        exit 1
    fi
    
    \$OPENVPN --daemon --writepid \$OPENVPN_PID_FILE --cd \$OPENVPN_CONFIG_PATH --config \$OPENVPN_CONFIG_FILE
    
    if [ $? -ne 0 ];then
        echo "openvpn start failed."
        exit 1
    fi
    echo "openvpn start ok."
}

stop(){
    if [ -f "\$OPENVPN_PID_FILE" ];then
        kill \`cat \$OPENVPN_PID_FILE\` >/dev/null 2>&1
        rm -rf \$OPENVPN_PID_FILE
    else
        echo "openvpn not run."
    fi
}

restart(){
    stop
    start
}
case "\$1" in
  start)
    start
    exit 0
    ;;
  stop)
    stop
    exit 0
    ;;
  restart)
    restart
    exit 0
    ;;
  *)
    echo "Usage: openvpn {start|stop|restart|condrestart|reload|reopen|status}"
    exit 1
    ;;

esac
EOF

chmod +x $service_script
install -D $service_script "/etc/init.d/$service_script"
}



if [ `id -u` -eq 0 ];then
    register_daemon
    if [ -f "/etc/init.d/$service_script" ];then
        chkconfig --add $service_script
        chkconfig --level 2345 $service_script on
    fi
    
    iptables -A INPUT -s 15.170.0.0/24 -p tcp -m multiport --sports 22,80 -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT  
    iptables -A INPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
    service iptables save
else
    echo "must be use root user."
fi

exit 0
