
示例2：捕获scp命令的提示 

#!/usr/bin/expect
#

set ip 192.168.122.121

spawn scp /etc/fstab $ip:/tmp

expect {
        "yes/no" { send "yes\r"; exp_continue }
        "password:" { send "uplooking\r" };
}

expect eof
