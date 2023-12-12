#!/bin/bash

if [ $# -ne 2 ]; then
	echo "script need 2 parameter"
 	echo "parameter 1: Source Wallet or Address"
  	echo "parameter 2: Dest Wallet or Address"
    	exit 1
fi

SENDER=$1
DEST=$2
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

function GET_FEE {
	FRONT=$(($RANDOM % 100+600))
	BACK=$(($RANDOM % 8000+1234))
	ADD_FEE=$FRONT$BACK
	echo $ADD_FEE
}

function MOVE_COINS {
	# 1: Send | 2: Receive | 3: Balance | 4: args
	mytonctrl <<< "mg $1 $2 $3 $4"
}

#FEE=$(GET_FEE)

GET_BALANCE=$(GET_BALANCE_TON $SENDER)
#GET_BALANCE=$(GET_BALANCE_NANO $SENDER)
#BALANCE_SUBTRUCTION_FEE=$(expr $GET_BALANCE - $FEE)
#BALANCE=$(DECIMAL $BALANCE_SUBTRUCTION_FEE)

#MOVE_COINS $SENDER $DEST $BALANCE -n
MOVE_COINS $SENDER $DEST all -n

#echo $FEE
#echo $BALANCE_SUBTRUCTION_FEE
echo "Send: $SENDER, Receive: $DEST"
echo "BALANCE: $GET_BALANCE"
