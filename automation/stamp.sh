#!/bin/bash 

function check() {
        RESULT=`curl 'https://burghquayregistrationoffice.inis.gov.ie/Website/AMSREG/AMSRegWeb.nsf/(getAppsNear)?readform&cat=All&sbcat=All&typ=Renewal&k=CFED070F3B4F7D82F65625D48C0730F1&p=8657A3F2408C1E27F8F54780BBF5768A&_=1578831158186' -H 'Connection: keep-alive' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: cors' -H 'Referer: https://burghquayregistrationoffice.inis.gov.ie/Website/AMSREG/AMSRegWeb.nsf/AppSelect?OpenForm' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-GB,en-IE;q=0.9,en-US;q=0.8,en;q=0.7,pt-BR;q=0.6,pt;q=0.5' -H 'Cookie: _ga=GA1.3.1228655857.1578830988; _gid=GA1.3.1680365956.1578830988; _hjid=35952cd5-5d94-4eee-8733-40862acba61a' --compressed -k -s`

        echo "$RESULT"

#        if [ "$RESULT" != '{"empty":"TRUE"}' ]; then
	if [ "$RESULT" != '{"empty":"TRUE"}' ]; then
		osascript -e 'display notification "something"'
        fi
}

while [ 1 ]; do check && sleep 60; done
