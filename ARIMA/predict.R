library("readxl")
library("httpgd")
library("dplyr")
library("ggplot2")

my_data <- read_excel("./data/commodities-1.xls")
my_data <- as.ts(my_data[,"Sugar price"])


plot(my_data[, "Sugar price"])
plot.ts(my_data[,"Sugar price"], col="blue")
table(my_data)
my_data[, "Sugar price"]

View(my_data)

#Take first, second and third lag difference of data
firstDiff <- diff(my_data[,"Sugar price"],lag=1, differences=1)
secondDiff <- diff(my_data[,"Sugar price"],lag=1, differences=2)
thirdDiff <- diff(my_data[,"Sugar price"],lag=1, differences=3)
plot.ts(thirdDiff, col="darkgreen")

ggplot(my_data, aes(x=my_data[,"Date"], y=my_data[,"Sugar price"])) +
       geom_line() 
       



acf(my_data)
pacf(my_data)


