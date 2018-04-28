./databackuper.sh /DATA/WEAVER /DATA/WEAVER_BACKUP

#!/bin/bash   
SOURCE=$1    
TARGET=$2    
CPEXEC=$(which cp)    
MKDIREXEC=$(which mkdir)    
CURDATE=$(date +%Y-%m-%d)    
BAKDIRTMP=${SOURCE%*/}    
BAKDIRNAME=${BAKDIRTMP##*/}$CURDATE    
BASEDIR=${BAKDIRTMP%/*}
 
if [ ! -d "$SOURCE" ]; then       
    echo "$(date +%Y-%m-%d_%H:%M:%S) - The source $SOURCE is not existed you specified" >>/var/log/${BAKDIRTMP##*/}.log        
    exit 2    
    fi
     
if [ ! -d "$TARGET" ]; then       
    echo "$(date +%Y-%m-%d_%H:%M:%S) - The target $TARGET is not existed you spec    
    ified" >>/var/log/${BAKDIRTMP##*/}.log        
    exit 22    
    fi
# $MKDIREXEC -p $TARGET/$BAKDIR   
# $CPEXEC -rf $SOURCE/* $TARGET/$BAKDIR/
 
cd $TARGET && tar zcf ${BAKDIRNAME}.tar.gz -C $BASEDIR ${BAKDIRTMP##*/}
 
if [ "$?" -ne 0 ]; then
      echo "$(date +%Y-%m-%d_%H:%M:%S) - Backup directory: $SOURCE to $TARGET/${BAKDIRNAME}.tar.gz is failed" >>/var/log/${BAKDIRTMP##*/}.log    
      else       
      echo "$(date +%Y-%m-%d_%H:%M:%S) - Backup directory: $SOURCE to $TARGET/${BAKDIRNAME}.tar.gz is successful" >>/var/log/${BAKDIRTMP##*/}.log    
fi    
exit 0



#!/bin/bash  
#指定源和目标 
SOURCE=/DATA/WEAVER    
TARGET=/DATA/WEAVER_BACKUP
CPEXEC=$(which cp)   
MKDIREXEC=$(which mkdir)    
CURDATE=$(date +%Y-%m-%d)    
BAKDIRTMP=${SOURCE%*/}    
BAKDIRNAME=${BAKDIRTMP##*/}$CURDATE    
BASEDIR=${BAKDIRTMP%/*}
if [ ! -d "$SOURCE" ]; then       
echo "$(date +%Y-%m-%d_%H:%M:%S) - The source $SOURCE is not existed you specified" >>/var/log/${BAKDIRTMP##*/}.log        
exit 2    
    fi
if [ ! -d "$TARGET" ]; then       
echo "$(date +%Y-%m-%d_%H:%M:%S) - The target $TARGET is not existed you spec    ified" >>/var/log/${BAKDIRTMP##*/}.log        
exit 22    
fi
# $MKDIREXEC -p $TARGET/$BAKDIR   
# $CPEXEC -rf $SOURCE/* $TARGET/$BAKDIR/
cd $TARGET && tar zcf ${BAKDIRNAME}.tar.gz -C $BASEDIR ${BAKDIRTMP##*/}
if [ "$?" -ne 0 ]; then      
echo "$(date +%Y-%m-%d_%H:%M:%S) - Backup directory: $SOURCE to $TARGET/${BAKDIRNAME}.tar.gz is failed" >>/var/log/${BAKDIRTMP##*/}.log    
    else       
echo "$(date +%Y-%m-%d_%H:%M:%S) - Backup directory: $SOURCE to $TARGET/${BAKDIRNAME}.tar.gz is successful" >>/var/log/${BAKDIRTMP##*/}.log    
fi    
exit 0