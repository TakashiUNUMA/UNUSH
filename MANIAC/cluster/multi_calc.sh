#!/bin/sh
################################################
# last update: 2011/07/18 (00:35JST) in centos #
# made by Takashi Unuma                        #
################################################
if test $# -lt 5
then
    echo "USAGE: ./multi_calc.sh [hostname] [node-num] [cpu-num] [exe-file] [list]"
    echo "   ex) ./multi_calc.sh rain 4 4 a.out list.input"
    exit
fi

CALCHOME=`pwd`
alias rsh="/usr/bin/rsh"

# hostname
nname=$1
# using cpu cores
ncore=$3
# execute file
exe=$4
# calculating time list
list=$5

# Number of list and total task check
dnum=`wc -l ${list} | awk '{print $1}'`
tmp=$2
anum=`expr ${tmp} \* $3`
if test ${dnum} -ne ${anum}
then
    echo "Don't match list and total task."
    exit
fi

# Cluster check
if test ${nname} = "storm"
then
    nsta=0
    nnum=`expr $2 - 1`
elif test ${nname} = "lisbon"
then
    nsta=999
    num=0
elif test ${nname} = "centos"
then
    nsta=999
    num=0
fi  

# Execute section
if test ${nsta} -eq 999 
then
    nfile=1
    for (( core=1 ; core<=${ncore} ; core++ ))
    do
	time=`head -n ${nfile} ${list} | tail -n 1 | awk '{print $1}'`

        # define using node and core
	node="${nname}"
	tmp="tmp${core}"
	DIR=${CALCHOME}"/"${node}"/"${tmp}
        
        # setup execute file
	if test ! -d ${DIR}
	then
	    mkdir -p ${DIR}
	fi
	if test ! -s ${DIR}"/"${exe}
	then
	    cp ${exe} ${DIR}/
	fi
	if test ! -s ${DIR}"/lonlat.input"
	then
	    cp lonlat.input ${DIR}/	    
	fi
	if test ! -s ${DIR}"/value.input"
	then
	    cp value.input ${DIR}/	    
	fi
	
        # execute
	cpu=`expr ${core} - 1`
	echo "Node = "${node}" Core = "${cpu}
	OUT="${CALCHOME}/rsl.out.00${num}${cpu}"
	cd ${DIR} ; ./${exe} ${time} > ${OUT} 2>&1 &
	cd ${CALCHOME}

	nfile=`expr ${nfile} + 1`
    done
else
    nfile=1
    for (( num=${nsta} ; num<=${nnum} ; num++ ))
    do
	for (( core=1 ; core<=${ncore} ; core++ ))
	do
	    time=`head -n ${nfile} ${list} | tail -n 1 | awk '{print $1}'`
	
	    # define using node and core
	    node=${nname}${num}
	    tmp="tmp${core}"
	    DIR=${CALCHOME}"/"${node}"/"${tmp}

	    # setup execute file
	    if test ! -d ${DIR}
	    then
		mkdir -p ${DIR}
	    fi
	    if test ! -s ${DIR}"/"${exe}
	    then
		cp ${exe} ${DIR}/
	    fi
	    if test ! -s ${DIR}"/lonlat.input"
	    then
		cp lonlat.input ${DIR}/	    
	    fi
	    if test ! -s ${DIR}"/value.input"
	    then
		cp value.input ${DIR}/	    
	    fi
	    
            # execute
	    cpu=`expr ${core} - 1`
	    echo "Node = "${node}" Core = "${cpu}
	    OUT="${CALCHOME}/rsl.out.00${num}${cpu}"
	    rsh ${node} -l ${USER} "cd ${DIR} ; ./${exe} ${time} > ${OUT} 2>&1 < ${OUT} &"

	    nfile=`expr ${nfile} + 1`
	done
    done
fi
