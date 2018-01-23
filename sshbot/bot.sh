#!/bin/bash
DOWORK=1

# http://mywiki.wooledge.org/SignalTrap#When_is_the_signal_handled.3F
_term () {
	DOWORK=0
	[[ $pid ]] && kill $pid
}

trap _term SIGTERM
trap _term SIGINT

rand_sleep() {
	rng2=$(($RANDOM % 5))
	echo $rng2
	sleep ${rng2}s & pid=$!
	wait
}

declare -a hostsArr
hostsCount=0
while IFS='' read -r line || [[ -n "$line" ]]; do
	hostsArr[$hostsCount]="$line"
	((hostsCount++))
done < ./hosts

if [ $hostsCount == 0 ]; then
	exit 1
fi

while [ $DOWORK == 1 ]; do
	rand_sleep

	rng=$(($RANDOM % $hostsCount))
	host=${hostsArr[rng]}
	echo $host
	sshpass -p passwordddd ssh $host -o StrictHostKeyChecking=no UserKnownHostsFile=/dev/null & pid=$!
	wait

	rand_sleep

	rng=$(($RANDOM % $hostsCount))
	host=${hostsArr[rng]}
	echo $host
	host2=(${host//@/ })
	wget http://${host2[0]}:pass@${host2[1]}/bitcoins/bitcoin & pid=$!
	wait
done

