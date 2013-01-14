#!/bin/sh

# 取得するファイルを指定する
# どこの範囲か知りたい場合は下記URL参照
# http://eros.usgs.gov/#/Find_Data/Products_and_Data_Available/gtopo30_info
files='e100n90.tar.gz e140n90.tar.gz e100n40.tar.gz e140n40.tar.gz'

# filesで指定したファイルを一つずつ取得
for file in ${files}
do
    wget --wait=15 http://edcftp.cr.usgs.gov/pub/data/gtopo30/global/${file}
done

# 取得したファイルを展開。
for file in ${files}
do
    tar -zxvf ${file}
done

# 元のtar.gzファイルはもう使わないので消去
rm -f *.tar.gz
