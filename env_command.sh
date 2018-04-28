root@huabei-slave:/home/erp/deploy_shell# cat env_command.sh 
#!/bin/bash
#DIR=$(find /home/erp/ -name ".env"|sed 's/.env//g')
DIR=$(find /home/erp/ -name ".env" -exec dirname {} \;)
CMD=$1
for i in $DIR
  do
     echo '-----------------------------------------------------------------'
     echo $i && \
     cd $i && \
     eval $CMD
     if [ $? -ne 0 ]
       then
          exit 33
     fi
done
