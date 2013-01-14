#!/bin/sh
#
# Program of getting JMA-MSM(GRIB2) datas from Kyoto Univ.
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/11/24
#

if test $# -lt 1
then
    echo "USAGE: ./msm_get.sh yyyymmddhh"
    exit
fi

input=$1
yyyy=`echo ${input} | cut -c1-4`
mm=`echo ${input} | cut -c5-6`
dd=`echo ${input} | cut -c7-8`
hh=`echo ${input} | cut -c9-10`

echo '  '${yyyy}'/'${mm}'/'${dd}'_'${hh}':00 (JST) getting...'

#wget --wait=15 http://database.rish.kyoto-u.ac.jp/arch/jmadata/data/gpv/original/${yyyy}/${mm}/${dd}/Z__C_RJTD_${yyyy}${mm}${dd}${hh}0000_MSM_GPV_Rjp_Lsurf_FH00-15_grib2.bin

wget --wait=15 http://database.rish.kyoto-u.ac.jp/arch/jmadata/data/gpv/original/${yyyy}/${mm}/${dd}/Z__C_RJTD_${yyyy}${mm}${dd}${hh}0000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
