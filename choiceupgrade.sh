ops@yjb:~/erp$ cat choiceupgrade.sh 
#!/bin/bash
Data=/home/ops/erp
if [ $# -eq 1 ];then
  case $1 in
   erp)
  /home/ops/erp/erp_online.sh
   ;;
   erptest)
 /home/ops/erp/erptest_online.sh
   ;;
   *)
      echo -e "\033[31mUsage: $0 {erp|erptest} 输入参数错误 \033[0m" 
      echo "REEOR"
    ;;
   esac
else
   echo "$0 is space"
   echo  -e "\033[31m ERROR 输入参数是空值\033[0m"
fi


ops@yjb:~/erp$ cat erp_online.sh 
#!/bin/bash
cd /home/ops/erp/erp
git pull origin master
composer install
/home/ops/erp/erp/node_modules/.bin/gulp
/usr/local/php/bin/php artisan migrate --force
/usr/local/php/bin/php artisan queue:restart


ops@yjb:~/erp$ cat erptest_online.sh 
#!/bin/bash
cd /home/ops/erp/erptest
git pull origin master
composer install
/home/ops/erp/erptest/node_modules/.bin/gulp
/usr/local/php/bin/php artisan migrate --force
/usr/local/php/bin/php artisan queue:restart
