#!/bin/sh
# 2種類の結果を時系列で比較するアニメーションGIFを作成する。
# 
# Last update: 2011/08/01


# 比較する年、月を指定
yyyy=2011
mm=06

# 日時リスト用の設定
dlist='20'
hlist='07 08'
nlist='00 10 20 30 40 50'

# 比較する画像があるディレクトリをそれぞれ指定する
fig1=fig1
fig2=fig2

# 比較する画像の時刻より前の部分の名前を指定する
header=radar_

# 処理部分
# まず、時刻毎にそれぞれの画像を左右に結合した図を作る
echo "Now making intermediate files..."
for dd in ${dlist}
do
    for hh in ${hlist}
    do
	for nn in ${nlist}
	do
	    ddate=${yyyy}${mm}${dd}${hh}${nn}
	    echo '  Now execute  '${ddate}
	    convert +append ${fig1}/${header}${ddate}.png ${fig2}/${header}${ddate}.png out_${ddate}.png
	done
    done
done
echo 'Successful append files.'


# 上記で作成した画像をアニメーションGIFにする
# デフォルトでは、「output.gif」で出力します
echo 'Make aimation gif...'
convert -delay 50 -loop 0 out_*.png output.gif


# 中間ファイル等を消去
rm -f out_*.png
rm -f gif_append.sh~
