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
ENV_LIST='jinse miyun qianshi lianzhong qianheng hsbl all shengshihengxin'

JINSE(){
           echo -e "\033[31m 北京金色环境 \033[0m"
           /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/jinse/jinse/ && git pull origin master"
           if [ $? -eq 0 ]; then   
             /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/jinse/jinse/ && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/jinse/jinse/ && /home/erp/beijing/jinse/jinse/node_modules/.bin/gulp"
             /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/jinse/jinse/ && /home/erp/beijing/jinse/jinse/node_modules/.bin/gulp"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/jinse/jinse/ && /usr/local/php/bin/php artisan migrate --force"
               if [ $? -eq 0 ]; then 
                  echo -e "\033[31m 金色环境代码拉取成功、033[0m"
                  /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/jinse/jinse/ && /usr/local/php/bin/php artisan queue:restart"
               else
                 echo -e "\033[31m 北京 金色 环境数据迁移失败,请查看 \033[0m"
                 exit 1
               fi
           else
               echo -e "\033[31m 北京 金色 环境程序拉取失败,请查看 \033[0m"
               exit 2
           fi
}

MIYUN(){
           echo -e "\033[31m 北京 密云 环境 \033[0m"
           /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/jinse/miyun/ && git pull origin master"
           if [ $? -eq 0 ]; then
             /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/jinse/miyun/ && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/jinse/miyun/ && /home/erp/beijing/jinse/miyun/node_modules/.bin/gulp"
             /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/jinse/miyun/ && /home/erp/beijing/jinse/miyun/node_modules/.bin/gulp"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/jinse/miyun/ && /usr/local/php/bin/php artisan migrate --force"
             if [ $? -eq 0 ]; then
                   /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/jinse/miyun/ && /usr/local/php/bin/php artisan queue:restart"
             else
                 echo -e "\033[31m 北京 密云 环境数据迁移失败,请查看 \033[0m"
                 exit 1
               fi

           else
                  echo -e "\033[31m 北京 密云 环境程序拉取失败,请查看 \033[0m"              
                    exit 2
           fi

}

QIANSHI(){
            echo -e "\033[31m 北京 千士 环境 \033[0m"
           /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/qianshi/ && git pull origin master"
           if [ $? -eq 0 ]; then
             /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/qianshi/ && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/qianshi/ && /home/erp/beijing/qianshi/node_modules/.bin/gulp"
             /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/qianshi/ && /home/erp/beijing/qianshi/node_modules/.bin/gulp"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/qianshi/ && /usr/local/php/bin/php artisan migrate --force"
              if [ $? -eq 0 ]; then 
                   /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/qianshi/ && /usr/local/php/bin/php artisan queue:restart"
              else
                 echo -e "\033[31m 北京 千士 环境数据迁移失败,请查看 \033[0m"
                 exit 1
               fi

           else
                   echo -e "\033[31m 北京 千士 环境程序拉取失败,请查看 \033[0m"
                    exit 2
           fi
}


LIANZHONG(){
              echo -e "\033[31m 北京 联众 环境 \033[0m"
           /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/lianzhong && git pull origin master"
           if [ $? -eq 0 ]; then
             /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/lianzhong && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/lianzhong && /home/erp/beijing/lianzhong/node_modules/.bin/gulp"
             /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/lianzhong && /home/erp/beijing/lianzhong/node_modules/.bin/gulp"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/lianzhong && /usr/local/php/bin/php artisan migrate --force"
               if [ $? -eq 0 ]; then
                   /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/lianzhong && /usr/local/php/bin/php artisan queue:restart"
               else
                   echo -e "\033[31m 北京 联众 环境数据迁移失败,请查看 \033[0m"
                   exit 1
               fi

           else
                 echo -e "\033[31m 北京 联众 环境程序拉取失败,请查看 \033[0m"
                 exit 3
           fi
}
HSBL(){
           echo -e "\033[31m 北京 华盛百利 环境 \033[0m"
           /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/hsbl && git pull origin master"
           if [ $? -eq 0 ]; then
             /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/hsbl && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/hsbl && /home/erp/beijing/hsbl/node_modules/.bin/gulp"
             /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/hsbl && /home/erp/beijing/hsbl/node_modules/.bin/gulp"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/hsbl && /usr/local/php/bin/php artisan migrate --force"
               if [ $? -eq 0 ]; then
                      /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/hsbl && /usr/local/php/bin/php artisan queue:restart"
               else
                 echo -e "\033[31m 北京 华盛百利 环境数据迁移失败,请查看 \033[0m"
                 exit 1
               fi

           else
                  echo -e "\033[31m 北京 华盛百利 环境程序拉取失败,请查看 \033[0m"
                  exit 4
           fi
}

QIANHENG(){
           echo -e "\033[31m 北京 乾恒  环境 \033[0m"
           /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/qianheng && git pull origin master"
           if [ $? -eq 0 ]; then
             /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/qianheng && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/qianheng && /home/erp/beijing/qianheng/node_modules/.bin/gulp"
             /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/qianheng && /home/erp/beijing/qianheng/node_modules/.bin/gulp"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/qianheng && /usr/local/php/bin/php artisan migrate --force"
                  if [ $? -eq 0 ]; then
           		/usr/bin/ansible 142server -m shell -a "cd $Data/beijing/qianheng && /usr/local/php/bin/php artisan queue:restart"
                   else
                    echo -e "\033[31m 北京 乾恒  环境数据迁移失败,请查看 \033[0m"
                    exit 1
               fi

           else
                   echo -e "\033[31m 北京 乾恒  环境程序拉取失败,请查看 \033[0m"
                   exit 4
           fi
}
shengshihengxin(){
           echo -e "\033[31m 北京 乾恒  环境 \033[0m"
           /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/shengshihengxin && git pull origin master"
           if [ $? -eq 0 ]; then
             /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/shengshihengxin && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/shengshihengxin && /home/erp/beijing/shengshihengxin/node_modules/.bin/gulp"
             /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/shengshihengxin && /home/erp/beijing/shengshihengxin/node_modules/.bin/gulp"
             /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/shengshihengxin && /usr/local/php/bin/php artisan migrate --force"
                  if [ $? -eq 0 ]; then
                        /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/shengshihengxin && /usr/local/php/bin/php artisan queue:restart"
                   else
                    echo -e "\033[31m 北京 盛世恒新  环境数据迁移失败,请查看 \033[0m"
                    exit 1
               fi

           else
                   echo -e "\033[31m 北京 盛世恒新  环境程序拉取失败,请查看 \033[0m"
                   exit 4
           fi
}


SSTZ(){
       echo -e "\033[31m 北京 shengshitianzhu  环境 \033[0m"
       /usr/bin/ansible erp       -m shell -a "cd /home/erp/beijing/shengshitianzhu && git pull origin master"
       if [ $? -eq 0 ]; then
         /usr/bin/ansible erp       -m shell -a "cd $Data/beijing/shengshitianzhu && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
         /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/shengshitianzhu && /home/erp/beijing/shengshitianzhu/node_modules/.bin/gulp"
         /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/shengshitianzhu && /home/erp/beijing/shengshitianzhu/node_modules/.bin/gulp"
         /usr/bin/ansible 114server -m shell -a "cd $Data/beijing/shengshitianzhu && /usr/local/php/bin/php artisan migrate --force"
           if [ $? -eq 0 ]; then 
                /usr/bin/ansible 142server -m shell -a "cd $Data/beijing/shengshitianzhu && /usr/local/php/bin/php artisan queue:restart"
           else
                echo -e "\033[31m 北京 shengshitianzhu  环境数据迁移失败,请查看 \033[0m"
                exit 1
           fi
       else
                exit 4
       fi
}
fangshan(){
       echo -e "\033[31m 北京 家和家润地产  环境 \033[0m"
       /usr/bin/ansible huebei02    -m shell -a "cd $Data/beijing/fangshan && git pull origin master"
       if [ $? -eq 0 ]; then
         /usr/bin/ansible huebei02  -m shell -a "cd $Data/beijing/fangshan && export PATH=/usr/local/php/bin:$PATH && /usr/local/bin/composer install"
         /usr/bin/ansible huabei02master -m shell -a "cd $Data/beijing/fangshan && $Data/beijing/fangshan/node_modules/.bin/gulp"
         /usr/bin/ansible huabei02slave  -m shell -a "cd $Data/beijing/fangshan && $Data/beijing/fangshan/node_modules/.bin/gulp"
         /usr/bin/ansible huabei02master -m shell -a "cd $Data/beijing/fangshan && /usr/local/php/bin/php artisan migrate --force"
           if [ $? -eq 0 ]; then
                /usr/bin/ansible huabei02master -m shell -a "cd $Data/beijing/fangshan && /usr/local/php/bin/php artisan queue:restart"
           else
                echo -e "\033[31m 北京 家和家润地产  环境数据迁移失败,请查看 \033[0m"
                exit 1
           fi
       else
                echo -e "\033[31m 北京 家和家润地产  程序拉取失败,请查看 \033[0m"
                exit 4
       fi
}



case $1 in
       fangshan)
              fangshan
       ;;
       jinse)   
           JINSE
       ;;
       miyun)
           MIYUN
       ;;
       qianshi)
           QIANSHI
       ;;
       lianzhong)
           LIANZHONG    
	   ;;
       hsbl)
           HSBL
       ;;
       shengshihengxin)
         shengshihengxin
        ;;
       qianheng)
           QIANHENG
       ;;
       shengshitianzhu)
           SSTZ
       ;;
       bjall)
           JINSE
           MIYUN
           QIANSHI
           QIANHENG
           LIANZHONG
           HSBL
           SSTZ
           shengshihengxin
           fangshan
        ;;
       *)
           echo "USAGE: $0 (jinse|miyun|qianshi|lianzhong|hsbl|qianheng|shengshitianzhu|bjall)"
esac
