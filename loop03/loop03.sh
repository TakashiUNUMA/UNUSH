#!/bin/sh
# 変数を "VAR" として, C言語風に DO LOOP 処理を行う
# 
# Last update: 2011/07/22

# 1から10までの数値が1増加しながらtimeに代入される
for (( time=1 ; time<=10 ; time=time+1 ))
do
    echo "Time = ${time}"
done
# 出力結果は
# 1, 2, 3, 4, 5, 6, 7, 8, 9, 10。


# もし, 初めや終わりの値、さらには増分を変化させたい場合は
start=5 # 初期値
end=30  # 終わりの数値
step=5  # 増分
for (( time=${start} ; time<=${end} ; time=time+${step} ))
do
    echo "Time = ${time}"
done

# とすれば, 始まりを「5」最終値を「30」増分を「5」として、
# 5, 10, 15, 20, 25, 30
# というようにカスタマイズできます。
