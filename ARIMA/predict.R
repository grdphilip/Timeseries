library("readxl")
library("httpgd")
library("dplyr")
library("ggplot2")
library("tseries")
library("forecast")
library("seasonal")
library("lmtest")

# We are looking for a model with:
# i) white noise residuals (=no autocorrelation in residuals),
# Chi squared test for white noise, Ljung-Box testing (Note that it is applied to the residuals of a fitted ARIMA model, not the original series).
# ii) low residual variance (=low information criteria),
# iii) few parameters and which is understandable, parameters that make common sense (a parsimonious model).

my_data <- read_excel("./data/commodities-1.xls")
my_data <- ts(my_data[, "Sugar price"], start = c(1960, 1), end = c(2022, 10), frequency = 12)
logged <- log(my_data)
diff.ts <- diff(my_data, lag = 1, differences = 1)
data_reserv <- my_data
clean_data <- tsclean(my_data)
diffclean <- diff(clean_data)
colnames(my_data) <- "Sugar price"

plot.ts(my_data, ylab = "Sugar price", col = "blue", main = "Suger price over time")
plot.ts(logged, ylab = "Sugar price", col = "darkgreen", main = "Logged data over time")
plot.ts(diff.ts[, "Sugar price"], col = "#a19f2d", main = "First difference of data")
plot.ts(clean_data[, "Sugar price"], col = "#8f1494", main = "First difference of data")



autoplot(my_data, series = "Sugar price") +
    autolayer(clean_data, series = "Without outliers") +
    xlab("Year") + ylab("Sugar price") +
    ggtitle("Sugar price over time without outliers") +
    scale_colour_manual(
        values = c("Sugar price" = "darkgreen", "Without outliers" = "#51bcc0"),
        breaks = c("Sugar price", "Without outliers")
    )


View(my_data)
View(diff.ts)

# Take first, second and third lag difference of data
firstlogDiff <- diff(log(my_data[, "Sugar price"]), lag = 1, differences = 1)
secondlogDiff <- diff(log(my_data[, "Sugar price"]), lag = 1, differences = 2)
thirdlogDiff <- diff(log(my_data[, "Sugar price"]), lag = 1, differences = 3)

summary(diff.ts)
Acf(my_data, lag.max = 20)
Pacf(my_data, lag.max = 20)
# Kolla diffad data
Acf(diff.ts, lag.max = 20, main = "Acf diffdata")
Pacf(diff.ts, lag.max = 20, main = "Pacf diffdata")
Acf(diff(diff.ts, lag.max = 20, main = "Lag2 diffdata"))
Pacf(diff(diff.ts, lag.max = 20, main = "Lag2 diffdata"))
Acf(diff(diff(diff.ts, lag.max = 20, main = "Lag3 diffdata")))
Pacf(diff(diff(diff.ts, lag.max = 20, main = "Lag3 diffdata")))
Acf(clean_data, lag.max = 20, main = "Acf cleandata")
Pacf(clean_data, lag.max = 20, main = "Pacf cleandata")
Acf(diff(clean_data, lag.max = 20, main = "Acf diffcleandata"))
Pacf(diff(clean_data, lag.max = 20, main = "Pacf diffcleandata"))
Acf(diff(diff(clean_data, lag.max = 20, main = "Lag2 cleandata")))
Pacf(diff(diff(clean_data, lag.max = 20, main = "Lag2 cleandata")))
adf.test(my_data)
adf.test(diff.ts)

# Verkar som att datan är är stationär i första differensen. Stor skillnad på lag 1 och 2


AR1 <- Arima(clean_data, order = c(1, 0, 0)) # AR(1)
MA1 <- Arima(clean_data, order = c(0, 1, 0)) # MA(1)
ARMA1 <- Arima(clean_data, order = c(1, 0, 1)) # ARMA(1)
Armalist <- list(AR1,MA1,ARMA1)

CleanARMA <- Arima(clean_data, order = c(2,1,1))
Clean_auto <- auto.arima(diffclean, trace = TRUE, seasonal = FALSE)


# moving average
autoplot(clean_data, series = "Sugar price") +
    autolayer(ma(clean_data, 3), series = "Moving average") +
    xlab("Year") + ylab("Sugar price") +
    ggtitle("Sugar price over time with moving average") +
    scale_colour_manual(
        values = c("Sugar price" = "blue", "Moving average" = "red"),
        breaks = c("Sugar price", "Moving average")
    )


model1 <- Arima(diff.ts, order = c(1, 0, 0))
model2 <- Arima(my_data, order = c(1, 1, 0))
model3 <- Arima(diff.ts, order = c(0, 0, 3))
model4 <- Arima(my_data, order = c(0, 1, 3))
model5 <- Arima(diffclean, order = c(0, 0, 1))
models <- list(model1, model2, model3, model4)
cleanmodels <- list(CleanARMA, Clean_auto)


forecast1 <- forecast(CleanARMA, n = 10)
for.mean <- my_data[nrow(my_data)] + cumsum(forecast1[["mean"]])


forecast2 <- forecast(model2, n = 10)
for.mean <- my_data[nrow(my_data)] + cumsum(forecast[["mean"]])

predict(model1, n.ahead = 10)
predict(model2, n.ahead = 10)

checkresiduals(model2)
Acf(residuals(model2))
Pacf(residuals(model2))

plot(my_data,main= "Ljung-Box Q Test", ylab= "P-values", xlab= "Lag")
qqline(CleanARMA$residuals)
qqnorm(CleanARMA$residuals)

auto.arima(my_data, trace = TRUE, seasonal = FALSE)

forecast(model3)

ﬁforecast(model4)


checkresiduals(ARMA1)
Acf(residuals(model3))
Pacf(residuals(model3))
autoplot(forecast(model1))
autoplot(forecast(model2))
autoplot(forecast(model3))
autoplot(forecast(model4))
