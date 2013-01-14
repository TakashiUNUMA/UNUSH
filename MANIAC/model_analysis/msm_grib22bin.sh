#!/bin/sh
#
# Make binary datas and CTL files for GrADS from MSM-P
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/11/24
#

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# [注意]
# このプログラムを実行する前に、「GRIB2-data」という
# ディレクトリ内にある、「get_msm_grib2.sh」を実行します。
# get_msm_grib2.sh は、任意の時刻のMSMデータを取得します。
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


echo '################################################'
echo '# JMA-MSM(GRIB2) => Binary datas and CTL files #'
echo '################################################'

#---------#---------#---------#---------#--------#--------#
###########################################################
#                                                         #
#  1. convert MSM-P grib2 binary data.                    #
#      \-- tmp_grib2bin.f                                 #
#  2. calculate stability index and thermo parameter.     #
#      \-- tmp_bin2ip.f                                   #
#  3. draw picture(.png file) by GrADS.                   #
#      \-- tmp_draw.gs, tmp_read?.ctl                     #
#                                                         #
#---------#---------#---------#---------#--------#--------#
#                                                         #
#  Usage: Choose date in 'config parameter':              #
#          ymd='20080512 20080513' !"date                 #
#          hour='00 06 12 18'      !"hour                 #
#          data_dir=GRIB2-data     !"grib2 data directry  #
#                                                         #
#         Finally, enter the following command:           #
#          $ ./make_data.sh                               #
#                                                         #
###########################################################
#---------#---------#---------#---------#--------#--------#

# config parameter
ymd='20080513'
hour='00'
data_dir=GRIB2-data

# Compiler option
FC=ifort
FCOPTIM='-O3 -convert big_endian -assume byterecl'


for date in ${ymd}
do
    yyyy=`echo ${date} | cut -c1-4`
    mm=`echo ${date} | cut -c5-6`

    for hh in ${hour}
    do
	ifile=Z__C_RJTD_${date}${hh}0000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
	ln -s ${data_dir}/${ifile} .
    done
  
    for hh in ${hour}
    do
	file=Z__C_RJTD_${date}${hh}0000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
	if test -s ${file}
	then
	    echo ' '${file}' is found.'
	else
	    echo ' ** '${file}' is not found. ** '
	    echo ' program stop'
	    rm -f Z__C_RJTD_*_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
	    exit
	fi
    done
    
    echo ''
    echo  " ### UNGRIB SECTION ### "

    flag1='-i -no_header'
    flag2='-append -ieee'
    for value in HGT UGRD VGRD TMP VVEL RH
    do
	for hh in ${hour}
	do
	    echo ' ** Value = '${value}' , Hour = '${hh}' ** '
	    ifile=Z__C_RJTD_${date}${hh}0000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
	    ofile=${value}_${date}${hh}.bin
	    wgrib2 ${ifile} | grep anl | grep ${value} | wgrib2 ${flag1} ${ifile} ${flag2} ${ofile} > /dev/null 2>&1
	done
    done
    
    echo  " ### SUCCESFULL UNGRIB ### "
    echo ""
    
    
    echo  " ###  EXECUTE SECTION  ### "
    cat > tmp_grib2bin.f << EOF
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Make GrADS binary data from MSM-P
c     Initial code : SIA PACK
c       Web: http://ssrs.dpri.kyoto-u.ac.jp/~ishizuka/
c
c     Modified by Takashi Unuma, Kochi Univ.
c     Last update: 2011/11/24
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      program msm_p

c-----### parameter set
      integer imax
      integer jmax
      integer kmax1
      integer kmax2
      integer nvar16
      integer nvar12
      integer lrecl             !" record length
      integer time
      parameter (imax=241)      !" lon grid point
      parameter (jmax=253)      !" lat grid point
      parameter (kmax1=16)      !" 16 lev grid point
      parameter (kmax2=12)      !" 12 lev grid point
      parameter (nvar16=5)      !" 16 level variable
      parameter (nvar12=1)      !" 12 level variable
      parameter
     &(lrecl=(imax*jmax*kmax1*nvar16 + imax*jmax*kmax2*nvar12)*4)
      parameter (lrecl1=imax*jmax*kmax1*4)
      parameter (lrecl2=imax*jmax*kmax2*4)

c-----### io value set
      real*4 z(imax,jmax,kmax1) !" Z (16 lev)
      real*4 u(imax,jmax,kmax1) !" U (16 lev)
      real*4 v(imax,jmax,kmax1) !" V (16 lev)
      real*4 temp(imax,jmax,kmax1) !" TEMP (16 lev)
      real*4 w(imax,jmax,kmax1) !" Vertical p-velocity (16 lev)
      real*4 rh(imax,jmax,kmax2) !" Relative Humidity (12 lev)

c-----### input file open
c---  # HGT
      open(11,file="HGT_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # UGRD
      open(12,file="UGRD_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # VGRD
      open(13,file="VGRD_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # TMP
      open(14,file="TMP_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # VVEL
      open(15,file="VVEL_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # RH
      open(16,file="RH_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl2)

c-----### output file open
      open(20,file="msm-p_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='unknown',
     & recl=lrecl)

      time=1
      read(11,rec=time) z
      read(12,rec=time) u
      read(13,rec=time) v
      read(14,rec=time) temp
      read(15,rec=time) w
      read(16,rec=time) rh
      write(20,rec=time) z, u, v, temp, w, rh

      close(11)
      close(12)
      close(13)
      close(14)
      close(15)
      close(16)
      close(20)
      stop
      end
EOF
    
    echo ' Date = '${date}
    for hh in ${hour}
    do
	echo '   Hour = '${hh}
	sed s/HH/${hh}/g tmp_grib2bin.f > tmp_.f
	ifort -O3 -assume byterec -convert big_endian tmp_.f -o tmp_grib2bin.exe
	./tmp_grib2bin.exe
	rm -f tmp_grib2bin.exe
	rm -f tmp_.f
    done
    rm -f Z__C_RJTD_*0000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
    echo  " ### SUCCESFULL EXECUTE ### "
    echo ''
done

# Make CTL files
cat > tmp_read0.ctl << EOF
dset     ^msm-p_%y4%m2%d2%h2.bin
title    JMA MSM-GPV pressure-level data
undef    9.999e20
options  big_endian
options  template
xdef     241  linear  120.0  0.125
ydef     253  linear  22.4   0.1
zdef     16   levels  1000 975 950 925 900 850 800 700 600 500 400 300 250 200 150 100
tdef     8    linear  HHZDDMMYYYY 03hr
vars     6
z        16 -99 ** Geopotential Height (m,gpm)
u        16 -99 ** Zonal Wind Speed (m/s)
v        16 -99 ** Meridional Wind Speed (m/s)
temp     16 -99 ** Temperature (C) (K)
w        16 -99 ** Vertical p-velocity (hPa/h) (Pa/s)
rh       12 -99 ** Relative Humidity (%)
endvars
EOF


### Config GrADS's control file ###
for date in ${ymd}
do
    yyyy=`echo ${date} | cut -c1-4`
    mm=`echo ${date} | cut -c5-6`
    dd=`echo ${date} | cut -c7-8`
    
    if [ $mm -eq 01 ]
    then
	MM=JAN
    elif [ $mm -eq 02 ]
    then
	MM=FEB
    elif [ $mm -eq 03 ]
    then
	MM=MAR
    elif [ $mm -eq 04 ]
    then
	MM=APR
    elif [ $mm -eq 05 ]
    then
	MM=MAY
    elif [ $mm -eq 06 ]
    then
	MM=JUN
    elif [ $mm -eq 07 ]
    then
	MM=JUL
    elif [ $mm -eq 08 ]
    then
	MM=AUG
    elif [ $mm -eq 09 ]
    then
	MM=SEP
    elif [ $mm -eq 10 ]
    then
	MM=OCT
    elif [ $mm -eq 11 ]
    then
	MM=NOV
    elif [ $mm -eq 12 ]
    then
	MM=DEC
    else
	echo 'Errer 1'
	echo 'program stop'
	rm -f grib2ip.sh~
	rm -f tmp_grib2bin.f
	rm -f tmp_grib2bin.exe
	rm -f HGT_*.bin
	rm -f RH_*.bin
	rm -f TMP_*.bin
	rm -f UGRD_*.bin
	rm -f VGRD_*.bin
	rm -f VVEL_*.bin
	rm -f tmp_read?.ctl
	rm -f tmp_?.ctl
	rm -f tmp_draw.gs
	rm -f msm-p_200*.bin
	exit
    fi
  # ----- draw setting for grads
    sed 's/HHZDDMMYYYY/00Z'${dd}${MM}${yyyy}'/g' tmp_read0.ctl > msm-p.ctl
done


# clean 1
rm -f make_data.sh~
rm -f tmp_grib2bin.f
rm -f tmp_grib2bin.exe

# clean 2
rm -f HGT_*.bin
rm -f RH_*.bin
rm -f TMP_*.bin
rm -f UGRD_*.bin
rm -f VGRD_*.bin
rm -f VVEL_*.bin

# clean 3
rm -f tmp_read?.ctl


echo  " !!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
echo  " !!! SUCCESFULL COMPLETION !!! "
echo  " !!!!!!!!!!!!!!!!!!!!!!!!!!!!! "#!/bin/sh
echo '###########################################'
echo '#  JMA-MSM(GRIB2) => Binary => Calculate  #'
echo '#             make_data.sh script ver.0.1 #'
echo '#              Producted by Takashi Unuma #'
echo '#              Last modified : 2011/09/20 #'
echo '###########################################'

#---------#---------#---------#---------#--------#--------#
###########################################################
#                                                         #
#  1. convert MSM-P grib2 binary data.                    #
#      \-- tmp_grib2bin.f                                 #
#  2. calculate stability index and thermo parameter.     #
#      \-- tmp_bin2ip.f                                   #
#  3. draw picture(.png file) by GrADS.                   #
#      \-- tmp_draw.gs, tmp_read?.ctl                     #
#                                                         #
#---------#---------#---------#---------#--------#--------#
#                                                         #
#  Usage: Choose date in 'config parameter':              #
#          ymd='20080512 20080513' !"date                 #
#          hour='00 06 12 18'      !"hour                 #
#          data_dir=GRIB2-data     !"grib2 data directry  #
#                                                         #
#         Finally, enter the following command:           #
#          $ ./make_data.sh                               #
#                                                         #
###########################################################
#---------#---------#---------#---------#--------#--------#

### config parameter ###
ymd='20080513'
hour='00'
data_dir=GRIB2-data

##-optimization option-#
FC=ifort
FCOPTIM='-O3 -convert big_endian -assume byterecl'


for date in ${ymd}
do
###__set parameter___###
    yyyy=`echo ${date} | cut -c1-4`
    mm=`echo ${date} | cut -c5-6`

###_____data link____###
    for hh in ${hour}
    do
	ifile=Z__C_RJTD_${date}${hh}0000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
	ln -s ${data_dir}/${ifile} .
    done
  
###____data check____###
    for hh in ${hour}
    do
	file=Z__C_RJTD_${date}${hh}0000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
	if test -s ${file}
	then
	    echo ' '${file}' is found.'
	else
	    echo ' ** '${file}' is not found. ** '
	    echo ' program stop'
	    rm -f Z__C_RJTD_*_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
	    exit
	fi
    done
    
    echo ''
    echo  " ### UNGRIB SECTION ### "
###___data ungrib____###
    flag1='-i -no_header'
    flag2='-append -ieee'
    for value in HGT UGRD VGRD TMP VVEL RH
    do
	for hh in ${hour}
	do
	    echo ' ** Value = '${value}' , Hour = '${hh}' ** '
	    ifile=Z__C_RJTD_${date}${hh}0000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
	    ofile=${value}_${date}${hh}.bin
	    wgrib2 ${ifile} | grep anl | grep ${value} | wgrib2 ${flag1} ${ifile} ${flag2} ${ofile} > /dev/null 2>&1
	done
    done
    
    echo  " ### SUCCESFULL UNGRIB ### "
    echo ""
    
    
    echo  " ###  EXECUTE SECTION  ### "
    cat > tmp_grib2bin.f << EOF
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Make GrADS binary data from MSM-P
c     Initial code : SIA PACK
c       Web: http://ssrs.dpri.kyoto-u.ac.jp/~ishizuka/
c
c     Modified by Takashi Unuma, Kochi Univ.
c     Last update: 2011/11/24
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      program msm_p

c-----### parameter set
      integer imax
      integer jmax
      integer kmax1
      integer kmax2
      integer nvar16
      integer nvar12
      integer lrecl             !" record length
      integer time
      parameter (imax=241)      !" lon grid point
      parameter (jmax=253)      !" lat grid point
      parameter (kmax1=16)      !" 16 lev grid point
      parameter (kmax2=12)      !" 12 lev grid point
      parameter (nvar16=5)      !" 16 level variable
      parameter (nvar12=1)      !" 12 level variable
      parameter
     &(lrecl=(imax*jmax*kmax1*nvar16 + imax*jmax*kmax2*nvar12)*4)
      parameter (lrecl1=imax*jmax*kmax1*4)
      parameter (lrecl2=imax*jmax*kmax2*4)

c-----### io value set
      real*4 z(imax,jmax,kmax1) !" Z (16 lev)
      real*4 u(imax,jmax,kmax1) !" U (16 lev)
      real*4 v(imax,jmax,kmax1) !" V (16 lev)
      real*4 temp(imax,jmax,kmax1) !" TEMP (16 lev)
      real*4 w(imax,jmax,kmax1) !" Vertical p-velocity (16 lev)
      real*4 rh(imax,jmax,kmax2) !" Relative Humidity (12 lev)

c-----### input file open
c---  # HGT
      open(11,file="HGT_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # UGRD
      open(12,file="UGRD_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # VGRD
      open(13,file="VGRD_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # TMP
      open(14,file="TMP_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # VVEL
      open(15,file="VVEL_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl1)
c---  # RH
      open(16,file="RH_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='old',
     & recl=lrecl2)

c-----### output file open
      open(20,file="msm-p_${date}HH.bin",
     & form='unformatted',
     & access='direct',
     & status='unknown',
     & recl=lrecl)

      time=1
      read(11,rec=time) z
      read(12,rec=time) u
      read(13,rec=time) v
      read(14,rec=time) temp
      read(15,rec=time) w
      read(16,rec=time) rh
      write(20,rec=time) z, u, v, temp, w, rh

      close(11)
      close(12)
      close(13)
      close(14)
      close(15)
      close(16)
      close(20)
      stop
      end
EOF
    
###______execute_____###
    echo ' Date = '${date}
    for hh in ${hour}
    do
	echo '   Hour = '${hh}
	sed s/HH/${hh}/g tmp_grib2bin.f > tmp_.f
	ifort -O3 -assume byterec -convert big_endian tmp_.f -o tmp_grib2bin.exe
	./tmp_grib2bin.exe
	rm -f tmp_grib2bin.exe
	rm -f tmp_.f
    done
    rm -f Z__C_RJTD_*0000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin
    echo  " ### SUCCESFULL EXECUTE ### "
    echo ''
done

### control files ###
# msm-p 
cat > tmp_read0.ctl << EOF
dset     ^msm-p_%y4%m2%d2%h2.bin
title    JMA MSM-GPV pressure-level data
undef    9.999e20
options  big_endian
options  template
xdef     241  linear  120.0  0.125
ydef     253  linear  22.4   0.1
zdef     16   levels  1000 975 950 925 900 850 800 700 600 500 400 300 250 200 150 100
tdef     8    linear  HHZDDMMYYYY 03hr
vars     6
z        16 -99 ** Geopotential Height (m,gpm)
u        16 -99 ** Zonal Wind Speed (m/s)
v        16 -99 ** Meridional Wind Speed (m/s)
temp     16 -99 ** Temperature (C) (K)
w        16 -99 ** Vertical p-velocity (hPa/h) (Pa/s)
rh       12 -99 ** Relative Humidity (%)
endvars
EOF


### Config GrADS's control file ###
for date in ${ymd}
do
    yyyy=`echo ${date} | cut -c1-4`
    mm=`echo ${date} | cut -c5-6`
    dd=`echo ${date} | cut -c7-8`
    
    if [ $mm -eq 01 ]
    then
	MM=JAN
    elif [ $mm -eq 02 ]
    then
	MM=FEB
    elif [ $mm -eq 03 ]
    then
	MM=MAR
    elif [ $mm -eq 04 ]
    then
	MM=APR
    elif [ $mm -eq 05 ]
    then
	MM=MAY
    elif [ $mm -eq 06 ]
    then
	MM=JUN
    elif [ $mm -eq 07 ]
    then
	MM=JUL
    elif [ $mm -eq 08 ]
    then
	MM=AUG
    elif [ $mm -eq 09 ]
    then
	MM=SEP
    elif [ $mm -eq 10 ]
    then
	MM=OCT
    elif [ $mm -eq 11 ]
    then
	MM=NOV
    elif [ $mm -eq 12 ]
    then
	MM=DEC
    else
	echo 'Errer 1'
	echo 'program stop'
	rm -f grib2ip.sh~
	rm -f tmp_grib2bin.f
	rm -f tmp_grib2bin.exe
	rm -f HGT_*.bin
	rm -f RH_*.bin
	rm -f TMP_*.bin
	rm -f UGRD_*.bin
	rm -f VGRD_*.bin
	rm -f VVEL_*.bin
	rm -f tmp_read?.ctl
	rm -f tmp_?.ctl
	rm -f tmp_draw.gs
	rm -f msm-p_200*.bin
	exit
    fi
  # ----- draw setting for grads
    sed 's/HHZDDMMYYYY/00Z'${dd}${MM}${yyyy}'/g' tmp_read0.ctl > msm-p.ctl
done


# clean 1
rm -f make_data.sh~
rm -f tmp_grib2bin.f
rm -f tmp_grib2bin.exe

# clean 2
rm -f HGT_*.bin
rm -f RH_*.bin
rm -f TMP_*.bin
rm -f UGRD_*.bin
rm -f VGRD_*.bin
rm -f VVEL_*.bin

# clean 3
rm -f tmp_read?.ctl


echo  " !!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
echo  " !!! SUCCESFULL COMPLETION !!! "
echo  " !!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
