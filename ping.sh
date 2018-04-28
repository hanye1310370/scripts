#!/bin/bash
#Author:丁丁历险(Jacob)
#定义for循环变量i，执行循环次数为254次，i从1循环到254
#每次循环对某一台目标主机测试ping的连通性，ping命令的语法格式参考前面的while版本
for  i in  {1..251}
do
          ping -c2 -i0.3 -W1 192.168.1.$i  &>/dev/null
         if [ $? –eq 0 ];then
               echo "192.168.1.$i is up"
         else
               echo  "192.168.1.$i is down"
         fi
done
