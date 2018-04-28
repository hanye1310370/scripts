#!/usr/bin/env python
# -*- coding: utf-8 -*-
import json
import sys
import os
pa=os.path.abspath(__file__) #取文件的名
print(os.path.dirname(pa)) #取文件的上级目录的绝对路径
PATH=os.path.dirname(os.path.dirname(pa))  #取文件上级目录的上级目录绝对路径
sys.path.append(PATH)
with open('/home/erp/JSON_text','r') as f:
# dic=json.loads(f.read())
# print(dic)
# print(type(dic))
    data = json.load(f)
    # print(data)
    txt=''
    for i in data:
        # print(i)
        if i == 'host':
            txt=txt+("%s=%s\n" %('host',data[i]))
        elif i == 'website':
            txt = txt + ("%s=%s\n" % ('website', data[i]))
        elif i == 'redis_ip':
            txt = txt + ("%s=%s\n" % ('redis_ip', data[i]))
        elif i == 'redis_pw':
            txt = txt + ("%s=%s\n" % ('redis_pw', data[i]))
        elif i == 'redis_port':
            txt = txt + ("%s=%s\n" % ('redis_port', data[i]))
        elif i == 'db1':
            txt = txt + ("%s=%s\n" % ('db1', data[i]))
        elif i == 'db2':
            txt = txt + ("%s=%s\n" % ('db2', data[i]))
        elif i == 'db3':
            txt = txt + ("%s=%s\n" % ('db3', data[i]))
        elif i == 'DBCONN':
            txt = txt + ("%s=%s\n" % ('DBCONN', data[i]))
        elif i == 'DBNAME':
            txt = txt + ("%s=%s\n" % ('DBNAME', data[i]))
        elif i == 'DBUSER':
            txt = txt + ("%s=%s\n" % ('DBUSER', data[i]))
        elif i == 'DBUSERPW':
            txt = txt + ("%s=%s\n" % ('DBUSERPW', data[i]))


with open('/home/erp/name.txt','w') as f2:
    f2.write(txt)
