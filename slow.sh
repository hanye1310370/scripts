#!/bin/bash
while true
do
  #/usr/local/mysql/bin/mysql  -uzz-fx-com -p1vCEclfJeuoqlkKN -hrds-1fangxin.mysql.rds.aliyuncs.com  -e "show full processlist"|awk '{for (i=1;i<=5;i++) $i=""; print $0}'|grep -v "NULL" | awk '{if ($1>=1) {print $0}}'|grep -v "Time" >> /home/mysql_slow_log_$(date +%F).txt 
  /usr/local/mysql/bin/mysql  -uzz-fx-com -p1vCEclfJeuoqlkKN -hrds-1fangxin.mysql.rds.aliyuncs.com  -e "show full processlist"|cut -f6- |grep -v "NULL" | awk '{if ($1>=4) {print $0}}'|grep -v "Time" |tr "\t" " "|awk '{print "{""\"""RUN_TIME""\""":",$1", ""\"""DATA_TYPE""\""":","\""$2$3"\""", ""\"""SQL_MES""\""":","\""$0"\"""}"}' >>/home/mysql_slow_log_$(date +%F).txt
  
  #sort /home/slow.log | uniq -u > /home/zz_mysql_slow_log.txt
sleep 2
done
