egen id = group(partner productcode6)
order id ,first  //对变量进行分组，准备回归
duplicates report id year //70个观测值重复了35次
duplicates tag id year,gen(f)
//删除了产品代码为380993的缺失了1992年的进口数据
//删除了产品代码为380999的只有1992年的进口数据
drop if f == 0
drop if f == 19
drop f
xtset id year
***生成log变量
gen lny = log(1+d.tradevaluein1000usd)
gen lnntm = log(1+d.count)
gen lntar=log(1+d.advalorem)
gen lngdp=log(1+d.gdp)
gen lnchngdp=log(1+d.chngdp)
gen lnpergdp = log(d.pergdp)
gen lnchnpergdp = log(d.chnpergdp)
gen lnex=log(1+d.exchangerate)
destring productcode6,replace
//补充produtctcode至6位
gen nproductcode = "0" + productcode6 if strlen(productcode6) == 5
replace productcode6 = nproductcode if strlen(productcode) == 5
gen productcode6 = substr(productcode,1,6)
drop nproductcode
order productcode6, after(productcode)
xtreg lny lnntm lntar lngdp lnchngdp lnpergdp lnchnpergdp lnex,absorb(year partner productcode6) 
est store reg1
