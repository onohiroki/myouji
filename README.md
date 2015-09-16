# myouji.pl / 姓名 分割 perl スクリプト


名字と名前の間に「,」をいれようとする perl スクリプトです．
このスクリプトの他に，名字のデータファイルが必要です．

## 他から入手が必要なファイル

+ [つっくんの部屋 名字博士 http://www.alles.or.jp/%7Etsuyama/name.htm](http://www.alles.or.jp/%7Etsuyama/name.htm)
+ [データファイル http://www.alles.or.jp/%7Etsuyama/image/myouji.lzh](http://www.alles.or.jp/%7Etsuyama/image/myouji.lzh)

## 概要

データベースなどで，なまえの姓名が分離していないと嫌な感じですよね．
名字と名前の間に「,」をいれようとする perl スクリプトです．
[つっくんの部屋 名字博士](http://www.alles.or.jp/%7Etsuyama/name.htm) からダウンロードできる[名字のデータファイル](http://www.alles.or.jp/%7Etsuyama/image/myouji.lzh)
を用いて，名前と名字が連結したものを分離しようとします．

1 文字の名字よりは 2 文字の名字．2 文字の名字よりは 3 文字以上の名字にマッチングしようとします．同じ漢字なら，よりメジャーなフリガナを選択して，名字のフリガナもふってみようとします．
名字のデータファイルは一行は名字(漢字),名字(読み仮名),その他のデータとなっている必要があります．カンマ「,」は 2 つ以上あれば幾つあっても大丈夫です．メジャーな名前から順番にソートされていることを前提としています．
入力ファイルは，一行に名前が一つずつのテキストファイル．出力はカンマ「,」区切りになり一行に名字(漢字),名前(漢字),名字(読み仮名)となります．

小野島子 という名前だと，名字データファイルに「小野」と「小野島」という名字が登録されていると，出力は
`小野島,子,オノシマ`
となります(苦笑)．

関守大 という名前だと，本当は「せきもり まさる」さんであっても「関守」という名字が名字データファイルに登録されていなくて，「関」という名字が登録されていれば，
`関,守大,セキ`
と出力します．

適当な名字が見つけられないと，
`おのひろき,error,error`
と出力されます．

UNIX や Windows の環境でもテストしました． data.txt という入力ファイルを用意したら

`myouji.pl data.txt`

の様にコマンドで実行してみてください．

出力は，出力ファイルと標準出力にでます．標準出力側にはちらっと警告文なども出るかもしれませんが，出力ファイルには余計なメッセージは含まれません．

[つっくんの部屋 名字博士](http://www.alles.or.jp/%7Etsuyama/name.htm)  はすばらしいです．5 万件ものデータが整理されているのですから．データを公開してくださってありがとうございます．

そんなこんなで自分が必要だからちょっと書いてみました．こんなものでもあれば誰かの役にたつこともあるでしょう，きっと．

+ 2001-01-31 公開
+ 2015-09-16 修正

## ファイル

| ファイル名                 | 説明　　　　                                       |
|--------------------------|---------------------------------------------------|
|[myouji.pl](myouji.pl)    | プログラム本体                                      |
|[nameDB.txt](nameDB.txt)  | 名字のデータファイルのサンプル．シフトJISのファイルです．|
|[data.txt](data.txt)      | 氏名が書かれたサンプルファイル．シフトJISのファイルです．|

## 使い方

### Windows の場合

Winodws に ActivePerl をインストールします．これにならってインストールすれば良いでしょう．

http://www.perlplus.jp/perlinstall/install/index1.html

つぎに，ここで配布しているファイルを用意します．

+ [myouji.pl](myouji.pl)
+ [nameDB.txt](nameDB.txt)
+  [data.txt](data.txt)


Windows でコマンドプロンプトを立ち上げて，CD コマンドを使って `myouji.pl` がある
ディレクトリまで移動します．

たとえば Documents の中に myouji というフォルダを作って，その中に三つのファイルを置いたとしたら，

`CD C:\Users\You\Documents\myouji`

としてから

`DIR`

で，先の三つのファイルのファイル名が見えれば OK です．

`perl myouji.pl data.txt`

とすると画面にいろいろ表示して `output.txt` というファイルも生成されます．
この時に `data.txt` と `output.txt` を比較して，何が起こったのか推測してください．
なお，`nameDB.txt` は苗字のデータベースですが，これはデータ数がとても少ないので，

[つっくんの部屋 名字博士 http://www.alles.or.jp/%7Etsuyama/name.htm](http://www.alles.or.jp/%7Etsuyama/name.htm)

からリンクのある

[データファイル http://www.alles.or.jp/%7Etsuyama/image/myouji.lzh](http://www.alles.or.jp/%7Etsuyama/image/myouji.lzh)

をダウンロードしてください．

`Myouji.lzh` を解凍すると `名字.txt` というファイルになるので，
`nameDB.txt` を削除してから `名字.txt` を `nameDB.txt` にリネームして使ってくださ
い．


あとは，実際に処理したい名前をテキストファイルにして用意します．たとえば `name.txt`
というファイルを用意したら，

`perl myouji.pl name.txt`

とすれば `output.txt` ができます．

## Mac の場合

最初から Perl はインストールされているので簡単だと思います．

---
<address>おのひろき <a name="address" href="mailto:onohiroki@cup.com?subject=onohiroki_online">onohiroki@cup.com</a></address>
