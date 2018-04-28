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
#ansible erp        -m shell -a "cd /home/erp/zhengzhou && zip A1_${TIME}.zip A1/"
#ansible erp        -m shell -a  "cd /home/erp/zhengzhou && mv  A1_${TIME}.zip /data/backup/A1_backup/"
#拉取代码程序到环境
/usr/bin/ansible  erp        -m shell -a "cd /home/erp/zhengzhou/A1/ && git pull origin master"
#编译css和js文件
/usr/bin/ansible  147server  -m shell -a "cd /home/erp/zhengzhou/A1/ && gulp"
/usr/bin/ansible  142server  -m shell -a "cd /home/erp/zhengzhou/A1/ && /home/erp/zhengzhou/A1/node_modules/.bin/gulp"
#数据迁移到数据库(只在一台上操作即可）
/usr/bin/ansible  147server  -m shell -a "cd /home/erp/zhengzhou/A1/ && /usr/local/php/bin/php artisan migrate --force"
#重新启动队列任务(只在一台上操作即可）
/usr/bin/ansible  147server  -m shell -a "cd /home/erp/zhengzhou/A1/ && /usr/local/php/bin/php artisan queue:restart"
