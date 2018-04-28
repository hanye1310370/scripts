#!/usr/bin/env python
# -*- coding: utf-8 -*-
import json
import os
import sys
reload(sys)
sys.setdefaultencoding('utf8')
def bakSrv(NameId="",GameName="",zoneId=""):
    localIP='192.168.100.168'
    tag = 'hunfu,ios'
    url = ['http://10.247.12.92/zhmjServer/']
    GameSrv = {}
    with open("game.json") as game_info:
        old_games = json.load(game_info,encoding="utf-8")
        GameSrv["localIP"] = u"%s" % localIP
        GameSrv["tag"] = u"%s" % tag
        GameSrv["url"] = url
        GameSrv["phyId"] = 1
        GameSrv["nameId"] = str(NameId)
        GameSrv["chName"] = u"%s" % GameName
        GameSrv["isPublic"] = False
        GameSrv["zoneId"] = int(zoneId)
        GameSrv["loadStatus"] = 0
        old_games.append(GameSrv)
        repr(old_games)

    f = open("game.json",'w+')       #创建写入文件对象
    json.dump(old_games, f,ensure_ascii=False,indent=4,separators=(',',': ')) 
    f.close()
    print("***************生成新的JSON配置文件成功!****************************")

bakSrv(NameId="10003",GameName="新测试服",zoneId=4)
