#!/bin/bash
##############################################
#Author: hanye
#Email:  hz7726@163.com
#Last modified: 2018/01/30/16:21
#Filename: jenkins_wofang.sh
#Revision:  0.1
#Description: 
#crontab: * * * * * jenkins_wofang.sh
#Website:   www.1fangxin.net
#License: GPL
#curl -s -u "user:passwd" -X GET   http://j.com/job/%E6%88%91%E6%88%BF%E6%AD%A3%E5%BC%8F%E7%8E%AF%E5%A2%83/build?token=wofang123456online
./jindutiao.sh
curl -s -u "user:passwd"  -X GET   http://j.com/job/%E6%88%91%E6%88%BF%E6%AD%A3%E5%BC%8F%E7%8E%AF%E5%A2%83/lastBuild/consoleText
