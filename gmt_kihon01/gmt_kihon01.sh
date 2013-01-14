#!/bin/sh
# GMTを使用して、AMeDASの1時間値を時系列に描いてみる
# 
# Last update: 2011/07/31


# アメダスデータ作成
cat > data.txt << EOF
  1 1010.3   -  18.6 68 1.5
  2 1009.2   -  18.2 70 2.4
  3 1009.8   -  17.7 71 1.0
  4 1010.3   -  17.1 75 1.9
  5 1010.8   -  17.0 74 1.9
  6 1011.5   -  17.2 74 1.2
  7 1012.2  1.0 16.0 86 1.1
  8 1012.2  0.5 16.4 87 1.9
  9 1012.2  0.5 17.4 84 1.1
 10 1012.9  4.0 16.6 92 2.8
 11 1013.4 11.0 16.2 94 1.7
 12 1013.2 16.0 15.9 93 0.6
 13 1012.9 31.5 15.8 96 1.2
 14 1012.3 17.0 16.1 95 1.2
 15 1012.0 11.0 17.1 90 2.2
 16 1011.4 20.5 16.8 95 2.0
 17 1011.3 39.5 17.6 93 3.3
 18 1010.4 20.0 17.8 91 3.0
 19 1011.0  0.5 18.7 83 1.9
 20 1011.2  0.5 16.1 88 2.6
 21 1011.5 10.0 15.6 92 2.1
 22 1011.0 38.5 15.5 96 1.0
 23 1011.6  5.0 15.4 97 1.7
 24 1011.1  3.5 15.2 96 0.9
EOF


# gmtsetによるGMTの書式設定 ----------------------------------- #
gmtset HEADER_FONT Times-Roman  HEADER_FONT_SIZE 18p
gmtset LABEL_FONT  Times-Roman  LABEL_FONT_SIZE  15p
gmtset ANOT_FONT   Times-Roman  ANOT_FONT_SIZE   14p
gmtset TICK_LENGTH +0.36c
gmtset FRAME_PEN    1.70p
gmtset GRID_PEN     1.70p
gmtset TICK_PEN     1.70p
gmtset MEASURE_UNIT cm

# 入力ファイルの指定
file=data.txt

# 出力ファイルの指定
psfile=output.ps

# 中間処理用の設定
gmtsta='-P -K'     # 出力初期に使用する
contin='-P -O -K'  # 出力途中に使用する
gmtend='-P -O'     # 出力終了時に使用する


# 描画セクション ---------------------------------------------- #
# 相対湿度(%)を一番下の列に描く
#   RANGE: x軸の最小値/x軸の最大値/y軸の最小値/y軸の最大値
#   PRJ:   描画する際の縦横比
RANGE="-0.5/25.5/60/100.0"
PRJ="X10.0c/5.0c"
psbasemap -X6.0c -Y3.0c -R${RANGE} -J${PRJ} -Ba6g6:"Time (hour)":/a10f5g10:"RH (%)":WSne ${gmtsta} > ${psfile}

awk '{print $1,$5}' ${file} | psxy -R -J -W0.06c ${contin} >> ${psfile}

# 気温(℃)を下から二番目の列に描く
RANGE="-0.5/25.5/10/20"
PRJ="X10.0c/5.0c"
psbasemap -X0.0c -Y5.5c -R${RANGE} -J${PRJ} -Bg6/a1f0.5g2:"Temperture (@~\260@~C)":Wsne ${contin} >> ${psfile}
awk '{print $1,$4}' ${file} | psxy -R -J -W0.06c ${contin} >> ${psfile}


# 風速(m/s)を上から二番目の列に描く
RANGE="-0.5/25.5/0.0/5.0"
PRJ="X10.0c/5.0c"
psbasemap -X0.0c -Y5.5c -R${RANGE} -J${PRJ} -Bg6/a1f0.5g1:"Wind Speed (m/s)":Wsne ${contin} >> ${psfile}
awk '{print $1,$6}' ${file} | psxy -R -J -W0.06c ${contin} >> ${psfile}


# 時間雨量(mm)を最上段列に描く
RANGE="-0.5/25.5/0.0/50"
PRJ="X10.0c/5.0c"
psbasemap -X0.0c -Y5.5c -R${RANGE} -J${PRJ} -Bg6/a10f5:"Rainfall (mm)"::."20080513 Kochi":Wsne ${contin} >> ${psfile}
awk '{print $1,$3}' ${file} | psxy -R -J -Sb0.2c -W0.06c -G0/0/0 -V -O >> ${psfile}


# ps2rasterを使って整形(PNG形式に変換)
ps2raster -Tg ${psfile}


# 中間ファイルを消去
rm -f gmt_amedas.sh~
rm -f ${psfile}
rm -f data.txt
