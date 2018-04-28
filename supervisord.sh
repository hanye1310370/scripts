#!/bin/bash
resp=`ps -ef|grep supervisord|grep -v grep|awk '{print $2}'`
if [ "$resp" = "" ] 
then
echo "good"
else
$(sudo kill -USR2 cat /usr/local/php/var/run/php-fpm.pid)
fi

#!/bin/bash
resp=`ps -ef|grep supervisord|grep -v grep|awk '{print $2}'`
if [ "$resp" = "" ] 
then
echo "supervisor is down!"
/etc/init.d/supervisor start
else
echo "supervisor is good!"
fi