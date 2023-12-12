#!/bin/bash

if [ $# -ne 3 ]; then
	echo "script need 3 parameter"
	echo "parameter 1: Wallet Version name"
	echo "parameter 2: iterator start number"
	echo "parameter 3: iterator end number"
	exit 1
fi

for ((i = $2; i <= $3; i++))
do
	createWallet.sh 0 $1_${i} v3r2
done
