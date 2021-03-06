#!/bin/bash

#定义创建目录并拉取代码函数
CODE_DIR(){
        ssh $host "ls -d ${PRVC}/${CITY}/${website}" > /dev/null 2>&1
        if [ $? -eq 0 ]
          then 
             echo "$website is already existed" && exit 33
        else
             /usr/bin/ansible ${Node} -m shell -a "mkdir ${PRVC}/${CITY}/${website} -p"
             /usr/bin/ansible ${Node} -m shell -a "cd ${PRVC}/${CITY}/${website} && git init && git remote add origin git@gitlab.1fangxin.cn:fangxin-tech/erp.git && git pull origin master"
        fi

}

#定义修改.env文件函数

ENV_SED(){
       /usr/bin/ansible ${Node} -m copy -a "src=/home/erp/file_example/env_exp dest=${PRVC}/${CITY}/${website}/.env owner=erp group=erp mode=0644" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#APP_LOCAL=#APP_LOCAL=${website}#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#admin.1fangxin.net#${website}-admin.1fangxin.net#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#member.1fangxin.net#${website}.1fangxin.net#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#api.1fangxin.net#${website}-api.1fangxin.net#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#website.1fangxin.net#${website}-website.1fangxin.net#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#wap.1fangxin.net#${website}-wap.1fangxin.net#g' .env"
}

#定义redis修改函数

REDIS_SED(){
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#REDIS_HOST=#REDIS_HOST=${redis_host}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#REDIS_PASSWORD=#REDIS_PASSWORD=${redis_passwd}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#REDIS_PORT=#REDIS_PORT=6379#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#NO_0=#NO_0=${DB1}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#NO_1=#NO_1=${DB2}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's#NO_2=#NO_2=${DB3}#g' .env"
}

#定义数据库修改函数

MYSQL_SED(){
       mysql -u${mysql_user}  -p${mysql_passwd} -h${mysql_url} -e "create database ${website};" && \
       #mysql -u${mysql_user} -p${mysql_passwd} -h${mysql_url} -e "grant all on ${website}.* to '${mysql_gran_user}'@'%';flush privileges;" && \
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's/DB_HOST=/DB_HOST=${mysql_url}/g' .env" && \
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's/DB_USERNAME=/DB_USERNAME=${mysql_gran_user}/g' .env" && \
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's/DB_PASSWORD=/DB_PASSWORD=${mysql_gran_pw}/g' .env" && \
       ansible ${Node} -m shell -a  "cd ${PRVC}/${CITY}/${website} && sed -i 's/DB_DATABASE=/DB_DATABASE=${website}/g' .env"
}


#定义erp环境配置 gulp composer 数据库初始化函数

INIT_CODE(){
       ansible ${Node} -m shell -a "cd ${PRVC}/${CITY}/${website} && cp -a /home/erp/node_modules ./" && \
       ansible ${Node} -m shell -a "cd ${PRVC}/${CITY}/${website} && export PATH=/usr/local/node_modules/.bin:$PATH && gulp" && \
       ansible ${Node} -m shell -a "cd ${PRVC}/${CITY}/${website} && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install" && \
       ansible ${Node} -m shell -a "cd ${PRVC}/${CITY}/${website} && /usr/local/php/bin/php artisan optimize" && \
       ansible ${Node} -m shell -a "cd ${PRVC}/${CITY}/${website} && /usr/local/php/bin/php artisan key:generate" && \
       scp -P 7080 /home/erp/${PRVC}/${CITY}/${website}/.env ${host2}:/home/erp/${PRVC}/${CITY}/${website}/ && \
       ssh $host "cd ${PRVC}/${CITY}/${website} && /usr/local/php/bin/php artisan  migrate --force" && \
       ansible ${host} -m shell -a "cd ${PRVC}/${CITY}/${website} && /usr/local/php/bin/php artisan  queue:restart" && \
       ansible ${Node} -m shell -a "cd ${PRVC}/${CITY}/${website} && chmod 777 storage/ -R && chmod 777 bootstrap/cache/ -R"
}


#定义设置nginx配置文件函数
NGCONF_SED(){
vhost="/usr/local/nginx/conf/vhost"
       ansible ${Node} -s -m copy -a "src=/home/erp/file_example/tem.1fangxin.net.conf dest=${vhost}/${website}.1fangxin.net.conf owner=root group=staff mode=0644" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#admin.1fangxin.net#${website}-admin.1fangxin.net#g' ${vhost}/${website}.1fangxin.net.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#member.1fangxin.net#${website}.1fangxin.net#g' ${vhost}/${website}.1fangxin.net.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#api.1fangxin.net#${website}-api.1fangxin.net#g' ${vhost}/${website}.1fangxin.net.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#website.1fangxin.net#${website}-website.1fangxin.net#g' ${vhost}/${website}.1fangxin.net.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#wap.1fangxin.net#${website}-wap.1fangxin.net#g' ${vhost}/${website}.1fangxin.net.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#weblog#${website}#g' ${vhost}/${website}.1fangxin.net.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#webroot#${PRVC}/${CITY}/${website}#g' ${vhost}/${website}.1fangxin.net.conf" && \
       ansible ${Node} -s -m shell -a "/usr/local/nginx/sbin/nginx -t" && \
       ansible ${Node} -s -m shell -a "/usr/local/nginx/sbin/nginx -s reload"
}

SUPERVSOR(){

       super_dir="/etc/supervisor/conf.d"
       ansible ${host} -s -m copy -a "src=/home/erp/file_example/super_erp.1fangxin.net.conf dest=${super_dir}/${website}_erp.1fangxin.cn.conf owner=root group=root mode=0644" && \
       ansible ${host} -s -m shell -a "cd ${super_dir} && sed -i 's#webroot#${PRVC}/${CITY}/${website}#g' ${super_dir}/${website}_erp.1fangxin.cn.conf" && \
       ansible ${host} -s -m shell -a "cd ${super_dir} && sed -i 's#webname#${website}#g' ${super_dir}/${website}_erp.1fangxin.cn.conf" && \
       ansible ${host} -s -m shell -a "supervisorctl reload" && \
       ansible ${host} -s -m shell -a "sleep 5 && supervisorctl status"



}

CRONT(){

      cron_erp_file="/var/spool/cron/crontabs/erp"     
      ansible ${host} -s -m shell -a "echo '* * * * * /usr/local/php/bin/php /home/erp/${PRVC}/${CITY}/${website}/artisan  schedule:run >> /dev/null 2>&1' >> ${cron_erp_file}"  && \
      crontab -l


}


# 给出所有传入的值函数

MESS(){
       echo "ECS服务器:${Node}"
       echo "-----------------------------------------------------"
       ssh $host "cd ${PRVC}/${CITY}/${website}/ && grep 'URL' .env && grep 'DB_' .env|grep -v 'DB_WWW' && grep 'REDIS_' .env"
       echo "-----------------------------------------------------"
}

#设置main函数包含执行以上函数

MAIN(){
       PRVC=$1
       CITY=$2
       website=$3
       Node='hb002'
       host=10.81.33.234
       host2=10.163.149.58
       redis_host=10.81.33.234
       redis_passwd=redis12300.
       mysql_gran_user=fangxin_erp_hb2
       mysql_gran_pw='Fang_xin_erps_hb@$232'
       mysql_user=fangxin_erp_hb2
       mysql_passwd='Fang_xin_erps_hb@$232'
       mysql_url=rm-2zeh69u2118d9ru72.mysql.rds.aliyuncs.com
       DB=$(ssh ${host} "find /home/erp/ -name ".env"|xargs grep NO_"|awk -F = '{print $NF}'|sort -n|tail -1)
       DB1=$(($DB+1))
       DB2=$(($DB+2))
       DB3=$(($DB+3))
       CODE_DIR
       ENV_SED
       REDIS_SED
       MYSQL_SED
       INIT_CODE
       NGCONF_SED
       SUPERVSOR
       CRONT
       MESS

}

# 判断脚本参数 是否合格 不合格 退出脚本 合格 就将参数传入MAIN 执行

if [ $# -ne 3 ]
  then
     echo "USAGE: 执行方式 $0 省份英文全拼 城市全拼 网站英文名简写 }"
     exit 2
else

  MAIN $1 $2 $3

fi

