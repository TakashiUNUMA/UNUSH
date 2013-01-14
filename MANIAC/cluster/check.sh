#!/bin/sh
################################################
# last update: 2011/08/01 (09:13JST) in centos #
# made by Takashi Unuma                        #
################################################
# check
if test $# -lt 3
then
    echo "USAGE: ./check.sh [hostname] [number-of-node] [executing-file]"
    exit
fi

alias rsh="/usr/bin/rsh"
node=$1
file=$3
if test ${node} = "storm"
then
    nsta=0
    nnum=`expr $2 - 1`
elif test ${node} = "lisbon"
then
    nsta=999
    num=0
elif test ${node} = "centos"
then
    nsta=999
    num=0
fi  

if test ${nsta} -eq 999
then
    echo ${node}
    top -b -n 1 | grep "${file}"
else
    for (( num=${nsta} ; num<=${nnum} ; num++ ))
    do
	if test ${node} = "rain"
	then
	    if test ${num} -eq 1
	    then
		echo "${node}${num}"
		top -b -n 1 | grep "${file}"
	    elif test ${num} -eq 2
	    then
		num=`expr ${num} + 1`
		echo "${node}${num}"
		rsh ${node}${num} top -b -n 1 | grep "${file}"
	    else
		echo "${node}${num}"
		rsh ${node}${num} top -b -n 1 | grep "${file}"
	    fi
	else
	    if test ${num} -eq 0
	    then
		echo "${node}${num}"
		top -b -n 1 | grep "${file}"
	    else
		echo "${node}${num}"
		rsh ${node}${num} top -b -n 1 | grep "${file}"
	    fi
	fi
    done
fi
