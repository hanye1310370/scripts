#!/usr/bin/expect
#set timeout 20 #设置超时时间
spawn ssh root@192.168.1.45
expect {
	"yes/no" { send "yes\r"; exp_continue }
	"password:" { send "1qaz2wsx\r" };
}
interact






#!/usr/bin/expect
#set timeout 20 #设置超时时间
spawn ssh root@192.168.43.131
expect "*password:"
send "123\r"
# expect "*#"
interact
解释：

1.#!/usr/bin/expect ：需要先安装软件，然后来说明用expect来执行
# yum install -y expect 

2.spawn ssh root@192.168.43.131 ：spawn是进入expect环境后才可以执行的expect内部命令，用来执行它后面的命令。

3.expect "*password:" ：也是expect的内部命令，用来解惑关键的字符串，如果有，就会立即返回下面设置的内容，如果没有就看是否设置了超时时间。

4.send "123\r"：这时执行交互式动作，与手工输入密码等效，在expect截获关键字之后，它就会输入send后面的内容。

5.interact ：执行完毕后把持交互状态，把控制台，这时候就可以进行你想要进行的操作了。如果没有这一句，在登陆完成之后就会退出，而不是留在远程终端上。

今天突然想起了expect，所以就重新看了一下，希望对你有帮助。
