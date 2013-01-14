#!/bin/sh
# アニメーションGIFを作成する。
# 
# Last update: 2011/08/01

if test $# -lt 2
then
    echo "USAGE: ./gif_anime01.sh [input_figures]"
    echo "   ex) ./gif_anime01.sh fig/*.png"
    exit
fi

inputs=$*
output=output.gif
    
convert -delay 50 -loop 0 ${inputs} ${output}
# 主に、Image Magickのconvertコマンドを使用する。
# -delay 50 : 画像が切り替わるまでの時間を1/50(s)にする。
# -loop 0   : 無限ループさせる。
# デフォルトでは、このスクリプトを実行する際に指定した引数全ての画像を「output.gif」というファイルにして出力します。