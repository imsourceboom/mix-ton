#!/bin/bash

#if [ $# -ne 3 ]; then
#	echo "script need 3 parameter"
#	echo "parameter 1: Source Wallet or Address"
#	echo "parameter 2: Dest Wallet or Address"
#	echo "parameter 3: "
#	exit 1
#fi

SOURCE_WALLET=$1
#DEST_WALLET=$2
#REMAIN_WALLET=$3
VERSION=$2
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

function TIGHT_FEE {
	FRONT=$(($RANDOM % 100+600))
	BACK=$(($RANDOM % 8000+1234))
	ADD_FEE=$FRONT$BACK
	echo $ADD_FEE
}

FEE=$(TIGHT_FEE)
SOURCE_BALANCE=$(GET_BALANCE_NANO $SOURCE_WALLET)
SOURCE_BALANCE_NANO=$(expr $SOURCE_BALANCE - $FEE)
SOURCE_BALANCE_DECIMAL=$(DECIMAL $SOURCE_BALANCE_NANO)
sleep $(($RANDOM % 6+5))

# Create Wallets AND Activate AND MoveCoins
#STRAIGHT_RANDOM=$(($RANDOM % 6+5))
STRAIGHT_RANDOM=20
for ((i = 1; i <= $STRAIGHT_RANDOM; i++))
do
	CREATE_WALLET ${VERSION}_${i}
done

sleep $(($RANDOM % 6+5))
MOVE_COINS ${SOURCE_WALLET} ${VERSION}_1 ${SOURCE_BALANCE_DECIMAL} -n
sleep $(($RANDOM % 11+10))
ACTIVATE_WALLET ${VERSION}_1
sleep $(($RANDOM % 11+10))

for ((i = 1; i < $STRAIGHT_RANDOM; i++))
do

	FEE=$(TIGHT_FEE)
	WALLET_BALANCE=$(GET_BALANCE_NANO ${VERSION}_${i})
	WALLET_BALANCE_NANO=$(expr $WALLET_BALANCE - $FEE)
	WALLET_BALANCE_DECIMAL=$(DECIMAL $WALLET_BALANCE_NANO)

	sleep $(($RANDOM % 11+10))
	MOVE_COINS ${VERSION}_${i} ${VERSION}_$((${i} + 1)) ${WALLET_BALANCE_DECIMAL} -n
	sleep $(($RANDOM % 11+10))
	ACTIVATE_WALLET ${VERSION}_$((${i} + 1))
	sleep $(($RANDOM % 11+10))
done

#echo "Created Total Wallets: $CREATED_TOTAL_WALLETS" >> ~/mix-ton/mix.log
#echo "Sended Total Balance: $(DECIMAL ${SENDED_TOTAL_BALANCE})" >> ~/mix-ton/mix.log
#echo "Source Wallet: $SOURCE_WALLET"
#echo "Dest Wallet: $DEST_WALLET"
echo "Script DONE"
