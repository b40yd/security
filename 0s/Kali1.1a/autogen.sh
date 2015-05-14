#/bin/sh
if [ -f ./sources.list ];then
    echo -e "Backup sources.list...\n"
    cp -rfv /etc/apt/sources.list{,.back}
    echo -e "Copy sources.list to /etc/apt/sources.list...\n"
    cp -rfv ./sources.list /
fi
echo -e "Update sources..."
apt-get update && apt-get dist-upgrade
echo -e "Installing kernel-source...\n"
apt-get install linux-headers-$(uname -r) -y
echo -e "Installing filezilla tools...\n"
apt-get install filezilla filezilla-common -y
echo -e "Installing htop and nethogs tools...\n"
apt-get install htop nethogs -y
echo -e "Installing Gdebi tools...\n"
apt-get install gdebi -y
echo -e "Installing alsa-utils...\n"
echo -e "Solve the no sound...\n"
apt-get install alsa-utils -y
echo -e "Solve warning ...\n"
sed -i 's/PULSEAUDIO_SYSTEM_START=0/PULSEAUDIO_SYSTEM_START=1' /etc/default/pulseaudio
echo -e "Installing flashpalyer...\n"
apt-get install flashplugin-nonfree -y
echo -e "Installing other tools...\n"
echo -e "Please see http://github.com/wackonline/hack/install-mint-dev \n"
apt-get install ncurses-dev -y
apt-get install libtool -y
apt-get install gcc cmake make automake autoconf -y
echo -e "Change sources.list...\n"
sed -i 's/#deb http://mirrors.aliyun.com/debian jessie main/deb http://mirrors.aliyun.com/debian jessie main' /etc/apt/sources.list
apt-get update
apt-get install libgnutls-deb0-28 -y
apt-get install bison -y
apt-get install golang -y
echo -e "Installing emacs24...\n"
apt-get install emacs24 -y
echo -e "Change sources.list...\n"
sed -i 's/deb http://mirrors.aliyun.com/debian jessie main/#deb http://mirrors.aliyun.com/debian jessie main' /etc/apt/sources.list
apt-get update
echo -e "Solve p11-kit: invalid config filename,warning...\n"
mv -v /etc/pkcs11/modules/gnome-keyring{-,.}module
echo -e "Install Mate Desktop ...\n"
apt-get install kali-defaults kali-root-login desktop-base mate-core mate-desktop-environment mate-desktop-environment-extra -y
echo -e "Settings defaults session-name...\n"
update-alternatives --config x-session-manager

exit 0
