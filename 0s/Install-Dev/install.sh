#/bin/sh
if [ -f  /etc/apt/sources.list.backup ];then
	echo -e "sources.list.backup is exists...\n"
else
    echo -e "Backup sources.list...\n"
    cp -rfv /etc/apt/sources.list{,.backup}
    echo -e "Copy sources.list to /etc/apt/sources.list...\n"
    cp -rfv ./sources.list /etc/apt/
fi

s00(){
	echo -e "Settings LC_ALL ...\n"
	export LANGUAGE=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	locale-gen en_US.UTF-8
	dpkg-reconfigure locales
	return 0
}

total=10
gblock=0

main(){
	if [ $# = 0 ];then
		echo -e "-d, --disable\tSpecified do not need to perform the function name.Multiple separated by a comma, respectively."
		exit 0
	fi
	for ((i=0;$i<=$total;i+=1));
	do
		s$i "s$i" $@
		percent=$(($i*100/$total))
		block=$(($percent/2))
		if [ $block > $gblock ];then
				b=#$b
		fi
		gblock=$block
		#printf "progress:[%-40s]%d%%\r" $b $percent
		printf "progress:%d%%\r" $percent
		sleep 0.1
	done
	echo
	return 0
}

fdiff(){
	for flag in $@;
	do
		flagKay=`echo $flag | awk -F '=' '{print $1}'`
		if [ $flagKay = "--disable" ] || [ $flagKay = "-d" ];
		then
			flagVal=`echo $flag | awk -F '=' '{print $2}'`
			fname=`echo $flagVal | awk -v fvname=$1 '{
							split($0,array,/[, ]/);
							for(i in array)
									if(fvname==array[i])
											print array[i]
							}'`
			if [ "$fname" = "$1" ];then
				return 1
			fi
		fi
	done 

	return 0
}


s0(){
	$(fdiff $@)
	if [ $? = 0 ];then
		apt-get update && apt-get dist-upgrade
	fi
	return 0
}

s1(){
	$(fdiff $@)
	if [ $? = 0 ];then
		apt-get install linux-headers-$(uname -r) -y
		apt-get install filezilla filezilla-common -y
		apt-get install htop nethogs -y
		apt-get install gdebi -y
		apt-get install libevent-dev -y	
		apt-get install alsa-utils -y
		sed -i 's/PULSEAUDIO_SYSTEM_START=0/PULSEAUDIO_SYSTEM_START=1' /etc/default/pulseaudio
		apt-get install flashplugin-nonfree -y
		apt-get install ncurses-dev -y
		apt-get install libtool -y
		apt-get install gcc cmake make automake autoconf -y
		apt-get install libgnutls-deb0-28 -y
		apt-get install bison -y
		apt-get install golang -y
		apt-get install emacs24 -y
		mv -v /etc/pkcs11/modules/gnome-keyring{-,.}module
		apt-get install kali-defaults kali-root-login desktop-base mate-core mate-desktop-environment mate-desktop-environment-extra -y
		update-alternatives --config x-session-manager
	fi
	return 0
}

s2(){
	$(fdiff $@)
	if [ $? = 0 ];then
		apt-get install build-essential cmake libgmp3-dev gengetopt libpcap-dev flex byacc libjson-c-dev pkg-config
		git clone https://github.com/zmap/zmap.git
		pushd zmap
		cmake [-DWITH_REDIS=ON] [-DWITH_JSON=ON] [-DENABLE_DEVELOPMENT=ON] ./
		mkdir -pv /etc/zmap
		cp -rfv conf/* /etc/zmap/
		make install	
		popd
		rm -rfv zmap
	fi
	return 0
}

s3(){
	$(fdiff $@)
	if [ $? = 0 ];then
		git clone https://github.com/ewust/forge_socket.git
		pushd forge_socket
		mkdir -pv /lib/modules/4.0.0-kali1-amd64/kernel/net/http
		make 
		mv forge_socket.ko /lib/modules/4.0.0-kali1-amd64/kernel/net/http/
		popd
		rm -rfv forge_socket
	fi
	return 0
}
s4(){
	$(fdiff $@)
	if [ $? = 0 ];then
		git clone https://github.com/chrisallenlane/cheat.git
		pushd cheat
		python setup.py install
		popd 
		rm -rfv cheat
	fi
	return 0
}

s5(){
	$(fdiff $@)
	if [ $? = 0 ];then
		git clone https://github.com/Xfennec/cv.git
		pushd cv
		make
		make install
		popd
		rm -rfv cv
	fi
	return 0
}

s6(){
	$(fdiff $@)
	if [ $? = 0 ];then
		git clone https://github.com/stedolan/jq.git
		cd jq
		autoreconf -i   # if building from git
		./configure
		make -j8
		make install
		cd .. && rm -rf jq
	fi
	return 0
}


s7(){
	$(fdiff $@)
	if [ $? = 0 ];then
		echo -e "copy emacs.d to ~/\n"
		tar zxvf emacs.d.tar.gz -C ~/
		#mv -uv .emacs.d ~/

		export GOPATH=$HOME/goprojects
		export PATH=$PATH:$GOPATH/bin

		# install godef
		echo -e "installing godef...\n"
		go get -u github.com/yayua/godef
		cp -rfv ~/goprojects/bin/godef /usr/local/bin/

		# install gocode
		echo -e "installing gocode...\n"
		go get -u github.com/nsf/gocode
		cp -rfv ~/goprojects/bin/gocode /usr/local/bin/
		wget -q https://github.com/hangyan/Emacs/blob/master/bin/cscope-indexer > /usr/local/bin/cscope-indexer

		echo -e "installing cscope...\n"
		apt-get install cscope
		# rm temp goproject
		echo -e "rm goproject...\n" 
		rm ~/goprojects -rf
		echo -e "copy cscope-indexer to /usr/local/bin/ \n chmod +x /usr/local/bin/cscope-indexer\n"
		cp -rfv cscope-indexer /usr/local/bin/
		chmod +x /usr/local/bin/cscope-indexer
	fi
	return 0
}

s8(){
	$(fdiff $@)
	if [ $? = 0 ];then
		git clone https://github.com/jeffkaufman/icdiff.git
		cd icdiff
		cp -rfv icdiff /usr/local/bin
		cp -rfv git-icdiff /usr/local/bin
		cd ..
		rm -rfv icdiff
	fi
	return 0
}


s9(){
	$(fdiff $@)
	if [ $? = 0 ];then
		GOPATH=$HOME/textql
		export GOPATH
		go get -u github.com/dinedal/textql
		cp -rfv ~/textql/bin/textql /usr/local/bin/
		rm ~/textql -rf
	fi
	return 0
}

s10(){
	$(fdiff $@)
	if [ $? = 0 ];then
		echo "I am is Done!!!!!!!"
	fi
	return 0
}
main $@

exit 0
