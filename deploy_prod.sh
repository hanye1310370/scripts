[root@localhost simple]# cat deploy_prod.sh 
#!/bin/bash
back_time=`date +"%Y-%m-%d-%H-%M-%S"`#备份的时间
all_ip=192.168.121.135
for_ip=`awk 'BEGIN{iplist="'$all_ip'";split(iplist,ip,",");for (s in ip) {print ip[s]}}'`  #awk数组转换
for dest_ip in ${for_ip[*]};do
    echo $dest_ip
done
src=/data/jenkins/workspace/simple/target#下面就是重启scp的过程
war_name="SimpleWeb-1.0.1-SNAPSHOT"
function stop_tomcat () {
    Tomcat_id=`ssh $dest_ip lsof -i:8080 | awk 'NR==2''{print $2}'`
if [ ! Tomcat_id  ];then
    echo "tomcat id 不存在"
else
    ssh $dest_ip "/bin/kill -9 $Tomcat_id"
fi
}
function start_tomcat () {
    ssh $dest_ip "cd /data/tomcat/bin && /bin/sh startup.sh"
}
if [ -f $src/${war_name}.war ];then
    stop_tomcat
    ssh $dest_ip "cd /data/tomcat/webapps && cp ${war_name}.war{,-${back_time}};cd /data/tomcat/webapps && /bin/rm -rf ${war_name}.war"
    ssh $dest_ip "cd /data/tomcat/webapps && /bin/rm -rf ${war_name}"
    scp $src/${war_name}.war $dest_ip:/data/tomcat/webapps
    start_tomcat 
fi