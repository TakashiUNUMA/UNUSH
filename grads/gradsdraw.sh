#!/bin/sh
#
# GrADS script を埋込んだ、描画プログラム
# Producted by Takashi Ununa, Kochi Univ.
# Last update: 2012/01/13
#

############################################################
### 設定ここから

# GrADS script 内で使用するパラメータの設定
file=data/test.nc # 描画するファイルを指定する

# 描画する断面のフラグ設定
DIM=2      # 0:水平断面
           # 1:鉛直断面
           # 2:任意鉛直断面
DIV=0.01   # 任意鉛直断面を作成する際の水平内挿をかける度合

# 経度方向の設定
slon=132   # 経度の始点を指定する
elon=135   # 経度の終点を指定する

# 緯度方向の設定
slat=30.5  # 緯度の始点を指定する
elat=35.5  # 緯度の終点を指定する

# 鉛直方向の設定
sz=1       # 鉛直層の始点を指定する
ez=10      # 鉛直層の終点を指定する
           #   水平断面の場合は、sz と ezを同じにする

# 時間方向の指定
t=1

# 描く変数の設定
var="rh"
cmin=0     # 描きたい変数の最小値を指定する
cmax=100   # 描きたい変数の最大値を指定する
cint=10    # 描きたい変数の値の間隔を指定する

# 軸ラベルに緯度経度を描く間隔(ここでは1度置き)
xlint=1
ylint=100

# 軸ラベルのフォントの大きさを調節
xlopts=0.2
ylopts=0.2

# 任意断面の線を水平面に書く(DIM=0のみ)
line=0     # 0:書かない
           # 1:書く
sx=132
ex=135
sy=30.5
ey=35.5

### 設定ここまで
############################################################

if test ${DIM} -eq 0
then
    if test ${sz} -ne ${ez}
    then
	echo "vertical setting error!"
	echo "please set 'sz'='ez'"
	exit
    fi
fi

############################################################
# GrADS script の作成
#
# 水平断面版
#
cat > tmp_grads_draw1.gs << EOF
### 描画範囲の指定 (Lon-Lat)
slon=${slon}
elon=${elon}
slat=${slat}
elat=${elat}

### 描画する時刻の指定
t=${t}

### 描画する高度の指定
sz=${sz}
ez=${ez}

### 描画する変数
var="${var}"

### 描画する際の値の設定
# 最小値
cmin=${cmin}
# 最大値
cmax=${cmax}
# 間隔
cint=${cint}

# 軸ラベルに緯度経度を描く間隔(ここでは1度置き)
xlint=${xlint}
ylint=${ylint}

# 軸ラベルのフォントの大きさを調節
xlopts=${xlopts}
ylopts=${ylopts}

# 任意断面の線を描く
line=${line}
sx=${sx}
sy=${sy}
ex=${ex}
ey=${ey}

###########################################################
### 実行セクション

### 初期化
'reinit'

### ファイルを開く
'sdfopen ${file}'

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
'set z 'sz' 'ez

* 上で指定したLon-Lat範囲にセット
'set lon 'slon' 'elon
'set lat 'slat' 'elat

* 軸ラベルに緯度経度を描く間隔(ここでは1度置き)
'set xlint 'xlint
'set ylint 'ylint

* 軸ラベルのフォントの大きさを調節
'set xlopts 1 1 'xlopts
'set ylopts 1 1 'ylopts

* zを指定したとき, 10以下なら0をつける
if ( sz < 10 )
   szz='0'sz
endif
if ( sz >= 10 )
   szz=sz
endif
if ( ez < 10 )
   ezz='0'ez
endif
if ( ez >= 10 )
   ezz=ez
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


* 軸の補助線をくっきり表示させる
'set gxout contour'
'set clab off'
'set ccolor 1'
'set cstyle 5'
'set cthick 8'
'set cint 'xlint
'd lon'
'set ccolor 1'
'set cstyle 5'
'set cthick 8'
'set cint 'ylint
'd lat'

### draw line option ###########
#if ( line = 1)
 'q w2xy 'sx' 'sy
   x1 = subwrd(result,3)
   y1 = subwrd(result,6)
 'q w2xy 'ex' 'ey
   x2 = subwrd(result,3)
   y2 = subwrd(result,6)
 'set line 1 1 7'
 'draw line 'x1' 'y1' 'x2' 'y2
 'set line 1 1 3'
 x1=x1-0.15
 x2=x2-0.15
 'set string 1 c 5'
 'set strsiz 0.20 0.20'
 'draw string 'x2' 'y2' B'
 'draw string 'x1' 'y1' A'
#endif
################################


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
say 'Z    = 'szz'-'ezz
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
'draw string 9.0 0.22 Z = 'szz'-'ezz

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
'printim 'var'_'year1''month2''day2''hour2''min1'JST_Z'szz'-'ezz'.png'
say ''
'quit'

EOF


#
# 鉛直断面or任意鉛直断面版
#
cat > tmp_grads_draw2.gs <<EOF
### 次元の設定
dim=${DIM}
div=${DIV}

### 描画範囲の指定 (Lon-Lat)
slon=${slon}
elon=${elon}
slat=${slat}
elat=${elat}

### 描画する時刻の指定
t=${t}

### 描画する高度の指定
sz=${sz}
ez=${ez}

### 描画する変数
var="${var}"

### 描画する際の値の設定
# 最小値
cmin=${cmin}
# 最大値
cmax=${cmax}
# 間隔
cint=${cint}

# 軸ラベルに緯度経度を描く間隔(ここでは1度置き)
xlint=${xlint}
ylint=${ylint}

# 軸ラベルのフォントの大きさを調節
xlopts=${xlopts}
ylopts=${ylopts}


### output picture setting ###########
#pic=${PIC}
#gray=${GRAY}
#ulab=${ULAB}


### vector setting ###################
#wind=${WIND}
#snum=${SNUM}


###########################################################
### 実行セクション

### 初期化
'reinit'

### ファイルを開く
'sdfopen ${file}'

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
'set z 'sz' 'ez

* 上で指定したLon-Lat範囲にセット
'set lon 'slon' 'elon
'set lat 'slat' 'elat

* 軸ラベルに緯度経度を描く間隔(ここでは1度置き)
'set xlint 'xlint
'set ylint 'ylint

* 軸ラベルのフォントの大きさを調節
'set xlopts 1 1 'xlopts
'set ylopts 1 1 'ylopts

* zを指定したとき, 10以下なら0をつける
if ( sz < 10 )
   szz='0'sz
endif
if ( sz >= 10 )
   szz=sz
endif
if ( ez < 10 )
   ezz='0'ez
endif
if ( ez >= 10 )
   ezz=ez
endif


'set grads off'


'set t 't
'set z 'sz' 'ez
'set zlog on'
'set xlint 'xlint
'set ylint 'ylint
'set xlopts 1 1 'xlopts
'set ylopts 1 1 'ylopts
'set grads off'

'set gxout shaded'
if ( dim = 1 )
   'color ${cmin} ${cmax} ${cint} -kind blue->cyan->greenyellow->yellow->orange->magenta->red'
   'd 'var
   'xcbar 9.7 9.9 1.2 5.2 -line on'
endif
if ( dim = 2 )
   'color ${cmin} ${cmax} ${cint} -kind blue->cyan->greenyellow->yellow->orange->magenta->red'

##### GrADS内で任意断面を計算する(ここから)
# 計算には、anyver.gs というスクリプトを使います。
   'anyver -d ${DIV} ${slon} ${elon} ${slat} ${elat} ${sz} ${ez} ${var}'
##### GrADS内で任意断面を計算する(ここまで)

   'xcbar 9.7 9.9 1.2 5.2 -line on'
endif


* 軸の補助線をくっきり表示させる
#'set gxout contour'
#'set clab off'
#'set ccolor 1'
#'set cstyle 5'
#'set cthick 8'
#'set cint 'xlint
#'d lon'
#'set ccolor 1'
#'set cstyle 5'
#'set cthick 8'
#'set cint 'ylint
#'d lat'


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
say 'Z    = 'szz'-'ezz
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
'draw string 9.0 0.22 Z = 'szz'-'ezz

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
'printim 'var'_'year1 month2 day2 hour2 min1'JST_Z'szz'-'ezz'_vcross'slon'-'elon'_'slat'-'elat'.png'
say ''
'quit'
EOF


# 端末からGrADSをバックグラウンドジョブで実行する。
# -b : GrADSのバックグラウンド処理
# -l : Landscape モードで実行
# -c : 引数で実行するGrADS script を指定する
if test ${DIM} -eq 0
then
    grads -blc tmp_grads_draw1.gs
elif test ${DIM} -eq 1 -o ${DIM} -eq 2
then
    grads -blc tmp_grads_draw2.gs
fi

echo " FINISH."

rm -f tmp_grads_draw?.gs

rm -f gradsdraw.sh~
