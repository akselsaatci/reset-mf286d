#!/bin/bash#!/bin/bash

hex_md5() {
    echo -n "$1" | openssl md5 -binary | xxd -p
}



response_headers=$(curl -X POST \
  http://192.168.1.1/goform/goform_set_cmd_process \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Accept-Language: en-US,en;q=0.9,tr-TR;q=0.8,tr;q=0.7' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'Cookie: zwsd="9ad6aaed513b73148b7d49f70afcfb32"' \
  -H 'Host: 192.168.1.1' \
  -H 'Origin: http://192.168.1.1' \
  -H 'Referer: http://192.168.1.1/m/index.html' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
 --data 'isTest=false&goformId=LOGIN&password=38D180985D1B2E7A6014190E2CBD3C967408837188354EC93D27BFD86D09A017' \
  -i)


cookie=$(echo "$response_headers" | grep -i '^Set-Cookie:' | sed -n 's/.*zwsd="\([^;]*\).*/\1/p')


unixTimestamp=$(date +%s)

url="http://192.168.1.1/goform/goform_get_cmd_process?isTest=false&cmd=RD&_=${unixTimestamp}"

response=$(curl -b "zwsd=$cookie" -H "Referer: http://192.168.1.1/m/index.html" -s "$url" | grep -o '"RD":"[^"]*' | cut -d':' -f2 | cut -d'"' -f2)

constString="6cea63fc7cd9bb8cd5d22d2a61e2301e"
string="$constString$response"

md5_hash=$(hex_md5 "$string")




curl -X POST \
  http://192.168.1.1/goform/goform_set_cmd_process \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Accept-Language: en-US,en;q=0.9,tr-TR;q=0.8,tr;q=0.7' \
  -H 'Connection: keep-alive' \
  -H "$(echo 'Cookie: "zwsd="'"$cookie")" \
  -H 'Host: 192.168.1.1' \
  -H 'Origin: http://192.168.1.1' \
  -H 'Referer: http://192.168.1.1/m/index.html' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  -H 'X-Requested-With: XMLHttpRequest' \
  --data "isTest=false&goformId=REBOOT_DEVICE&AD=$md5_hash"


