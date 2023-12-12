#!/bin/bash

if [ $# -lt 3 ]; then
	echo "script need 3 more parameter"
 	echo "parameter 1: Source Wallet or Address"
  	echo "parameter 2: Dest Wallet or Address"
  	echo "parameter 3: Dest Wallet or Address"
  	echo "parameter 4: args"
    	exit 1
fi

SENDER=$1
DEST=$2
BALANCE=$3
ARGS=$4

function MOVE_COINS {
	# 1: Send | 2: Receive | 3: Balance | 4: args
	mytonctrl <<< "mg $1 $2 $3 $4"
}

MOVE_COINS $SENDER $DEST $BALANCE $ARGS
