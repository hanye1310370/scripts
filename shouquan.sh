#!/bin/bash
find /home/erp  -name storage -type d |xargs chmod -R 777
#find . -name storage -type d  -exec chmod -R 777 {} \;
find /home/erp  -name cache -type d|grep bootstrap |xargs chmod -R 777
