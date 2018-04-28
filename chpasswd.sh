#!/bin/bash
. /etc/init.d/functions
user="xiaoting"
passfile="/data/user.log"
for num in `seq -w 11 20`
do 
pass="`echo "test$RANDOM"|md5sum|cut -c3-11`"
useradd $user$num &>/dev/null &&\
#echo "$pass"|passwd --stdin $user$num &>/dev/null &&\
echo -e "$user${num}:$pass">>$passfile
if [ $? -eq 0 ]
then
action "$user$num is OK" /bin/true
else
action "$user$num is fail" /bin/false
fi
done 
echo ~~~~~~~~~~~~~~~~
#cat $passfile &&  >$passfile
chpasswd < $passfile
cat $passfile &&  >$passfile

