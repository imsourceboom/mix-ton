#!/bin/bash

if [ $# -ne 3 ]; then
	echo "script need 3 parameter"
	echo "parameter 1: Wallet VERSION"
	echo "parameter 2: Wallet COUNT"
	echo "parameter 3: BALANCE LIMIT"
	exit 1
fi

VERSION=$1
WALLET_COUNT=$2
BALANCE_LIMIT=$3
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

function OUTPUT {
	echo "CYCLE: $1 | $2 | $3"
	echo "SEND: $4, RECEIVE: $5"
	echo "BALANCE: $6"
}

NETWORK_RANDOM=$(($RANDOM % 31+30))
for ((j = 1; j <= $NETWORK_RANDOM; j++))
do
	for ((i = 1; i <= $WALLET_COUNT; i++))
	do
		TARGET_RANDOM=$(($RANDOM % $WALLET_COUNT+1))
	
		FEE=$(TIGHT_FEE)
		WALLET_BALANCE_TON=$(GET_BALANCE_TON ${VERSION}_${i})
		WALLET_BALANCE=$(echo $WALLET_BALANCE_TON | tr -d '.')
		sleep $(($RANDOM % 3+5))

		if [ $WALLET_BALANCE -gt $NANO ]; then
			BALANCE_INT=$(echo $WALLET_BALANCE_TON | cut -d '.' -f 1)
			BALANCE_DECIMAL=$(echo $WALLET_BALANCE_TON | cut -d '.' -f 2)
			WALLET_BALANCE_NANO=$(expr $WALLET_BALANCE - $FEE)

			RANDOM_DECIMAL_CUT=$(($RANDOM % 10+0))

			if [ $WALLET_BALANCE -ge $(($NANO * $BALANCE_LIMIT)) ]; then
				DIVISION_RANDOM=$(($RANDOM % 2+2))
				INT_BALANCE=$(expr $BALANCE_INT / $DIVISION_RANDOM)

				if [ $RANDOM_DECIMAL_CUT = 0 ]; then
					MOVE_COINS ${VERSION}_${i} ${VERSION}_${TARGET_RANDOM} ${INT_BALANCE} -n
					OUTPUT ${i} ${j} ${NETWORK_RANDOM} ${VERSION}_${i} ${VERSION}_${TARGET_RANDOM} ${INT_BALANCE}
				else
					CALCUL_DECIMAL=$(echo $BALANCE_DECIMAL | cut -c -${RANDOM_DECIMAL_CUT})
					SUM_BALANCE="${INT_BALANCE}.${CALCUL_DECIMAL}"
					MOVE_COINS ${VERSION}_${i} ${VERSION}_${TARGET_RANDOM} ${SUM_BALANCE} -n
					OUTPUT ${i} ${j} ${NETWORK_RANDOM} ${VERSION}_${i} ${VERSION}_${TARGET_RANDOM} ${SUM_BALANCE}
				fi
				echo "DECIMAL RANDOM: ${RANDOM_DECIMAL_CUT}"
			else
				WALLET_BALANCE_DECIMAL=$(DECIMAL $WALLET_BALANCE_NANO)
				MOVE_COINS ${VERSION}_${i} ${VERSION}_${TARGET_RANDOM} ${WALLET_BALANCE_DECIMAL} -n
				OUTPUT ${i} ${j} ${NETWORK_RANDOM} ${VERSION}_${i} ${VERSION}_${TARGET_RANDOM} ${WALLET_BALANCE_DECIMAL}
			fi
		
			sleep $(($RANDOM % 11+20))
		fi
	
	done
done

echo "Script DONE"
