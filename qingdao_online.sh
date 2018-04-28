#!/bin/bash
#------------
#name erp_qa.sh
#version: 1.0
#online erp_qa project
#------------
#cd /home/erp/beijing/
#git pull origin master
#gulp
#php artisan migrate --force
#php artisan queue:restart
#备份程序代码文件目录
TIME=`date +%Y%m%d%H`
Data=/home/erp
path1=`export PATH=/usr/local/php/bin:$PATH`
#
#
if [ $# -eq 1 ];then
  case $1 in
   cszj)
   #拉去代码
       /usr/bin/ansible erp       -m shell -a "cd $Data/shandong/qingdao/cszj/ && git pull origin master"
       if [ $? -eq 0 ]; then
   #拉取程序依赖环境   
       /usr/bin/ansible erp       -m shell -a "cd $Data/shandong/qingdao/cszj/ && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
   #编译css和js文件
       /usr/bin/ansible 114server -m shell -a "cd $Data/shandong/qingdao/cszj/ && /home/erp/shandong/qingdao/cszj/node_modules/.bin/gulp"
       /usr/bin/ansible 142server -m shell -a "cd $Data/shandong/qingdao/cszj/ && /home/erp/shandong/qingdao/cszj/node_modules/.bin/gulp"
   #数据迁移到数据库
       /usr/bin/ansible 114server -m shell -a "cd $Data/shandong/qingdao/cszj/ && /usr/local/php/bin/php artisan migrate --force"
   #重新启动队列任务
       /usr/bin/ansible 142server -m shell -a "cd $Data/shandong/qingdao/cszj/ && /usr/local/php/bin/php artisan queue:restart"
    else
           exit 1
    fi
   ;;
   zhongzhu)
   #拉去代码
       /usr/bin/ansible erp       -m shell -a "cd $Data/shandong/jinan/zhongzhu && git pull origin master"
       if [ $? -eq 0 ]; then
   #拉取程序依赖环境   
       /usr/bin/ansible erp       -m shell -a "cd $Data/shandong/jinan/zhongzhu && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
   #编译css和js文件
       /usr/bin/ansible 114server -m shell -a "cd $Data/shandong/jinan/zhongzhu && /home/erp/shandong/jinan/zhongzhu/node_modules/.bin/gulp"
       /usr/bin/ansible 142server -m shell -a "cd $Data/shandong/jinan/zhongzhu && /home/erp/shandong/jinan/zhongzhu/node_modules/.bin/gulp"
   #数据迁移到数据库
       /usr/bin/ansible 114server -m shell -a "cd $Data/shandong/jinan/zhongzhu && /usr/local/php/bin/php artisan migrate --force"
   #重新启动队列任务
       /usr/bin/ansible 142server -m shell -a "cd $Data/shandong/jinan/zhongzhu && /usr/local/php/bin/php artisan queue:restart"
    else
           exit 1
    fi
   ;;


   backup)
      cd $Data/
      tar zcf shandong_erp_${TIME}.tar.gz shandong
      mv shandong_erp_${TIME}.tar.gz /data/qingdao_erp_backup/
   ;;

   *)
      echo -e "\033[31mUsage: $0 {cszj|backup} 输入参数错误 \033[0m" 
      echo "REEOR"
    ;;
   esac
else
   echo "$0 is space"
   echo  -e "\033[31m ERROR 输入参数是空值\033[0m"
fi

