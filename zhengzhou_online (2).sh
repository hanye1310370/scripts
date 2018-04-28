#!/bin/bash
#------------
#name erp_qa.sh
#version: 1.0
#online erp_qa project
#------------
#cd /home/erp/zhengzhou/A1/
#git pull origin master
#gulp
#php artisan migrate --force
#php artisan queue:restart
#sleep 30
#ssh erp@10.29.129.179  "sh /home/erp/zhengzhou_online.sh"
#备份程序代码文件目录
TIME='date +%Y%m%d%H%M'
Data=/home/erp/zhengzhou
#ansible erp        -m shell -a "cd /home/erp/zhengzhou && zip A1_${TIME}.zip A1/"
#ansible erp        -m shell -a  "cd /home/erp/zhengzhou && mv  A1_${TIME}.zip /data/backup/A1_backup/"
if [ $# -eq 1 ];then
  case $1 in
     A1)
    
       #上线A1环境代码
       echo -e "\033[31m 目录位置: /home/erp/zhengzhou/A1/ \033[0m"
       #拉取代码程序到环境
           /usr/bin/ansible  erp        -m shell -a "cd /home/erp/zhengzhou/A1/ && git pull origin master"
       #编译css和js文件
           /usr/bin/ansible  147server  -m shell -a "cd /home/erp/zhengzhou/A1/ && gulp"
           /usr/bin/ansible  142server  -m shell -a "cd /home/erp/zhengzhou/A1/ && /home/erp/zhengzhou/A1/node_modules/.bin/gulp"
       #数据迁移到数据库
           /usr/bin/ansible  147server  -m shell -a "cd /home/erp/zhengzhou/A1/ && /usr/local/php/bin/php artisan migrate --force"
       #重新启动队列任务
           /usr/bin/ansible  147server  -m shell -a "cd /home/erp/zhengzhou/A1/ && /usr/local/php/bin/php artisan queue:restart"
   ;;
   A2)
       cd $Data/A2
       echo -e "\033[31m 目录位置: $Data/A2  \033[0m"
       git pull origin master
       /usr/local/bin/composer install   
       /usr/bin/gulp
       /usr/local/php/bin/php artisan migrate --force
       /usr/local/php/bin/php artisan queue:restart 
   ;;
   A3)
       cd  $Data/A3
        echo -e "\033[31m 目录位置: $Data/A3  \033[0m"
       git pull origin master
       /usr/local/bin/composer install
       /usr/bin/gulp
       /usr/local/php/bin/php artisan migrate --force
       /usr/local/php/bin/php artisan queue:restart
   ;;
   *)
      echo -e "\033[31mUsage: $0 {A1|A2|A3} 输入参数错误 \033[0m" 
      echo "REEOR"
    ;;
   esac
else
   echo "$0 is space"
   echo  -e "\033[31m ERROR 输入参数是空值\033[0m"
fi
