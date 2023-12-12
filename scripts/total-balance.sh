#!/bin/bash

if [ $# -ne 2 ]; then
	echo "script Need 2 parameter"
	echo "parameter 1: Wallet Version"
	echo "parameter 2: Wallet Count"
	exit
fi

VERSION=$1
COUNT=$2

NANO=1000000000

function GET_BALANCE_NANO {
	mytonctrl <<< "wl" | grep -w $1 | awk '{print $3}' | tr -d '.'
}

function DECIMAL {
	echo $1 $NANO | awk '{printf "%.9f", $1 / $2}'
}

TOTAL_WALLETS=0
TOTAL_BALANCE=0

for ((i = 1; i <= $COUNT; i++))
do
	BALANCE_NANO=$(GET_BALANCE_NANO ${VERSION}_${i})
	TOTAL_BALANCE=$(expr $TOTAL_BALANCE + $BALANCE_NANO)
	TOTAL_WALLETS=${i}
done

echo "Total Wallets: $TOTAL_WALLETS"
echo "Total Balance: $(DECIMAL ${TOTAL_BALANCE})"
