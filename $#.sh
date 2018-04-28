[ $# -ne 2 ] && {
echo "must be two args."
exit 119      终止程序运行，并以指定的119状态值退出程序，赋值给当前Shell的"$?"变量
}
echo oldgirl


#sh test.sh
must be two args
#echo $?
119

#sh test.sh a1 a2
oldgirl
##echo $?
0