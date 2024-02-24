#!/bin/bash

if [ $# -ne 1 ]; then
	echo "script need 1 parameter"
	echo "parameter 1: file name"
	echo "ex) removeWallets.sh wallet_name*"
	exit 1
fi

NAME=$1

rm `ls $HOME/.local/share/mytoncore/wallets/${NAME}`
