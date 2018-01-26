UNUSH
=====

__ last modified January 26, 2018 __

# 更新履歴
- ver. 0.8.1
  - README.md を作成．GitHub で管理していこうと思います．

- ver. 0.8
  - `utc2jst.sh`, `jst2utc.sh` を作成
	- それぞれ引数に 12 桁の年月日時を指定し，その時刻を変換した時刻を返すプログラム．
  - grads_draw.sh を改良
	- 任意断面の描画に対応．軸目盛の細かい設定が出来るように改良．テストデータを追加．

- ver. 0.7
  - `gd2grads.sh` を作成
	- 気象庁 1 km メッシュ全国合成レーダー (2005 年 6 月以降, GRIB2 形式) をGrADSで描画するプログラム．
  - `gmt_kihon03.sh` を作成
	- `gmt_kihon02.sh` の 3 次元バージョン (地形図を 3 次元で描画)
  - マニアック第五段
	- `windas2txt.sh` を作成
	   - 国内 2 進法フォーマットのWINDASデータからテキストデータへの変換支援プログラム．
    - `windastxt2gmt.sh` を作成
	   - 上記の windas2txt.sh から気象庁のページで表示される図と同じような時系列図をGMTで描くプログラム．
    - `png_transparent.sh` を作成
       - 透過PNG画像を簡単に作れるスクリプト．
    - `radar2gmt.sh` を作成
       - 気象庁 1 km メッシュ全国合成レーダー (2005 年 6 月以降, GRIB2 形式) を GMT で描画するプログラム．
    - `msm_grib22bin.sh` を作成
       - 気象庁メソ数値予報モデル (2006 年 3 月以降, GRIB2 形式) から GrADS 用のバイナリデータと CTL ファイルを作成するプログラム．
    - `msmg2_bin2grads.sh` を作成
       - `msm2bin.sh` で作ったバイナリデータと CTL ファイルを使用してGrADSで描画するプログラム
    - `netcdf_io.sh` を作成
       - 任意の NetCDF ファイルを Fortran を介して読み込むプログラム．今のところ WRF で出力した NetCDF のみ対応．

- ver. 0.6
  - マニアック第四段
	- `crop_picture.sh` を作成
		- 既存の画像の任意領域を切り取るプログラム．
	- `append_picture.sh` を作成
		- `crop_picture.sh` で切り出した画像を繋げるプログラム．Kato and Goda (2001,JMSJ) の Fig. 4 を参考にしました．

- ver. 0.5
  - `gradsdraw.sh` を作成
  - その他今後の開発のためにディレクトリ構造を修正

- ver. 0.4
  - `gmt_kihon01.sh`, `gmt_kihon02.sh` を作成。
  - AMeDAS 時系列データの描画，GTOPO30 の描画についてのスクリプト．
  - GMTの超基本マニュアルを作成
  - マニアック第三段
	- アニメーションGIF作成スクリプト
	  - ImageMagick の convert コマンドを使用
    - クラスター管理用ツール
	  - NFS でディレクトリが共有され，それらのノードでrshによるリモートログインが許可されている状態で動作します．
	  - スタンドアロンの Workstation でも，同じ処理を複数コアで実行するということは出来ます．

- ver. 0.3
  - `backup_rsync.sh`, `backup_targz.sh` を作成。
	- GrADS で使用するオススメスクリプトの紹介を追加．
  - マニアック第二段として,
	- 全国合成レーダー, レーダー・アメダス解析雨量, JMA-GSM, JMA-MSMの各解析用ツールの紹介を追加．
  - その他ちょこちょこ修正．

- ver. 0.2
  - `loop03.sh`, `utc2jst.sh` を作成。
	- MENU.html を開いたときにブラウザがUTF-8で認識するように修正．
  - マニアック第一段として, 
    - `.bashrc`の設定方法を作成．

- ver. 0.1
  - `hensuu.sh`, `loop01.sh`, `loop02.sh`, `if01.sh`, `if02.sh` を作成．



# 開発環境
```
OS:          CentOS 6.7 (x86_64) 
			 Ubuntu 16.04 (64 bit)
文字エンコード: UTF-8
Editer:      emacs ver. 25.3.1
Compiler:    GNU Compiler ver. 5.4.0
GrADS:       ver. 2.0.2 (x86_64)
GMT:         ver. 5.2.1
```


# その他
- ライセンスについては，考え中．
- 全てのファイルの文字エンコードは UTF-8 です．
- バグ・要望等は `kijima.m.u (at) gmail.com` ( (at) を @ に直して) へお寄せください．
