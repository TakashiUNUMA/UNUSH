#!/bin/sh
# 気象庁1kmメッシュ全国合成レーダーをGrADSで描く。
# 
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/11/24
#

echo '############################################'
echo '#   ** RADAR data => picture by grads **   #'
echo '############################################'


##################################################
#  Usage :  Make sure that you have
#               'jmaradar2bin'
#            in current directory.
#
#  Finally, enter the following command:
#     $ ./gd2grads.sh YYYYMMDD
#     ex) $ sh gd2grads.sh 20080513
#
#---------#---------#---------#---------#--------#
#  Preparations:
#     1 ; Get Data
#          + - Get from Kyoto-University (default)
#
#     2 ; Decode Data
#          + - Use jmaradar2bin 
#          !! Please get and compile yourself !!
#
#---------#---------#---------#---------#--------#
# What's new
#  ver.1.3 : add data-getting options.
#  ver.1.2 : add new data-getting type.
#  ver.1.1 : draw option modified.
#  ver.1.0 : add UTC2JST routine.
#  ver.0.9 : add routine of no specify date-name.
#  ver.0.8 : add the UTC=>JST option.
##################################################

## Ranges setting:
#     SLON = : start point of longitude(deg.)
#     ELON = : end point of longitude(deg.)
#     SLAT = : start point of latitude(deg.)
#     ELAT = : end point of latitude(deg.)
#     LINT = : Specifies the interval in X and Y axis.
#-------------------------------------------------
## Output Picture Type:
#  TYPE = 0 : PNG 
#       = 1 : GIF
#       = 2 : JPEG
#       = 3 : EPS
#-------------------------------------------------
## Gray Scale Option:
#  GRAY = 0 : off (color)
#       = 1 : on  (gray scale)
#-------------------------------------------------
## Coast Line Resolution:
#  MPDS = lowres
#       = mres
#       = hires
#-------------------------------------------------
SLON=130.5
ELON=136.5
SLAT=31.5
ELAT=35.5
LINT=1.0
TYPE=0
GRAY=0
MPDS=hires


##################################################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!! EXECUTE SECTION !!!!!!!!!!!!!!!!!#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
# --- date setting
ymd=$1

if test -z $1
    then
    echo '-------------------------------------'
    echo ' DATE ERROR '
    echo ' Please specify date.'
    echo ''
    echo '   (e.g.)$ ./gd2grads.sh yyyymmdd'
    echo '       yyyy = (year)'
    echo '       mm   = (month)'
    echo '       dd   = (day)'
    echo '-------------------------------------'
    exit
else
    echo ''
fi

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
echo 'DATE = '${ymd}

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

### GRAY option check ###
if [ $GRAY -eq 1 ]
    then
    echo 'GRAY = ON'
elif [ $GRAY -eq 0 ]
    then
    echo 'GRAY = OFF'
else
    echo 'GRAY option Error!'
    exit
fi
rm -rf lst tmp_lst


# -- namelist file --
echo ''
echo 'Data convert start'
for hour in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
do
    for min in 00 10 20 30 40 50
    do
	echo ${ymd}${hour}${min} >> tmp_lst
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
#    echo ${YY}${MM}${DD}${HH}${NN}
    
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

# ----------------------------- make control file
    cat > draw.ctl <<EOF
dset ^kyoudo.bin
title precipitaton dataset
undef -999.
xdef  2560  linear  118.0 0.0125
ydef  3360  linear   20.0 0.00833
zdef   1    linear    1.   1.
tdef   1    linear ${hh}:${nn}Z${dd}${mon}${yyyy} 10mn
vars   1
p 0 99 precipitation intensity derived from JMA radar (mm/hr)
endvars

EOF
# ----------------------------- make grads script
    cat > draw.gs <<EOF
### value setting ###
type=${TYPE}
gray=${GRAY}
#####################

### pre set #########
'reinit'
'open draw.ctl'
'set display color white'
'c'
'set mpdset ${MPDS}'
'set gxout shaded'
'set parea 1.5 9.5 1 7.5'
#####################

### time setting ####
'q time'
ctime1 = subwrd(result,3)
hour1  = substr(ctime1, 1,2)
tmp1   = substr(ctime1, 3,1)
if ( tmp1 = ':' )
  min1   = substr(ctime1, 4,2)
  day1   = substr(ctime1, 7,2)
  month1 = substr(ctime1, 9,3)
  year1  = substr(ctime1,12,4)
endif
if ( tmp1 = 'Z' )
  min1   = '00'
  day1   = substr(ctime1, 4,2)
  month1 = substr(ctime1, 6,3)
  year1  = substr(ctime1, 9,4)
endif

### UTC->JST ########
if ( hour1 < 15 )
  hour2_=hour1+9
  if ( hour2_ < 10 )
     hour2='0'hour2_
  endif
  if ( hour2_ >= 10 )
     hour2=hour2_
  endif
  day2=day1
endif
if ( hour1 >= 15 )
  hour2_=hour1-15
  if ( hour2_ < 10 )
     hour2='0'hour2_
  endif
  if ( hour2_ >= 10 )
    hour2=hour2_
  endif
  day2_=day1+1
  if ( day2_ < 10 )
    day2='0'day2_
  endif
  if ( day2_ >= 10 )
    day2=day2_
  endif
endif
######################


### range setting ####
'set grads off'
'set lon ${SLON} ${ELON}'
'set lat ${SLAT} ${ELAT}'
'set xlint ${LINT}'
'set ylint ${LINT}'
'set xlopts 1 1 0.15'
'set ylopts 1 1 0.15'
#'set xlab off'
#'set ylab off'
######################


## color bar #########
if (gray=0)
   'color -levs 1 5 10 20 30 50 80 -kind white->cyan->greenyellow->yellow->orange->magenta->red'
   'd p'
   'xcbar 9.7 9.9 1.2 4.5 -line on'
endif
if (gray=1)
   'color -levs 1 5 10 20 30 50 80 -kind white->black'
   'd p'
   'xcbar 9.7 9.9 1.2 4.5 -line on'
   'set gxout contour'
   'set clab off'
   'set clevs 1 5 10 20 30 50 80'
   'set ccols 0 15 1 1 15 15 1'
   'd p'
endif


###JST time label ####
# top right time label ---
    'set string 1 c 5'
    'set strsiz 0.20 0.20'
    'draw string 7.9 7.7 'hour2':'min1'JST'day2 month1 year1''
######################


### label(UTC) #######
#    'set string 1 l 2'
#    'set strsiz 0.15 0.15'
#    'draw string 1.5 0.4 UTC Time = 'hour1':'min1'UTC'day1 month1 year1''
######################

### Value name #######
'set string 1 l 5'
'set strsiz 0.20 0.20'
'draw string 1.5 7.7 ' 'JMA-RADAR(mm/h)'
######################

## picture type
if (type=0)
   'printim radar_${date}.png'
endif
if (type=1)
   'printim radar_${date}.gif'
endif
if (type=2)
   'printim radar_${date}.jpg'
endif
if (tipe=3)
   'print -R radar_${date}.eps'
endif

'quit'
EOF

# ----- draw setting for grads
    grads -blc draw.gs >& /dev/null
done

# ----- cleaning
rm -f lst
rm -f tmp_lst
rm -f kyoudo.bin 
rm -f draw*.gs
rm -f draw.ctl
rm -f tmp*
rm -f lst.bk
rm -f Z__C_RJTD_2_0_int.bin
rm -f Z__C_RJTD_*_RDR_JMAGPV_Ggis1km_Prr10lv_ANAL_grib2.bin 
rm -f Z__C_RJTD_*_RDR_JMAGPV_Gll2p5km_Phhlv_ANAL_grib2.bin
rm -f gd2grads.sh~

# ----- make directry
mkdir -p picture/${ymd}_JST
mv radar_${ymd}*.${suffix} picture/${ymd}_JST

echo ' '
echo '------------------------------------'
echo ' Save picture in picture/'${ymd}_JST
echo '         SUCCESS COMPLESSION'
echo '------------------------------------'
