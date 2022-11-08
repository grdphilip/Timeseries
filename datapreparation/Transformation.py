import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


#Read data
df = pd.read_excel('../data/klein.xls')


#Extract data to make plotting easier
timeaxis = df.iloc[:,0]
Usadexp = df.iloc[:,1]
CPI = df.iloc[:,2]
GDP = df.iloc[:,3]

#Grid of multiple histograms
"""
axs[0].hist(CPI, edgecolor='black')
axs[1].hist(Usadexp, edgecolor='black')
"""

#Plotgrid
fig, axs=plt.subplots(nrows=1, ncols=2)

CPIReal = []
USDReal = []
Usadexp = np.array(Usadexp)

for i in CPI:
    CPIReal.append(i/100)
    
for i in CPIReal:
    USDReal.append(1/i)

"""
USDReal = np.array(USDReal)
NominalResult = np.array(Usadexp*USDReal)
axs[0].plot(timeaxis, NominalResult, color='green', label='Real GDP')
axs[0].plot(timeaxis, Usadexp, color = 'orange', label='Real ad expendture')
axs[0].legend()
plt.title(label='Ad expendture over consumption')

logDiffAdExp = np.diff(Usadexp)
logDiffGDP = np.diff(NominalResult)
axs[1].plot(logDiffAdExp, color='blue')
axs[1].plot(logDiffGDP, color='green')
"""
#Om differenses är negativ så kan man fuska och förskjuta kurvan geno att lägga till en konstan x > min(y)

#pd.plotting.lag_plot(CPI, lag=1)
plt.show()    
    

    

    





