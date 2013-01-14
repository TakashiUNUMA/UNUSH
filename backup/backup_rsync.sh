#!/bin/sh
# rsync を用いたバックアップ
# 
# Last update: 2011/07/28

# バックアップをはじめる時刻(JST)を表示する。
echo "Start Time = `date +%F_%T`"

# 実行するコマンドを表示する。
echo "Executing Command: rsync -ah --progress --delete /home/user ./"

# 実行する。
rsync -ah --progress --delete /home/user ./
# コマンドの説明:
#  -ah        : おまじない。
#  --progress : 進捗状況を表示する。
#  --delete   : バックアップ元で消去されたものがあれば、バックアップ先でも消去する。


# 終了時刻を表示する。
echo "End Time = `date +%F_%T`"
