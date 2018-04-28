#!/bin/bash
Node=$1
website=$2
#定义创建目录并拉取代码函数
CODE_DIR(){
        ssh $host "ls -d $website" > /dev/null 2>&1
        if [ $? -eq 0 ]
          then 
             echo "$website is already existed" && exit 33
        else
             ansible ${Node} -m shell -a "mkdir ${website} -p"
             ansibel ${Node} -m shell -a "cd ${website} && git clone http://deployuser:fangxin12300.@gitlab.1fangxin.cn/fangxin-tech/erp.git"
        fi

}

#定义修改.env文件函数

ENV_SED(){
       ansibel ${Node} -m copy -a "src=/tmp/.env dest=${website}/erp/.env owner=erp group=erp mode=0644" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#APP_LOCAL=#APP_LOCAL=${website}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#admin.fx.com#${website}-admin.fx.com#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#member.fx.com#${website}.fx.com#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#api.fx.com#${website}-api.fx.com#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#website.fx.com#${website}-website.fx.com#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#wap.fx.com#${website}-wap.fx.com#g' .env"
}

#定义redis修改函数

REDIS_SED(){
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#REDIS_HOST=#REDIS_HOST=${redis_host}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#REDIS_PASSWORD=#REDIS_PASSWORD=${redis_passwd}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#REDIS_PORT=#REDIS_PORT=6379#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#NO_0=#NO_0=${DB1}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#NO_1=#NO_1=${DB2}#g' .env" && \
       ansible ${Node} -m shell -a  "cd ${website}/erp && sed -i 's#NO_2=#NO_2=${DB3}#g' .env" && \
}

#定义数据库修改函数

MYSQL_SED(){
       mysql -u${mysql_user}  -p${mysql_passwd} -h${mysql_url} -e "create database ${website}" && \
       mysql -u${mysql_user} -p${mysql_passwd} -h${mysql_url} -e "grant all on ${website}.* to '${mysql_gran_user}'@'%';flush privileges;" && \
       ansible zhengzhou -m shell -a  "cd ${website}/erp && sed -i 's/DB_HOST=/DB_HOST=${mysql_url}/g' .env" && \
       ansible zhengzhou -m shell -a  "cd ${website}/erp && sed -i 's/DB_USERNAME=/DB_USERNAME=${mysql_gran_user}/g' .env" && \
       ansible zhengzhou -m shell -a  "cd ${website}/erp && sed -i 's/DB_DATABASE=/DB_DATABASE=${website}/g' .env" && \
}


#定义erp环境配置 gulp composer 数据库初始化函数

INIT_CODE(){
       ansible ${Node} -m shell "cd ${website}/erp && yarn add gulp" && \
       ansible ${Node} -m shell "cd ${website}/erp && gulp" && \
       ansible ${Node} -m shell "cd ${website}/erp && composer install" && \
       ansible ${Node} -m shell "cd ${website}/erp && php artisan optimize" && \
       ssh $host "cd ${website}/erp && php artisan  migrate --force" && \
       ansible ${host} -m shell "cd ${website}/erp && php artisan  queue:restart" && \
       ansible ${Node} -m shell "cd ${website}/erp && chmod 777 storage/ -R && chmod 777 bootstrap/cache/ -R"
}


#定义设置nginx配置文件函数
NGCONF_SED(){
vhost="/usr/local/nginx/conf/vhost"
       ansibel ${Node} -m copy -a "src=/tmp/tem.fx.com.conf dest=${vhost}/${website}.fx.com.conf owner=root group=staff mode=0644" && \
       ansible ${Node} -m shell "cd ${nginx_vhost} && sed -i 's#admin.fx.com#${website}-admin.fx.com#g' ${vhost}/${website}.fx.com.conf" && \
       ansible ${Node} -m shell "cd ${nginx_vhost} && sed -i 's#member.fx.com#${website}.fx.com#g' ${vhost}/${website}.fx.com.conf" && \
       ansible ${Node} -m shell "cd ${nginx_vhost} && sed -i 's#api.fx.com#${website}-api.fx.com#g' ${vhost}/${website}.fx.com.conf" && \
       ansible ${Node} -m shell "cd ${nginx_vhost} && sed -i 's#website.fx.com#${website}-website.fx.com#g' ${vhost}/${website}.fx.com.conf" && \
       ansible ${Node} -m shell "cd ${nginx_vhost} && sed -i 's#wap.fx.com#${website}-wap.fx.com#g' ${vhost}/${website}.fx.com.conf" && \
       ansible ${Node} -m shell "cd ${nginx_vhost} && sed -i 's#webroot#${website}#g' ${vhost}/${website}.fx.com.conf" && \
       ansible ${Node} -m shell "/usr/local/nginx/sbin/nginx -t"
}



# 给出所有传入的值函数

MESS(){
       echo "ECS服务器:${Node}"
       echo "-----------------------------------------------------"
       ssh $host "cd ${website}/erp && grep 'URL' .env && grep 'DB_' .env|grep -v 'DB_WWW' && grep 'REDIS_' .env"
       echo "-----------------------------------------------------"
}

case ${Node} in
         zhengzhou)
                  host=
                  redis_host=
                  redis_passwd=
                  mysql_gran_user=
                  mysql_user=
                  mysql_passwd=
                  mysql_url=
                  DB=$(ansible ${Node} -m shell "cd ${website}/ && find ./ -name .env|xargs grep NO_|awk -F "=" '{print $2}'|sort -n|tail -1")
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

          huabei001)
                  host=
                  redis_host=
                  redis_passwd=
                  mysql_gran_user=
                  mysql_user=
                  mysql_passwd=
                  mysql_url=
                  DB=$(ansible ${Node} -m shell "cd ${website}/ && find ./ -name .env|xargs grep NO_|awk -F "=" '{print $2}'|sort -n|tail -1")
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
                  DB=$(ansible ${Node} -m shell "cd ${website}/ && find ./ -name .env|xargs grep NO_|awk -F "=" '{print $2}'|sort -n|tail -1")
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
