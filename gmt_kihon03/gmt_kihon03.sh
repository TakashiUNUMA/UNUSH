#!/bin/sh
# GMTを使用して、GTOPO30の日本付近の地形図を描く
#   3次元立体バージョン
# 
# Last update: 2011/09/09
#

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
# (！重要！)
#  実行する前には、initial_data内にある「wget_gtopo30.sh」
#  を実行してください。
#  実行に必要なファイルの取得及び前処理を行います。
#  デフォルトでは、日本付近のデータのみを取得しますので、
#  世界地図等を書く場合には、取得するファイル名を適宜変更
#  してご使用ください。
#  
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#

# 描画させたい範囲の指定
slon=132.0
elon=135.0
slat=32.5
elat=34.5



# initial_data内に取得した日本付近のデータを指定する。
files="E100N40.DEM E100N90.DEM E140N40.DEM E140N90.DEM"

# 取得したデータは分割されているので、
# GMTで処理しやすいようにデータを結合する
if test -s japan.grd
then
    echo 'skip making data.'
else
    for file in ${files}
    do
	ln -s initial_data/${file} ./
	if test ${file} = "E100N40.DEM"
	then
	    RANGE="100/140/-10/40"
	elif test ${file} = "E100N90.DEM"
	then
	    RANGE="100/140/40/90"
	elif test ${file} = "E140N40.DEM"
	then
	    RANGE="140/180/-10/40"
	elif test ${file} = "E140N90.DEM"
	then
	    RANGE="140/180/40/90"
	else
	    echo 'program stop'
	    exit
	fi
	# xyz2grd でgrdファイルを作成。
	# オプション等はおまじないとして実行する。
	xyz2grd ${file} -G${file%.DEM}.grd -Dm/m/m/1/0/=/= -R${RANGE} -I30c -N-9999 -V -ZTLhw -F
    done
    # リンクの消去
    rm -f E*.DEM

    # grdpaste (東側を作成)
    echo 'now making east data'
    grdpaste E140N40.grd E140N90.grd -Geast.grd

    # grdpaste (西側を作成)
    echo 'now making west data'
    grdpaste E100N40.grd E100N90.grd -Gwest.grd

    # grdpaset (日本域の結合したファイルを作成)
    echo 'now making japan data'
    grdpaste east.grd west.grd -Gjapan.grd

    # remove tmp. files
    rm -r E*.grd east.grd west.grd
    echo 'SUCCESS.'
fi


# make data
echo "Now execute grd2xyz"
grd2xyz japan.grd -R${slon}/${elon}/${slat}/${elat} > output.txt
input=output.txt

# ここからGMTの描画セクション
# gmtsetによるGMTの書式設定 ----------------------------------- #
gmtset HEADER_FONT Times-Roman  HEADER_FONT_SIZE 20p
gmtset LABEL_FONT  Times-Roman  LABEL_FONT_SIZE  20p
gmtset ANOT_FONT   Times-Roman  ANOT_FONT_SIZE   20p
gmtset TICK_LENGTH -0.5c 
gmtset GRID_PEN     0.2p
gmtset FRAME_PEN    0.4p
gmtset MEASURE_UNIT cm
    
# Data file
data=${input}
    
# 出力ファイルの指定
psfile="${input%.txt}.ps"

# 中間処理用の設定
gmtsta='-P -K'
gmtcon='-P -O -K'
gmtend='-P -O'

# -R option
XMIN=${slon}
XMAX=${elon}
YMIN=${slat}
YMAX=${elat}
ZMIN=0
ZMAX=6000
RANGE="${XMIN}/${XMAX}/${YMIN}/${YMAX}/${ZMIN}/${ZMAX}"

# -J option
HPRJ="x5"
VPRJ="z0.00075"

# -E option
LIGHT="90/30"
VIEW="150/30"

# -S option
symb="c0.2 -G255/0/0"

# -W option
line="6,255/0/0"

# -B option
xgrd="a1f0.5"
ygrd="a1f0.5"
zgrd="a3000f500"
XLABEL="Longitude"
YLABEL="Latitude"
ZLABEL="Height"

# xyz2grd
echo "Now execute xyz2grd"
xyz2grd ${input} -G${input%.txt}.grd1 -R${RANGE} -I0.01

# grdgradient
echo "Now execute grdgradient"
grdgradient ${input%.txt}.grd1 -A${LIGHT} -G${input%.txt}.grd2

# grdhisteq
echo "Now execute grdhisteq"
grdhisteq ${input%.txt}.grd2 -G${input%.txt}.grd3 -N

# grdmath
echo "Now execute grdmath"
grdmath ${input%.txt}.grd3 2. / = ${input%.txt}.grd4 > /dev/null 2>&1

# grdview
echo "Now execute grdview"
grdview ${input%.txt}.grd1 -J${HPRJ} -J${VPRJ} -R${RANGE} -B${xgrd}:"${YLABEL}":/${ygrd}:"${YLABEL}":/${zgrd}:"${ZLABEL}":WSneZ+ -N0/100/200/100 -Qsm -I${input%.txt}.grd4 -CGMT_relief.cpt -E${VIEW} ${gmtsta} > ${psfile}


# pstext
#  x     y   size angle font place comment
#cat << EOF | pstext -R1/10/1/10 -Jx1.0 -N ${gmtend} >> ${psfile}
# -2.0  19.0    1   0.0   4    MC    .
# 19.0  19.0    1   0.0   4    MC    .
# -2.0  -2.0    1   0.0   4    MC    .
# 19.0  -2.0    1   0.0   4    MC    .
#EOF


# ps2raster
echo "Now execute ps2raster"
#ps2raster -Te -A ${psfile}
ps2raster -Tg -A ${psfile}

# clean
rm -f *grd[1-4] 
rm -f *.ps
rm -f draw_3Dtopo.sh~ 
rm -f .gmt_bb_info
rm -f .gmtcommands4
rm -f .gmtdefaults4
