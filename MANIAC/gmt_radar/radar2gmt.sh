#!/bin/sh
# 気象庁1kmメッシュ全国合成レーダーをGMTで描く。
# 
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/11/24
#

echo '############################################'
echo '#    *****  RADAR2PLOT ( by GMT)  *****    #'
echo '############################################'


##################################################
#  Usage :  Make sure that you have
#               'jmaradar2bin'                   #
#            in current directory.               #
#---------#---------#---------#---------#--------#
# What's new                                     #
#  ver.0.1 : rewrite.                            #
##################################################

## Ranges setting:
#     SLON = : start point of longitude(deg.)
#     ELON = : end point of longitude(deg.)
#     SLAT = : start point of latitude(deg.)
#     ELAT = : end point of latitude(deg.)
#-------------------------------------------------
## Output Picture Type:
#  TYPE = 0 : PNG 
#       = 1 : GIF
#       = 2 : JPEG
#       = 3 : EPS
#-------------------------------------------------
#SLON=132
#ELON=135
#SLAT=32.5
#ELAT=34.5
SLON=131.94865
ELON=134.73462
SLAT=31.94732
ELAT=34.28732
TYPE=0


##################################################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!! EXECUTE SECTION !!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
# --- date setting
ymd=$1

# Check Arguments
if test $# -lt 1
    then
    echo "USAGE: $ ./radar2gmt.sh yyyymmdd"
    echo "    yyyy    = year"
    echo "    mm      = month"
    echo "    dd      = day"
    echo " or"
    echo "USAGE: $ ./radar2gmt.sh yyyymmdd [h_start] [h_end] [h_step] [m_start] [m_end] [m_step]"
    echo "    h_start = start time of hour"
    echo "    h_end   = end time of hour"
    echo "    h_step  = step of hour"
    echo "    m_start = start time of minute"
    echo "    m_end   = end time of minute"
    echo "    m_step  = step of minute"
    echo ""
    exit
fi

# Check the Decode Program
if test -s jmaradar2bin
then
    echo "Decode program: ./jmaradar2bin"
else
    echo "'jmaradar2bin' is not found."
    echo "please visit following web site:"
    echo "http://shimizus.hustle.ne.jp/wiki/wiki.cgi?page=%A5%EC%A1%BC%A5%C0%B4%D8%CF%A2%A5%E1%A5%E2"
    echo ""
    echo "Program Stop."
    exit
fi

### TYPE option check ###
if [ $TYPE -eq 0 ]
    then
    echo 'PICTURE  = PNG'
    suffix=png
elif [ $TYPE -eq 1 ]
    then
    echo 'PICTURE  = GIF'
    suffix=gif
elif [ $TYPE -eq 2 ]
    then
    echo 'PICTURE  = JPEG'
    suffix=jpg
elif [ $TYPE -eq 3 ]
    then
    echo 'PICTURE  = EPS'
    suffix=eps
else
    echo 'PICTURE TYPE option Error!'
    exit
fi

echo 'DATE = '${ymd}

echo ''
echo 'Data convert start'

# -- Make namelist file --
if test $# -eq 1
then
    h_sta=0
    h_end=23
    hstep=1
    m_sta=0
    m_end=5
    mstep=1
elif test $# -eq 7
then
    h_sta=$2
    h_end=$3
    hstep=$4
    m_sta=$5
    m_end=$6
    mstep=$7
else
    echo "USAGE: $ ./radar2plot.sh yyyymmdd [h_start] [h_end] [h_step] [m_start] [m_end] [m_step]"
    exit
fi

rm -f lst tmp_lst
touch tmp_lst
for (( hour=${h_sta} ; hour<=${h_end} ; hour=hour+${hstep} ))
do
    for (( min=${m_sta} ; min<=${m_end} ; min=min+${mstep} ))
    do
	if test ${hour} -eq 0
	then
	    h=00
	elif test ${hour} -lt 10
	then
	    h=0${hour}
	else
	    h=${hour}
	fi
	if test ${min} -eq 0
	then
	    m=00
	else
	    m="${min}"
	fi
	echo ${ymd}${h}${m} >> tmp_lst
    done
done

for date in `cat tmp_lst`
do
    year=`echo ${date} | cut -c1-4`
    month=`echo ${date} | cut -c5-6`
    day=`echo ${date} | cut -c7-8`
    hour=`echo ${date} | cut -c9-10`
    minute=`echo ${date} | cut -c11-12`
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
    NN=${minute}

# Define UTC Time
    yyyymmddhhnn=${YY}${MM}${DD}${HH}${NN}


# -- date setting -- (RADAR data)
    yyyymmdd=`echo ${yyyymmddhhnn}|cut -c1-8`
    yyyy=`echo ${yyyymmddhhnn}|cut -c1-4`
    mm=`echo ${yyyymmddhhnn}|cut -c5-6`
    dd=`echo ${yyyymmddhhnn}|cut -c7-8`
    hh=`echo ${yyyymmddhhnn}|cut -c9-10`
    nn=`echo ${yyyymmddhhnn}|cut -c11-12`
    
# --- GrADS month setting
    if [ $mm -eq 01 ]
    then
        mon=JAN
    elif [ $mm -eq 02 ]
    then
        mon=FEB
    elif [ $mm -eq 03 ]
    then
        mon=MAR
    elif [ $mm -eq 04 ]
    then
        mon=APR
    elif [ $mm -eq 05 ]
    then
        mon=MAY
    elif [ $mm -eq 06 ]
    then
        mon=JUN
    elif [ $mm -eq 07 ]
    then
        mon=JUL
    elif [ $mm -eq 08 ]
    then
        mon=AUG
    elif [ $mm -eq 09 ]
    then
        mon=SEP
    elif [ $mm -eq 10 ]
    then
        mon=OCT
    elif [ $mm -eq 11 ]
    then
        mon=NOV
    elif [ $mm -eq 12 ]
    then
        mon=DEC
    else
        echo 'Errer 1'
        echo 'program stop'
        exit
    fi
    
    file=Z__C_RJTD_${yyyymmddhhnn}00_RDR_JMAGPV_Ggis1km_Prr10lv_ANAL_grib2.bin
###########################################
# Get Data
#------------------------------------------
# 'wget' from kyoto-university
    if test ! -s data
    then
	mkdir -p data
    fi	
    if test -s data/${file}
    then
	echo " ${file} is found."
	echo " skip wget step..."
	ln -s data/${file} ./
    else
	wget --wait=3 http://database.rish.kyoto-u.ac.jp/arch/jmadata/data/jma-radar/synthetic/original/${yyyy}/${mm}/${dd}/Z__C_RJTD_${yyyymmddhhnn}00_RDR_JMAGPV__grib2.tar
	tar xvf Z__C_RJTD_${yyyymmddhhnn}00_RDR_JMAGPV__grib2.tar
	rm -f Z__C_RJTD_${yyyymmddhhnn}00_RDR_JMAGPV__grib2.tar
	mv ${file} data/
	ln -s data/${file} ./
    fi
#------------------------------------------
########################################### 

    echo '  '${date}'JST converting...'

###########################################
# Decode Data
# -----------------------------------------
# shimizu's program
    ./jmaradar2bin ${file} kyoudo.bin >& /dev/null
#------------------------------------------
###########################################
 
    
    
#------------------------------------------
# GMT setting
    gmtdefaults -D .gmtdefaults4 > .gmtdefaults4
    gmtset HEADER_FONT Times-Roman
    gmtset HEADER_FONT_SIZE 12p
    gmtset LABEL_FONT  Times-Roman
    gmtset LABEL_FONT_SIZE  12p
    gmtset ANOT_FONT   Times-Roman
    gmtset ANOT_FONT_SIZE   10p
    gmtset BASEMAP_TYPE   plain
    gmtset TICK_LENGTH   -0.10c
    gmtset FRAME_PEN      0.25p
    gmtset GRID_PEN       0.20p
    gmtset TICK_PEN       0.25p
    gmtset PAPER_MEDIA    a4+
    gmtset MEASURE_UNIT cm

# Useful option
    gmtsta='-P -K'
    gmtcon='-P -K -O'
    gmtend='-P -O'

# Specify output file
    psfile=radar_${date}.ps

# set color palet
    CPALET=cpl.cpt
    cat << EOF > ${CPALET}
0   255 255 255    1  255 255 255
1   128 255 255    5  128 255 255
5   128 255 128    10 128 255 128
10  255 255 128    20 255 255 128
20  255 128  64    30 255 128  64
30  255 128 255    50 255 128 255
50  255  64  64   200 255  64  64
B   255 255 255
F   255 255 255
N   255 255 255
EOF

# specify color scale
    SCALE=sc.scale
    cat << EOF > ${SCALE}
0   255 255 255    1  255 255 255
1   128 255 255    5  128 255 255
5   128 255 128    10 128 255 128
10  255 255 128    20 255 255 128
20  255 128  64    30 255 128  64
30  255 128 255    50 255 128 255
50  255  64  64    80 255  64  64
B   255 255 255
F   255 255 255
N   255 255 255
EOF

    CPALET=cpl.cpt
    SCALE=sc.scale

    RANGE="118.0000/149.9875/20.00000/47.98047"
    INT="0.0125/0.00833"

# xyz2grd
    xyz2grd kyoudo.bin -Gtest.bin -R${RANGE} -I${INT} -ZBLf

# shikoku field
# set field
    RANGE="${SLON}/${ELON}/${SLAT}/${ELAT}"
# mercator
    PRJ="m2.88"
# lambelt
#    PRJ="l133.5/33.5/32.5/34.5/2.0"

# grdimage
    grdimage test.bin -J${PRJ} -R${RANGE} -C${CPALET} -X1.0 -Y1.0 ${gmtsta} > ${psfile}

# pscoast
    pscoast -J${PRJ} -R${RANGE} -W1 -A10 -Df ${gmtcon} >> ${psfile}

# psbasemap
    psbasemap -J${PRJ} -R${RANGE} -Ba1WSne -L134.3/32.2/32.3/50+lkm ${gmtcon} >> ${psfile}

# psscale
    gmtset FRAME_PEN 0.10p
    gmtset GRID_PEN  0.10p
    gmtset TICK_PEN  0.10p
    gmtset ANOT_FONT_SIZE 10p
    psscale -D8.3/2.5/5.0/0.225 -C${SCALE} -L -I ${gmtcon} >> ${psfile}

# psxy (draw circle kochi point)
    echo 133.54944 33.56806 | psxy -J${PRJ} -R${RANGE} -Sx0.25 -W2,0/0/0 ${gmtcon} >> ${psfile}

# labels (pstext)
# x     y   size angle font place comment
    cat << EOF | pstext -R1/240/1/240 -Jx1.0 -N ${gmtend} >> ${psfile}
 1.0   9.2   10   0.0   4    ML    JMA_RADAR
 9.0   9.2   10   0.0   4    MR    ${hour}:${minute}JST ${day}${mon}${year}
EOF
    rm -f test.* cpl.cpt sc.scale
    ps2raster -Te -A ${psfile}
    rm -f ${psfile}
    mv ${psfile%.ps}.eps ${psfile}
done


echo ""
# Convert File Types
for pic in `ls radar_*.ps`
do
    echo "Convert from ${pic} to ${pic%.ps}.${suffix}"
    convert ${pic} ${pic%.ps}.${suffix}
done


# --- cleaning 2
rm -f tmp_lst
rm -f radar2gmt.sh~
rm -f kyoudo.bin
rm -f Z__C_RJTD_2_0_int.bin
rm -f Z__C_RJTD_*_RDR_JMAGPV_Ggis1km_Prr10lv_ANAL_grib2.bin
rm -f Z__C_RJTD_*_RDR_JMAGPV_Gll2p5km_Phhlv_ANAL_grib2.bin


# ----- make directry
mkdir -p picture/${ymd}_JST
mv radar_${ymd}*.png picture/${ymd}_JST

echo ' '
echo '------------------------------------'
echo ' Save picture in picture/'${ymd}_JST
echo '         SUCCESS COMPLESSION'
echo '------------------------------------'
