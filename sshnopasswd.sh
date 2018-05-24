expect实现ssh无密钥登陆
说明：用了两个脚本，一个bash脚本(send_key.sh)，在其中调用另外一个expect脚本(scp_key_to_node.exp)，两个脚本放在同一个目录下：
（1）bash脚本：send_key.sh

[plain] view plaincopyprint?在CODE上查看代码片派生到我的代码片
 
#!/bin/bash    
ssh-keygen -t dsa    
for (( i = 1; i <= 100 ; i ++ ))    
do    
  ./scp_key_to_node.exp $i    
done    
 
（2）expect脚本：(scp_key_to_node.exp)

[plain] view plaincopyprint?在CODE上查看代码片派生到我的代码片
 
#!/usr/bin/expect    
set timeout 5    
set hostno [lindex $argv 0]    
spawn scp ~/.ssh/id_dsa.pub impala$hostno:~/.ssh/pub_key    
expect "*password*"    
send "111111\r"    
spawn ssh impala$hostno "cat ~/.ssh/pub_key/ >> ~/.ssh/authorized_keys"    
expect "*password*"    
send "111111\r"    
spawn ssh impala$hostno "chmod 600 ~/.ssh/authorized_keys"    
expect "*password*"    
send "111111\r"    
expect eof    
（3）分析：
set可以设置超时，或者设置一个变量的值
spawn是执行一个命令
expect等待一个匹配的输出流中的内容
send是匹配到之后向输入流写入的内容
[lindex $argv 0]表示脚本的第0个参数
expect eof表示读取到文件结束符
（4）脚本执行方式：
在脚本所在的目录下执行：
# ./send_key.sh 

 
