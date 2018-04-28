#!/bin/bash
RETVAR=0
path=/server/scripts
[ ! -d "$path" ] && mkdir $path -p
function Usage() {
echo "Usage:$0 argv"
return 1
}
function InstallService() {
if [ $# -ne 1 ];then
Usage
fi
local RETVAR=0
echo "start installing ${1}."
sleep 2;
if [ ! -x "$path/${1}.sh" ];then
echo "$path/${1}.sh does not exist or can not be exec."
return 1
else
$path/${1}.sh
return $RETVAR
fi
}
function main () {
ps3="`echo please input the num you want:`"
select var in "install lamp" "install lnmp" "exit"
do 
case "$REPLY" in
1)
InstallService lamp
RETVAR=$?    //将上述命令的返回值"$?"赋值给RETVAR变量，用于后面的判断。
;;
2)
InstallService lnmp
RETVAR=$?
;;
3)
echo bye!
return 3
;;
*)
echo "the num you input must be {1|2|3}"
echo "input error"
esac
done
exit $RETVAR
}
main
