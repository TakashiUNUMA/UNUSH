#!/bin/sh
################################################
# last update: 2011/08/01 (09:20JST) in centos #
# made by Takashi Unuma                        #
################################################

if test $# -lt 3
then
    echo "USAGE: ./killjob.sh [hostname] [number-of-node] [executing-job]"
    exit
fi

node=$1
nnum=$2
file=$3

if test ${node} = "storm"
then
    echo "Now working jobs... ======================================================="
    ./check.sh ${node} ${nnum} ${file}
    echo "==========================================================================="
    echo ""

    echo "Now making PID list."
    rm -f tmp_kill_lst
    ./check.sh ${node} ${nnum} ${file} | \
	grep "${USER}" | \
	awk '{print $1}' > tmp_kill_lst
    
    echo -n "Now killing jobs. "
    for job in `cat tmp_kill_lst`
    do
	for (( num=1 ; num<=${nnum} ; num++ ))
	do
	    echo -n "."
	    rsh rain${num} "kill -KILL ${job}" > /dev/null 2>&1
	done
    done
    echo "OK"
    echo ""
    
    echo "Check killed jobs..."
    ./check.sh ${node} ${nnum} ${file}
    rm -f tmp_kill_lst

else
    echo "Now working jobs... ======================================================="
    ./check.sh ${node} 1 ${file}
    echo "==========================================================================="
    echo ""
    
    echo "Now making PID list."
    rm -f tmp_kill_lst
    ./check.sh ${node} ${nnum} ${file} | \
	grep "${USER}" | \
	awk '{print $1}' > tmp_kill_lst
    
    echo -n "Now killing jobs. "
    for job in `cat tmp_kill_lst`
    do
	echo -n "."
	kill -KILL ${job} > /dev/null 2>&1
    done
    echo "OK"
    echo ""
    
    echo "Check killed jobs..."
    ./check.sh ${node} 1 ${file}
    rm -f tmp_kill_lst
fi
