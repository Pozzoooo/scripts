#!/bin/bash 

function check() {
#curl 'https://burghquayregistrationoffice.inis.gov.ie/Website/AMSREG/AMSRegWeb.nsf/(getAppsNear)?readform&cat=All&sbcat=All&typ=Renewal&k=D7561514377684885CEE448F5D23036A&p=12C4A3F9B4288BF75250E88FF2890432&_=1578933242290' -H 'Connection: keep-alive' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: cors' -H 'Referer: https://burghquayregistrationoffice.inis.gov.ie/Website/AMSREG/AMSRegWeb.nsf/AppSelect?OpenForm' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-GB,en-IE;q=0.9,en-US;q=0.8,en;q=0.7,pt-BR;q=0.6,pt;q=0.5' -H 'Cookie: _ga=GA1.3.741549364.1575896712; _hjid=856f0a6a-4d8c-485d-b1e1-03ebc3fc7803; _gid=GA1.3.2035158849.1578922473; _gat=1' --compressed

	RESULT=`eval "$1 -k -s"`        
	echo "$RESULT"

	if [ "$RESULT" != '{"empty":"TRUE"}' ] && [ "$RESULT" != '{"slots":["empty"]}' ]; then
		osascript -e 'display notification "something"'
        fi
}

while [ 1 ]; do check "$1" && sleep 30; done

