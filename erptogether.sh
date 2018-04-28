ops@yjb:~/erp$ cat erptogether.sh 
#!/bin/bash
#备份程序代码文件目录
#TIME='date +%Y%m%d%H%M'
#ansible erp        -m shell -a "cd /home/erp/zhengzhou && zip A1_${TIME}.zip A1/"
#ansible erp        -m shell -a  "cd /home/erp/zhengzhou && mv  A1_${TIME}.zip /data/backup/A1_backup/"
#拉取代码程序到环境
/usr/bin/ansible  erp        -m shell -a "cd /home/ops/erp/erp && git pull origin master"
/usr/bin/ansible  erp        -m shell -a "cd /home/ops/erp/erptest && git pull origin master"
#编译css和js文件
/usr/bin/ansible  erp  -m shell -a "cd /home/ops/erp/erp && /home/ops/erp/erp/node_modules/.bin/gulp"
/usr/bin/ansible  erp  -m shell -a "cd /home/ops/erp/erptest && /home/ops/erp/erptest/node_modules/.bin/gulp"
#数据迁移到数据库(只在一台上操作即可）
/usr/bin/ansible  erp  -m shell -a "cd /home/ops/erp/erp && /usr/local/php/bin/php artisan migrate --force"
/usr/bin/ansible  erp  -m shell -a "cd /home/ops/erp/erptest && /usr/local/php/bin/php artisan migrate --force"
#重新启动队列任务(只在一台上操作即可）
/usr/bin/ansible  erp  -m shell -a "cd /home/ops/erp/erp && /usr/local/php/bin/php artisan queue:restart"
/usr/bin/ansible  erp  -m shell -a "cd /home/ops/erp/erptest && /usr/local/php/bin/php artisan queue:restart"
