#!/bin/sh
#
# crop_picture.sh で切り出した画像を繋げるプログラム。
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/10/13
#


#--------------#
# date setting #
#--------------#
yyyy='2011'
mm='06'
dlist='20'
hlist='07 08'
nlist='00 20 40'

#------------------#
# directry setting #
#------------------#
dir=croped

#-------------------#
# file name setting #
#-------------------#
ofile=$1

#---------------#
# check section #
#---------------#
if test -z $ofile
then
    echo '-------------------------------------'
    echo ' Please specify output gif file name.'
    echo ''
    echo '  $ ./append_picture.sh [output-name]'
    echo 'ex) ./append_picture.sh output'
    echo '-------------------------------------'
    exit
else
    continue
fi

#----------------#
# append section #
#----------------#
n=1
for dd in ${dlist}
do
    for hh in ${hlist}
    do
	for nn in ${nlist}
	do
	    ddate=${yyyy}${mm}${dd}${hh}${nn}
	    convert -size 400x204 xc:white -font /usr/share/fonts/japanese/TrueType/sazanami-mincho.ttf -gravity center -fill black -draw "font-size 72 text 0,0 '${hh}:${nn}JST'" date_${ddate}.png
	    file1=date_${ddate}.png
	    file2=${dir}/crop_radar_${ddate}.png
	    
	    echo ' Now execute  '${ddate}
	    if test ${n} -eq 1
	    then
		convert -size 454x204 xc:white -font /usr/share/fonts/japanese/TrueType/sazanami-mincho.ttf -gravity center -fill black -draw "font-size 72 text 0,0 ''" name1.png
		convert -size 454x204 xc:white -font /usr/share/fonts/japanese/TrueType/sazanami-mincho.ttf -gravity center -fill black -draw "font-size 72 text 0,0 'JMA-RADAR'" name2.png
		convert -append name1.png ${file1} out1.png
		convert -append name2.png ${file2} out2.png
	    else
		convert -append out1.png ${file1} out1.png
		convert -append out2.png ${file2} out2.png
	    fi
	    n=`expr ${n} + 1`
	done
    done
done
echo ' Successful append files.'

convert +append out1.png out2.png ${ofile}.png


#----------#
# cleaning #
#----------#
rm -f name*.png
rm -f date_*.png
rm -f tmp[1-9]*.png
rm -f out[1-9]*.png
rm -f out_*.png
rm -f out_*.png
rm -f out1_*.png out2_*.png
rm -f append_picture.sh~

echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!! SUCCESSFUL COMPLETION !!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
