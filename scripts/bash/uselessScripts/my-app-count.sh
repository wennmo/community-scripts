#!/bin/sh
## Author: colsson
## Version: v0.0.3
## Description: my app count
user_id=$(qlik user me | jq .id -r)
echo $(qlik app ls --createdByUserId="$user_id" -q) | wc -w
