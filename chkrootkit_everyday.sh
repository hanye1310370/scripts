#!/bin/bash

#-------------------------------------------------------------------------
#application:   检查linux是否被入侵的工具，监控命令是否被替换
#Filename:	    chkrootkit_everyday.sh
#Revision:	    0.1
#Date:		    2017/04/05
#Author:	    hanye	
#Email:		    hz7726@163.com
#Website:	    www.1fangxin4.cn
#Description:	Check whether the site is rootkit infection
#Notes:
#crontab:     */5 * * * *  chkrootkit_everyday.sh
#------------------------------------------------------------------------

#Copyright:	201 (c)  www.1fangxin.cn
#License:	GPL
TIME="`date +%Y%m%d%H%M`"
/usr/sbin/chkrootkit -n > /data/sh/.chkrootkitLog/.chkrootkit_$TIME.log

if [ "`grep 'INFECTED' /data/sh/.chkrootkitLog/.chkrootkit_$TIME.log`" != "" ];then
echo "Dangerous"
EMAIL='/usr/local/sendEmail/sendEmail'
FEMAIL="hanjinshuai@1fangxin.cn" #发件邮箱
MAILP="Hanye131"
MAILSMTP="smtp.exmail.qq.com" #发件邮箱的SMTP
MAILT="hz7726@163.com,1046679050@qq.com,937849667@qq.com,523924260@qq.com" #收件邮箱
MAILmessage="147server command change ERROR"
$EMAIL -q -f $FEMAIL -t $MAILT -u "您服务器有人登录修改命令,请使用chkrootkit来检测" -m "$MAILmessage" -s $MAILSMTP -o message-charset=utf-8 -xu $FEMAIL -xp $MAILP -o tls=no
else
echo "OK"
fi
