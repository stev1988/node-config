
/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 wallet unlock --password=PW5KVA8cCnugpNHCPUHch6x3796cmJqYXdxw7oPW8vGTfp6hzZVrW

function random()
{
    min=$1;
    max=$2-$1;
    num=$(date +%s+%N);
    ((retnum=num%max+min));
    #进行求余数运算即可
    echo $retnum;
    #这里通过echo 打印出来值，然后获得函数的，stdout就可以获得值
    #还有一种返回，定义全价变量，然后函数改下内容，外面读取
}

#账户数组
arr=("sujianzhong1" "sjjsjjsjjsjj" "marcol521313" "etokengogogo" "eosbille1234" "billhan12345" "alisa1111111" "mnbkhfjlhgch" "xyg555555555" "liuchen12345"  "supervilommz" "elina1234543" "elina1234543")

#获取一个随机账户
#rand=$(( $RANDOM % ${#arr[*]} ))
#account=${arr[$rand]}
#echo account=$account

buytoken()
{
rand=$(( $RANDOM % ${#arr[*]} ))
account=${arr[$rand]}
echo account=$account

	balance=`/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 get currency balance eosio.token $account EOS`
	balance=${balance%%.*}

        marketbalance=`/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 get currency balance eosio.token etbexchange2 EOS`

        marketbalance=${marketbalance%%.*}

#        balance=$(random 0 $balance)
        echo balance=$balance,marketbalance=$marketbalance

        if [ $balance -gt $marketbalance ]; then
        balance=$marketbalance
        fi

        amount=`echo "scale=4;$balance/10" | bc`
        if [[ $amount == .* ]]; then
                amount=0$amount
        fi


        echo buytoken $amount EOS `date`

/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 push action etbexchanger buytoken '["'$account'", "'$amount' EOS", "octtothemoon","4,OCT", "'$account'", "0"]' -p $account

}

selltoken()
{
rand=$(( $RANDOM % ${#arr[*]} ))
account=${arr[$rand]}
echo account=$account


	balance=`/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 get currency balance octtothemoon $account OCT`
	balance=${balance%%.*}

	marketbalance=`/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 get currency balance octtothemoon etbexchange2 OCT`

        marketbalance=${marketbalance%%.*}

	balance=$(random 0 $balance)
	echo balance=$balance,marketbalance=$marketbalance

        if [ $balance -gt $marketbalance ]; then
        balance=$marketbalance
        fi

	amount=`echo "scale=4;$balance/2" | bc`
        if [[ $amount == .* ]]; then
		amount=0$amount
	fi

        echo selltoken $amount OCT `date`

	/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 push action etbexchanger selltoken '["'$account'", "octtothemoon","'$amount' OCT", "'sujianzhong1'", "0" ]' -p $account
}

ram=$(random 0 2)
echo ram=$ram
if [ $ram == 1 ]; then
buytoken
else
selltoken
fi

sleep 30 

ram=$(random 0 2)
echo ram=$ram
if [ $ram == 1 ]; then
buytoken
else
selltoken
fi

