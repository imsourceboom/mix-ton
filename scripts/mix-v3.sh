#!/bin/bash

if [ $# -ne 6 ]; then
	echo "script need 6 parameter"
	echo "parameter 1: Wallet VERSION"
	echo "parameter 2: Wallet COUNT"
	echo "parameter 3: BALANCE LIMIT"
	echo "parameter 4: RANDOM DECIMAL START INT 0"
	echo "parameter 5: RANDOM DECIMAL END LIMIT INT 10"
	echo "parameter 6: Amount Division"
	#echo "example RANDOM_DECIMAL_CUT=$(($RANDOM % 10+0))"
	#echo "RANDOM_DECIMAL_CUT=$(($RANDOM % $RANDOM_DECIMAL_END + $RANDOM_DECIMAL_START))"
	exit 1
fi

VERSION=$1
WALLET_COUNT=$2
BALANCE_LIMIT=$3
RANDOM_DECIMAL_START=$4
RANDOM_DECIMAL_END=$5
AMOUNT_DIVISION=$6
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
	#echo "CYCLE: $1 | $2 | $3"
	echo "SEND: $1, RECEIVE: $2"
	echo "BALANCE: $3"
}

TOTAL_MIX_COUNT=0
for ((;;))
do
	SOURCE_RANDOM=$(($RANDOM % $WALLET_COUNT+1))
	TARGET_RANDOM=$(($RANDOM % $WALLET_COUNT+1))

	FEE=$(TIGHT_FEE)
	WALLET_BALANCE_TON=$(GET_BALANCE_TON ${VERSION}_${SOURCE_RANDOM})
	WALLET_BALANCE=$(echo $WALLET_BALANCE_TON | tr -d '.')
	sleep $(($RANDOM % 3+5))

	if [ $WALLET_BALANCE -gt $NANO ]; then
		BALANCE_INT=$(echo $WALLET_BALANCE_TON | cut -d '.' -f 1)
		BALANCE_DECIMAL=$(echo $WALLET_BALANCE_TON | cut -d '.' -f 2)
		#WALLET_BALANCE_NANO=$(expr $WALLET_BALANCE - $FEE)

		#RANDOM_DECIMAL_CUT=$(($RANDOM % 10+0))
		RANDOM_DECIMAL_CUT=$(($RANDOM % $RANDOM_DECIMAL_END+$RANDOM_DECIMAL_START))

		if [ $WALLET_BALANCE -ge $(($NANO * $BALANCE_LIMIT)) ]; then
			DIVISION_RANDOM=$(($RANDOM % $AMOUNT_DIVISION+2))
			INT_BALANCE=$(expr $BALANCE_INT / $DIVISION_RANDOM)

			if [ $RANDOM_DECIMAL_CUT = 0 ]; then
				MOVE_COINS ${VERSION}_${SOURCE_RANDOM} ${VERSION}_${TARGET_RANDOM} ${INT_BALANCE} -n
				OUTPUT ${VERSION}_${SOURCE_RANDOM} ${VERSION}_${TARGET_RANDOM} ${INT_BALANCE}
			else
				CALCUL_DECIMAL=$(echo $BALANCE_DECIMAL | cut -c -${RANDOM_DECIMAL_CUT})
				SUM_BALANCE="${INT_BALANCE}.${CALCUL_DECIMAL}"
				MOVE_COINS ${VERSION}_${SOURCE_RANDOM} ${VERSION}_${TARGET_RANDOM} ${SUM_BALANCE} -n
				OUTPUT ${VERSION}_${SOURCE_RANDOM} ${VERSION}_${TARGET_RANDOM} ${SUM_BALANCE}
			fi
			echo "DECIMAL RANDOM: ${RANDOM_DECIMAL_CUT}"
			TOTAL_MIX_COUNT=`expr $TOTAL_MIX_COUNT + 1`
			echo "Total Mix Count: $TOTAL_MIX_COUNT"
		else
			if [ $WALLET_BALANCE -ge $(($NANO * 500)) ]; then
				#WALLET_BALANCE_DECIMAL=$(DECIMAL $WALLET_BALANCE_NANO)
				INT_RANDOM=$(($RANDOM % 9+1))
				CALCUL_INT=$(expr $BALANCE_INT - $INT_RANDOM)
				CALCUL_DECIMAL=$(echo $BALANCE_DECIMAL | cut -c -${RANDOM_DECIMAL_CUT})
				SUM_BALANCE="${CALCUL_INT}.${CALCUL_DECIMAL}"
				MOVE_COINS ${VERSION}_${SOURCE_RANDOM} ${VERSION}_${TARGET_RANDOM} ${SUM_BALANCE} -n
				OUTPUT ${VERSION}_${SOURCE_RANDOM} ${VERSION}_${TARGET_RANDOM} ${SUM_BALANCE}
				echo "DECIMAL RANDOM: ${RANDOM_DECIMAL_CUT}"
				TOTAL_MIX_COUNT=`expr $TOTAL_MIX_COUNT + 1`
				echo "Total Mix Count: $TOTAL_MIX_COUNT"
			fi
		fi
	

		#sleep $(($RANDOM % 11+20))
		sleep $(($RANDOM % 6+5))
	fi
done

echo "Script DONE"
