#!/bin/sh
# 変数を VAR として, おなじディレクトリ内の "list.input"
# 内のデータを1行づつ読んで VAR に代入していく DO LOOP
#
# Last update : 2011/07/21

for VAR in `cat list.input` # list.input を1行目から順番にVARに代入していく
do
    echo "${VAR}"
done
