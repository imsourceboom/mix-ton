#!/bin/bash

if [ $# -ne 7 ]; then 
	echo "script need 7 parameter"
	echo "parameter 1: Source Wallet"
	echo "parameter 2: Wallet Version"
	echo "parameter 3: Start number"
	echo "parameter 4: Iterate Count"
	echo "parameter 5: Random decimal Start number"
	echo "parameter 6: Random decimal end number"
	echo "parameter 7: Amount Division"
	exit
fi

SOURCE_WALLET=$1
WALLET_VERSION=$2
START_NUMBER=$3
ITERATE_COUNT=$4
START_RANDOM_DECIMAL=$5
END_RANDOM_DECIMAL=$6
AMOUNT_DIVISION=$7
NANO=1000000000

function GET_BALANCE_TON () {
	mytonctrl <<< "wl" | grep -w $1 | awk '{print $3}'
}

function MOVE_COINS () {
	mytonctrl <<< "mg $1 $2 $3 $4"
}

SOURCE_WALLET_BALANCE_TON=$(GET_BALANCE_TON $SOURCE_WALLET)
SOURCE_WALLET_BALANCE_NANO=$(echo $SOURCE_WALLET_BALANCE_TON | tr -d '.')
SOURCE_WALLET_BALANCE_TON_INT=$(echo $SOURCE_WALLET_BALANCE_TON | cut -d '.' -f 1)

SOURCE_WALLET_BALANCE_DIVISION=$(expr $SOURCE_WALLET_BALANCE_TON_INT / $AMOUNT_DIVISION)

for ((i = $START_NUMBER; i <= $ITERATE_COUNT; i++))
do
	TARGET_WALLET=${WALLET_VERSION}_${i}
	FRONT=$(($RANDOM % 8000+1234))
	BACK=$(($RANDOM % 80000+12345))
	SUM_DECIMAL=${FRONT}${BACK}
	RANDOM_DECIMAL=$(($RANDOM % $END_RANDOM_DECIMAL+$START_RANDOM_DECIMAL))
	OUTPUT_DECIMAL=$(echo $SUM_DECIMAL | cut -c -${RANDOM_DECIMAL})
	RANDOM_100=$(($RANDOM % 1500+1))
	INT_BALANCE=$(expr $SOURCE_WALLET_BALANCE_DIVISION + $RANDOM_100)
	ADD_BALANCE="${INT_BALANCE}.${OUTPUT_DECIMAL}"

	if [ $RANDOM_DECIMAL = 0 ]; then
		MOVE_COINS $SOURCE_WALLET $TARGET_WALLET $INT_BALANCE -n 
		echo "TARGET_WALLET: $TARGET_WALLET"
		echo "BALANCE: $INT_BALANCE"
	else
		MOVE_COINS $SOURCE_WALLET $TARGET_WALLET $ADD_BALANCE -n
		echo "TARGET_WALLET: $TARGET_WALLET"
		echo "BALANCE: $ADD_BALANCE"
	fi
	echo "RANDOM_DECIMAL: $RANDOM_DECIMAL"
	echo "NUMBER: $i"
	sleep $((RANDOM % 6+5))
done
