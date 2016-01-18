# -*- coding: utf-8 -*-
require 'otama'

FILE1 = "./image_test_1.jpg"
FILE2 = "./image_test_2.jpg"

# 設定
CONFIG = {
  # 名前空間. 省略可能.
  # 指定した場合は、テーブルやデータファイルなどにこの名称がprefixとして付加される。
  # 同じデータベースやディレクトリに複数のインデックスを作る場合に使用する。
  :namespace => "piyopiyo",

  # ドライバの設定
  :driver => {
    # 画像検索エンジンのドライバ名
    #
    # color: 画像の色の分布で検索するドライバ (雰囲気が似ている風景写真など）
    # id: 全く同じものが写っている画像を検索するドライバ (本やCD,お菓子の袋など印刷物のみ)
    # sim: colorとidの中間くらいの適当な類似検索ドライバ
    # 他、ラベル付きデータから距離感数を学習するドライバなどが用意されています
    :name => :sim,

    # ドライバがローカルの検索インデックス構築などに使うディレクトリ
    :data_dir => "./data",

    # 他にドライバのパラメーターがあれば続く..
    # たとえばsim固有のパラメーター color_weight
    # 色の重み(0.0-1.0), BoVWの重み => 1.0 - color_weight
    :color_weight => 0.2
  },
  # データベースの設定
  # マスタとして使われる
  :database => {
    # データベースドライバ名
    # pgsql, mysql, sqlite3
    :driver => "sqlite3",

    # データベース名
    # sqlite3の場合はデータベースのファイル名を指定する
    :name => "db",

  }
}
# この設定はYAMLファイルに記述してOtama.openの引数にファイル名で渡すこともできる

kvs = {}
Otama.open(CONFIG) do |db|
  # マスタにテーブルを作成する(すでにある場合は無視）
  db.create_database

  # 画像をデータベースに登録
  #
  # 登録されるのは画像から抽出した特徴量と画像のID(SHA1)のみで
  # 画像自体はotama側では管理しない

  # ファイルから
  id1 = db.insert(:file => FILE1)
  # メモリ上のデータから
  id2 = db.insert(:data => File.read(FILE2))

  # insertからは追加した画像データを識別するためのIDが返ってくるので
  # ファイル名などと対応付けて保持しておく
  kvs[id1] = FILE1
  kvs[id2] = FILE2

  # この時点ではまだマスタのデータベースに追加されただけで検索できる保証はない

  # pullによってマスタの更新情報をローカルの検索インデックスに反映させる
  db.pull

  # pullのあとは検索できる

  # 画像をクエリに類似検索(似ているほうから10件検索)
  # クエリ :file => ファイル名, :data => 画像データ, :id => 登録済み画像ID, ...
  results = db.search(10, :file => FILE1)

  # 検索結果表示
  puts "---"
  results.each_with_index do |result, i|
    puts "#{i}: file => #{kvs[result.id]}, #{result.value.inspect}"
  end

  # FILE1を削除
  # (削除はマスタ側に削除フラグを付ける)
  db.remove(id1)

  # この時点ではまだマスタのデータベースで削除されただけで
  # 検索結果から消えている保証はない

  # pullによってマスタの更新情報をローカルの検索インデックスに反映させる
  db.pull

  # メモリ上の画像データをクエリに類似検索(似ているほうから10件検索)
  results = db.search(10, :data => File.read(FILE1))

  # 検索結果表示
  puts "---"
  results.each_with_index do |result, i|
    puts "#{i}: file => #{kvs[result.id]}, #{result.value.inspect}"
  end
end