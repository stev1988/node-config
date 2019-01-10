#!/bin/sh

#*/1 * * * *  /bin/bash /root/monitor-eos-proc/eos.sh >>/root/monitor-eos-proc/eos.log
filename=~/monitor-eos-proc/backuping
if [ -f $filename ]
then
echo $filename exist,备份中...
exit 0
fi


#while true
#do
#sleep 30

cmd_getinfo=`/eos/eos/build/programs/cleos/cleos --wallet-url http://127.0.0.1:6667 --url http://172.18.85.228:8001 get info | grep head_block_num`
#获取阿里云节点的块号
cmd_getinfo2=`/eos/eos/build/programs/cleos/cleos --wallet-url http://127.0.0.1:6667 --url http://47.52.250.41:8001 get info | grep head_block_num`
proc_name="172.18.85.228:8001"                                                # 进程名或端口号  
file_name="/root/monitor-eos-proc/eos.log"                             # 日志文件  
pid=0  

file_getinfo="/root/monitor-eos-proc/eos_getinfo"	#存放getinfo指令的head_block_num数据

info1=""
info2=""

eos_get_info()
{
	info1=`echo $cmd_getinfo`
}
read_get_info_file()
{
	info2=`cat $file_getinfo`
}

eos_get_info2()
{
	info3=`echo $cmd_getinfo2`
}



eos_get_info
read_get_info_file
eos_get_info2


proc_num()                                                      # 计算进程数  
{  
    num=`ps -ef | grep $proc_name | grep -v grep | wc -l`  
    return $num  
}  

proc_id()                                                       # 进程号  
{  
   pid=`ps -ef | grep $proc_name | grep -v grep | awk '{print $2}'`  
}  


echo info1=$info1, info3=$info3
#info1="head_block_num": 26294224,
#当前节点的实时块高度
blocknum1=`echo ${info1:18}`
blocknum1=`echo ${blocknum1%,*}`
#echo block1=$blocknum1

if [ "$blocknum1" == "" ]
then
blocknum1=0
fi


#当前节点上一分钟的块高度
blocknum2=`echo ${info2:18}`
blocknum2=`echo ${blocknum2%,*}`
#echo block2=$blocknum2

#当前节点阿里云节点的块高度
blocknum3=`echo ${info3:18}`
blocknum3=`echo ${blocknum3%,*}`
#echo block3=$blocknum3

#当前节点和阿里云节点的块高度差
num=$(($blocknum3-$blocknum1))
#echo res=$num

#当前节点与上一分钟的高度差
num2=$(($blocknum1-$blocknum2))
#echo num2=$num2

#假如已经慢了100个块以上
if [ "$num" -gt 100 ]
then
	echo 落后$num个块,本分钟同步了$num2个块 >> $file_name
	if [ "$num2" -lt 60 ]
	then
	
	proc_id
	`sudo kill $pid`
	echo 同步太慢,一分钟只同步了$num2个块,重启,kill ${pid}, `date` >> $file_name                          # 将新进程号和重启时间记录 
	sleep 5

	else
	echo runing info1:$info1,  info2:$info2, `date` >> $file_name
	rm -rf $file_getinfo
	echo $info1 >> $file_getinfo
	fi
else
echo runing info1:$info1,  info2:$info2, `date` >> $file_name
rm -rf $file_getinfo
echo $info1 >> $file_getinfo
fi


proc_num
number=$?  
echo proc number=$number
if [ $number -eq 0 ]                                           # 判断进程是否存在  
then  
    echo "启动命令" 
    sh /root/monitor-eos-proc/start.sh>> $file_name    					       # 重启进程的命令，请相应修改  
    proc_id   
    echo start ${pid}, `date` >> $file_name                          # 将新进程号和重启时间记录  
fi 


#done

exit



if [ "$info1" == "$info2" ]
then
	proc_id
	
	`sudo kill $pid`
	echo kill ${pid}, `date` >> $file_name                          # 将新进程号和重启时间记录 
	sleep 5

else
echo runing info1:$info1,  info2:$info2, `date` >> $file_name
rm -rf $file_getinfo
echo $info1 >> $file_getinfo
fi



