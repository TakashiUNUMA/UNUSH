#!/bin/sh
#
# 日時処理(JST->UTC)
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2012/01/13
#

# 引数があるかどうかチェック
if test $# -lt 1
then
    echo "USAGE: $0 yyyymmddhhnn"
    echo "   ex) $0 200805131200"
    exit
fi

# 1番目の引数をDATEに代入
DATE=$1

year=`echo ${DATE} | cut -c1-4`
month=`echo ${DATE} | cut -c5-6`
day=`echo ${DATE} | cut -c7-8`
hour=`echo ${DATE} | cut -c9-10`
minute=`echo ${DATE} | cut -c11-12`
if [ ${hour} -lt 9 ]
then
    HH__=`expr ${hour} + 24`
    HH_=`expr ${HH__} - 9`
    if [ ${HH_} -lt 10 ]
    then
	HH='0'${HH_}
    else
	HH=${HH_}
    fi
    DD_=`expr ${day} - 1`
    if [ ${DD_} -eq 0 ]
    then
	if [ ${month} -eq 01 ]
	then
	    DD=31
	    MM=12
	    YY=`expr ${year} - 1`
	elif [ ${month} -eq 02 ]
	then
	    DD=31
	    MM=01
	    YY=${year}
	elif [ ${month} -eq 03 ]
	then
	    MM=02
	    YY=${year}
	    ymod=`expr ${year} % 4`
	    if [ ${ymod} -eq 0 ]
	    then
		DD=29
	    else
		DD=28
	    fi
	elif [ ${month} -eq 04 ]
	then
	    DD=31
	    MM=03
	    YY=${year}
	elif [ ${month} -eq 05 ]
	then
	    DD=30
	    MM=04
	    YY=${year}
	elif [ ${month} -eq 06 ]
	then
	    DD=31
	    MM=05
	    YY=${year}
	elif [ ${month} -eq 07 ]
	then
	    DD=30
	    MM=06
	    YY=${year}
	elif [ ${month} -eq 08 ]
	then
	    DD=31
	    MM=07
	    YY=${year}
	elif [ ${month} -eq 09 ]
	then
	    DD=31
	    MM=08
	    YY=${year}
	elif [ ${month} -eq 10 ]
	then
	    DD=30
	    MM=09
	    YY=${year}
	elif [ ${month} -eq 11 ]
	then
	    DD=31
	    MM=10
	    YY=${year}
	elif [ ${month} -eq 12 ]
	then
	    DD=30
	    MM=11
	    YY=${year}
	else
	    echo 'month error !'
	    exit
	fi
    else
	MM=${month}
	YY=${year}
	if [ ${DD_} -lt 10 ]
	then
	    DD='0'${DD_}
	else
	    DD=${DD_}
	fi
    fi
elif [ ${hour} -ge 9 ]
then
    HH_=`expr ${hour} - 9`
    if [ ${HH_} -lt 10 ]
    then
	HH='0'${HH_}
    else
	HH=${HH_}
    fi
    DD=${day}
    MM=${month}
    YY=${year}
fi
echo ${YY}${MM}${DD}${HH}${minute}
