#!/bin/sh
#
# Program of NetCDF IO (WRF's NetCDF data)
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/11/24
#

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# [注意]
# このプログラムを実行するためには、NetCDFが必要です。
# NetCDFのコンパイル時のコンパイラーと、このプログラムを実
# 行するときのコンパイラーは、同じになるようにして下さい。
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# NetCDF
NETCDF='/usr/local/netcdf-3.6.3-intelxe'

# Compile Options
FC='ifort'
FCOPTIM='-O3 -assume byterecl'

# Input file, Var and Ratio
ncfile=$1
var=$2
ratio=$3

# Check args
if test -z $ncfile
then
    echo '-------------------------------------'
    echo ' INPUT NETCDF FILE ERROR '
    echo ' Please specify NetCDF file.'
    echo ''
    echo '   (e.g.)$ ./nc2nc geo_em.d01.nc HGT_M 0.5'
    echo '-------------------------------------'
    exit
else
    if test -z $var
    then
	echo '-------------------------------------'
	echo ' INPUT VALUE ERROR '
	echo ' Please specify VALUE.'
	echo ''
	echo '   (e.g.)$ ./nc2nc geo_em.d01.nc HGT_M 0.5'
	echo '-------------------------------------'
	exit
    else
	if test -z $ratio
	then
	    echo '-------------------------------------'
	    echo ' INPUT RATIO ERROR '
	    echo ' Please specify ratio.'
	    echo ''
	    echo '   (e.g.)$ ./nc2nc geo_em.d01.nc HGT_M 0.5'
	    echo '-------------------------------------'
	    exit
	else
	    continue
	fi
    fi
fi

#--- get ncnx, ncny
ncnx=`ncdump -h ${ncfile} | grep 'west_east =' | awk '{print $3}'`
ncny=`ncdump -h ${ncfile} | grep 'south_north =' | awk '{print $3}'`
#--- get staggered ncnx, ncny
sncnx=`ncdump -h ${ncfile} | grep 'west_east_stag =' | awk '{print $3}'`
sncny=`ncdump -h ${ncfile} | grep 'south_north_stag =' | awk '{print $3}'`


# display parameters
echo ' ##### Parapeters #####'
echo '   FC           = '${FC}
echo '   FCOPTIM      = '${FCOPTIM}
echo '   NETCDF       = '${NETCDF}
echo '   INPUT FILE   = '${ncfile}
echo '    x grid num  = '${ncnx}
echo '    y grid num  = '${ncnx}
echo '    staggered x = '${sncnx}
echo '    staggered y = '${sncnx}
echo '   RATIO        = '${ratio}
echo ' ######################'
echo ''
sleep 1 &
wait $!

#--- adjust staggered grid
stag=`ncdump -h ${ncfile} | grep "${var}:stagger" | awk '{print $3}' | sed "s/^\"//" | sed "s/\"$//"`
#stag="M"
if test ${stag} = "M"
then
    numx=${ncnx}
    numy=${ncny}
elif test ${stag} = "U"
then
    numx=${sncnx}
    numy=${ncny}
elif test ${stag} = "V"
then
    numx=${ncnx}
    numy=${sncny}
else
    echo 'stag error.'
    exit
fi


#--- program part
cat > tmp_nc2nc.f <<EOF
c----6----+---------+---------+---------+---------+----------+----------+
      program nc2nc
      include 'netcdf.inc'

c     ### netcdf file dimention
      parameter(x=${numx})
      parameter(y=${numy})
      integer ncid
      integer status
      integer rhid
      real sla(x,y)
      character filename*45
      character var*10

c     ### input netcdf file
      filename='${ncfile}'
      var='${var}'

c     ### file open
      status=nf_open(filename,nf_write,ncid)
      if (status.ne.nf_noerr) call handle_err(status)

c     ### get value infomation
      status=nf_inq_varid(ncid,var,rhid)
      if (status.ne.nf_noerr) call handle_err(status)

c     ### read value data
      status=nf_get_var_real(ncid,rhid,sla)
      if (status.ne.nf_noerr) call handle_err(status)

c     ### rewrite value data
      do 10 j=1,y
         do 20 i=1,x
            if (sla(i,j).gt.1.0) then
               sla(i,j)=sla(i,j)*${ratio}
            end if
 20      continue
 10   continue
      status = nf_put_var_real(ncid,rhid,sla)
      if (status.ne.nf_noerr) call handle_err(status)

c     ### file close
      status=nf_put_var_real(ncid,rhid,sla)
      if (status.ne.nf_noerr) call handle_err(status)
      stop
      end program nc2nc


c----------------------------------------
      subroutine handle_err(status)
c     error subroutine
c----------------------------------------
      integer status
      write(*,*) nf_strerror(status)
      write(*,*) 'PROGRAM ERROR!!!'
      stop
      end subroutine handle_err
c----6----+---------+---------+---------+---------+----------+----------+
EOF


#--- compile
${FC} ${FCOPTIM} -I${NETCDF}/include tmp_nc2nc.f -L${NETCDF}/lib -lnetcdf -o nc2nc.exe


#--- execute
echo ' Rewrite '${var}
echo '  staggered type = '${stag}
echo '  x grid num     = '${numx}
echo '  y grid num     = '${numy}
./nc2nc.exe



#---cleaning
rm -f tmp*.* *~ nc2nc.exe

echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!! SUCCESSFUL COMPLETION !!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
