#!/bin/sh
#
# Make a picture from windas text data 
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/11/24
#

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# 「重要」
# このプログラムを実行する前に、windas2txt.sh を実行し、
# テキストデータに変換してから使用して下さい。
# デフォルトでは、
#  data/200805/wpr20080513.893 というデータから
# 「wpr20080513.txt」というテキストデータを吐き出します。
# そして、テキストデータをこのプログラムの引数に指定します。
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


# Check arg
if test $# -lt 1
then
    echo "USAGE: ./windastxt2gmt.sh [wprYYYYMMDD.txt]"
    exit
fi

# Execute section
for input in $*
do
    
    iyy=`echo ${input} | cut -c4-7`
    imm=`echo ${input} | cut -c8-9`
    idd=`echo ${input} | cut -c10-11`
    
    echo "Now execute = ${input}"

# make data
    awk '{print $1,$2/1000,270.0-$4,$5/20.0,$6}' ${input} | sed "s/9999/NaN/g" | sed "s/499.95/NaN/g" > data.input

# GMT option
    gmtset HEADER_FONT Times-Roman  HEADER_FONT_SIZE 20p
    gmtset LABEL_FONT  Times-Roman  LABEL_FONT_SIZE  15p
    gmtset ANOT_FONT   Times-Roman  ANOT_FONT_SIZE   15p
    gmtset TICK_LENGTH -0.5c 
    gmtset GRID_PEN     0.2p
    gmtset FRAME_PEN    0.4p
    gmtset MEASURE_UNIT cm
    gmtset VECTOR_SHAPE 2
    
# Data file
    data=data.input
    
# Post script file
    psfile="${input%.txt}.ps"
    
# start end option
    gmtsta='-P -K'
    gmtcon='-P -O -K'
    gmtend='-P -O'

# -R option
    XMIN=0
    XMAX=144
    YMIN=0
    YMAX=10
    RANGE="${XMIN}/${XMAX}/${YMIN}/${YMAX}"

# -J option
    PRJ="x0.2/1.0"

# -S option
    symb1="s0.4"
    symb2="V0.01/0.1/0.1 -G0/0/0"

# -W option
    line="2,0/0/0"

# -B option
    xgrd="a36f6g72"
    ygrd="a5f1"
    XLABEL="Time"
    YLABEL="Height (m)"

# -C option
    cat << EOF >> w.cpt
#COLOR_MODEL = RGB
#
-10.0   255     21      21      -2.5    255     21      21
-2.5    255     106     106     -1.0    255     106     106
-1.0    255     149     149     -0.5    255     149     149
-0.5    255     234     234      0      255     234     234
0       234     234     255     0.5     234     234     255
0.5     149     149     255     1.0     149     149     255
1.0     106     106     255     2.5     106     106     255
2.5     21      21      255     10.0    21      21      255
B        -       -       -
F        -       -       -
N        -       -       -
EOF

# psbasemap
    psbasemap -X4.0c -Y4.5c -R${RANGE} -J${PRJ} -B${xgrd}:"${XLABEL}":/${ygrd}:"${YLABEL}":WSne ${gmtsta} > ${psfile}


# psxy
    awk '{print $1,$2,$5}' ${data} | psxy -R -J -S${symb1} -Cw.cpt ${gmtcon} >> ${psfile} #> /dev/null 2>&1
    psxy ${data} -R -J -S${symb2} -W0.1 ${gmtcon} >> ${psfile} #> /dev/null 2>&1


# pstext
#  x     y   size angle font place comment
    pstext -R1/10/1/10 -Jx1.0 -N ${gmtend} << EOF >> ${psfile}
  1.0  11.4   20   0.0   4    ML    WINDAS
 29.8  11.4   20   0.0   4    MR    ${idd}/${imm}/${iyy}
EOF


# ps2raster
#ps2raster -Te -A ${psfile}
    ps2raster -Tg -A ${psfile}

# clean
    rm -f w.cpt
    rm -f *.ps
    rm -f draw_wd.sh~ 
    rm -f .gmt_bb_info
    rm -f .gmtcommands4
    rm -f .gmtdefaults4
done
