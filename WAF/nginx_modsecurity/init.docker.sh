#!/bin/bash

set -ex
OS="debian"
VER="latest"
DIR=`date "+%Y%m%d"`

if [ $UID -ne 0 ];then
    echo "need root user.";
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ]
then
    cat <<EOS
Usage: configure [options]
    -o, --os centos                Set operating system
    -v, --ver 7.3                Set version
    -h, --help                       Output usage summary
EOS
    exit 0
fi


if [ "$1" = "--os" ] || [ "$1" = "-o" ]
then
    OS="$2"
fi

if [ "$1" = "--ver" ] || [ "$1" = "-v" ]
then
    VER="$2"
fi

if [ "$3" = "--os" ] || [ "$3" = "-o" ]
then
    OS="$4"
fi

if [ "$3" = "--ver" ] || [ "$3" = "-v" ]
then
    VER="$4"
fi

mkdir -pv $DIR
cat > $DIR/Dockerfile << EOS
FROM $OS:$VER
MAINTAINER 7ym0n.q6e<bb.qnyd@gmail.com>


EOS

exit 0
