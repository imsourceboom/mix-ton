#!/bin/bash

if [ $# -ne 10 ]; then
	echo "scirpt need 10 parameter"
	echo "parameter 1: Wallet Version"
	echo "parameter 2: Range Start Number"
	echo "parameter 3: Range Increase Number"
	echo "parameter 4: Dest Wallet or Address"
	echo "parameter 5: Random decimal Start number"
	echo "parameter 6: Random decimal End number"
	echo "parameter 7: Initial Division - Least 2 more"
	echo "parameter 8: Amount Division"
	echo "parameter 9: Delay Start"
	echo "parameter 10: Delay End"
	exit 1
fi

DELAY_START=$9
DELAY_END=${10}

for ((;;))
do
	INIT_DIVISION=$7
	AMOUNT_DIVISION=$((RANDOM % $8+1))
	SLEEP_RANDOM=$((RANDOM % $DELAY_END+$DELAY_START))
	randomMoveCoins.sh $1 $2 $3 $4 $5 $6 $INIT_DIVISION $AMOUNT_DIVISION
	if [ $# -ne 10 ]; then
		exit 1
	fi
	sleep $SLEEP_RANDOM;
done
