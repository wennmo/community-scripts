#!/bin/sh
user_id=$(qlik user me | jq .id -r)
echo $(qlik app ls --createdByUserId="$user_id" -q) | wc -w
