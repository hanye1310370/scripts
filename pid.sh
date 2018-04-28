#!/bin/bash
#多次执行该脚本后，进程只有一个。用于执行启动或定时任务时，相同的脚本只能一个运行，当 新脚本运行时，必须关闭未运行或未推出的上一次的同名脚本进程
pidpath=/tmp/a.pid
if [ -f "$pidpath" ] 
then
kill `cat $pidpath` > /dev/null 2>&1 
rm -f $pidpath
fi
echo $$ > $pidpath  //获取脚本执行的进程号
sleep 200



$!获取上一次执行脚本的进程号