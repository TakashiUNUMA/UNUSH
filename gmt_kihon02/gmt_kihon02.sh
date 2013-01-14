#!/bin/sh
# GMTを使用して、GTOPO30の日本付近の地形図を描く
# 
# Last update: 2011/08/01

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
# (！重要！)
#  実行する前には、initial_data内にある「wget_gtopo30.sh」
#  を実行してください。
#  実行に必要なファイルの取得及び前処理を行います。
#  デフォルトでは、日本付近のデータのみを取得しますので、
#  世界地図等を書く場合には、取得するファイル名を適宜変更
#  してご使用ください。
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#


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

# ここからGMTの描画セクション
# gmtsetによるGMTの書式設定 ----------------------------------- # 
gmtset HEADER_FONT Times-Roman  HEADER_FONT_SIZE 18p
gmtset LABEL_FONT  Times-Roman  LABEL_FONT_SIZE  12p
gmtset ANOT_FONT   Times-Roman  ANOT_FONT_SIZE   10p
gmtset BASEMAP_TYPE plain
gmtset TICK_LENGTH -0.20c
gmtset FRAME_PEN    1.00p
gmtset GRID_PEN     0.50p
gmtset TICK_PEN     1.00p
gmtset MEASURE_UNIT cm

# 中間処理用の設定
gmtsta='-P -K'     # 出力初期に使用する
gmtcon='-P -K -O'  # 出力途中に使用する
gmtend='-P -O'     # 出力終了時に使用する

# 出力ファイルの指定
psfile=topo.ps

# 使用するカラーパレットの指定
CPALET="-CGMT_relief.cpt"

# 描画範囲
# 説明： 経度の始点/経度の終点/緯度の始点/緯度の終点
RANGE="120/150/24/47"

# 地図投影の種類を指定(メルカトル)
PRJ="M"

# B オプション
# a10  : 10度置きに目盛を表示する
# f1   : 1度置きに補助目盛を表示する
# g10  : 10度置きにグリッドを描画する
# WSne : 左及び下側のみ目盛の数値を描画する
BOPT="a10f1g10WSne"

# grdimage で描画
echo 'now execute grdimage'
grdimage japan.grd -J${PROJ} -R${RANGE} -B${BOPT} ${CPALET} ${gmtsta} > ${psfile}

# psscale でスケールを右下に描画
psscale -Ba1000f500 ${CPALET} -D12.3c/3c/6c/0.3c ${gmtend} -I >> ${psfile}

# ps2raster で整形
ps2raster ${psfile} -Tg -A

# remove tmp files
rm -f ${psfile}

echo 'ok'
