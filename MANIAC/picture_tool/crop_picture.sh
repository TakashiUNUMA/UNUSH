#!/bin/bash
#
# 任意領域を切り出すプログラム
# Producted by Takashi Unuma, Kochi Univ.
# Last update: 2011/10/13
#

# 引数が無い場合は、使用方法を表示する。
if test $# -lt 1
then
    echo "USAGE: ./crop_picture.sh [images]"
    echo "   ex) ./crop_picture.sh inital/*png"
    exit
fi

# 引数は、何個あってもOK。
inputs=$*

# 切り出したい領域の横幅(単位: pixel)
xsize=450

# 切り出したい領域の縦幅(単位: pixel)
ysize=200

# 切り出したい領域の左上の点の横方向の位置(単位: pixel)
xpoint=550

# 切り出したい領域の左上の点の縦方向の位置(単位: pixel)
ypoint=600

# 回転角
rotate=45

# 出力形式(デフォルトでは、PNG形式で出力)
suffics=png

# 処理部
for input in ${inputs}
do
    infile=`basename ${input}`
    echo "Now croping ${infile}"

    # 上記で設定した条件で画像を切り出す。
    convert -rotate ${rotate} -crop ${xsize}x${ysize}+${xpoint}+${ypoint} ${input} tmp_${infile%.*}.${suffics}

    # 切りぬいた画像に赤色で枠を付ける。
    convert -bordercolor red -border 2x2 tmp_${infile%.*}.${suffics} croped/crop_${infile%.*}.${suffics}

    rm -f tmp_${infile%.*}.${suffics}
done

echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!  SUCCESSFUL COMPLESSION  !!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
rm -f crop_picture.sh~
