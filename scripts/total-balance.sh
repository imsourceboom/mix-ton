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

function GET_BALANCE_TON {
	mytonctrl <<< "wl" | grep -w $1 | awk '{print $3}'
}

function GET_BALANCE_NANO {
	mytonctrl <<< "wl" | grep -w $1 | awk '{print $3}' | tr -d '.'
}

function DECIMAL {
	echo $1 $NANO | awk '{printf "%.9f", $1 / $2}'
}

TOTAL_WALLETS=0
TOTAL_BALANCE=0
TOTAL_BALANCE_NANO=0

for ((i = 1; i <= $COUNT; i++))
do
	GET_BALANCE=$(GET_BALANCE_TON ${VERSION}_${i})
	BALANCE_TON=$(echo $GET_BALANCE | cut -d '.' -f 1)
	BALANCE_NANO=$(echo $GET_BALANCE | tr -d '.')
	TOTAL_BALANCE=$(expr $TOTAL_BALANCE + $BALANCE_TON)
	TOTAL_BALANCE_NANO=$(expr $TOTAL_BALANCE_NANO + $BALANCE_NANO)
	TOTAL_WALLETS=${i}
done

echo "Total Wallets: $TOTAL_WALLETS"
echo "Total Ton Balance: $(${TOTAL_BALANCE})"
echo "Total Nano Balance: $(DECIMAL ${TOTAL_BALANCE_NANO})"
