root@yjb:~# ll stu_102999_*
-rw-r--r-- 1 root root 0 11月  7 16:45 stu_102999_1_finished.jpg
-rw-r--r-- 1 root root 0 11月  7 16:45 stu_102999_2_finished.jpg
-rw-r--r-- 1 root root 0 11月  7 16:45 stu_102999_3_finished.jpg

root@yjb:~# cat mv.sh 
#!/bin/bash
for f in `ls /root/*fin*.jpg`
do 
mv $f `echo ${f//_finished/}`
done

#sh mv.sh
root@yjb:~# ll stu_102999_*
-rw-r--r-- 1 root root 0 11月  7 16:45 stu_102999_1.jpg
-rw-r--r-- 1 root root 0 11月  7 16:45 stu_102999_2.jpg
-rw-r--r-- 1 root root 0 11月  7 16:45 stu_102999_3.jpg
