#!/bin/sh
# VARに数値を代入して、その数値によって条件分岐する
#
# Last update: 2011/07/23

VAR=0               # VAR に 0 を代入。

if [ ${VAR} -eq 0 ] # VAR と 0 が等しい場合が「真」。
then
    echo " VAR = ${VAR}" # 真の場合の処理。
else
    echo " VAR is not 0" # 偽の場合の処理。
fi

# 数値の評価には、
# ${VAR} -lt 0    VAR <  0 の場合
# ${VAR} -le 0    VAR <= 0 の場合
# ${VAR} -gt 0    VAR >  0 の場合
# ${VAR} -ge 0    VAR >= 0 の場合
# ${VAR} -eq 0    VAR =  0 の場合
# ${VAR} -ne 0    VAR != 0 の場合 が使えます。