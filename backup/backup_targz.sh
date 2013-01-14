#!/bin/sh
# rsync           
# 
# Last update: 2011/07/28

# バックアップをはじめる時刻(JST)を表示する。
echo "Start Time = `date +%F_%T`"

# 実行するコマンドを表示する。
echo "Executing Command: tar -czvf home_user.tar.gz /home/user"

# 実行する。
tar -czvf home_user.tar.gz /home/user
# コマンドの説明:
# tar : アーカイブを作成するコマンド。
#  -c : アーカイブを作成。
#   z : gzで圧縮する。
#   v : 進捗状況を表示。
#   f : 圧縮、アーカイブしたファイルを指定。

# 終了時刻を表示する。
echo "End Time = `date +%F_%T`"
