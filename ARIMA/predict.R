library("readxl")
library("httpgd")
library("dplyr")
library("ggplot2")
library("forecast")
library("seasonal")

my_data <- read_excel("./data/commodities-1.xls")
my_data <- ts(my_data, start=c(1960, 1), end = c(2022, 10), frequency = 12)
logged <- log(my_data)
data_reserv <- my_data 
colnames(data_reserv) <- "Sugar price"

plot(my_data, ylab="Sugar price", col="blue")
table(my_data)
my_data[, "Sugar price"]

View(my_data)

#Take first, second and third lag difference of data
firstlogDiff <- diff(log(my_data[,"Sugar price"]),lag=1, differences=1)
secondlogDiff <- diff(log(my_data[,"Sugar price"]),lag=1, differences=2)
thirdlogDiff <- diff(log(my_data[,"Sugar price"]),lag=1, differences=3)
diff.ts <- diff(my_data, lag=1, differences=1)
plot.ts(diff.ts, col="#a19f2d", main = "Diff")

summary(my_data)
Acf(my_data, lag.max = 20)
Pacf(my_data, lag.max = 20)
#Kolla diffad data
Acf(diff.ts, lag.max = 20, main="Acf diffdata")
Pacf(diff.ts, lag.max = 20, main="Pacf diffdata")
#Verkar som att datan är 







