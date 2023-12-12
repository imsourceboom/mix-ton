#!/bin/bash

if [ $# -ne 9 ]; then
	echo "scirpt need 9 parameter"
	echo "parameter 1: Wallet Version"
	echo "parameter 2: Wallet Count"
	echo "parameter 3: Dest Wallet or Address"
	echo "parameter 4: Random decimal Start number"
	echo "parameter 5: Random decimal End number"
	echo "parameter 6: Initial Division - Least 2 more"
	echo "parameter 7: Amount Division"
	echo "parameter 8: Delay Start"
	echo "parameter 9: Delay End"
	exit 1
fi

DELAY_START=$8
DELAY_END=$9

for ((;;))
do
	INIT_DIVISION=$6
	AMOUNT_DIVISION=$((RANDOM % $7+1))
	SLEEP_RANDOM=$((RANDOM % $DELAY_END+$DELAY_START))
	randomMoveCoins.sh $1 $2 $3 $4 $5 $INIT_DIVISION $AMOUNT_DIVISION
	if [ $# -ne 9 ]; then
		exit 1
	fi
	sleep $SLEEP_RANDOM;
done
