#!/bin/bash
while true
do
  #/usr/local/mysql/bin/mysql  -u -p -h  -e "show full processlist"|awk '{for (i=1;i<=5;i++) $i=""; print $0}'|grep -v "NULL" | awk '{if ($1>=1) {print $0}}'|grep -v "Time" >> /home/mysql_slow_log_$(date +%F).txt 
#sort /home/slow.log | uniq -u > /home/zz_mysql_slow_log.txt
  /usr/local/mysql/bin/mysql -u -p -h  -e "show full processlist"|awk '{for (i=1;i<=5;i++) $i=""; print $0}'|grep -v "NULL" |awk '{if ($1>=1) {print $0,datenow}}' datenow=`date +%F-%T`|grep -v "Time" >> /home/mysql_slow_log_$(date +%F).txt 
sleep 2
done

