#!/bin/sh

proc_name="172.31.24.18:6001"                                                # 进程名或端口号

filename=/home/ubuntu/monitor-eos-proc/backuping

if [ -f $filename ]
then
echo $filename exist,备份中...
exit 0
fi

date=`date`
#date=`echo Tue Oct 9 18:13:22 UTC 2018`
echo $date
if [[ $date == Fri* ]]
then
	if [[ $date == *" 18:"* ]]
	then
		echo "周五凌晨2点开始备份..."
	else
		echo "不是周五凌晨2点,exit"
		exit 0
	fi
else
	echo "不是周五,exit"
	exit 0
fi

#创建开始备份标志，自动重启节点的eos.sh就不会再启动
touch $filename


while true
do

#杀掉进程
pid=`ps -ef | grep $proc_name | grep -v grep | awk '{print $2}'`  
sudo kill $pid
sleep 3

num=`ps -ef | grep $proc_name | grep -v grep | wc -l`
echo pidnum=$num

	if [ $num -eq 0 ]
	then
		tar -czvf "/eos-1.3.1/eos/tutorials/bios-boot-tutorial/nodes/00-producer1111/`date -I`.tar.gz" /eos-1.3.1/eos/tutorials/bios-boot-tutorial/nodes/00-producer1111/blocks /eos-1.3.1/eos/tutorials/bios-boot-tutorial/nodes/00-producer1111/state 
	
		rm $filename
		echo 成功删除$filename
		exit 0
	fi
done
