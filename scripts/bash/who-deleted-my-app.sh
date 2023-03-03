#!/bin/bash
## Author: wennmo
## Version: v0.0.1
## Description: Find the user that deleted an app with id
## Arguments: appId
## Usage: ./who-deleted-the-app.sh <appId>
if [ -z "$1" ]
  then
    echo "No appId supplied"
    exit 1
else
    appId=$1
fi

echo "Checking who deleted app with id: $appId"
userId=$(qlik audit ls --eventType com.qlik.app.deleted | jq --arg appId $appId -r '.[] | select(.data.id==$appId) | .userId')
userName=$(qlik user get $userId -v | jq '.name')
echo "The app was deleted by user $userName with id $userId"