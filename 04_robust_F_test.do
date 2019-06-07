*　データの読み込み
import delimited using "D:\Dropbox\Lectures\Econome_ml_with_R\04_OLS_df.csv", clear
　
*　log of wage
gen log_wage = log(wage)

* 均一分散を仮定した標準誤差
reg log_wage education 
reg log_wage education experience
reg log_wage education experience experience2

* 不均一分散に対して頑健な標準誤差
reg log_wage education, robust
reg log_wage education experience, robust
reg log_wage education experience experience2, robust
