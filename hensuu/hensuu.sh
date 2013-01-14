#!/bin/sh
# 変数の基本
# 
# Last update: 2011/07/22

# 変数の定義
VAR1=1        # 数値はそのまま書いてもOK
VAR2="KOCHI"  # 文字列やスペースを含む場合は, "" で囲むのが基本

# 画面出力
echo "${VAR1}"         # 変数の展開は${VAR1}.
echo "${VAR2}"
echo ${VAR1}           # 上と同じ.
echo "This is ${VAR1}" # 文字列はそのまま, 変数は展開される.
