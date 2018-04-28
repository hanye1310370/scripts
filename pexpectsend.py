#!/usr/bin/python
# -*- coding: utf-8 -* 
import pexpect,sys
ip = "192.168.1.190"
user = "root"
passwd = "123456"
target_file ="/data/wwwlogs"
child = pexpect.spawn('/usr/bin/ssh',[user+'@'+ip])
fout = file('mylog.txt','w')
child.logfile = fout
try:
        child.expect('(?i)password')

        child.sendline(passwd)

        child.expect('#')

        child.sendline("tar -czf /data/adminlog.tar.gz"+target_file)

        child.expect('#')

        print child.before

        child.sendline('exit')

        fout.close()
except EOF:
    print "expect EOF" 
except TIMEOUT:
    print "expect TIMEOUT"
child = pexpect.spawn('/usr/bin/scp', [user+'@'+ip+':/data/adminlog.tar.gz','/home'])

fout = file('mylog.txt','a')

child.logfile = fout
try:
    child.expect('(?i)password')
    child.sendline(passwd)
    child.expect(pexpect.EOF)
except EOF:

    print "expect EOF"
except TIMEOUT:
    print "expect TIMEOUT"
