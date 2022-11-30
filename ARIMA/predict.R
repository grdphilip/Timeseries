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

my_data <- read_excel("./data/commodities-1.xls") #Load our data
my_data <- ts(my_data[, "Sugar price"], start = c(1960, 1), end = c(2022, 10), frequency = 12) #Transform to timesseries
colnames(my_data) <- "Sugar price" #Name column Sugar price
newSeries <- window(my_data, start=1982, frequency=12) #Cut off volatile period
logNew <- log(newSeries)
diffNew <- diff(newSeries)
diffLogNew <- diff(logNew)

#Identify outliers, compare results to make sure outliers are gone 
outlied <- subset(my_data, my_data[,1] >= (mean(my_data)*3.5))
notOutlied <- subset(newSeries, newSeries[,1] >= (mean(newSeries)*3.5)) 
notOutlied2 <- subset(diffLogNew, diffLogNew[,1] >= (mean(diffLogNew)*3.5)) 

#Plots
plot.ts(my_data , ylab = "Sugar price", col = "blue", main = "Suger price over time")
plot.ts(newSeries, ylab = "Sugar price", col = "blue", main = "Suger price over time")
plot.ts(logNew, ylab = "Sugar price", col = "darkgreen", main = "Logged data over time")
plot.ts(diffNew, col = "#a19f2d", main = "First difference of data")
plot.ts(clean_data[, "Sugar price"], col = "#8f1494", main = "First difference of data")
plot.ts(diffLogNew, col = "#8f1494", main = "First diff of logged series from 1982")
boxplot(my_data, col="lightblue", main="Boxplot to detect outliers")
hist(my_data, col="lightblue")
autoplot(my_data, series = "Sugar price") +
    autolayer(newSeries, series = "Without outliers") +
    xlab("Year") + ylab("Sugar price") +
    ggtitle("Sugar price over time without outliers") +
    scale_colour_manual(
        values = c("Sugar price" = "blue", "Without outliers" = "orange"),
        breaks = c("Sugar price", "Without outliers")
    )

z_score=(my_data-(mean(my_data))/sd(my_data))
plot(z_score, type="o", col="purple", main="Outlier identification")

# Determine ARIMA order with 
Acf(newSeries ,lag.max = 20, main = "Acf diffdata")
Pacf(newSeries, lag.max = 20, main = "Pacf diffdata")
Acf(diffLogNew, lag.max = 20)
Pacf(diffLogNew, lag.max = 20)




# Verkar som att datan är är stationär i första differensen. Stor skillnad på lag 1 och 2
model1 <- arima(newSeries, order=c(2,1,0)) #Only based on cut off data
model2 <- arima(newSeries, order=c(1,1,2)) #1st diff of logged cut off data 
auto.arima(newSeries, trace=TRUE, seasonal = FALSE) #Suggests (2,1,1)
model3 <- arima(newSeries, order = c(2,1,1))



# moving average
autoplot(diffLogNew, series = "Sugar price") +
    autolayer(ma(diffLogNew, 3), series = "Moving average") +
    xlab("Year") + ylab("Sugar price") +
    ggtitle("Sugar price over time with moving average") +
    scale_colour_manual(
        values = c("Sugar price" = "blue", "Moving average" = "red"),
        breaks = c("Sugar price", "Moving average")
    )



forecast1 <- forecast(model1, n = 10)
forecast2 <- forecast(model2, n = 10)
forecast3 <- forecast(model3, n = 10)
for.mean <- my_data[nrow(my_data)] + cumsum(forecast1[["mean"]])

predict(forecast3, n.ahead = 10)
autoplot(predict(forecast3))

checkresiduals(model1)
Acf(residuals(model2))
Pacf(residuals(model2))

plot(my_data,main= "Ljung-Box Q Test", ylab= "P-values", xlab= "Lag")
qqline(CleanARMA$residuals)
qqnorm(CleanARMA$residuals)


validatePred <- window(my_data, start=1982, frequency=12, end=2017)
validateAct <- window(my_data, start=1982, frequency=12, end=2019)
plot.ts(validatePred, ylab = "Sugar price", col = "darkgreen", main = "Logged data over time")
plot.ts(validateAct, col = "#a19f2d", main = "First difference of data")
Acf(diff(validatePred), lag.max = 20)
Pacf(diff(validatePred), lag.max = 20)

model4 <- arima(validatePred, order=c(1,1,2))
forecast4 <- forecast(model4, n=10)
predict(forecast4, n.ahead=10)
autoplot(predict(forecast4))

autoplot(predict(forecast4), series = "Prediction") +
    autolayer(validateAct, series = "Actual price") +
    xlab("Year") + ylab("Sugar price") +
    ggtitle("Validated prediction to 2019") +
    scale_colour_manual(
        values = c("Prediction" = "blue", "Actual price" = "red"),
        breaks = c("Prediction", "Actual price")
    )
