#!/bin/sh
# 変数を "VAR" として, "in" につづく数値を代入していく DO LOOP
# 
# Last update: 2011/07/22

for VAR in 0 1 2 3 4 5   # 0から5までの数値がVARに代入されていく
do
    echo "${VAR}"        # 代入された数値をを画面に表示
done
