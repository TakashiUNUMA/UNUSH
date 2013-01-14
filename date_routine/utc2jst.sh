#!/bin/sh
#
# 日時処理(UTC->JST)
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

if [ ${hour} -ge 15 ]
then
    HH__=`expr ${hour} + 9`
    HH_=`expr ${HH__} - 24`
    if [ ${HH_} -lt 10 ]
    then
	HH='0'${HH_}
    else
	HH=${HH_}
    fi
    DD_1=`expr ${day} + 1`
    if test ${DD_1} -lt 10
    then
	if test ${#DD_1} -eq 2
	then
	    DD_=${DD_1}
	else
	    DD_="0${DD_1}"
	fi
    else
	DD_=${DD_1}
    fi
    if test ${month} = "01"
    then
	if test ${DD_} -eq 32
	then
	    DD=01
	    MM=02
	else
	    DD=${DD_}
	    MM=01
	fi
	YY=${year}
    elif test ${month} = "02"
    then
	ymod=`expr ${year} % 4`
	if [ ${ymod} -eq 0 ]
	then
	    if test ${DD_} -eq 30
	    then
		DD=01
		MM=03
	    else
		DD=${DD_}
		MM=02
	    fi
	else
	    if test ${DD_} -eq 29
	    then
		DD=01
		MM=03
	    else
		DD=${DD_}
		MM=02
	    fi
	fi
	YY=${year}
    elif test ${month} = "03"
    then
	if test ${DD_} -eq 32
	then
	    DD=01
	    MM=04
	else
	    DD=${DD_}
	    MM=03
	fi
	YY=${year}
    elif test ${month} = "04"
    then
	if test ${DD_} -eq 31
	then
	    DD=01
	    MM=05
	else
	    DD=${DD_}
	    MM=04
	fi
	YY=${year}
    elif test ${month} = "05"
    then
	if test ${DD_} -eq 32
	then
	    DD=01
	    MM=06
	else
	    DD=${DD_}
	    MM=05
	fi
	YY=${year}
    elif test ${month} = "06"
    then
	if test ${DD_} -eq 31
	then
	    DD=01
	    MM=07
	else
	    DD=${DD_}
	    MM=06
	fi
	YY=${year}
    elif test ${month} = "07"
    then
	if test ${DD_} -eq 32
	then
	    DD=01
	    MM=08
	else
	    DD=${DD_}
	    MM=07
	fi
	YY=${year}
    elif test ${month} = "08"
    then
	if test ${DD_} -eq 32
	then
	    DD=01
	    MM=09
	else
	    DD=${DD_}
	    MM=08
	fi
	YY=${year}
    elif test ${month} = "09"
    then
	if test ${DD_} -eq 31
	then
	    DD=01
	    MM=10
	else
	    DD=${DD_}
	    MM=09
	fi
	YY=${year}
    elif test ${month} = "10"
    then
	if test ${DD_} -eq 32
	then
	    DD=01
	    MM=11
	else
	    DD=${DD_}
	    MM=10
	fi
	YY=${year}
    elif test ${month} = "11"
    then
	if test ${DD_} -eq 31
	then
	    DD=01
	    MM=12
	else
	    DD=${DD_}
	    MM=11
	fi
	YY=${year}
    elif test ${month} = "12"
    then
	if test ${DD_} -eq 32
	then
	    DD=01
	    MM=01
	    YY=`expr ${year} + 1`
	else
	    DD=${DD_}
	    MM=12
	    YY=${year}
	fi
    else
	echo 'month error !'
	exit
    fi
elif [ ${hour} -lt 15 ]
then
    HH_=`expr ${hour} + 9`
    if [ ${HH_} -lt 10 ]
    then
	HH='0'${HH_}
    else
	HH=${HH_}
    fi
    if test ${day} -lt 10
    then
	if test ${#day} -eq 2
	then
	    DD=${day}
	else
	    DD="0${day}"
	fi
    else
	DD=${day}
    fi
    MM=${month}
    YY=${year}
fi
echo ${YY}${MM}${DD}${HH}${minute}
