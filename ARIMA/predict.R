library("readxl")
library("httpgd")

my_data <- read_excel("./data/commodities.xls")
my_data <- as.ts(my_data)

plot.ts(my_data)
table(my_data)
df

View(my_data)

firstDiff <- diff(my_data,lag=1, differences=1)
secondDiff <- diff(my_data,lag=1, differences=2)
thirdDiff <- diff(my_data,lag=1, differences=3)

acf(my_data)
pacf(my_data)


