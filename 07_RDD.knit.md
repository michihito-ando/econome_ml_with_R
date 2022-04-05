---
title: "Rで学ぶ計量経済学と機械学習 7<br> <br> 計量経済学３：回帰不連続デザイン(+モンテカルロ・シミュレーション入門）"
author: "安藤道人（立教大学）　三田匡能 (株式会社 GA technologies)"
date: "2022-01-19"
output:
 html_document:
    css : R_style.css
    self_contained: true   # 画像などの埋め込み 
    #theme: cosmo
    highlight: haddock     # Rスクリプトのハイライト形式
    #code_folding: 'hide'  # Rコードの折りたたみ表示を設定
    toc: true
    toc_depth: 2           # 見出しの表示とその深さを指定
    toc_float: true        # 見出しを横に表示し続ける
    number_sections: true # 見出しごとに番号を振る
    # df_print: paged        # head()の出力をnotebook的なものに（tibbleと相性良）
    latex_engine: xelatex  # zxjatypeパッケージを使用するために変更
    fig_height: 4          # 画像サイズのデフォルトを設定
    fig_width: 6           # 画像サイズのデフォルトを設定
    dev: png
classoption: xelatex,ja=standard
editor_options: 
  chunk_output_type: console
---




# データ

## データ生成過程
前回、前々回と同様、自分で生成したデータを用いて分析していく。

すなわち、個人の所得$Y$と学歴$X$・能力$A$との関係についての架空データを次のように生成する。

$$
Y = 200 + 10A + 500X+ \varepsilon
$$

- サンプルは1万人
- 切片は200万円
- 能力が1上がると所得は10上昇する
- 能力は0から100まで均等に分布する
- 大卒だと所得が500万円上昇する
- 能力を部分的に反映した学力テストの点数が 180点以上であれば大卒となる
- この最後の学力テスト点数が新しいデータ生成条件であり、これを回帰不連続デザインで利用する。






































