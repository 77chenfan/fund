#/bin/bash

#codelist=(020026 020019)
codelist=(420003)

function getTime(){
timestamp=$[$(date +%s%N)/1000000]
echo $timestamp
return $timestamp
}

function getOnePageData(){
	code=$1
	page=$2
	timestamp=getTime
	curl 'http://api.fund.eastmoney.com/f10/lsjz?callback=jQuery18302776763650864096_1526797751265&fundCode='$code'&pageIndex='$page'&pageSize=50&startDate=&endDate=&_='${timestamp} -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: zh-CN,zh;q=0.9' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36' -H 'Accept: */*' -H 'Referer: http://fund.eastmoney.com/f10/jjjz_020026.html' -H 'Cookie: st_pvi=84040595467984; emstat_bc_emcount=30022193361696989921; HAList=a-sz-000903-%u4E91%u5185%u52A8%u529B%2Ca-sz-000065-%u5317%u65B9%u56FD%u9645%2Ca-sz-300059-%u4E1C%u65B9%u8D22%u5BCC; em_hq_fls=old; emstat_ss_emcount=2_1501102466_1592229248; qgqp_b_id=817bcdb145e237ef20ab3f2fb349a431; st_si=91282328582978; EMFUND0=null; EMFUND1=null; EMFUND2=null; EMFUND3=null; EMFUND4=null; EMFUND5=null; EMFUND6=null; EMFUND7=null; EMFUND8=null; EMFUND9=05-20 14:27:55@#$%u56FD%u6CF0%u6210%u957F%u4F18%u9009%u6DF7%u5408@%23%24020026' -H 'Proxy-Connection: keep-alive' --compressed  > ${code}-${page}-data.json

}

function formatJsonFile(){
	code=$1
	files=`ls ${code}*.json`
	f=`echo $files|cut -d " " -f 1`
	echo $f
	rep1=`grep -i "^.*(" $f -o`
	rep2=")"
	echo $rep1
	echo ${code}*.json
	sed -i 's/'${rep1}'//g' ${code}*.json
	sed -i "s/)//g" ${code}*.json
	chmod  777 *.json
}

function start(){

	for code in ${codelist[*]};do
		echo "start to get" $code "data"
		for (( i=1; i<12; i++ ));
		do
			getOnePageData $code $i
			sleep 1
		done
		formatJsonFile $code
	done
	
}
