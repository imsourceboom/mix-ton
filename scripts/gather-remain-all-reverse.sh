#!/bin/bash

if [ $# -ne 4 ]; then
	echo "script need 4 parameter"
	echo "parameter 1: Wallet VERSION"
	echo "parameter 2: Iterate Start Number | Because it's upside down, the start must be greater than the end number"
	echo "parameter 3: Iterate End Number"
	echo "parameter 4: Dest Wallet Address"
	exit 1
fi

VERSION=$1
ITERATE_START=$2
ITERATE_END=$3
DEST_WALLET=$4
NANO=1000000000

function MOVE_COINS {
	# 1: Send | 2: Receive | 3: Balance | 4: args
	mytonctrl <<< "mg $1 $2 $3 $4"
}

function GET_BALANCE_TON {
	mytonctrl <<< "wl" | grep -w $1 | awk '{print $3}'
}

function GET_BALANCE_NANO {
	mytonctrl <<< "wl" | grep -w $1 | awk '{print $3}' | tr -d '.'
}

function DECIMAL {
	echo $1 $NANO | awk '{printf "%.9f", $1 / $2}'
}

function TIGHT_FEE {
	FRONT=$(($RANDOM % 100+600))
	BACK=$(($RANDOM % 8000+1234))
	ADD_FEE=$FRONT$BACK
	echo $ADD_FEE
}

	for ((i = $ITERATE_START; i >= $ITERATE_END; i--))
	do
		#FEE=$(TIGHT_FEE)
		#WALLET_BALANCE=$(GET_BALANCE_NANO ${VERSION}_${i})
		WALLET_BALANCE=$(GET_BALANCE_TON ${VERSION}_${i})
#		WALLET_BALANCE_NANO=$(echo $WALLET_BALANCE | tr -d '.')
#		WALLET_BALANCE_INT=$(echo $WALLET_BALANCE | cut -d '.' -f 1)
#		WALLET_BALANCE_DECIMAL=$(echo $WALLET_BALANCE | cut -d '.' -f 2)
		#RANDOM_DECIMAL=$(($RANDOM % $END_RANDOM_DECIMAL+$START_RANDOM_DECIMAL))
		sleep $(($RANDOM % 3+5))
		
		#if [ $WALLET_BALANCE -gt $NANO ]; then
			#WALLET_BALANCE_NANO=$(expr $WALLET_BALANCE - $FEE)
#			if [ $WALLET_BALANCE -ge $(($NANO * $BALANCE_LIMIT)) ]; then
#				DIVISION_RANDOM=$(($RANDOM % 2+2))
#				WALLET_BALANCE_NANO=$(expr $WALLET_BALANCE / $DIVISION_RANDOM - $FEE)
#			fi
			#WALLET_BALANCE_DECIMAL=$(DECIMAL $WALLET_BALANCE_NANO)
#			CALCUL_INT=$(echo $WALLET_BALANCE_DECIMAL | cut -d '.' -f 1)
#			CALCUL_DECIMAL=$(echo $WALLET_BALANCE_DECIMAL | cut -d '.' -f 2)
#			CUT_DECIMAL=$(echo $CALCUL_DECIMAL | cut -c -${RANDOM_DECIMAL})
#			OUTPUT_BALANCE="${CALCUL_INT}.${CUT_DECIMAL}"
		
			MOVE_COINS ${VERSION}_${i} ${DEST_WALLET} all -n
			#MOVE_COINS ${VERSION}_${i} ${DEST_WALLET} ${WALLET_BALANCE_DECIMAL} -n
			#MOVE_COINS ${VERSION}_${i} ${DEST_WALLET} ${OUTPUT_BALANCE} -n
			echo "SEND: ${VERSION}_${i}, RECEIVE: ${DEST_WALLET}"
			#echo "BALANCE: ${OUTPUT_BALANCE}"
			#echo "BALANCE: ${WALLET_BALANCE_DECIMAL}"
			echo "BALANCE: ${WALLET_BALANCE}"
			sleep $(($RANDOM % 6+5))
		#fi
	
	done

echo "Script DONE"
