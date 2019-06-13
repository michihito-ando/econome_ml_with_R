import delimited using "D:\Dropbox\Lectures\Econome_ml_with_R\Grunfeld.csv"

rename v1 id
xtset firm year

*pooled
reg inv value capital
reg inv value capital,r

*oneway fe
xtreg inv value capital, fe
xtreg inv value capital, r fe

*twoway fe
reg inv value capital i.firm i.year
reg inv value capital i.firm i.year, r
reg inv value capital i.firm i.year, cluster(firm)

xtreg inv value capital i.year, fe
xtreg inv value capital i.year, r fe
