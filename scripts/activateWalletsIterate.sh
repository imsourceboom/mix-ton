#!/bin/bash

if [ $# -ne 3 ]; then
	echo "script need 3 parameter"
	echo "parameter 1: wallet name"
	echo "parameter 2: iterate start number"
	echo "parameter 3: iterate end number"
	exit 1
fi

NAME=$1
START=$2
END=$3

for ((i = $START; i <= $END; i++))
do 
	activateWallet.sh ${NAME}_${i}
done
