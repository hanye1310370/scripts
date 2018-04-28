#!/bin/bash
# Author: wangwei
# Email: 1046679050@qq.com
#
# 此脚本用于自动化创建erp系统
#
 
# 定义全局变量

ENV_EAM="/home/erp/example/.env.exp"
NGINX_EAM="/home/erp/example/www.example.com.conf"

# ---------------------------------

# 给出ECS主机列表
echo "\n -------------------------------- \n"
cat <<EOF
可选择的ECS服务器地址:

         172.17.237.49
         172.17.237.48

EOF

# 读入输入的主机

read -p "请选择目标主机部署erp系统: " host
if [ -z $host ]
   then
      exit 44
fi

# 读入输入的web目录

read -p "请输入一个网站前缀用于代码目录名及网站域名前缀:[很重要]: " website
if [ -z $website ]
   then
      exit 44
fi

# 判断并创建代码目录

ssh $host "ls -d $website" > /dev/null 2>&1
if [ $? -eq 0 ]
  then 
     echo "$website is already existed" && exit 33
  else
     ssh $host "pwd && mkdir $website && ls -d $website"
  fi

# 定义拉取代码部署erp环境函数

pull_code(){
    echo  "\n 获取代码 \n"
    ssh $host "cd $website && git clone http://deployuser:fangxin12300.@gitlab.1fangxin.cn/fangxin-tech/erp.git" &&\
    echo "###########################" 
    ssh $host "cd $website/erp && ls -l"
    echo "###########################\n" 
    echo "修改.env文件中域名配置 \n"
    scp ${ENV_EAM} ${host}:~/$website/erp/.env && \
    ssh $host "cd ${website}/erp && sed -i 's#APP_LOCAL=#APP_LOCAL=${website}#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#admin.fx.com#${website}-admin.fx.com#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#member.fx.com#${website}.fx.com#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#api.fx.com#${website}-api.fx.com#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#website.fx.com#${website}-website.fx.com#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#wap.fx.com#${website}-wap.fx.com#g' .env" && \

cat <<EOF
    域名信息：
       ${website}-admin.fx.com 
       ${website}.fx.com 
       ${website}-api.fx.com 
       ${website}-website.fx.com 
       ${website}-wap.fx.com 
EOF

# 查看redis db 使用情况及修改redis配置

    echo "\n 修改.env文件中的redis配置 \n"

cat <<EOF
redis-server地址：
       172.17.237.49 passwd=null port=6379
           
       172.17.237.48 passwd=null port=6379
EOF
    echo "\n 查看本地所有erp环境对redis db 的使用情况 \n" 
    ssh $host "find ./ -name '.env'|xargs grep 'REDIS'" && \
    read -p "please input redis-server ip: " redis_ip && \
    read -p "please input redis-server password: " redis_pw && \
    read -p "please input redis-server port: " redis_port && \
    read -p "please input redis-server REDIS_NO_0: " db1 && \
    read -p "please input redis-server REDIS_NO_1: " db2 && \
    read -p "please input redis-server REDIS_NO_2: " db3  && \
    ssh $host "cd ${website}/erp && sed -i 's#REDIS_HOST=#REDIS_HOST=${redis_ip}#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#REDIS_PASSWORD=#REDIS_PASSWORD=${redis_pw}#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#REDIS_PORT=#REDIS_PORT=${redis_port}#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#NO_0=#NO_0=${db1}#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#NO_1=#NO_1=${db2}#g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's#NO_2=#NO_2=${db3}#g' .env" && \

# 查看数据库列表及创建数据库，修改.env文件database配置
# 数据库列表
    echo  "\n 修改.env文件中数据库信息 \n"

cat <<EOF
数据库服务器地址:
          172.17.237.49
          172.17.237.48
EOF

# 选择数据库地址
    read -p "请选择一个数据库服务器地址: " DBCONN && \
    read -p "请选择一个数据库名做为所创建erp的数据库: " DBNAME && \
    read -p "请为此数据库创建一个数据库用户名: " DBUSER && \
    read -p "请为数据库用户${DBUSER}创建密码: " DBUSERPW && \
    echo  "\n 正在创建数据库........... \n"

    if [ ${DBCONN} = '172.17.237.48' ]
       then
          mysql -uroot -pwangweiQQ123 -h${DBCONN} -e "create database ${DBNAME};"
          mysql -uroot -pwangweiQQ123 -h${DBCONN} -e "grant all on ${DBNAME}.* to '${DBUSER}'@'%' identified by '${DBUSERPW}';flush privileges;"
    elif [ $DBCONN = '172.17.237.49']
       then
         echo "......................."
    fi

# 打印出创建的数据库信息
cat <<EOF
数据库创建完成：
数据库地址: ${DBCONN}
数据库名称: ${DBNAME}
数据库用户: ${DBUSER}
数据库密码: ${DBUSERPW}
EOF

# 修改.env文件数据库内容
    ssh $host "cd ${website}/erp && sed -i 's/DB_HOST=/DB_HOST=${DBCONN}/g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's/DB_USERNAME=/DB_USERNAME=${DBUSER}/g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's/DB_PASSWORD=/DB_PASSWORD=${DBUSERPW}/g' .env" && \
    ssh $host "cd ${website}/erp && sed -i 's/DB_DATABASE=/DB_DATABASE=${DBNAME}/g' .env"
}

#定义设置nginx配置文件
nginx_cnf(){
    vhost="/usr/local/nginx/conf/vhost"
    echo  "\n 配置nginx配置文件 \n"
    scp ${NGINX_EAM} root@${host}:${vhost}/${website}.fx.com.conf && \
    ssh root@${host} "cd ${nginx_vhost} && sed -i 's#admin.fx.com#${website}-admin.fx.com#g' ${vhost}/${website}.fx.com.conf" && \
    ssh root@${host} "cd ${nginx_vhost} && sed -i 's#member.fx.com#${website}.fx.com#g' ${vhost}/${website}.fx.com.conf" && \
    ssh root@${host} "cd ${nginx_vhost} && sed -i 's#api.fx.com#${website}-api.fx.com#g' ${vhost}/${website}.fx.com.conf" && \
    ssh root@${host} "cd ${nginx_vhost} && sed -i 's#website.fx.com#${website}-website.fx.com#g' ${vhost}/${website}.fx.com.conf" && \
    ssh root@${host} "cd ${nginx_vhost} && sed -i 's#wap.fx.com#${website}-wap.fx.com#g' ${vhost}/${website}.fx.com.conf"
    ssh root@${host} "/usr/local/nginx/sbin/nginx -t"

}

# erp环境配置 gulp composer 数据库初始化

erp_init(){
    echo  "\n erp环境配置 gulp composer 数据库初始化 \n"
    ssh $host "cd ${website}/erp && yarn add gulp" && \
    ssh $host "cd ${website}/erp && gulp" && \
    ssh $host "cd ${website}/erp && composer install" && \
    ssh $host "cd ${website}/erp && php artisan optimize" && \
    ssh $host "cd ${website}/erp && php artisan  migrate --force" && \
    ssh $host "cd ${website}/erp && php artisan  queue:restart" && \
    ssh $host "cd ${website}/erp && chmod 777 storage/ -R && chmod 777 bootstrap/cache/ -R"

}

main(){
    pull_code
    nginx_cnf
    erp_init
    echo "\n 新部署的${website}环境信息如下\n"
    echo "-----------------------------------------------------\n"
    ssh $host "cd ${website}/erp && grep 'URL' .env && grep 'DB_' .env|grep -v 'DB_WWW' && grep 'REDIS_' .env"
    echo "\n-----------------------------------------------------"
}
main
