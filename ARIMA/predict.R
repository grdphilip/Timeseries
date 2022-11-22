library("readxl")
library("httpgd")
library("dplyr")
library("ggplot2")
library("tseries")
library("forecast")
library("seasonal")


my_data <- read_excel("./data/commodities-1.xls")
my_data <- ts(my_data[,"Sugar price"], start=c(1960, 1), end = c(2022, 10), frequency = 12)
logged <- log(my_data)
data_reserv <- my_data 
colnames(my_data) <- "Sugar price"

plot.ts(my_data, ylab="Sugar price", col="blue")
table(my_data)

View(my_data)

#Take first, second and third lag difference of data
firstlogDiff <- diff(log(my_data[,"Sugar price"]),lag=1, differences=1)
secondlogDiff <- diff(log(my_data[,"Sugar price"]),lag=1, differences=2)
thirdlogDiff <- diff(log(my_data[,"Sugar price"]),lag=1, differences=3)
diff.ts <- diff(my_data, lag=1, differences=1)
plot.ts(diff.ts[,"Sugar price"], col="#a19f2d", main = "Diff")

summary(my_data)
Acf(my_data, lag.max = 20)
Pacf(my_data, lag.max = 20)
#Kolla diffad data
Acf(diff.ts, lag.max = 20, main="Acf diffdata")
Pacf(diff.ts, lag.max = 20, main="Pacf diffdata")
adf.test(my_data)
adf.test(diff.ts)

#Verkar som att datan är är stationär i första differensen. Stor skillnad på lag 1 och 2


AR1 <- Arima(my_data, order=c(1,0,0)) #AR(1)
MA1 <- Arima(my_data, order=c(0,1,0)) #MA(1)
ARMA1 <- Arima(my_data, order=c(1,0,1)) #ARMA(1)

model1 <- Arima(diff.ts, order= c(1,0,0), include.mean= FALSE)
model2 <- Arima(my_data, order = c(1,1,0))
forecast1 <- forecast(model1, n=10)
for.mean <- my_data[nrow(my_data)] + cumsum(forecast1[["mean"]])


forecast2 <- forecast(model2, n=10)
for.mean <- my_data[nrow(my_data)] + cumsum(forecast[["mean"]])

predict(model1, n.ahead = 10)
predict(model2, n.ahead = 10)

checkresiduals(model2)
Acf(residuals(model2))
Pacf(residuals(model2))

auto.arima(diff.ts, trace=TRUE, seasonal=FALSE)
model3 <- Arima(diff.ts, order=c(0,0,3), include.mean = FALSE)
forecast(model3)

checkresiduals(model3)
Acf(residuals(model3))
Pacf(residuals(model3))
autoplot(forecast(model1))


