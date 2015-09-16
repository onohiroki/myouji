#!/usr/bin/perl
# myouji.pl
# 2001 copyright (c) おのひろき onohiroki@cup.com
# 著作権はおのひろきにあります．
#
# The MIT License (MIT)
#
# Copyright (c) 2001 ONO Hiroi.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# データベースなどで，なまえの姓名が分離していないと嫌な感じですよね．
# 名字と名前の間に「,」をいれようとする perl スクリプトです．
# つっくんの部屋 名字博士 http://www.alles.or.jp/~tsuyama/name.htm から
# ダウンロードできる名字のデータファイル
# http://www.alles.or.jp/~tsuyama/image/myouji.lzh
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
# UNIX や Windows の環境でもテストしました． 
# data.txt という入力ファイルを用意したら
# myouji.pl data.txt
# の様にコマンドで実行してみてください．
#
# 出力は，出力ファイルと標準出力にでます．標準出力側にはちらっと警告文など
# も出るかもしれませんが，出力ファイルには余計なメッセージは含まれません．
#
# [つっくんの部屋 名字博士] はすばらしいです．5 万件ものデータが整理
# されているのですから．データを公開してくださってありがとうございます．
#
# そんなこんなで自分が必要だからちょっと書いてみました．こんなものでも
# あれば誰かの役にたつこともあるでしょう，きっと．
#
# おのひろき onohiroki@cup.com
# http://onohiroki.cycling.jp/
# 2001-01-31 公開
# 2015-09-16 修正しました．
#
###########################################################################

use strict;
use warnings;
use utf8;
use Encode qw/encode decode/;

# 名字データファイル
# つっくんの部屋 名字博士 http://www.alles.or.jp/~tsuyama/name.htm
# http://www.alles.or.jp/~tsuyama/image/myouji.lzh
# ダウンード後にファイル名を 名字.txt から nameDB.txt にリネームしてください．
my $nameDB = "名字.txt";
$nameDB = 'nameDB.txt';

#出力漢字コード Windows なら cp932．そうでなければ UTF-8 ．
my $input_kanji  = 'cp932';
my $output_kanji = 'cp932';

# $output_kanji   = "UTF-8";
if ( exists( $ENV{'LANG'} ) ) {
    $output_kanji = 'UTF-8' if ( $ENV{'LANG'} =~ m/UTF/i );
}
my $outfile = 'outfile.txt';    #出力ファイル

# プログラムはここから始まりです．
my $kw    = q{};
my $name1 = q{};
my $name2 = q{};
my $name3 = q{};
my $yomi0 = q{};
my $yomi1 = q{};
my $yomi2 = q{};
my $yomi3 = q{};
open( OUTFILE, ">", $outfile ) or die "error $!";
print "start...\n";

while ( my $name = <> ) {
    $name = decode( $input_kanji, $name );
    $name =~ s/\x0D|\x0A//gi;
    open( DBFILE, "<", $nameDB ) or die "error $!";
    my $sw1 = 1;
    while ( my $kw = <DBFILE> ) {
        last unless $sw1;
        $kw = decode( $input_kanji, $kw );
        $kw =~ s/\x0D|\x0A//gi;
        $kw =~ s/([^,]+),([^,]+).*/$1/;
        $yomi0 = $+;
        if ( $name =~ /^$kw(.*)/ ) {
            if ( length($kw) eq 2 ) {
                $name1 = "$kw,$+";
                if ( $name1 eq q{} && $name2 eq q{} && $name3 eq q{} ) {
                    Jcode::convert( \$kw, $output_kanji );
                    print "[$kw?]";
                }
                if ( $yomi1 eq q{} ) { $yomi1 = $yomi0; }
            }
            if ( length($kw) eq 4 ) {
                $name2 = "$kw,$+";
                if ( $yomi2 eq q{} ) { $yomi2 = $yomi0; }
            }
            if ( length($kw) > 4 ) {
                $name3 = "$kw,$+";
                if ( $yomi3 eq q{} ) { $yomi3 = $yomi0; }
                $sw1 = 0;
            }
        }
    }
    close(DBFILE);
    if ($sw1) { $name = "$name,error,error\n"; }
    if ($name3) {
        $name = "$name3,$yomi3\n";
    }
    elsif ($name2) {
        $name = "$name2,$yomi2\n";
    }
    elsif ($name1) {
        $name = "$name1,$yomi1\n";
    }
    $name1 = q{};
    $name2 = q{};
    $name3 = q{};
    $yomi1 = q{};
    $yomi2 = q{};
    $yomi3 = q{};
    print encode( $output_kanji, $name );
    print OUTFILE encode( $output_kanji, $name );
}
close(OUTFILE);
print "End of script.\n";

