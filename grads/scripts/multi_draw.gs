#
# ホフメラー図を描くGrADS Script
# producted by Takashi Unuma, Kochi Univ.
# Last Update: 2012/01/06
#


##### パラメータの設定 #####
### ファイル
# ファイルの指定
file=test.nc

# タイトル
title="Test of GrADS Script"

### 描画範囲の指定 (Lon-Lat)
# 経度の開始点
slon=133.5
# 経度の終了点
elon=133.5
# 緯度の開始点
slat=30
# 緯度の終了点
elat=40

### 描画する時刻の指定
# 初期時刻
st=1
# 終了時刻
et=8

### 描画する高度の指定
# 最下層
sz=1
# 最上層
ez=1

### 描画する変数
var=RH

### 描画する際の値の設定
# 最小値
cmin=0
# 最大値
cmax=100
# 間隔
cint=10


###########################################################
### 実行セクション

### 初期化
'reinit'

### ファイルを開く
'sdfopen 'file

#* 背景を白にする
'set display color white'

#* 一度画面を消す
'c'

#* 地図情報の解像度を上げる
'set mpdset hires'

#* 描画範囲を指定する
'set parea 1.5 9.5 1 7.5'

#* 上で指定した時刻にセット
'set t 'st' 'et

#* 上で指定した高度にセット
'set z 'sz' 'ez

#* 上で指定した緯度経度範囲にセット
'set lon 'slon' 'elon
'set lat 'slat' 'elat

* 緯度経度を軸ラベルに描く間隔(ここでは1度置き)
#'set xlint 1'
#'set ylint 1'

#* 軸ラベルのフォントの大きさを調節
'set xlopts 1 1 0.15'
'set ylopts 1 1 0.15'

# 左下に出る表示を消す
'set grads off'

# 座標軸の縦軸と横軸を入れ替える
'set xyrev on'

#* べた塗り設定
'set gxout shaded'

#* color.gsというgrads scriptを使用してカラーバーの設定をする.(別途取得)
'color 'cmin' 'cmax' 'cint' -kind blue->cyan->greenyellow->yellow->orange->magenta->red'

#* 描画
'd 'var
'set gxout contour'
'set clab off'
'd 'var

#* カラーバーを右側に描く
* xcbar.gsというgrads scriptを使用してカラーバーの設定をする.(別途取得)
'xcbar 9.7 9.9 1.2 5.2 -line on'


### タイトルラベル
'set string 1 c 5'
'set strsiz 0.20 0.20'
'draw string 7.9 7.7 'title


### 描画する変数をラベルに出力
'set string 1 l 5'
'set strsiz 0.20 0.20'
'draw string 1.5 7.7 ' var


### 図の出力
# .png file  
'printim 'var'.png'
say ''
'quit'
