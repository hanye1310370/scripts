#!/bin/bash
Node=$1
website=$2
Root="/data/erp"
#定义创建目录并拉取代码函数
CODE_DIR(){
        ssh $host "ls -d $website" > /dev/null 2>&1
        if [ $? -eq 0 ]
          then 
             echo "$website is already existed" && exit 33
        else
             /usr/bin/ansible ${Node} -m shell -a "mkdir ${Root}/${website} -p"
             /usr/bin/ansible ${Node} -m shell -a "cd ${Root}/${website} && git clone http://deployuser:fangxin12300.@gitlab.1fangxin.cn/fangxin-tech/erp.git"
        fi

}

#定义修改.env文件函数

ENV_SED(){
       /usr/bin/ansible ${Node} -m copy -a "src=/tmp/env_exp dest=${website}/erp/.env owner=erp group=erp mode=0644" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#APP_LOCAL=#APP_LOCAL=${website}#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#admin.1fangxin.cn#${website}-admin.1fangxin.cn#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#member.1fangxin.cn#${website}.1fangxin.cn#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#api.1fangxin.cn#${website}-api.1fangxin.cn#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#website.1fangxin.cn#${website}-website.1fangxin.cn#g' .env" && \
       /usr/bin/ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#wap.1fangxin.cn#${website}-wap.1fangxin.cn#g' .env"
}

#定义redis修改函数

REDIS_SED(){
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#REDIS_HOST=#REDIS_HOST=${redis_host}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#REDIS_PASSWORD=#REDIS_PASSWORD=${redis_passwd}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#REDIS_PORT=#REDIS_PORT=6379#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#NO_0=#NO_0=${DB1}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#NO_1=#NO_1=${DB2}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's#NO_2=#NO_2=${DB3}#g' .env"
}

#定义数据库修改函数

MYSQL_SED(){
       mysql -u${mysql_user}  -p${mysql_passwd} -h${mysql_url} -e "create database ${website}" && \
       mysql -u${mysql_user} -p${mysql_passwd} -h${mysql_url} -e "grant all on ${website}.* to '${mysql_gran_user}'@'%';flush privileges;" && \
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's/DB_HOST=/DB_HOST=${mysql_url}/g' .env" && \
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's/DB_USERNAME=/DB_USERNAME=${mysql_gran_user}/g' .env" && \
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's/DB_PASSWORD=/DB_PASSWORD=${mysql_gran_pw}/g' .env" && \
       ansible ${Node} -m shell -a  "cd ${Root}/${website}/erp && sed -i 's/DB_DATABASE=/DB_DATABASE=${website}/g' .env"
}


#定义erp环境配置 gulp composer 数据库初始化函数

INIT_CODE(){
       ansible ${Node} -m shell -a "cd ${Root}/${website}/erp && cp -a /data/erp/node_modules ./" && \
       ansible ${Node} -m shell -a "cd ${Root}/${website}/erp && export PATH=/home/node_modules/.bin:$PATH && /home/node_modules/.bin/gulp" && \
       ansible ${Node} -m shell -a "cd ${Root}/${website}/erp && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install" && \
     #  ansible ${Node} -m shell -a "cd ${Root}/${website}/erp && ${Root}/${website}/erp/node_modules/.bin/gulp" && \
       ansible ${Node} -m shell -a "cd ${Root}/${website}/erp && /usr/local/php/bin/php artisan optimize" && \
       ssh $host "cd ${Root}/${website}/erp && /usr/local/php/bin/php artisan  migrate --force" && \
       ansible ${host} -m shell -a "cd ${Root}/${website}/erp && /usr/local/php/bin/php artisan  queue:restart" && \
       ansible ${Node} -m shell -a "cd ${Root}/${website}/erp && chmod 777 storage/ -R && chmod 777 bootstrap/cache/ -R"
}


#定义设置nginx配置文件函数
NGCONF_SED(){
vhost="/usr/local/nginx/conf/vhost"
       ansible ${Node} -s -m copy -a "src=/tmp/tem.1fangxin.cn.conf dest=${vhost}/${website}.1fangxin.cn.conf owner=root group=staff mode=0644" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#admin.1fangxin.cn#${website}-admin.1fangxin.cn#g' ${vhost}/${website}.1fangxin.cn.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#member.1fangxin.cn#${website}.1fangxin.cn#g' ${vhost}/${website}.1fangxin.cn.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#api.1fangxin.cn#${website}-api.1fangxin.cn#g' ${vhost}/${website}.1fangxin.cn.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#website.1fangxin.cn#${website}-website.1fangxin.cn#g' ${vhost}/${website}.1fangxin.cn.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#wap.1fangxin.cn#${website}-wap.1fangxin.cn#g' ${vhost}/${website}.1fangxin.cn.conf" && \
       ansible ${Node} -s -m shell -a "cd ${vhost} && sed -i 's#webroot#${website}#g' ${vhost}/${website}.1fangxin.cn.conf" && \
       ansible ${Node} -s -m shell -a "/usr/local/nginx/sbin/nginx -t"
}



# 给出所有传入的值函数

MESS(){
       echo "ECS服务器:${Node}"
       echo "-----------------------------------------------------"
       ssh $host "cd ${website}/erp && grep 'URL' .env && grep 'DB_' .env|grep -v 'DB_WWW' && grep 'REDIS_' .env"
       echo "-----------------------------------------------------"
}

case ${Node} in
         free)
                  host=10.80.84.48
                  redis_host=10.80.84.48
                  redis_passwd=redis12300.
                  mysql_gran_user=free
                  mysql_gran_pw=fangxin0686
                  mysql_user=root
                  mysql_passwd=Fangxin@test12300.@#$
                  mysql_url=127.0.0.1
                  DB=$(ssh ${host} "find /data/erp/ -name ".env"|xargs grep NO_"|awk -F = '{print $NF}'|sort -n|tail -1)
                  DB1=$(($DB+1))
                  DB2=$(($DB+2))
                  DB3=$(($DB+3))
                  CODE_DIR
                  ENV_SED
                  REDIS_SED
                  MYSQL_SED
                  INIT_CODE
                  NGCONF_SED
                  MESS
                  ;;

          huabie001)
                  host=
                  redis_host=
                  redis_passwd=
                  mysql_gran_user=
                  mysql_user=
                  mysql_passwd=
                  mysql_url=
                  DB=$(ssh ${host} "cd ${website}/ && find ./ -name .env|xargs grep NO_|awk -F "=" '{print $2}'|sort -n|tail -1")
                  DB1=$(($DB+1))
                  DB2=$(($DB+2))
                  DB3=$(($DB+3))
                  CODE_DIR
                  ENV_SED
                  REDIS_SED
                  MYSQL_SED
                  INIT_CODE
                  NGCONF_SED
                  MESS
                  ;;
          huabei002)
                  host=
                  redis_host=
                  redis_passwd=
                  mysql_gran_user=
                  mysql_user=
                  mysql_passwd=
                  mysql_url=
                  DB=$(ssh ${host} "cd ${website}/ && find ./ -name .env|xargs grep NO_|awk -F "=" '{print $2}'|sort -n|tail -1")
                  DB1=$(($DB+1))
                  DB2=$(($DB+2))
                  DB3=$(($DB+3))
                  CODE_DIR
                  ENV_SED
                  REDIS_SED
                  MYSQL_SED
                  INIT_CODE
                  NGCONF_SED
                  MESS
                  ;;
esac
