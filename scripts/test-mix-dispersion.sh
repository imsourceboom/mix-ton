#!/bin/bash

if [ $# -ne 2 ]; then
	echo "script need 2 parameter"
	echo "parameter 1: Source Wallet or Address"
	echo "parameter 2: Dest Wallet or Address"
	exit 1
fi

SOURCE_WALLET=$1
DEST_WALLET=$2
NANO=1000000000

function CREATE_WALLET {
	mytonctrl <<< "nw 0 $1 v3r2"
}

function MOVE_COINS {
	# 1: Send | 2: Receive | 3: Balance | 4: args
	mytonctrl <<< "mg $1 $2 $3 $4"
}

function ACTIVATE_WALLET {
	mytonctrl <<< "aw $1"
}

function GET_BALANCE_NANO {
	mytonctrl <<< "wl" | grep -w $1 | awk '{print $3}' | tr -d '.'
}

function DECIMAL {
	echo $1 $NANO | awk '{printf "%.9f", $1 / $2}'
}

function GET_FEE {
	FRONT=$(($RANDOM % 4000+6000))
	BACK=$(($RANDOM % 9000+1234))
	ADD_FEE=$FRONT$BACK
	echo $ADD_FEE
}

CREATED_TOTAL_WALLETS=0
SENDED_TOTAL_BALANCE=0

# Create Wallets AND Activate AND MoveCoins
SOURCE_BALANCE=49999999999999
#SOURCE_BALANCE=$(GET_BALANCE_NANO $SOURCE_WALLET)
FIRST_RANDOM=$(($RANDOM % 3+2))
for ((i = 1; i <= $FIRST_RANDOM; i++))
do
	FEE=$(GET_FEE)
	FIRST_BALANCE_NANO=$(expr $SOURCE_BALANCE / $FIRST_RANDOM - $FEE)
	FIRST_BALANCE_DECIMAL=$(DECIMAL $FIRST_BALANCE_NANO)

	CREATE_WALLET ${i}
#	sleep $(($RANDOM % 6+5))
#	MOVE_COINS ${SOURCE_WALLET} ${i} ${FIRST_BALANCE_DECIMAL} -n
#	sleep $(($RANDOM % 31+30))
#	ACTIVATE_WALLET ${i}
#	sleep $(($RANDOM % 241+60))

echo ${i} ${FIRST_BALANCE_DECIMAL} >> ~/mix-ton/mix.log
CREATED_TOTAL_WALLETS=$(expr $CREATED_TOTAL_WALLETS + 1)

	SECOND_RANDOM=$(($RANDOM % 4+1))
	for ((j = 1; j <= $SECOND_RANDOM; j++))
	do
		FEE=$(GET_FEE)
		SECOND_BALANCE_NANO=$(expr $FIRST_BALANCE_NANO / $SECOND_RANDOM - $FEE)
		SECOND_BALANCE_DECIMAL=$(DECIMAL $SECOND_BALANCE_NANO)

		CREATE_WALLET ${i}_${j}
#		sleep $(($RANDOM % 6+5))
#		MOVE_COINS ${i} ${i}_${j} ${SECOND_BALANCE_DECIMAL} -n
#		sleep $(($RANDOM % 31+30))
#		ACTIVATE_WALLET ${i}_${j}
#		sleep $(($RANDOM % 241+60))

echo ${i}_${j} ${SECOND_BALANCE_DECIMAL} >> ~/mix-ton/mix.log
CREATED_TOTAL_WALLETS=$(expr $CREATED_TOTAL_WALLETS + 1)

		THIRD_RANDOM=$(($RANDOM % 6+1))
		for ((y = 1; y <= $THIRD_RANDOM; y++))
		do
			FEE=$(GET_FEE)
			THIRD_BALANCE_NANO=$(expr $SECOND_BALANCE_NANO / $THIRD_RANDOM - $FEE)
			THIRD_BALANCE_DECIMAL=$(DECIMAL $THIRD_BALANCE_NANO)

			CREATE_WALLET ${i}_${j}_${y}
#			sleep $(($RANDOM % 6+5))
#			MOVE_COINS ${i}_${j} ${i}_${j}_${y} ${THIRD_BALANCE_DECIMAL} -n
#			sleep $(($RANDOM % 31+30))
#			ACTIVATE_WALLET ${i}_${j}_${y}
#			sleep $(($RANDOM % 241+60))
			FINAL_BALANCE_NANO=$(expr $THIRD_BALANCE_NANO - $FEE) 
			FINAL_BALANCE_DECIMAL=$(DECIMAL $FINAL_BALANCE_NANO) 
#			MOVE_COINS ${i}_${j}_${y} ${DEST_WALLET} ${FINAL_BALANCE_DECIMAL} -n
#			sleep $(($RANDOM % 241+60))

echo ${i}_${j}_${y} ${THIRD_BALANCE_DECIMAL} >> ~/mix-ton/mix.log
CREATED_TOTAL_WALLETS=$(expr $CREATED_TOTAL_WALLETS + 1)
SENDED_TOTAL_BALANCE=$(expr $SENDED_TOTAL_BALANCE + $FINAL_BALANCE_NANO)
echo $FEE
		done
	done
done

echo "Created Total Wallets: $CREATED_TOTAL_WALLETS" >> ~/mix-ton/mix.log
echo "Sended Total Balance: $(DECIMAL ${SENDED_TOTAL_BALANCE})" >> ~/mix-ton/mix.log
echo "Source Wallet: $SOURCE_WALLET"
echo "Dest Wallet: $DEST_WALLET"
