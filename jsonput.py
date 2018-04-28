#!/usr/bin/env python
# -*- coding: utf-8 -*-
# import json
#
# dic={'name':'alex','age':'18'}
# data=json.dumps(dic)
# print(type(data))
# f=open('JSON_text','w')
# f.write(data)

# -------------------------------------------

import json

dic={'host':'172.17.237.48',
     'website':'kk',
     'redis_ip':'172.17.237.48',
     'redis_pw':'123456',
     'redis_port':'6379',
     'db1':'1',
     'db2':'2',
     'db3':'3',
     'DBCONN':'172.17.237.48',
     'DBNAME':'kk',
     'DBUSER':'kk',
     'DBUSERPW':'123456'
}
f=open('JSON_text','w')
# data=json.dumps(dic)
# f.write(data)
json.dump(dic,f)
f.close()
