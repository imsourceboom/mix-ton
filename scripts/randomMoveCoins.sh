#!/bin/bash

if [ $# -ne 8 ]; then
	echo "script need 8 parameter"
 	echo "parameter 1: Wallet Version"
 	echo "parameter 2: Range Start Number"
 	echo "parameter 3: Range Increase Number"
  	echo "parameter 4: Dest Wallet or Address"
  	echo "parameter 5: Random decimal Start number"
  	echo "parameter 6: Random decimal End number"
  	echo "parameter 7: Initial Division - Least 2 more"
  	echo "parameter 8: Amount Division"
    	exit 1
fi

VERSION=$1
RANGE_START_NUMBER=$2
INCREASE_NUMBER=$3
DEST=$4
START_RANDOM_DECIMAL=$5
END_RANDOM_DECIMAL=$6
INIT_DIVISION=$7
AMOUNT_DIVISION=$8

NANO=1000000000
RANDOM_WALLET=$(($RANDOM % $INCREASE_NUMBER+$RANGE_START_NUMBER))

function GET_BALANCE_TON {
	mytonctrl <<< "wl" | grep -w $1 | awk '{print $3}'
}

function GET_BALANCE_NANO {
	NANO_BALANCE=$(GET_BALANCE_TON $1 | tr -d '.')
	echo $NANO_BALANCE
}

function MOVE_COINS {
	# 1: Send | 2: Receive | 3: Balance | 4: args
	mytonctrl <<< "mg $1 $2 $3 $4"
}

function GENERATE_RANDOM_DECIMAL {
	FRONT=$(($RANDOM % 800+123))
	MIDDLE=$(($RANDOM % 800+123))
	BACK=$(($RANDOM % 800+123))
	ADD=$FRONT$MIDDLE$BACK
	echo $ADD
}

WALLET_BALANCE_TON=$(GET_BALANCE_TON ${VERSION}_${RANDOM_WALLET})
WALLET_BALANCE_NANO=$(echo $WALLET_BALANCE_TON | tr -d '.')


if [ $WALLET_BALANCE_NANO -gt $(($NANO * 10)) ]; then
	WALLET_BALANCE_INT=$(echo $WALLET_BALANCE_TON | cut -d '.' -f 1)
	WALLET_BALANCE_DECIMAL=$(echo $WALLET_BALANCE_TON | cut -d '.' -f 2)

	RANDOM_DECIMAL_CUT=$(($RANDOM % $END_RANDOM_DECIMAL+$START_RANDOM_DECIMAL))
	DIVISION_RANDOM=$(($RANDOM % $AMOUNT_DIVISION+$INIT_DIVISION))

	INT_BALANCE=$(expr $WALLET_BALANCE_INT / $DIVISION_RANDOM)
	if [ $RANDOM_DECIMAL_CUT = 0 ]; then
		MOVE_COINS ${VERSION}_${RANDOM_WALLET} $DEST $INT_BALANCE -n
		echo "Wallet: ${VERSION}_${RANDOM_WALLET}"
		echo "Balance: $WALLET_BALANCE_TON"
		echo "Decimal Cut Number: $RANDOM_DECIMAL_CUT"
		echo "Send Balance: $INT_BALANCE"
	else
		GET_DECIMAL=$(GENERATE_RANDOM_DECIMAL)
		#CALCUL_DECIMAL=$(echo $WALLET_BALANCE_DECIMAL | cut -c -${RANDOM_DECIMAL_CUT})
		CALCUL_DECIMAL=$(echo $GET_DECIMAL | cut -c -${RANDOM_DECIMAL_CUT})
		SUM_BALANCE="${INT_BALANCE}.${CALCUL_DECIMAL}"
		MOVE_COINS ${VERSION}_${RANDOM_WALLET} $DEST $SUM_BALANCE -n
		echo "Wallet: ${VERSION}_${RANDOM_WALLET}"
		echo "Balance: $WALLET_BALANCE_TON"
		echo "Decimal Cut Number: $RANDOM_DECIMAL_CUT"
		echo "Send Balance: $SUM_BALANCE"
	fi
fi
