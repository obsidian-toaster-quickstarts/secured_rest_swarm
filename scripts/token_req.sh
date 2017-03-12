#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

. $SCRIPT_DIR/common.sh $*

#echo ">>> HTTP Token query"
echo "curl -skv -X POST $SSO_HOST/auth/realms/$REALM/protocol/openid-connect/token -d grant_type=password -d username=$USER -d client_secret=$SECRET -d password=$PASSWORD -d client_id=$CLIENT_ID"

auth_result=$(curl -sk -X POST $SSO_HOST/auth/realms/$REALM/protocol/openid-connect/token -d grant_type=password -d username=$USER -d client_secret=$SECRET -d password=$PASSWORD -d client_id=$CLIENT_ID)
access_token=$(echo -e "$auth_result" | awk -F"," '{print $1}' | awk -F":" '{print $2}' | sed s/\"//g | tr -d ' ')

echo ">>> TOKEN Received"
echo $access_token

echo ">>> Greeting"
echo curl -kv $APP_URL/greeting -H "Authorization:Bearer $access_token"
curl -kv $APP_URL/greeting -H "Authorization:Bearer $access_token"

