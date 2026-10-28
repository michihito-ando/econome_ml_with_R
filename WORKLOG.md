# 作業ログ（Rmd → Quarto (qmd) 移行）

このファイルには、講義資料（econome_ml_with_R）をR Markdown（.Rmd）からQuarto（.qmd）へ移行していく作業の記録を残す。今後も1ファイルずつ移行していく予定なので、セッションごとに追記していく。

## 2026-09-23: 01_elements.Rmd → 01_elements.qmd

### やったこと

1. **[01_elements.Rmd](01_elements.Rmd) を [01_elements.qmd](01_elements.qmd) に変換**
   - 本文・コードチャンク・画像パスはそのまま維持。
   - YAMLヘッダーをQuarto形式に書き換え（`output: html_document:` → `format: html:`、`self_contained` → `embed-resources`、`toc_depth` → `toc-depth` など）。
   - `date: "This version: \`r Sys.Date()\`"` はQuartoだと実際の日付として解釈され独自書式（例: "September 23, 2026"）で上書きされ、「This version: 」の接頭辞が消えてしまう問題があったため、`subtitle:` フィールドに変更して対処。

2. **[R_style.css](R_style.css) を更新**
   - Quartoが生成するHTML構造（`<section class="level1">` など）は、旧来のRmarkdown（`<div class="section level1">`）と異なるため、見出しの装飾（h1の縞模様の背景、h2の下線）が効かなくなっていた。
   - `div.section.levelN` セレクタに加えて `section.levelN > hN` セレクタを追加し、両方の出力形式に対応させた（既存のRmd由来の出力には影響しない、後方互換な変更）。

3. **URL・リンクまわりの修正**
   - 参考サイト一覧やPosit Cloudの案内にあった裸のURL（クリックできないプレーンテキスト）をMarkdownリンク `[URL](URL)` 形式に変更。
   - 死んでいる/古い参考リンク「統計解析フリーソフト R の備忘録頁」を削除。
   - 「Rではじめるデータサイエンス」のAmazonリンクを短縮版URL（`https://www.amazon.co.jp/R.../dp/487311814X/`）に更新。
   - `format: html:` に `link-external-newwindow: true` を追加し、外部リンクは新しいタブで開く設定に（`target="_blank" rel="noopener"` が自動付与される）。

4. **その他のクリーンアップ（提案し、承認を得た上で実施）**
   - `write.csv()` チャンクが `eval=FALSE` だったため、ゼロから render すると直後の `read.csv("df1.csv")` が失敗する問題があった。`eval=TRUE` に変更し、実際にファイルを書き出すようにした。
   - コメントアウトされたまま残っていた古い節（列の取り出し方の説明ブロック、JIN'S PAGEへのリンク）を削除。
   - Posit Cloudの無料枠に関する記述（「1ヶ月につき25時間」）は情報が古くなりがちなため削除。大学PC/自PCへのインストールを勧める本題の文は維持。
   - ワーキングディレクトリの節（`getwd()`/`setwd(".")`）は現状維持でよいとのことで変更なし。

5. 各変更後、Quarto CLIで実際にレンダリングし、ブラウザでリンクの動作・見た目（見出し装飾、TOC、コードハイライトなど）を確認した上で [01_elements.html](01_elements.html) を上書き。html上書き前にユーザー側でバックアップ済みであることを都度確認。

### 技術メモ（今後の移行作業のために）

- このマシンにQuartoはPATHに入っていないが、RStudio.appに同梱されている：
  `/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto`（確認時点でv1.8.25）
- `date:` フィールドはQuartoのtitle-blockが日付としてパースして独自フォーマットで表示するため、「This version: 」のような接頭辞をつけたい場合は `subtitle:` を使うと回避できる。
- Quartoの標準HTML出力は見出しを `<section class="levelN">` で囲む（Rmarkdownの `<div class="section levelN">` とは異なる）。共通の `R_style.css` を使う場合はセレクタを両対応させる必要がある。
- `link-external-newwindow: true` は静的HTMLの属性としてではなく、ページ読み込み時に実行されるJS（quarto.jsから注入されるインラインスクリプト）によって `target="_blank"` が付与される。そのためHTMLソースをgrepしても属性は見つからない（ブラウザのDOMで確認する必要がある）。
- `write.csv(..., eval=FALSE)` のようなチャンクの後に同じファイルを `read.csv()` するチャンクがある場合、ゼロからrenderすると失敗する（過去に手元にファイルが残っていた状態でしかknitが通らない構成になっていた）。他のRmd/qmdファイルにも同様のパターンがないか、移行時に確認するとよい。

### 次にやること

- 残りの `.Rmd` ファイル（02_data_wrangling以降）を同様の方針で `.qmd` へ移行。

## 2026-09-23: 「11 （おまけ）Pythonで同様の作業を行う場合」を追加

演習はRで行うが、参考としてPythonでの対応コードを簡単に紹介するセクションを最後に追加してほしいとの依頼。

- `01_elements.qmd` の末尾に新しい level1 見出し「（おまけ）Pythonで同様の作業を行う場合」を追加（自動採番で「11」になる）。
- 本文の各節（計算と代入／ベクトル／関数／データフレーム／csv読み書き／因子(factor)型／辞書・行列）に対応するPythonコード（NumPy・pandas使用）を簡潔に掲載。
- **これらのPythonコードチャンクは実行されない**（&#96;```python&#96; の素のフェンスドコードブロックで、Rチャンクのような &#96;```{r}&#96; 形式にはしていない）。理由: このqmdのエンジンはknitrであり、Pythonを実際に実行するにはJupyterカーネルなど追加のセットアップが必要になるため、まずは「おまけ」の説明用コードとして静的に掲載する方針にした。
- 掲載前に、ローカルに一時的なvenvを作ってNumPy/pandasをインストールし、掲載したコードが実際に動作し、Rの出力（平均値 86.33/82.67、行列積の結果など）と一致することを確認済み（venv自体は作業後に削除済み）。
- 今後、実際にPythonコードをqmd内で実行・出力表示させたい場合は、Quartoの `jupyter` エンジンの導入（Python環境のセットアップ、`format`/`engine`設定の変更など）が別途必要になる。

## 2026-09-23: `docs/01_elements.html` の更新とGitHubへのpush

ウェブサイト（GitHub Pages、`docs/`配下）に反映するため、最新の `01_elements.html` を `docs/01_elements.html` にコピーし、commit・pushを実施。

### やったこと

1. `01_elements.html` を `docs/01_elements.html` に上書きコピー。`docs/index.html` は `01_elements.html` というファイル名で参照しているだけなので変更不要だった。
2. 今回のセッションで触った範囲（`01_elements.qmd`、`01_elements.html`、`docs/01_elements.html`、`R_style.css`、`WORKLOG.md`）のみをステージしてcommit。無関係な未コミット変更（`backup_2023ver/`配下、`desktop.ini`の削除、`.DS_Store`、`backup_2026spring_ver/`、`xyz_data_for_RMarkdown.xlsx`）はセッション開始前から存在していたものなので、そのまま触らずに残した。
3. `git push origin master` が **403エラー**で失敗。
   ```
   remote: Permission to michihito-ando/econome_ml_with_R.git denied to michihito-ando-private.
   ```
   原因は、このMacの`gh` CLI（`/Users/Michi/bin/gh`、PATHには入っていない）が `michihito-ando-private` アカウントでログインしており、そのアカウントには `michihito-ando/econome_ml_with_R`（`michihito-ando`名義のリポジトリ）への書き込み権限がなかったため。
4. ユーザーに、正しいアカウント（`michihito-ando`）での再ログインを依頼。
   - `gh auth login` のブラウザ認証フローは、**ブラウザの現在のログインセッションのアカウントでそのまま認証してしまう**ため、`michihito-ando-private`でログイン中のブラウザで試すと何度やっても`michihito-ando-private`のままになる、という問題が発生。
   - 最終的に、`michihito-ando`でログインしたブラウザからPersonal Access Token（classic、`repo`スコープ）を発行し、`gh auth login` → `Paste an authentication token` で認証することで解決。
5. `gh auth status` で `michihito-ando` が `Active account: true` になったことを確認し、`git push origin master` を再実行 → 成功（`6cbb6bb..5138046 master -> master`）。

### わかったこと（GitHubの複数アカウント運用について）

- `gh auth switch --user <name>` は **`gh`自身のアクティブアカウントを切り替えるだけ**で、`git push`/`git pull`が実際に使う認証情報（このMacでは`osxkeychain`が管理）は自動では切り替わらないことを実験で確認した（`gh auth switch`前後で `printf "protocol=https\nhost=github.com\n\n" | git credential fill` の結果が変わらなかった）。
- このMac上のリポジトリは `michihito-ando` 名義のもの（`econome_ml_with_R`、`github_website`、`covid19-japan-policies` など）と `michihito-ando-private` 名義のもの（`fiscal_portal`＝財政関連ニュースサイト、`shonan-compass` など）が混在している。github.com向けのHTTPS認証情報はMac全体で1枠しかないため、「どちらのアカウントの資格情報が今キャッシュされているか」と「pushしようとしているリポジトリがどちらの持ち物か」が一致していないと403になる。プロジェクトごとに自動で正しいアカウントが選ばれるわけではない。
- 実際に今回の対応後、`michihito-ando-private`名義の財政関連ニュースサイト側でGitHubにアクセスできなくなる、という逆の問題が発生することが確認された（想定通り）。
- 恒久対策として `gh auth setup-git` を一度実行することで、gitがgithub.comへの認証を `gh` に委譲するようになり、以後は `gh auth switch --hostname github.com --user <name>` だけで `gh` コマンドとgit push/pull の両方が連動して切り替わるようになる（ユーザー側で実行予定。gitのconfigを変更するコマンドのため、Claudeからは実行せずユーザーに依頼した）。

### 次にやること

- ユーザーが `gh auth setup-git` を実行後、`gh auth status` と `git credential fill` で正しく連動しているか確認する。
- 残りの `.Rmd` ファイルを同様の方針で `.qmd` へ移行。

## 2026-09-30: 02_data_wrangling.Rmd → 02_data_wrangling.qmd

第2回「データ整理」を、第1回と同じ方針でqmd化。

### やったこと

1. **[02_data_wrangling.qmd](02_data_wrangling.qmd) を新規作成**。YAMLヘッダー、`R_style.css`との連携、`link-external-newwindow`などは第1回と同じ方針。全85+チャンクがゼロからのrenderでエラーなく通ることを確認（`test_scores.xlsx`は元々リポジトリに存在していたので依存関係の問題なし）。
2. **リンク修正**: `test_scores.xlsx`へのGoogleリダイレクト経由リンクを直接URLに変更。「R Studio Cloud」の表記を第1回に合わせて「Posit Cloud」に統一。
3. **パイプ演算子を`%>%`（{magrittr}）から`|>`（base Rのネイティブパイプ、R 4.1+）に変更**。本文中の実例はすべて`|>`に統一し、「パイプ演算子には`{dplyr}`が必要」という記述を「`|>`はbase Rの機能、`{dplyr}`はこの後使うfilter/select等のために読み込む」に修正。`%>%`についても、他の資料で今も広く使われているとの理由で参考節を1つ残した。
4. **「（参考）Rのチートシート」の画像を削除**（`1549118953251.png`、Help→Cheatsheetsメニューの古いスクリーンショット）。前後の文章は画像なしでも自然に読めることを確認。
5. **`test_scores.xlsx`の列名を日本語から英語に変更**（`クラス/名前/数学/英語/国語` → `class/name/math/english/japanese`）。ユーザーからの「変数名に日本語を使うのは避けたい」という方針に基づく。
   - xlsx本体（リポジトリ直下および`docs/`の両方）をopenpyxlで書き換え。フォント・書式は変更していない。
   - `02_data_wrangling.qmd`内の`df`に対するJapaneseな列名参照（`クラス`, `名前`, `数学`, `英語`, `国語`）をすべて英語名に置き換え。新規追加列（合計点→`total_score`、数国計→`math_japanese`、数英計→`math_english`）も英語名に統一。
   - `ends_with("語")`（英語・国語の両方が「語」で終わることを利用した列選択デモ）は英語名では成立しなくなるため、`all_of(c("english","japanese"))`に変更。同様に`contains("国")`は`contains("an")`（`japanese`のみが"an"を含む）に変更し、元のデモ（1列だけがマッチする）の趣旨を維持。
   - **「列名の変更」節を拡張**: 実務では読み込んだデータの列名が日本語のままのことがよくある、という説明を追加した上で、`colnames()`のデモを実データ(`df`)ではなく、説明用に作成した日本語列名のデータフレーム(`df_ja`)を使って「日本語→英語への変換」を実演する形に変更。`rename()`のデモは引き続き実データ(`df2`)を使い、`name`→`NAME`という「翻訳ではない一般的なリネーム」の例として維持。
6. **[03_EDA.Rmd](03_EDA.Rmd)への波及対応**: このファイルは`test_scores.xlsx`読み込み直後に`dplyr::rename(class = クラス, ...)`としており、xlsx側の列名が変わったことでこのままではエラーになることが判明。まだqmd化していない章だが、放置すると壊れたソースになってしまうため、不要になった`rename()`チャンクとその説明文を削除する最小限の互換性修正のみ実施（第3章の内容自体は変更していない。本格的なqmd移行は別途行う）。
7. 各変更後、Quarto CLIでレンダリングし、ブラウザで実際の出力（`contains("an")`が`japanese`列のみにマッチすること、`all_of()`のフィルタ結果、列名変更のデモ結果など）を確認済み。

## 2026-09-30: 02_data_wrangling.qmdの仕上げ（画像削除・軽微な修正）

1. 「列名の変更」節にあった、`test_scores.xlsx`がもともと日本語列名だったという裏話の一文を削除（ユーザー指示）。
2. [02_data_wrangling.assets/view_table.PNG](02_data_wrangling.assets/view_table.PNG)（`View()`のスクリーンショット、変更前の日本語列名が写り込んだままだった）を削除。前後の文章はチートシート画像を削除したときと同様、画像なしでも自然に読めることを確認。
3. **見つけて修正した既存のバグ**: 「データフレームオブジェクトの確認」「View()」の節の本文が、実際には存在しない`dat`という変数名を参照していた（実際のコードは一貫して`df`を使用）。`dat`→`df`に修正。該当スクリーンショット（[1549111107106.png](02_data_wrangling.assets/1549111107106.png)）は2019年当時の`dat`という表示のまま残っているが、実害は小さいためそのままにしている。
4. **代入演算子を`<-`に統一**: 「新たな列を追加する」節（`df["total_score"] = ...`）と「データフレームの展開」節（`sales_wide = ...`）で使われていた`=`による代入を`<-`に変更。第1回で「`<-`が正統な記法」と説明していることとの一貫性のため。
5. 「（参考）Rのチートシート」節にあった、日本語版チートシートへの言及（更新が古い可能性があると自身でも注記されていた一文）を削除。
6. 各変更後、Quarto CLIでレンダリングしエラーがないことを確認済み。

## 2026-09-30: 「9 （おまけ）Pythonで同様の作業を行う場合」を追加

第1回と同じ方針で、末尾にPython（pandas）版の対応コードを追加。

- 本文の各節（パッケージ／エクセル読み込み／データフレームの概観／パイプ演算子／条件指定・列の取り出し／列名の変更／並べ替え／新規列追加／連結／結合／展開／文字列操作）に対応するpandasコードを掲載。
- 掲載前に、実際に`test_scores.xlsx`を読み込んですべてのコードを実行し、結果がR側の出力と整合すること（`filter(like="an")`が`japanese`列のみにマッチする、`merge(..., how="outer")`が`full_join()`と同じ欠損行を持つ、`pivot`/`melt`の往復が一致する等）を確認済み（venvは作業後に削除）。
- 第1回同様、コードは実行はせず静的な```python```フェンスドコードブロックとして掲載（qmdのエンジンがknitrのため）。
- Rの`|>`に直接対応する演算子はpandasに無いため、メソッドチェーン（`.method1().method2()`）が同様の役割を果たす旨を説明した。

## 2026-09-30: 「参考文献」を刷新

旧い参考文献（石田基広『Rによるテキストマイニング入門』、データ整理とは間接的にしか関連しない）を削除し、ウェブで調査した現行の資料に置き換えた。置き換え前にすべてのリンクが実際に生きていること、内容が本講義の範囲（select/filter/rename/arrange、パイプ、pivot、結合、文字列処理）と一致することを確認済み。

- [R for Data Science (2nd edition)](https://r4ds.hadley.nz/) の[Data transformation](https://r4ds.hadley.nz/data-transform)・[Joins](https://r4ds.hadley.nz/joins)章（旧版と異なり`|>`ベースに更新されている）
- [私たちのR](http://www.jaysong.net/RBook/)（第1回でも引用済みのサイト）の[第13章 データハンドリング[抽出]](http://www.jaysong.net/RBook/datahandling1.html)・[第17章 整然データ構造](http://www.jaysong.net/RBook/tidydata.html)・[第18章 文字列の処理](http://www.jaysong.net/RBook/string.html)
- [tidyr公式: Pivoting](https://tidyr.tidyverse.org/articles/pivot.html)（パッケージ開発元による公式解説）

## 2026-09-30: `link-external-newwindow`がfile://で無効化されるバグを修正（01・02共通）

ユーザーから「外部リンクをクリックしても同じタブで開いてしまう」との報告。原因を調査したところ、Quartoの`link-external-newwindow`機能は内部で

```js
var filterRegex = new RegExp('/' + window.location.host + '/');
```

という正規表現で「サイト内リンクかどうか」を判定しており、`file://`で直接ローカルファイルを開いた場合は`window.location.host`が空文字列になるため、この正規表現が`//`という「ほぼ全てのhttp(s)リンクにマッチしてしまう」パターンになってしまうことが判明（Pythonで`re`を使って`//`が`https://r4ds.hadley.nz/`等に必ずマッチすることを確認）。結果として、ローカルでfile://として開いたときだけ全リンクが「サイト内リンク」と誤判定され、新しいタブで開かなくなっていた（GitHub Pagesで公開後は`window.location.host`が`michihito-ando.github.io`になるため、この問題自体は起きない想定だが、ローカルでの動作確認に支障が出る）。

**対応**: `format: html:`に`link-external-filter: '^(?:http:|https:)\/\/michihito-ando\.github\.io'`を明示的に追加し、`window.location.host`に依存しない判定に変更。これにより`file://`で直接開いた場合でも、本サイト（michihito-ando.github.io）以外へのリンクは正しく新しいタブで開くようになる。01_elements.qmd・02_data_wrangling.qmdの両方に適用し、再レンダリング後、埋め込まれたスクリプトの正規表現が意図通りになっていることを確認。`docs/`配下の該当htmlにも反映済み。

## 2026-10-07: 03_EDA.Rmd → 03_EDA.qmd

第3回「データの可視化」を、第1回・第2回と同じ方針でqmd化。

### やったこと

1. **[03_EDA.qmd](03_EDA.qmd) を新規作成**。YAMLは第1・2回と同じ形（`subtitle`での日付表示、`link-external-newwindow` + `link-external-filter`など）。元のRmdの図のサイズ設定（`fig_height: 4`, `fig_width: 6`）は維持。画像ファイルの参照はなし。
2. **第2回で決めた講義全体の方針に合わせた修正**: `%>%`→`|>`（第2回で「本講義では以降`|>`に統一」と明記したため、7箇所）、「RStudio Cloud」→「Posit Cloud」。
3. **明らかな誤りの修正**: 「`packman`をインストール」→`pacman`、コメントの「plolyで表示」→「plotlyで表示」、リンク切れだった`skimr`の解説（CRANのvignette URLが404）を[rOpenSciの現行ページ](https://docs.ropensci.org/skimr/articles/using_skimr.html)に差し替え。
4. **見出しの`{-}`（番号なし見出し）**: 元のRmdでは`見出し{-}`とスペースなしで書かれていたが、確実に効くよう`見出し {.unnumbered}`に変更。
5. **日本語のグラフタイトルの文字化けを修正**: この環境（macOS）で通常の`png`デバイスで描くと、`labs(title = "クラスごとの国語の点数の分布")`などの日本語が□□□になっていた。非表示のセットアップチャンクで`knitr::opts_chunk$set(dev = "ragg_png")`を指定し、フォントの代替表示に対応した`{ragg}`で描画するようにした（学生向けに見えるコードには影響しない）。plotlyのインタラクティブなグラフは元々問題なし。
6. `pacman`パッケージがこのマシンに未インストールだったため、レンダリングのためCRANからインストールした。
7. レンダリングし、ブラウザで静的なggplot（日本語タイトル含む）、plotlyのインタラクティブグラフ、番号なし見出し、外部リンクの新規タブ化を確認済み。

## 2026-10-08: 03_EDA.qmdへの提案事項の反映

ユーザーの承認を受けて、変換時に提案した6項目をすべて反映。

1. **「（おまけ）Pythonで同様の作業を行う場合」を追加**（第14節）。pandas＋seaborn/matplotlib＋plotly.expressで、要約統計量・相関・各種グラフ（棒グラフ・ヒストグラム・散布図・回帰直線・折れ線・箱ひげ図・バイオリンプロット・層別化・バブルチャート）・グラフの保存・集計してからの描画に対応するコードを掲載。掲載前に一時的なvenvで全コードを実行し、出力（グラフ画像含む）を確認済み（venvは作業後に削除）。
   - matplotlibもRと同様、日本語フォントを指定しないと□□□になるため、`plt.rcParams["font.family"]`の設定をコードに含めた。
   - seabornのバイオリンプロットはデフォルトで最小値・最大値の外側まで曲線が伸びる（Rの`geom_violin()`は切る）ため`cut=0`を指定。クラスの並び順もRと同じA・B・Cになるよう`order`を指定。
   - Rの`longley`データはPythonでは`statsmodels`に収録されているので、それを使った。
2. `summary()`の説明で「`english`、`japanese`、`math`は整数（integer）型」となっていたのを「数値（numeric）型」に修正（`read_excel()`は`dbl`として読み込むため）。
3. ggplot2チートシートの「日本語翻訳」への参考リンクを削除（第2回で日本語チートシート情報を削除したのに合わせた）。
4. 見出し「例示用データの用意と前処理」→「例示用データの読み込み」（列名変換をなくしたため前処理をしていない）。
5. 表示されない（`eval=F, include=F`）分散の計算コードを削除。
6. **参考文献を刷新**: 2021年のブログ記事を削除し、R for Data Science 2nd edition（Data visualization / Layers / Exploratory data analysis）、私たちのR（第19〜21章 可視化）、ggplot2公式本（3rd edition）、Healy『Data Visualization』のウェブ版（日本語訳の書籍も併記）、Kabacoff『Data Visualization with R』、Plotly公式のggplot2解説、skimr公式解説に整理。全リンクの生存を確認済み。

## 2026-10-08: test_scores.xlsxの得点データを作り直し

旧データは3教科の得点間の相関がほぼゼロ（math–english 0.16、math–japanese 0.23、english–japanese 0.04）で、散布図や相関行列の例として面白みに欠けるとの指摘を受け、得点（math, english, japanese列）だけを作り直した。

- **残したもの**: 40行×5列の構成、`class`・`name`列の値と並び順、シート名（`classes`）、フォント等の書式。第2回の`str_subset("安")`・`str_which("川")`のデモが名前に依存しているため。
- **生成方法**: 「一般的な学力」の因子を3教科共通に、「語学系」の因子をenglishとjapaneseにだけ持たせ、科目固有の成分を足して得点を作った（標準偏差16前後、平均65前後）。クラスごとに小さな得意傾向（A：数学がやや高い、B：国語がやや高い、C：英語がやや高い）もつけた。四捨五入して25〜100点に収めた。
- **乱数のseedの選び方**: 第2回のデモが意味のある結果を返す条件を満たす最初のseedを使った（seed=39）。条件は、①100点がある（`if_any(... == 100)`のデモ用）、②englishとjapaneseがともに90超の生徒がいる（`if_all(...)`のデモ用）、③50<english<60の生徒が4人以上いる、④相関が狙った範囲に入る、の4つ。
- **結果**: 相関はmath–english 0.51、math–japanese 0.36、english–japanese 0.62（語学系どうしの相関が最も高い、それっぽい構造）。平均は67.8/66.0/66.1、標準偏差は13.8/17.1/14.4。100点とenglish・japaneseがともに90超の両方に該当するのは「橋本」。50<english<60は7人。english=25の生徒（鈴井）が1人いる（下限で切った値。外れ値の例にもなる）。
- リポジトリ直下と`docs/`の両方の`test_scores.xlsx`を更新し、第2回・第3回を再レンダリングしてエラーがないことを確認。第3回の散布図・回帰直線ではっきりした右上がりの関係が見えるようになった。

## 2026-10-14: 04_OLS.Rmd → 04_OLS.qmd

第4回「回帰分析」を、第1〜3回と同じ方針でqmd化。

### やったこと

1. **[04_OLS.qmd](04_OLS.qmd) を新規作成**。YAMLは第1〜3回と同じ形（`subtitle`での日付表示、`link-external-newwindow` + `link-external-filter`、非表示のセットアップチャンクで`dev = "ragg_png"`）。図のサイズは元と同じ高さ3・幅4。
2. **講義全体の方針に合わせた修正**: `%>%`→`|>`（1箇所）、`df = CPS1985 ...`→`df <- CPS1985 ...`。
3. **記法の不具合の修正**:
   - `summary(reg_logwage_r)`のチャンクが、開始は4つのバッククォート（` ```` `）で終了は3つという不一致になっていた。Quartoでは閉じられないチャンクになってしまうため、3つに揃えた。
   - チャンクのエンジン指定が大文字の`{R}`になっていた4箇所を、他と同じ`{r}`に統一。
   - 番号なし見出し`{-}`（2箇所）を`{.unnumbered}`に変更（第3回と同様）。
   - 参考文献の本文中の誤字「`lm_robst`」→「`lm_robust`」。
4. `{AER}`パッケージ（CPS1985データを収録）がこのマシンに未インストールだったため、レンダリングのためにCRANからインストールした。
5. レンダリングし、stargazer/texregの表、ヒストグラム、F検定の出力などを確認済み。stargazerにtibbleを渡すと表が空になるバグ（本文で注意書きしている例）は、現行のstargazer 5.2.3でもそのまま再現することを確認したので、注意書きは現在も正しい。

## 2026-10-14: 04_OLS.qmdへの提案事項の反映（modelsummaryへの移行など）

ユーザーの承認を受けて、変換時に提案した8項目をすべて反映。表作成は`{modelsummary}`をメインにするよう指示があった。

1. **表作成を`{stargazer}`/`{texreg}`から`{modelsummary}`に移行**:
   - 要約統計量の表は`datasummary_skim(CPS1985, type = "numeric")`（小さなヒストグラムつき）。回帰分析の表はすべて`modelsummary(list(...), stars = TRUE, gof_omit = "AIC|BIC|Log.Lik|RMSE")`。ファイル保存は`output = "xxx.docx"`（Word）/`.html`。
   - `gof_omit`でAIC・BIC・対数尤度・RMSEを省略している理由: `lm_robust()`の結果を`modelsummary()`に入れると、AIC/BIC/RMSEがおかしな値（RMSEが`lm()`の0.46に対して8.59など）で表示されるため。
   - `lm_robust()`の結果も`modelsummary()`にそのまま入るので、以前の「stargazerと相性が悪いのでtexregを使う」という説明は不要になり、`{texreg}`は使わなくなった。
   - 新しい節「modelsummaryでロバスト標準誤差を指定する」を追加。`lm()`の結果に`vcov = "HC1"`と指定するだけでロバスト標準誤差の表が作れる。**このとき表のF統計量も頑健なものに置き換わる**（90.416/77.265/53.462で、`waldtest(..., vcov = vcovHC(..., type = "HC1"))`と一致）ことを確認し、本文の説明に反映した。分散共分散行列を自分で計算して`vcov = list(...)`で渡した場合はF統計量が表示されないことも確認し、本文に明記した。
   - stargazerは「（参考）stargazerを使う場合」という節に移した（更新停止中であること、`se`引数でロバスト標準誤差に置き換える方法、tibbleを入れると表示されないバグ）。
2. 「制約なし」→「制約あり」（定数項のみに回帰するモデルは制約ありのモデル）。直前に「まず」がないのに「次に」で始まっていた文も修正。
3. 変数名・コメントの綴り`reg_lowage`/`vcov_reg_lowage`→`reg_logwage`/`vcov_reg_logwage`。
4. 使われていないコード（コメントアウトされた「ディレクトリの設定」、中身がコメントだけの非表示チャンク2つ）を削除。
5. Rコード中の全角スペース（`　#`）3箇所を半角に。
6. 「RMarkdown（このウェブ資料）ではNote以下の部分が正しく表示されていない」という古い一文を削除。
7. 節「（参考）不均一分散への対応 (lm_robustを使わない方法)」を「（参考）ロバスト標準誤差を自分で計算する方法」に改題し、表は`modelsummary(..., vcov = list(自分で計算した分散共分散行列))`に変更。
8. **参考文献を刷新**: 安藤の「計量経済学１」講義資料は残し、Hanckらの[Introduction to Econometrics with R](https://www.econometrics-with-r.org/)（Stock & Watsonの教科書のRでの実践版で、本講義と同じ`{AER}`を使う）、矢内勇生氏の[KUT 計量経済学応用](https://yukiyanai.github.io/econometrics2/)、[modelsummary公式](https://modelsummary.com/)、[estimatr公式](https://declaredesign.org/r/estimatr/articles/getting-started.html)に整理。本文中のManchester大学ECLRへの参照（httpsの証明書切れ）も、Introduction to Econometrics with Rの5.4節に差し替え。
9. **「（おまけ）Pythonで同様の作業を行う場合」を追加**（statsmodels）。データは`sm.datasets.get_rdataset("CPS1985", "AER")`で読み込む。一時的なvenvで実行し、係数・ロバスト標準誤差・均一分散のF統計量（90.006/71.214/55.229）・頑健なF統計量（90.416/77.265/53.462）がRと完全に一致することを確認した。`summary_col()`の`*`の基準が`modelsummary()`と異なることも注記した。
   - このマシンのPython（公式サイト版）では`get_rdataset()`がSSL証明書のエラーになった（公式サイト版のPythonは`Install Certificates.command`を実行するまで証明書が入っていないため）。テストは`certifi`の証明書を指定して実行し、学生も同じエラーに遭遇しうるので本文に対処法を一文入れた。
- （追記）ユーザーの指示で、`lm_robust()`の結果を入れるオブジェクト名を`reg_logwage_r`/`reg_multiple_r`/`reg_mincer_r`から`reg_logwage_robust`/`reg_multiple_robust`/`reg_mincer_robust`に変更（R本文とPython付録の両方、計12箇所）。

## 2026-10-21: 05_OLS_Matching.Rmd → 05_OLS_Matching.qmd

第5回「計量経済学１：差の検定/回帰分析/マッチング」を、第1〜4回と同じ方針でqmd化。

### やったこと

1. **[05_OLS_Matching.qmd](05_OLS_Matching.qmd) を新規作成**。YAMLは第1〜4回と同じ形（`subtitle`、`link-external-newwindow` + `link-external-filter`、非表示のセットアップチャンクで`dev = "ragg_png"`）。図のサイズは元と同じ高さ3.5・幅5。画像（`05_Test_OLS_Matching.assets/`の2枚）の参照はそのまま。
2. `%>%`→`|>`（11箇所）。
3. 明らかな誤字の修正: コメントの「`sample_fram()`」→`sample_frac()`、参考文献の「Introuction」→「Introduction」（2箇所）。
4. `{DiagrammeR}`・`{Matching}`がこのマシンに未インストールだったため、レンダリングのためにCRANからインストールした。
5. レンダリングし、DiagrammeRの因果ダイアグラム（日本語ラベル。`fontname = 'Yu Gothic'`というWindows用フォントの指定だが、Macのブラウザでも代替フォントで正しく表示される）、本文中にインラインRで埋め込まれた数値、マッチングの推定結果（502.52）などを確認済み。

## 2026-10-21: 05_OLS_Matching.qmdへの提案事項の反映

ユーザーの承認を受けて、変換時に提案した8項目をすべて反映。

1. **回帰分析の表を`{stargazer}`から`{modelsummary}`に変更**（第4回の方針に合わせた）。`modelsummary(..., stars = TRUE, gof_omit = "AIC|BIC|Log.Lik|RMSE")`。本文の「ｙ切片（`constant`)」も、modelsummaryの表記に合わせて「切片（`(Intercept)`）」に。
2. **数値の食い違いを修正**: 「1600 - 655 = 945万円」（平均値を先に丸めてから引き算）と、回帰係数の「約946万円」が、本文で「等しい」とされながら1ずれていた。丸める前の平均の差を使う形（「両者の平均の差である約946万円」）に直し、3箇所とも946で一致するようにした。
3. 本文中の数値のためだけに`OLS_missing_A`と同じ回帰をもう一度行っていた非表示チャンク（`lm_score`）を削除し、インラインRで`OLS_missing_A`の係数を使うようにした。
4. 使われていないコードを削除: 「没コード」の非表示チャンク（非推奨の`data_frame()`・`funs()`を使用）、コメントアウトされた厳密マッチングのチャンク、コメントアウトされたダイアグラム（`grViz`）、HTMLコメント2つ。
5. `sample_frac(0.5)`（現在のdplyrでは置き換えが推奨されている関数）→`slice_sample(prop = 0.5)`。同じseedで全く同じ標本が抽出され、結果の数値は変わらなかった。
6. `Matching::Match()`はデフォルト（`estimand = "ATT"`）で処置群における平均処置効果（ATT）を推定すること、今回のデータでは効果が一定なのでATT=ATEであることを本文に追記。
7. 細かい表記の修正（「これまでの学習した」→「これまでに学習した」、コメントの「ランダムに選ばれて大卒にする」→「ランダムに選んで大卒にする」）。
   - **追加で見つけて修正**: `Match()`の`Weight = 1`のコメントが「ユークリッド距離に基づくマッチング」となっていたが、ヘルプによると`Weight = 1`は「各共変量の分散の逆数で重みづけた距離」（デフォルト）。コメントを修正した（共変量が1つの今回は結果は同じ）。
8. **「（おまけ）Pythonで同様の作業を行う場合」を追加**: NumPyでのデータ生成、SciPyでの$t$検定（Rの`t.test()`のデフォルトに合わせて`equal_var=False`）、statsmodelsでの回帰分析、scikit-learnの`NearestNeighbors`による最近傍マッチング（ATT）。一時的なvenvで実行し、回帰の大卒の係数500.9、マッチングのATT 501.0とR版とほぼ同じ結果になることを確認（乱数の生成方法がRと違うため数値は完全には一致しない旨を本文に明記）。

## 2026-10-21: 第5回に「（参考）共変量が複数ある場合：回帰分析・マッチング・傾向スコア」を追加

ユーザーの依頼で、マッチング法の節の後（参考文献の前）に、共変量を3つに増やしたデータで4つの方法（重回帰・マッチング・傾向スコアマッチング・IPW）を比較する参考節（第8節）を追加。

- **新しいデータを生成した理由**: 本編のDGPは「能力80以上の人からだけ大卒が選ばれる」ため、能力80未満の人が大卒になる確率は0で、比較相手がいない（オーバーラップが成り立たず、IPWでは0で割ることになる）。そこで、大卒になる確率が共変量によってなめらかに変わるDGPを別に用意した（本文でもこの理由を説明）。
- **DGP**（`df_multi`、n=10,000、`set.seed(1)`）: 能力$A$〜U(0,100)、親の所得$P$〜U(200,1000)、都市部出身$U$〜Bernoulli(0.5)。大卒になる確率は$e=\text{logistic}(-4+0.04A+0.003P+0.6U)$（範囲0.03〜0.97でオーバーラップ良好）。所得は$Y=200+10A+0.5P+100U+500X+\varepsilon$（$\varepsilon$〜N(0,50²)）。効果は全員500で一定なのでATE=ATT=500。本文にDiagrammeRで因果ダイアグラムも追加。
- **推定結果**: 単純な平均の差835.4（大きなバイアス）、重回帰500.3、共変量マッチング502.2、傾向スコアマッチング501.5、IPW 504.2。マッチングは`Matching::Match(..., estimand = "ATE")`で、他の方法と同じくATEを推定。傾向スコアは`glm(..., family = binomial)`のロジスティック回帰で推定（係数は真の値に近い）。IPWは重み付き平均の差。
- **わかりやすさのための工夫**: 傾向スコアの分布を大卒・非大卒で重ねたヒストグラム（オーバーラップの確認）、IPWの重みをつける前と後での共変量の平均の比較表（重みなしでは大卒者の能力62.7・非大卒者36.2が、重み付きでは50.0・49.8にそろう）、4つの推定結果の比較表、各方法の前提（無交絡性・オーバーラップ・モデルの正しさ）のまとめ。
- 表示の調整: tibbleのままだと比較表の数値が「500.」のように3桁に丸められ、共変量の比較表は列が省略されてしまうため、`knitr::kable()`で表として表示。見出しにつけていた「1.」〜「4.」は自動の節番号と二重になるので外した（8.1〜8.6）。
- Python付録はこの節に対応するコードをまだ含んでいない。
- （追記）ユーザーの依頼で、傾向スコアを使った2つの方法を、より一般的に使われるパッケージに差し替えた。
  - **傾向スコアマッチング**: `Matching::Match()`→**{MatchIt}**の`matchit(..., method = "nearest", distance = "glm", estimand = "ATT", replace = TRUE)`。効果は`match.data()`で取り出したデータに対し、マッチングの重みつきで`estimatr::lm_robust(income ~ university, weights = weights, se_type = "HC1")`で推定（501.9）。MatchItの最近傍マッチングはATEに対応していないためATTを推定対象とし、今回は効果が一定でATT=ATEである旨を本文に明記。
  - **復元マッチング（`replace = TRUE`）にした理由**: 今回は大卒者（5215人）のほうが非大卒者（4785人）より多く、傾向スコアが高い非大卒者が少ないため、非復元では推定値が約882と大きく偏る（プロトタイプで確認。大卒者の割合を35%に下げたデータでも非復元では638だった）。本文でも理由を説明し、非復元の場合の値はインラインRで計算して表示している。
  - **IPW**: 手計算の重み付き平均→**{WeightIt}**の`weightit(..., method = "glm", estimand = "ATE")`と`lm_weightit()`。推定値は手計算と同じ504.2で、標準誤差（5.04）は傾向スコアの推定を考慮したものになる（以前の「`lm()`の重み付き回帰の標準誤差は正しくない」という注意書きは不要になったので削除）。
  - **バランスの確認**: 手作りの平均比較表→**{cobalt}**の`bal.tab(..., un = TRUE, disp = "means")`（重み付け・マッチング前後の平均と標準化平均差）。マッチング（ATT）では非大卒者が大卒者の平均（能力≈62.7）にそろい、IPW（ATE）では両群が全体の平均（能力≈50）にそろう、という違いを本文で説明した。
  - 「共変量そのものを使ったマッチング」（8.3節）は、本編と同じ`Matching::Match()`のまま。
  - `{MatchIt}`・`{WeightIt}`・`{cobalt}`をCRANからインストールした（`{estimatr}`は第4回で導入済み）。
- （追記）ユーザーの指示で、第5回のマッチングをすべて**{MatchIt}に統一**し、標準誤差についての解説を追加した。
  - **本編「7 マッチング法」**: `Matching::Match()`→`matchit(university ~ ability, method = "nearest", distance = "euclidean", estimand = "ATT", replace = TRUE)`。流れを「`matchit()` → `bal.tab()`でバランス確認 → `match.data()`で取り出して`lm_robust()`で重みつき回帰」に統一し、`bal.tab()`の見方（`M.0`/`M.1`、`Un`/`Adj`、標準化平均差の0.1の目安）と、最近傍マッチングがATTしか推定できない理由（大卒者一人ひとりにだけ相手を探す片方向のマッチングのため）、復元マッチングの意味を本編で説明。推定値は502.8（以前の`Match()`では502.5）。冒頭の`p_load()`は`Matching`→`MatchIt, cobalt, estimatr`に変更。「傾向スコアマッチングはここでは扱わない」という一文は「次節の参考で扱う」に変更。
  - **8.3節（共変量でのマッチング）**: `distance = "mahalanobis"`（共変量の単位の違いを調整する距離）で`matchit()`を使用、ATT推定値501.9。
  - **8.4節（傾向スコアマッチング）**: 本編と重複する説明を削り、「`distance = "glm"`にするだけ」という違いが分かる形に整理。
  - **比較表**の手法名に推定対象（ATT/ATE）を併記。
  - **標準誤差の解説**（8.6節「標準誤差について」）: マッチング後はロバスト標準誤差（MatchItの公式解説で、重みがつく復元マッチングでは推奨。非復元ではペアごとのクラスター頑健標準誤差）が近似的なものであること、ブートストラップも使われること、傾向スコアが推定値であることによる誤差を`lm_weightit()`は考慮するが傾向スコアマッチング後のロバスト標準誤差は考慮しないこと。MatchItの公式解説「Estimating Effects After Matching」の内容を確認した上で記述。本編のマッチングの節からもこの解説にリンク。
  - 参考文献にMatchIt・WeightItの公式サイトを追加。Python付録の「Rの`Matching::Match()`と同じく」という記述も`matchit()`に合わせて修正。
- （追記）**第5回の参考文献を更新**（全リンクの生存と内容を確認済み）。
  - 矢内勇生氏の講義ノートを、旧URL（`/jp/classes/econometrics2/contents/R/...`）から、2020年度版の講義資料（`https://yukiyanai.github.io/econometrics2/`の「回帰分析」「傾向スコア」の章）に更新。
  - The Effect（2021）の第13章・第14章は継続（第14章がマハラノビス距離・傾向スコア・IPWを扱っていることを確認）。
  - 新規追加: Cunningham "Causal Inference: The Mixtape"（ウェブでは改訂中の第2版 "The Remix" が公開。"Potential Outcomes and Randomization"・"Unconfoundedness"の章が回帰・最近傍マッチング・傾向スコア・IPWを扱い、Rコードつき）、Hernán & Robins (2020) "Causal Inference: What If"（PDF無料）。
  - MatchIt・WeightIt公式サイトは1項目にまとめた。DGPの出典（安藤 2015）は従来どおり。
- （追記）**Python付録に、8節（共変量が複数ある場合）に対応するコードを追加**（付録の「（参考）共変量が複数ある場合：回帰分析・マッチング・傾向スコア」）。
  - Pythonには{MatchIt}・{WeightIt}のような定番のパッケージがないため、statsmodels（重回帰、`smf.logit()`による傾向スコアの推定、`smf.wls()`によるIPW）とscikit-learnの`NearestNeighbors`（`metric="mahalanobis"`による共変量マッチング、傾向スコアによるマッチング。いずれも復元・ATT）で、仕組みが分かる形で実装。バランスの確認（マッチング前後・重み付けの前後の共変量の平均）も含めた。
  - 掲載するコードそのものを一時的なvenvで実行して確認: 単純な平均の差833.3、重回帰500.0、マッチング502.6、傾向スコアマッチング501.0、IPW 497.4。傾向スコアの係数も真の値に近い。重み付き平均では両群の能力が50.3・50.5にそろう。
  - バランス表の重み付き平均は、pandasのバージョンで挙動が変わる`groupby().apply()`を避け、「重み×値の合計 ÷ 重みの合計」で計算する形にした。
  - マッチング・IPWの標準誤差は計算しておらず、`wls`の標準誤差は傾向スコアの推定を考慮していない旨と、ブートストラップやDoWhyなどの選択肢を注記。

## 2026-10-28: 06_IV.Rmd → 06_IV.qmd

第6回「計量経済学２：操作変数法」を、第1〜5回と同じ方針でqmd化。

### やったこと

1. **[06_IV.qmd](06_IV.qmd) を新規作成**。YAMLは第1〜5回と同じ形（`subtitle`、`link-external-newwindow` + `link-external-filter`、非表示のセットアップチャンクで`dev = "ragg_png"`）。図のサイズは元と同じ高さ3.5・幅5。
2. `%>%`→`|>`（9箇所）。
3. 明らかな誤字の修正: コメントの「`sample_fram()`」→`sample_frac()`、本文の「{textreg}」→「{texreg}」、「開示しつも」→「開示しつつも」、参考文献の「Introuction」→「Introduction」。
4. `{Hmisc}`がこのマシンに未インストールだったため、初回レンダリング時に`pacman::p_load()`がCRANからインストールした（その際のメッセージがhtmlに出たので、インストール後にもう一度レンダリングした）。
5. レンダリングして結果の数値を確認: 欠落変数を無視した回帰 674.7・713.6、第一段階 0.396、誘導型 201.8、IV推定値 509.67（割り算・`ivreg()`・`iv_robust()`で一致）。

### 確認したこと（提案事項の根拠）

- データ生成のコードで、`case_when()`の最初の条件が`exemption == 1`になっているため、能力80以上で元々大卒だった人も、学費免除に当たると50%の確率で非大卒になってしまう（seed 0では312人中151人）。本文・コードのコメントの「能力80以上で大卒となった人は対象外（学費免除の有無に関わらず卒業できる）」と食い違う（IVの用語では「defier」が生じ、単調性の仮定が満たされない。ただし効果が全員500で一定なので、IV推定値には偏りが出ない）。
- `sample_frac(0.5)`→`slice_sample(prop = 0.5)`に置き換えても、同じseedで全く同じデータになることを確認。

## 2026-10-28: 06_IV.qmdへの提案事項の反映

ユーザーの承認を受けて、変換時に提案した9項目をすべて反映。

1. **表を`{stargazer}`・`{texreg}`から`{modelsummary}`に変更**（第4・5回の方針に合わせた）。`AER::ivreg()`と`estimatr::iv_robust()`の結果もそのまま表にできた。「stargazerだとなぜかエラーがでたのでtexregを使用」のコメントは削除。htmlへの出力も`texreg::htmlreg()`から`modelsummary(..., output = "06ivreg_table.html")`に変更（`eval=FALSE`のまま）。`p_load()`から`stargazer`・`texreg`・`Hmisc`を外し、`modelsummary`・`skimr`を追加。
2. **データ生成のコードを本文に合わせて修正**: `case_when()`の条件の順番を入れ替え、`university == 1 ~ 1`を先に判定するようにした（能力80以上で既に大卒の人は、学費免除に当たっても大卒のまま。defierがいなくなる）。`case_when()`は上から順に判定するので順番に注意する、というコメントも追加。これにより結果が変わった: 欠落変数を無視した回帰 699.4・756.9、第一段階 0.446（旧0.396）、誘導型 227.0、IV推定値 508.58（SE 14.38、ロバストSE 14.33）。「なぜ40%なのか」の説明を「なぜ50%ではなく約45%なのか」に書き直した（学費免除者約3,000人のうち、能力80以上で元々大卒の約300人を除いた約2,700人の50%＝約1,350人が学費免除によって大卒になる → 1350/3000=0.45。大卒率0.55と0.10の差としても説明）。`head(df)`の6行は修正前と同じ。
3. 本文の細かい修正: 第一段階・誘導型の「学歴ダミーの係数推定値」→「学費免除ダミーの係数推定値」、「誘導形」→「誘導型」、「テストの点数」への言及を削除、「手動で二段階の推定する」→「推定を行う」、「500万を正確に推定できている」→「500万円を、ほぼ推定できている」、「学費補助」→「学費免除」（2箇所）、「大卒になる確率が約40%上昇」→インラインRで「約45%ポイント上昇」。
4. コードを第5回のqmdにそろえた: `sample_frac(0.5)`→`slice_sample(prop = 0.5)`、`no_university_df["university"] = 0`→`mutate()`、乱数の種などのコメント、`iv_reg =`→`<-`、2つ目のダイアグラムのチャンクの`p_load(DiagrammeR)`を削除。
5. 記述統計を`Hmisc::describe()`から`skimr::skim()`（第3回で扱った関数）に変更し、ダミー変数の平均が割合を表すことを一言追加。
6. **「弱操作変数の確認」の小節を追加**（5.4。ロバスト標準誤差は5.5に）: `summary(iv_reg, diagnostics = TRUE)`の出力と、Weak instruments（第一段階のF検定。目安F>10、近年はより厳しい基準もある。今回は約3,013）・Wu-Hausman・Sargan（操作変数が1つなのでNA）の簡単な説明。TSLSの節の`summary(iv_reg)`は`modelsummary(iv_reg)`に置き換えた。
7. 使われていない部分を削除: {ivpack}（CRANから削除）のコメントアウトされた節、ロバスト標準誤差についてのHTMLコメント（「ロバスト標準誤差のほうが若干大きく」とあったが、実際にはわずかに小さく、内容も誤っていた）。
8. 参考文献を第5回と同じ書式で刷新: 矢内勇生「計量経済学応用」の新しい版（Topic 9 操作変数法）、The Effect 第19章、Mixtape（Remix）の「Instrumental Variables」の章を追加。リンクはすべて200を確認。
9. **「（おまけ）Pythonで同様の作業を行う場合」を追加**: NumPyでのデータ生成（修正後のDGP）、statsmodelsでのOLS・第一段階・誘導型、linearmodelsの`IV2SLS.from_formula("income ~ 1 + [university ~ exemption]")`によるTSLS、`first_stage`（Partial F）と`wu_hausman()`、`cov_type="robust", debiased=True`（HC1相当）のロバスト標準誤差と`compare()`の比較表。掲載したコードをそのまま一時的なvenvで実行し、OLS 695.0・746.7、第一段階0.433、誘導型222.5、IV推定値513.8、第一段階F 2,854を確認（venvは削除済み）。

## 2026-10-28: 06_IV.qmdのデータ生成コードを単純化し、seedを10101に変更

ユーザーの依頼で、データ生成のコードを単純化（能力の一様分布・正規分布の誤差項は元のまま）。

1. `filter()`→`slice_sample()`→`anti_join()`→`bind_rows()`→`arrange()`→`case_when()`と中間のデータフレーム4つを使っていたコード（約40行）を、`tibble()`と1つの`mutate()`の中で`rbinom()`と`if_else()`を使って変数を1つずつ作る形（約10行）に変更。能力80以上の人は「ちょうど半分」ではなく「確率50%で」大卒になるが、本文はもともと「約2,000人中から約1,000人」なので食い違いはない。「まだ大卒でない学費免除者」を`university == 0 & exemption == 1`と直接書くので、`case_when()`の順番の問題も起きなくなった。コードの前に「前回はfilter()などで抽出・結合したが、今回はrbinom()でmutate()の中で1つずつ作る」という説明を追加。
2. `set.seed(0)`→`set.seed(10101)`。結果: 欠落変数を無視した回帰 687・746、第一段階 0.46、誘導型 229、IV推定値 502.0（SE 14.1、ロバストSE 14.2）、弱操作変数のF 3,176.5。
3. 第一段階が0.46になったため、「なぜ50%ではなく約45%と推定されるのか」→「なぜ50%より小さい値が推定されるのか」に変更（理論値0.45の説明はそのまま）。
4. Pythonのおまけも同じ形（`np.where()`と`rng.binomial()`）に直し、`default_rng(10101)`に変更。掲載したコードを一時的なvenvでそのまま実行し、本文の数値を更新（OLS 690・749、第一段階0.44、誘導型216、IV推定値487（SE約15）、第一段階F 2,956）。venvは削除済み。

## 2026-10-28: 06_IV.qmdで`AER::ivreg()`を`ivreg::ivreg()`に変更し、modelsummaryでの標準誤差の書き換えを追加

ユーザーの依頼で以下を反映。

1. `p_load()`の`AER`→`ivreg`、`AER::ivreg()`→`ivreg::ivreg()`。{ivreg}（0.6-8）がこのマシンに未インストールだったため、レンダリング前にCRANからインストールした（`p_load()`のインストールメッセージがhtmlに出るのを避けるため）。推定値・標準誤差・`summary(..., diagnostics = TRUE)`の結果は{AER}版と同じ（IV推定値502.015、SE 14.102、弱操作変数のF 3,176.5）。
2. TSLSの節に、{AER}版との違いについての短い注を追加（もともと{AER}の関数で、同じ開発者が独立させて開発を続けている／書き方と推定結果は同じで、回帰診断の機能などが追加されている／古い資料の`AER::ivreg()`はそのまま読み替えてよい／両方読み込むと関数名が重なるので`ivreg::ivreg()`と明示する）。
3. ロバスト標準誤差の節に「（参考）`modelsummary()`で標準誤差を書き換える」の小見出し（番号なし）を追加。同じ`iv_reg`を2列並べて`vcov = list("iid", "HC1")`とし、通常の標準誤差（14.102）とロバスト標準誤差（14.243）を比較。2列目が`iv_robust(se_type = "HC1")`と一致することを本文で説明（{sandwich}・{fixest}を含めた3つの方法で完全一致することを事前に確認済み）。
   - メモ: `vcov = "iid"`を`iv_robust`のオブジェクトに指定すると、modelsummaryが「iv_robustのデフォルトのvcovはIIDとは限らない」という警告を出す（表示ラベルが実際と食い違う）。そのため`iv_robust`は比較表に入れず、`ivreg`の2列だけにした。

## 2026-10-28: 06_IV.qmdの参考文献のMixtapeの記述を修正

ユーザーの指摘で、参考文献の「Causal Inference: The Mixtape（現在ウェブ上では改訂中の第2版"The Remix"が公開されている）」を、書名「Causal Inference: The Remix」とし、「"Causal Inference: The Mixtape"（2021年）の第2版」という説明に変更（改訂は終了しているため「改訂中」を削除）。URLはそのまま。

## 2026-10-28: 05_OLS_Matching.qmdの参考文献のMixtapeの記述を第6回にそろえて修正

第6回と同じく、書名を「Causal Inference: The Remix」とし、「"Causal Inference: The Mixtape"（2021年）の第2版」という説明に変更（「改訂中」を削除）。章へのリンクと説明はそのまま。再レンダリング済み（`docs/05_OLS_Matching.html`は次のcommit時に更新）。
