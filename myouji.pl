#!/usr/local/bin/perl
# myouji.pl
# 2001 copyright (c) おのひろき onohiroki@cup.com
# 著作権はおのひろきにあります．自由に改変して自由に配布してくだされ．
#
# データベースなどで，なまえの姓名が分離していないと嫌な感じですよね．
# 名字と名前の間に「,」をいれようとする perl スクリプトです．
# つっくんの部屋 名字博士 http://www.alles.or.jp/‾tsuyama/name.htm から
# ダウンロードできる名字のデータファイル
# http://www.alles.or.jp/‾tsuyama/image/myouji.lzh
# をもちいて，名前と名字が連結したものを分離しようとします．
# 1 文字の名字よりは 2 文字の名字．2 文字の名字よりは 3 文字以上の
# 名字にマッチングしようとします．同じ漢字なら，よりメジャーなフリガナ
# を選択して，名字のフリガナもふってみようとします．
# 名字のデータファイルは一行は
# 名字(漢字),名字(読み仮名),その他のデータ
# となっている必要があります．カンマ「,」は 2 つ以上あれば幾つ
# あっても大丈夫です．メジャーな名前から順番にソートされている
# ことを前提としています．
# 入力ファイルは，一行に名前が一つずつのテキストファイル．
# 出力はカンマ「,」区切りになり一行に
# 名字(漢字),名前(漢字),名字(読み仮名)
# となります．
#
# 小野島子 という名前だと，名字データファイルに「小野」と「小野島」
# という名字が登録されていると，出力は
# 小野島,子,オノシマ
# となります(苦笑)．
# 
# 関守大 という名前だと，本当は「せきもり まさる」さんであっても
# 「関守」という名字が名字データファイルに登録されていなくて，
# 「関」という名字が登録されていれば，
# 関,守大,セキ
# と出力します．
#
# 適当な名字が見つけられないと，
# おのひろき,error,error 
# と出力されます．
#
# MacJPerl では，ドロップレットとして保存して，変換したいファイルを
# ドラグ&ドロップします．
#
# UNIX や Windows の環境でもテストしました．data.txt という入力ファイルを
# 用意したら
# myouji.pl data.txt
# の用にコマンドで実行してみてください．
#
# jcode.pl を使う場合は，このスクリプト myouji.pl と同じディレクトリに
# 置くか，perl のライブラリとして適切な場所に置いてください．
#
# 出力は，出力ファイルと標準出力にでます．標準出力側にはちらっと警告文など
# も出るかもしれませんが，出力ファイルには余計なメッセージは含まれません．
#
# ぼくは perl についてまだ初心者ですから，なにか指摘してもらえたりすると
# 嬉しいです．質問に対しては perl そのものの質問にはあまり答えられない
# かもしれません．
#
# [つっくんの部屋 名字博士] はすばらしいです．5 万件ものデータが整理
# されているのですから．データを公開してくださってありがとうございます．
#
# そんなこんなで自分が必要だからちょっと書いてみました．こんなものでも
# あれば誰かの役にたつこともあるでしょう，きっと．
# 
# おのひろき onohiroki@cup.com 2001 年 1 月 31 日
# http://onohiroki.cycling.jp/
#
###########################################################################

# 日本語の処理に jcode.pl の機能を一部利用します．
# 漢字コード変換と半角カナ・全角カナの変換を行わない場合は，
# とくに必要ないのですが，その場合は &jcode で始まる行を
# コメントアウトするか削除してください．
require 'jcode.pl';
 
# 名字データファイル
# つっくんの部屋 名字博士 http://www.alles.or.jp/‾tsuyama/name.htm
# http://www.alles.or.jp/‾tsuyama/image/myouji.lzh
$nameDB = "名字.txt"; 

# 半角カナを全角に変換する場合には名字データファイルの漢字コードを
# 指定します (euc | sjis | null) 
$h2z = "sjis"; 

$kanji = "sjis";           #出力漢字コード  (euc | sjis | jis)
$outfile = "outfile.txt";  #出力ファイル

# プログラムはここから始まりです．
$kw = "";
$name1 = "";$name2 = "";$name3 = "";
$yomi0 = "";$yomi1 = "";$yomi2 = "";$yomi3 = "";
open(OUTFILE,">>$outfile");
print "start...\n";
while($name = <>){
 &jcode'convert(*name, euc);
 $name =‾ s/\n//g;
  $name =‾ s/\r//g;
  open(DBFILE, "< $nameDB");
 $sw1 = 1;
  while(($kw = <DBFILE> ) && $sw1){
  if ($h2z eq "sjis"){
   &jcode'h2z_sjis(*kw);
  }elsif ($h2z eq "euc"){
   &jcode'h2z_euc(*kw);
  }
  &jcode'convert(*kw, euc);
    $kw =‾ s/\n//g;
    $kw =‾ s/\r//g;
    $kw =‾ s/([^,]+),([^,]+).*/$1/;
  $yomi0 = $+; #print $kw;print $yomi0;print "\n";
    if ($name =‾ /^$kw(.*)/) { 
    if (length($kw) eq 2) { 
     $name1 = "$kw,$+";
     if ($name1 eq "" &&$ name2 eq "" && $name3 eq "") { 
       &jcode'convert(*kw, $kanji);;
              print "[$kw?]";}
     if ($yomi1 eq "") {$yomi1 = $yomi0;}
    }
    if (length($kw) eq 4) { 
     $name2 = "$kw,$+";
     if ($yomi2 eq "") {$yomi2 = $yomi0;}
    }
    if (length($kw) > 4) {
     $name3 = "$kw,$+";
     if ($yomi3 eq "") {$yomi3 = $yomi0;}
     $sw1 = 0;
    }
  }
 }
 close (DBFILE);
 if ($sw1) { $name = "$name,error,error\n";}
 if ($name3) {$name = "$name3,$yomi3\n";
 } elsif ($name2) {$name = "$name2,$yomi2\n";
 } elsif ($name1) {$name = "$name1,$yomi1\n"; }
 
 $name1 = "";$name2 = "";$name3 = "";
 $yomi1 = "";$yomi2 = "";$yomi3 = "";
 &jcode'convert(*name, $kanji);
 print $name;
 print OUTFILE $name;
 # MacPerl や MacJPerl で　出力ファイルのファイルタイプを指定します．
 #&MacPerl'SetFileInfo('JEDT', 'TEXT', $outfile);
}
close (OUTFILE);
print "End of script.\n";