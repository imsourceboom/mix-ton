#!/bin/bash

if [ $# -ne 3 ]; then
	echo "script need 3 parameter"
	echo "parameter 1: wallet name | ex) wallet_name"
	echo "parameter 2: iterate start number"
	echo "parameter 3: iterate end number"
	exit 1
fi

WALLET_NAME=$1
START=$2
END=$3

for ((i = $START; i <= $END; i++))
do
	removeWallet.sh ${WALLET_NAME}_${i}
done
