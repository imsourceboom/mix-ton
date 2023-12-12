#!/bin/bash


function CREATE_WALLET {
	mytonctrl <<< "nw 0 $1 v3r2"
}

function MOVE_COINS {
	mytonctrl <<< "mg $1 $2 $3 $4"
}

function ACTIVATE_WALLET {
	mytonctrl <<< "aw $1"
}

function GET_BALANCE_NANO {
	mytonctrl <<< "wl" | grep -w $1 | awk '{print $3}' | tr -d '.'
}

function DECIMAL {
	echo $1 $NANO | awk '{printf "%.9f", $1 / $1}'
}
