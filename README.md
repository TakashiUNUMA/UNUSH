UNUSH
=====

* 更新履歴

- ver. 0.8 :
   - utc2jst.sh, jst2utc.sh を作成。
      それぞれ引数に12桁の年月日時を指定し、その時刻を変換した時刻を返すプログラム。
   * grads_draw.sh を改良。
      任意断面の描画に対応。
      軸目盛の細かい設定が出来るように改良。
      テストデータを追加。

- ver. 0.7
   * gd2grads.sh を作成。
       + 気象庁1kmメッシュ全国合成レーダー(2005年6月以降, GRIB2形式)をGrADSで描画するプログラム。
   * gmt_kihon03.sh を作成。
       gmt_kihon02.sh の3次元バージョン(地形図を3次元で描画)
   - マニアック第五段：
     (その1)： windas2txt.sh を作成。
         国内2進法フォーマットのWINDASデータから、テキストデータ
         への変換支援プログラム。
     (その2)： windastxt2gmt.sh を作成。
         上記の windas2txt.sh から、気象庁のページで表示される図と同じような時系列図をGMTで描くプログラム。
     (その3)： png_transparent.sh を作成。
         透過PNG画像を簡単に作れるスクリプト。
     (その4)： radar2gmt.sh を作成。
         気象庁1kmメッシュ全国合成レーダー(2005年6月以降, GRIB2形式)をGMTで描画するプログラム。
     (その5)： msm_grib22bin.sh を作成。
         気象庁メソ数値予報モデル(2006年3月以降, GRIB2形式)から、GrADS用のバイナリデータとCTLファイルを作成するプログラム。
     (その6)： msmg2_bin2grads.sh を作成。
         msm2bin.sh で作ったバイナリデータとCTLファイルを使用してGrADSで描画するプログラム。
     (その7)： netcdf_io.sh を作成。
         任意のNetCDFファイルをFortranを介して読み込むプログラム。
         今のところWRFのNetCDFのみ対応です。

- ver. 0.6
   マニアック第四段：
     (その1)： crop_picture.sh を作成。
         既存の画像の任意領域を切り取るプログラム。
     (その2)： append_picture.sh を作成。
         crop_picture.sh で切り出した画像を繋げるプログラム。
         Kato and Goda (2001,JMSJ) の Fig. 4を参考にしました。

- ver. 0.5
   * gradsdraw.sh を作成。
   * その他今後の開発のためにディレクトリ構造をちょこちょこ修正。

- ver. 0.4
  * gmt_kihon01.sh, gmt_kihon02.sh を作成。
  * AMeDAS時系列データの描画、GTOPO30の描画についてのスクリプトです。
  * GMTの超基本マニュアルを作成。
  マニアック第三段：
    (その1)：アニメーションGIF作成スクリプト
	Windowsな環境ならいろんなソフトウェアがあるようですが、
	Linuxでは、ImageMagick という最強ライブラリがあるので
	こちらのcomvertコマンドを最大限に使用します。
    (その2)：クラスター管理用ツール
	NFS でディレクトリが共有され，それらのノードでrshによるリモートログインが許可されている状態で動作します．
	スタンドアロンの Workstation でも，同じ処理を複数コアで実行するということは出来ます．

- ver. 0.3
  - backup_rsync.sh, backup_targz.sh を作成。
	- GrADSで使用するオススメスクリプトの紹介を追加。
  - マニアック第二段として,
	- 全国合成レーダー, レーダー・アメダス解析雨量, JMA-GSM, JMA-MSMの各解析用ツールの紹介を追加。
  - その他ちょこちょこ修正。

- ver. 0.2
  - loop03.sh, utc2jst.sh を作成。
	- MENU.html を開いたときにブラウザがUTF-8で認識するように修正。
  - マニアック第一段として, 
    - 「.bashrc」の設定方法を作成。

- ver. 0.1
  - hensuu.sh, loop01.sh, loop02.sh, if01.sh, if02.sh を作成。




-----------------------------------------------------------------


* 開発環境
OS:          CentOS 5.6, 5.7, 6.0 (x86_64) 
              and
             Scientific Linux 6.0, 6.1 (x86_64)
文字エンコード: UTF-8
Editer:      emacs-23.2
Compiler:    Intel Compiler ver.12 (intel64)
GrADS:       ver.2.0.a9, 2.0.0, 2.0.1 (x86_64)
GMT:         ver.4.5.3

* その他
あとは、各自で煮るなり焼くなりご自由にお使い下さい。
全てのファイルの文字エンコードはUTF-8です。

バグや、要望等は下記までご連絡ください。
E-mail: kijima.m.u(at)gmail.com
(at) を @ に直してください.
