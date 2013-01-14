#!/bin/sh
#
# Make text data from windas data 
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/11/24
#

echo '***************************'
echo '**    WINDAS => text     **'
echo '***************************'
echo ''

# Check arg
if test $# -lt 1
then
    echo "USAGE: ./windas2txt.sh [file-date-list]"
    exit
fi

# Input list file
input=$1

# Fortran Compiler Options
FC="ifort"
FCOPTIM="-O3 -assume byterecl"


# Re-format
sed s/..$//g ${input} | uniq -c | awk '{print $2}' > tmp_list

# File IO Section
echo '-- data output start --'
for date in `cat tmp_list`
do
    yyyymmdd=`echo ${date}| cut -c1-8`
    yyyy=`echo ${date}| cut -c1-4`
    mm=`echo ${date}| cut -c5-6`
    dd=`echo ${date}| cut -c7-8`
    hh=`echo ${date}| cut -c9-10`

    wprdata="wpr${yyyymmdd}.893"
    nosuffix=`echo ${wprdata} | cut -c1-11`
    ln -s data/${yyyy}${mm}/${wprdata} ./
    echo "  ${wprdata}"
    
    maxrecl=`ls -l data/${yyyy}${mm}/${wprdata} | awk '{print $5}'`
    maxrec=`expr ${maxrecl} / 2`
    
    cat > tmp_wpr_read.f <<EOF
cccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Program of windas data IO
c     Producted by Takashi Unuma, Kochi Univ.
c     Last update: 2011/11/24
c     !!! Only Kochi Site !!!
cccccccccccccccccccccccccccccccccccccccccccccccccc

      program wpr_read
      
      integer MREC
      integer i
      integer j
      integer k
      integer numh
      integer time
      integer undef
      integer height
      parameter(MREC=${maxrec})
      integer*2 data(MREC)

c     # input data
      open(10,
     &     file='${wprdata}',
     &     access='direct',
     &     form='unformatted',
     &     recl=4*MREC)
      read(10,rec=1) data
      close(10)

      write(*,*) " Station numver: ",data(1),data(2)
      write(*,*) " Longitude:      ",data(3)
      write(*,*) " Latitude:       ",data(4)
      write(*,*) " Height:         ",data(5)
      write(*,*) " Year:           ",data(6)
      write(*,*) " Month:          ",data(7)
      write(*,*) " Day:            ",data(8)
      
      do i = 9, 152, 1
         write(*,*) " Data:      ",i-8,data(i)
      enddo
      
c     ### data output section ####################
c     #  missing data check                      #
c     #  missing value = 9999                    #
c     #  'time height quality dir hvel vvel s/n' #
c     #  output by text data                     #
c     ############################################
      open(11,file='${nosuffix}.txt')
      time = 1
      numh = 9
      undef = 9999
      do j = 153, MREC, 1
         if(data(numh).eq.0) then
c            write(*,*) time,numh,data(numh)
            write(*,200) ">",
     &           data(6),data(7),data(8),time/6,mod(time,6)
            write(*,100) time,undef,2,undef,undef,undef,undef
            write(11,100) time,undef,2,undef,undef,undef,undef
            time = time + 1
            numh = numh + 1
         endif
         if(data(j).eq.394) then
c            write(*,*) time,numh,data(numh)
            write(*,200) ">",
     &           data(6),data(7),data(8),time/6,mod(time,6)
            write(*,100) time,data(j),data(j+1),
     &           data(j+2),data(j+3),data(j+4),data(j+5)
            write(11,100) time,data(j),data(j+1),
     &           data(j+2),data(j+3),data(j+4),data(j+5)
            height = 2
            k = j + 6
            do while(height.le.data(numh))
               write(*,100) time,data(k),data(k+1),
     &              data(k+2),data(k+3),data(k+4),data(k+5)
               write(11,100) time,data(k),data(k+1),
     &              data(k+2),data(k+3),data(k+4),data(k+5)
               height = height + 1
               k = k + 6
            enddo
            time = time + 1
            numh = numh + 1
         endif
      enddo

      close(11)
 100  format(i4,i7,i7,i7,i7,i7,i7)
 200  format(a2,i5,i3,i3,i4':'i1'0 (JST)')
      stop
      end program wpr_read
EOF

# execute section
    if test -s data/${yyyy}${mm}/${wprdata}
    then
	${FC} ${FCOPTIM} -o tmp_wpr_read.exe tmp_wpr_read.f
	./tmp_wpr_read.exe
	rm -f ${wprdata}
    fi
done

#  clean
rm -f tmp_wpr_read.exe
rm -f tmp_wpr_read.f 
rm -f tmp_list
rm -f windas2txt.sh~

echo "Finish."
