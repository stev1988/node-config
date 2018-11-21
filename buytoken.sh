
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


buytoken()
{
	balance=`/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 get currency balance eosio.token sujianzhong1 EOS`
        balance=${balance%%.*}

        marketbalance=`/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 get currency balance eosio.token etbexchange1 EOS`

        marketbalance=${marketbalance%%.*}

        balance=$(random 0 $balance)
        echo balance=$balance,marketbalance=$marketbalance

        if [ $balance -gt $marketbalance ]; then
        balance=$marketbalance
        fi

        amount=`echo "scale=4;$balance/10" | bc`
        if [[ $amount == .* ]]; then
                amount=0$amount
        fi


        echo buytoken $amount EOS `date`

/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 push action etbexchanger buytoken '["sujianzhong1", "'$amount' EOS", "issuemytoken","4,TEST", "sujianzhong1", "1"]' -p sujianzhong1

}

selltoken()
{
	balance=`/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 get currency balance issuemytoken sujianzhong1 TEST`
	balance=${balance%%.*}

	marketbalance=`/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 get currency balance issuemytoken etbexchange1 TEST`

        marketbalance=${marketbalance%%.*}

	balance=$(random 0 $balance)
	echo balance=$balance,marketbalance=$marketbalance

        if [ $balance -gt $marketbalance ]; then
        balance=$marketbalance
        fi

	amount=`echo "scale=4;$balance/100" | bc`
        if [[ $amount == .* ]]; then
		amount=0$amount
	fi

        echo selltoken $amount TEST `date`

	/eos-1.1.0/eos/build/programs/cleos/cleos  --wallet-url http://127.0.0.1:8900 --url http://47.52.250.41:8001 push action etbexchanger selltoken '["sujianzhong1", "issuemytoken","'$amount' TEST", "sujianzhong1", "0" ]' -p sujianzhong1
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

