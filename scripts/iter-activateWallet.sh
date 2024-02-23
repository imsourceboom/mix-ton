#!/bin/bash

if [ $# -ne 2 ]; then
	echo "script need 2 parameter"
	echo "parameter 1: name"
	echo "parameter 2: iterate limit count"
	exit 1
fi

NAME=$1
COUNT=$2

for ((i = 1; i <= $COUNT; i++))
do 
	mytonctrl <<< "aw $NAME_$i"
done
