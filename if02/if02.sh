#!/bin/sh
# VAR に文字列を代入し, その文字列の比較をする条件分岐
#
# Last update: 2011/07/23

VAR="KOCHI"             # VAR に "KOCHI" という文字列を代入

if [ ${VAR} = "KOCHI" ] # VARに代入された文字列が"KOCHI"ならば「真」
then
    echo " VAR = ${VAR}"      # 真の場合の処理
else
    echo " VAR is not ${VAR}" # 偽の場合の処理
fi

# 文字列の場合は, ${VAR} = "MOJI" のように 「=」で評価します。
# 否定の場合は, ${VAR} != "MOJI" のように 「!=」を用います。