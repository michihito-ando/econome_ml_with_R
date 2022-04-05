# 準備

setwd("D:/Dropbox/Lectures/Econome_ml_with_R/data")

library(tidyverse)
set.seed(666)

# データ読み込み
library(carData)
data("TitanicSurvival")
head(TitanicSurvival)

# NA（欠損値）を含む行を削除
tita <- na.omit(TitanicSurvival)

# ID列を追加
df = tita %>% rownames_to_column("ID")

# 80%を学習用データに
train <- df %>% sample_frac(size = 0.8)

# 学習用データに使っていないIDの行をテスト用データに
test <- anti_join(df, train, by = "ID")

# ID列は予測に使わないため削除しておく
train <- train %>% select(-ID)
test <- test %>% select(-ID)

#install.packages("nnet")
library(nnet)

titanic_nnet <- nnet(survived ~ . , data = train,
                     size = 2, decay = 0.1)


# network構造の図
if(!require(NeuralNetTools)) {install.packages("NeuralNetTools")} # インストールされていなければインストールする

library(NeuralNetTools)

plotnet(titanic_nnet)


# 訓練データを用いて予測
y_pred_train = predict(titanic_nnet, train, type = "class")

# 混同行列
table(train$survived, y_pred_train)

# 正解率
library(MLmetrics)
Accuracy(y_pred = y_pred_train, y_true = train$survived)

# テストデータを用いて予測
y_pred_test = predict(titanic_nnet, test, type = "class")

# 混同行列
table(test$survived, y_pred_test)

#正解率
Accuracy(y_pred = y_pred_test, y_true = test$survived)


# ディープラーニング

# パッケージの読み込み
library(tidyverse)
library(MLmetrics)

# 乱数の種を固定
set.seed(0)

#MNIST

#MNISTデータのダウンロード
if (!dir.exists('data')) { # もしdataディレクトリがないなら作成
  dir.create('data')
}
if (!file.exists('data/train.csv')) { # もしdataディレクトリにtrain.csvがないならダウンロード
  download.file(url='https://raw.githubusercontent.com/wehrley/Kaggle-Digit-Recognizer/master/train.csv',
                destfile='data/train.csv')
}

mnist <- read.csv('data/train.csv')

# 1レコード目の1~10列
mnist[1, 1:10]

# 1レコード目の210~220列
mnist[1, 210:220]

# 1レコード目の最後の10列
k = ncol(mnist)
mnist[1, (k-10):k]

# 教師データ（目的変数）= 1列目
y <- mnist[,1]

# 特徴量（説明変数）= 残りの784列
X <- mnist[,-1]

# 0から1の値になるよう正規化し、(数値が0~255なので、255で割る)、行と列をt()で入れ替える
X <- t(X/255)

# 扱っているデータを覗く
i = 10 # 10レコード目
pixels = matrix(X[,i], nrow=28, byrow=TRUE)
image(t(apply(pixels, 2, rev)) , col=gray((255:0)/255), 
      xlab="", ylab="", main=paste("Label for this image:", y[i]))

i = 1000 # 1000レコード目
pixels = matrix(X[,i], nrow=28, byrow=TRUE)
image(t(apply(pixels, 2, rev)) , col=gray((255:0)/255), 
      xlab="", ylab="", main=paste("Label for this image:", y[i]))

# testとtrainに分割
# ID列を追加
df = mnist %>% rownames_to_column("ID")

# 80%を学習用データに
train <- df %>% sample_frac(size = 0.8)

# 学習用データに使っていないIDの行をテスト用データに
test <- anti_join(df, train, by = "ID")

# ID列は予測に使わないため削除しておく
train <- train %>% select(-ID)
test <- test %>% select(-ID)

# 教師データのラベル
table(train[, 1])

# ライブラリの用意
if(!require(h2o)) {install.packages("h2o")}
library(h2o)

# 初期化
h2o.init()

# データをh2o用のデータ型に変換
train <- as.h2o(train)
test <- as.h2o(test)

# 1列目（目的変数）をfactor型に変換
train[,1] = h2o::as.factor(train[,1])
test[,1] = h2o::as.factor(test[,1])

# trainデータを学習用のものと検証用のものに分ける
splits <- h2o.splitFrame(train, ratios = 0.8, seed = 0)

# 学習
mnist_dl = h2o.deeplearning(
  x = 2:ncol(train), # 特徴量の列番号を指定
  y = 1,             # 目的変数の列番号を指定
  training_frame = splits[[1]],   # 訓練データを指定
  validation_frame = splits[[2]], # 検証データを指定（学習には使わず、精度を測るためだけに使う）
  activation = c("RectifierWithDropout"), # 活性化関数を指定
  hidden = c(128, 64, 16), # 中間層（隠れ層）のサイズ
  epochs = 15,       # エポック数。学習データ何回分の学習を反復させて重みを更新していくか。
  hidden_dropout_ratios = c(0.5, 0.5, 0.5), # 各中間層においてdropoutするユニットの割合
  sparse = TRUE,     # 0が多いデータ（スパースデータ）の取り扱い方を変え、メモリ使用量を抑える。
  standardize = TRUE,# データの標準化を学習前に行う
  seed = 0
)

mnist_dl

# 予測誤差の推移
plot(mnist_dl)

# 予測
pred <- h2o.predict(mnist_dl, test)

# 予測結果
pred

# 予測確率
round(pred[,2:11], 3)

y_true = as.vector(test[,1])
y_pred = as.vector(pred[,1])

# 混同行列
table(y_true, y_pred)

# 混同行列（h2oパッケージの関数を使う場合）
h2o.confusionMatrix(mnist_dl, test)

# 正解率
library(MLmetrics)
Accuracy(y_pred = y_pred, y_true = y_true)
