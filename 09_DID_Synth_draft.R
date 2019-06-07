# 事前準備 --------------------
# パッケージの読み込み
library(tidyverse)
library(plm)
library(stargazer)
# 乱数の種を固定
set.seed(0)

# データの生成 ----------------
n <- 10000
# 能力は0から100まで均等に分布
ability <- runif(n, min = 0, max = 100)

# IDとabilityをデータフレームに格納する
df <- tibble(ID = 1:n, ability)

# 1年目

## year = 0を加える
df0 <- df %>% mutate(year = 0)

##　職業訓練フラグ
##　一年目は誰も職業訓練をうけない
df0 <- df0 %>% mutate(training = 0)

#所得 incomeを加える
df0 <- df0 %>% mutate(income = 200 + 10*ability + rnorm(n, mean = 0, sd = 50))

# 2年目

## year = 1　を加える
df1 <- df %>% mutate(year = 1)

## 職業訓練フラグ
## 条件：能力を部分的に反映した適正試験が 180 点以上であれば職業訓練を受けられる
## 10%くらいが該当するように恣意的に設定
## abilityとscoreの関係は非線形なものとする
## 今回もmutate()とcase_when()を使用して作成

#適正試験の点数 score
df1 <- df1 %>% mutate(score = 30 * log10(ability) + rnorm(n, mean = 115, sd = 10))
#職業訓練ダミー training (score 180点以上=1)
df1 <- df1 %>% mutate(training = case_when(score >= 180 ~ 1, TRUE ~ 0))
#所得 income: 年ショックとして100も追加
df1 <- df1 %>% mutate(income = 200 + 10*ability + 500*training + rnorm(n, mean = 100, sd = 50))

# 1年目と2年目をくっつける。
df_binded <- bind_rows(df0, df1)

# panelとして認識
df_panel <- pdata.frame(df_binded, index = c("ID", "year")) # 個体=firm、時間=yearと認識させたdf

# regression

# pooled OLS
pool_lm <- lm(income ~ training, data = df_panel)
summary(pool_lm)

pool_plm <- plm(income ~ training, data = df_panel, model = "pooling")
summary(pool_plm)

# DID with one-way FE model
DID_plm1 <- plm(income ~ training + training*year, data = df_panel, model = "within")
summary(DID_plm1)

# DID with two-way FE model
DID_plm2 <- plm(income ~ training, data = df_panel, model = "within", effect = "twoways")
summary(DID_plm2)

stargazer(pool_lm, pool_plm, DID_plm1, DID_plm2, type = "text", digits = 3, df = FALSE,
          column.labels = c("Pooled(lm)","Pooled(plm)","DID(onewayFE)","DID(twowayFE)"),
          model.names = F, model.numbers = F)

