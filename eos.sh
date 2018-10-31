#!/bin/sh


#while true
#do
#sleep 30

cmd_getinfo=`/eos-1.2.5/eos/build/programs/cleos/cleos --wallet-url http://127.0.0.1:6667 --url http://172.31.25.126:8001 get info | grep head_block_num`
proc_name="172.31.25.126:8001"                                                # 进程名或端口号  
file_name="/home/ubuntu/monitor-eos-proc/eos.log"                             # 日志文件  
pid=0  

file_getinfo="/home/ubuntu/monitor-eos-proc/eos_getinfo"	#存放getinfo指令的head_block_num数据
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

eos_get_info
read_get_info_file


proc_num()                                                      # 计算进程数  
{  
    num=`ps -ef | grep $proc_name | grep -v grep | wc -l`  
    return $num  
}  

proc_id()                                                       # 进程号  
{  
   pid=`ps -ef | grep $proc_name | grep -v grep | awk '{print $2}'`  
}  


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


proc_num
number=$?  
#echo number=$number
if [ $number -eq 0 ]                                           # 判断进程是否存在  
then   
    sh /home/ubuntu/monitor-eos-proc/start.sh    					       # 重启进程的命令，请相应修改  
    proc_id   
    echo start ${pid}, `date` >> $file_name                          # 将新进程号和重启时间记录  
fi 


#done

exit
