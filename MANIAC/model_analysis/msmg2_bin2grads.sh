#!/bin/sh
#
# GrADS script を埋込んだ、描画プログラム
#
# Last update: 2011/11/24
#

# GrADS script 内で使用するパラメータの設定
file=msm-p.ctl # 描画するGrADSファイルを指定する
slon=120   # 経度の始点を指定する
elon=150   # 経度の終点を指定する
slat=22.5  # 緯度の始点を指定する
elat=46.5  # 緯度の終点を指定する
t=1        # MSMのタイムステップを指定する
z=1        # MSMの鉛直層を指定する
var="rh"   # 描きたい変数を指定する
cmin=0     # 描きたい変数の最小値を指定する
cmax=100   # 描きたい変数の最大値を指定する
cint=10    # 描きたい変数の値の間隔を指定する


# GrADS script の作成
cat > tmp_grads_draw.gs << EOF
### 描画範囲の指定 (Lon-Lat)
slon=${slon}
elon=${elon}
slat=${slat}
elat=${elat}

### 描画する時刻の指定
t=${t}

### 描画する高度の指定
z=${z}

### 描画する変数
var="${var}"

### 描画する際の値の設定
# 最小値
cmin=${cmin}
# 最大値
cmax=${cmax}
# 間隔
cint=${cint}


###########################################################
### 実行セクション

### 初期化
'reinit'

### ファイルを開く
'open ${file}'

* 背景を白にする
'set display color white'

* 一度画面を消す
'c'

* 地図情報の解像度を上げる
'set mpdset hires'

* 描画範囲を指定する
'set parea 1.5 9.5 1 7.5'

* 上で指定した時刻にセット
'set t 't

* 上で指定した高度にセット
'set z 'z

* 上で指定したLon-Lat範囲にセット
'set lon 'slon' 'elon
'set lat 'slat' 'elat

* 緯度経度を軸ラベルに描く間隔(ここでは1度置き)
'set xlint 1'
'set ylint 1'

* 軸ラベルのフォントの大きさを調節
'set xlopts 1 1 0.15'
'set ylopts 1 1 0.15'

* zを指定したとき, 10以下なら0をつける
if ( z < 10 )
   zz='0'z
endif
if ( z >= 10 )
   zz=z
endif


'set grads off'

* べた塗り設定
'set gxout shaded'

* color.gsというgrads scriptを使用してカラーバーの設定をする.(別途取得)
'color 'cmin' 'cmax' 'cint' -kind blue->cyan->greenyellow->yellow->orange->magenta->red'

* 描画
'd 'var

* カラーバーを右側に描く
* xcbar.gsというgrads scriptを使用してカラーバーの設定をする.(別途取得)
'xcbar 9.7 9.9 1.2 5.2 -line on'


### 時刻ラベル
'q time'
ctime1 = subwrd(result,3)
hour1  = substr(ctime1, 1,2)
tmp1   = substr(ctime1, 3,1)
if ( tmp1 = ':' )
min1   = substr(ctime1, 4,2)
day1   = substr(ctime1, 7,2)
month1 = substr(ctime1, 9,3)
year1  = substr(ctime1,12,4)
endif
if ( tmp1 = 'Z' )
min1   = '00'
day1   = substr(ctime1, 4,2)
month1 = substr(ctime1, 6,3)
year1  = substr(ctime1, 9,4)
endif

if ( hour1 < 15 )
  hour2_=hour1+9
  if ( hour2_ < 10 )
    hour2='0'hour2_
  endif
  if ( hour2_ >= 10 )
    hour2=hour2_
  endif
  day2=day1
endif
if ( hour1 >= 15 )
  hour2_=hour1-15
  if ( hour2_ < 10 )
    hour2='0'hour2_
  endif
  if ( hour2_ >= 10 )
    hour2=hour2_
  endif
  day2_=day1+1
  if ( day2_ < 10 )
    day2='0'day2_
  endif
  if ( day2_ >= 10 )
    day2=day2_
  endif
endif


### 3桁の英字月を数字に直す
if ( month1 = "JAN" )
   month2=01
endif
if ( month1 = "FEB" )
   month2=02
endif
if ( month1 = "MAR" )
   month2=03
endif
if ( month1 = "APR" )
   month2=04
endif
if ( month1 = "MAY" )
   month2=05
endif
if ( month1 = "JUN" )
   month2=06
endif
if ( month1 = "JUL" )
   month2=07
endif
if ( month1 = "AUG" )
   month2=08
endif
if ( month1 = "SEP" )
   month2=09
endif
if ( month1 = "OCT" )
   month2=10
endif
if ( month1 = "NOV" )
   month2=11
endif
if ( month1 = "DEC" )
   month2=12
endif


### 実行時の表示用
say 'Var  = 'var
say 'Z    = 'zz
say 'Time = 'year1'/'month2'/'day2'/'hour2':'min1' (JST)'


### JST時刻に直した時間をラベルに書く
'set string 1 c 5'
'set strsiz 0.20 0.20'
'draw string 7.9 7.7 'hour2':'min1'JST'day2 month1 year1''

### UTC時刻も下の方に書く
'set string 1 l 2'
'set strsiz 0.15 0.15'
'draw string 1.5 0.4 UTC TIME = 'hour1':'min1'UTC'day1 month1 year1''


### 右隅にZ levelをラベルに出力
'draw string 9.2 0.22 Z = 'zz

### 描画した気圧面をラベルに出力
'q dims'
rel=sublin(result,4)
plev=subwrd(rel,6)
'set strsiz 0.20 0.20'
'draw string 4.0 7.7 ' 'LEV='
'draw string 4.8 7.7 ' plev

### 描画する変数をラベルに出力
'set string 1 l 5'
'set strsiz 0.20 0.20'
'draw string 1.5 7.7 ' var


### 図の出力
# .png file  
'printim 'var'_'year1''month2''day2''hour2''min1'JST_Z'zz'.png'
say ''
'quit'

EOF

# 端末からGrADSをバックグラウンドジョブで実行する。
# -b : GrADSのバックグラウンド処理
# -l : Landscape モードで実行
# -c : 引数で実行するGrADS script を指定する
grads -blc tmp_grads_draw.gs

echo " FINISH."

rm -f tmp_grads_draw.gs
rm -f msmg2_bin2grads.sh~
