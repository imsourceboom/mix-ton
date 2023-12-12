#!/bin/bash

if [ $# -ne 3 ]; then
	echo "script need 3 parameter"
	echo "parameter 1: workchain id"
	echo "parameter 2: wallet name"
	echo "parameter 3: version"
	exit 1
fi

function CREATE_WALLET {
	mytonctrl <<< "nw $1 $2 $3"
}

CREATE_WALLET $1 $2 $3
