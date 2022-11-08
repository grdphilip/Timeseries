import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df = pd.read_csv('../data/eu_ger.csv', sep=';')

#Extract data
#df.dropna()
    
GER3m = df.iloc[:,1] #3 month average interest rate 
USBill3m = df.iloc[:,2] #3 month average treasury bill 
SWE3m = df.iloc[:,3] #3 month average interest rate
SEK_EUR = df.iloc[:,4] #Exchange rate SEK/EUR
SEK_USD = df.iloc[:,5] #Exchange rate SEK/USD
    

def compareData(df):
    for i in range(1, len(df.axes[1])):
        plt.plot(df.iloc[:,0],df.iloc[:,i], label= df.columns[i])

    print(df.head())
    plt.legend()
    plt.show()
    
    
#Data preparation
#Log all variables
logdf = pd.DataFrame()
logGer3m = np.log(GER3m)
logUSBill3m = np.log(USBill3m)
logSWE3m = np.log(SWE3m)
logSEK_EUR = np.log(SEK_EUR)
logSEK_USD = np.log(SEK_USD)
logdf['Time'] = df.iloc[:,0] 
logdf['logGer3m'] = logGer3m
logdf['logUSBill3m'] = logUSBill3m
logdf['logSWE3m '] = logSWE3m 
logdf['logSEK_EUR'] = logSEK_EUR 
logdf['logSEK_USD'] = logSEK_USD

#Take the df delta
deltadf = pd.DataFrame()
deltaGer3m = pd.Series(np.diff(GER3m))
deltaUSBill3m = pd.Series(np.diff(USBill3m))
deltaSWE3m = pd.Series(np.diff(SWE3m))
deltaSEK_EUR = pd.Series(np.diff(SEK_EUR))
deltaSEK_USD = pd.Series(np.diff(SEK_USD))
deltadf['Time'] = pd.Series(df.iloc[:,0])
deltadf['deltaGer3m'] = deltaGer3m
deltadf['deltaSBill3m'] = deltaUSBill3m
deltadf['deltaSWE3m '] = deltaSWE3m 
deltadf['deltaSEK_EUR'] = deltaSEK_EUR 
deltadf['deltaSEK_USD'] = deltaSEK_USD


#Delta log for stationarity
deltalogdf = pd.DataFrame()
deltalogGer3m = pd.Series(np.diff(np.log(GER3m)))
deltalogUSBill3m = pd.Series(np.diff(np.log(USBill3m)))
deltalogSWE3m = pd.Series(np.diff(np.log(SWE3m)))
deltalogSEK_EUR = pd.Series(np.diff(np.log(SEK_EUR)))
deltalogSEK_USD = pd.Series(np.diff(np.log(SEK_USD)))
deltalogdf['Time'] = pd.Series(df.iloc[:,0])
deltalogdf['deltalogGer3m'] = deltalogGer3m
deltalogdf['deltalogUSBill3m'] = deltalogUSBill3m
deltalogdf['deltalogSWE3m '] = deltalogSWE3m 
deltalogdf['deltalogSEK_EUR'] = deltalogSEK_EUR 
deltalogdf['deltalogSEK_USD'] = deltalogSEK_USD

