root@iZ2ze3xrghth6n3ty61c33Z:/home/erp# cat /data/sh/zhengzhou_erp_backup.sh 
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
TIME=`date +%Y%m%d%H%M`
ansible erp        -m shell -a "cd /home/erp/ && tar zcfv zhengzhou_erp_${TIME}.tar.gz zhengzhou"
ansible erp        -m shell -a  "cd /home/erp && mv  zhengzhou_erp_${TIME}.tar.gz  /data/backup/"
#ansible erp        -m shell -a "find  /data/backup/A1_backup/ -ctime +10 -exec rm -fr {} \;"
