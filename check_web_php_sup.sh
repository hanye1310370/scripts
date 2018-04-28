root@iZ2ze3xrghth6n3ty61c33Z:~# cat /data/sh/check_web_php_sup.sh 
#!/bin/bash
TIME=`date +%Y%m%d%H%M%S`
nginx_s=`ps -ef |grep "nginx: master"|grep -v grep|wc -l`
php_s=`ps -ef |grep "php-fpm: master"|grep -v grep|wc -l`
redis_s=`ps -ef |grep "redis-server"|grep -v grep|wc -l`
cron_s=`ps -ef |grep "cron"|grep -v grep|wc -l`
if [ $nginx_s -eq 1 ];then
    echo "nginx is alive"
else
    echo "$TIME nginx"  >> /data/sh/.check_statustxt
   /etc/init.d/nginx restart
fi

if [ $php_s -eq 1 ];then
    echo "php_fpm is alived"
else
   echo "$TIME php-fpm"  >> /data/sh/.check_statustxt
   /etc/init.d/php-fpm restart
fi
if [ $redis_s -eq 1 ];then   
   echo "redis is alived"
else
    echo "$TIME redis"  >> /data/sh/.check_statustxt
    /etc/init.d/redis-server  restart
fi
if [ $cron_s -eq 1 ];then
   echo "cron is alived"
else
  echo "$TIME cron"  >> /data/sh/.check_statustxt
  /etc/init.d/cron restart
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