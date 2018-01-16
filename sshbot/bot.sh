#!/bin/sh

SSHHOST=$1
DOWORK=1

_term () {
	DOWORK=0
}

trap _term SIGTERM
trap _term SIGINT

echo $SSHHOST

while [ $DOWORK == 1 ]; do
	timeout -t 10 sshpass -p passwordddd ssh $SSHHOST -o StrictHostKeyChecking=no UserKnownHostsFile=/dev/null
done
