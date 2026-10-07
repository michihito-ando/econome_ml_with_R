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
