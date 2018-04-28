#!/usr/bin/python
import pexpect
import sys
child = pexpect.spawn('ssh root@192.168.1.45')
fout = file('mylog.txt','w')
child.logfile = fout
#child.logfile = sys.stdout
child.expect("password:")
child.sendlne("1qaz2wsx")
child.expect('#')
child.sendline('ls /home')
child.expect('#')
