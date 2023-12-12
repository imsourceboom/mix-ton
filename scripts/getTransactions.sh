#!/bin/bash

ADDRESS=$1

curl "https://toncenter.com/api/index/getTransactionsByAddress?address=${ADDRESS}&limit=6&include_msg_body=true" | jq '.'

echo "Bye."
