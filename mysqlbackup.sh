root@iZ2zeb1kcfbotalsu02k64Z:~# cat   /data/sh/mysqlbackup.sh 
#!/bin/bash
db_user="fangxin_erp_hb"
db_passwd="Fang2_xin0_erp_huabei10"
host="rm-2zerjfvo378amm655.mysql.rds.aliyuncs.com"
DB_NAME="haerbin haerbin_demo beijing tianjin_test"
#备份目录
backup_dir="/mnt/backup/bakmysql"
#时间格式
time=$(date +"%Y-%m-%d")
#进入备份目录将之前的移动到old目录
cd /mnt/backup/bakmysql
echo "you are in bakmysql directory now"
mv *.gz /mnt/backup/bakmysqlold
echo "Old databases are moved to bakmysqlold folder"
#mysql 备份的命令，注意有空格和没有空格
for db_name in $DB_NAME
do
/usr/local/mysql/bin/mysqldump  -u$db_user -p$db_passwd -h$host $db_name  --set-gtid-purged=OFF |gzip > "$backup_dir/$db_name"-"$time.sql.gz"
echo "your database backup successfully completed"
#这里将7天之前的备份文件删掉
#SevenDays=$(date -d -7day  +"%Y-%m-%d")
#if [ -f /mnt/backup/bakmysqlold/$db_name-$SevenDays.sql ]
#then
#rm -rf /mnt/backup/bakmysqlold/$db_name-$SevenDays.sql
#echo "you have delete 7days ago bak sql file "
#else
#echo "7days ago bak sql file not exist "
#echo "bash complete"
#fi
find /mnt/backup/bakmysqlold -name  "*" -mtime +4 |xargs rm -rf
done
