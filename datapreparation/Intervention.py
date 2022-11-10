import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df_mozam = pd.read_excel('../data/Ex_2_Intervention/mozam_gdp_q.xls')
#df_rwt = pd.read_excel('../data/Ex_2_Intervention/random_walk_trend.xlsx')
df_rw = pd.read_excel('../data/Ex_2_Intervention/rw.xls')
df_swe_exch = pd.read_excel('../data/Ex_2_Intervention/swe_exch.xls')
df_swe_gdp = pd.read_excel('../data/Ex_2_Intervention/swe_gdp.xls')
df_swe_ipi =  pd.read_excel('../data/Ex_2_Intervention/swe_ipi_mon.xlsx')
adj_df_swe_ipi =  pd.read_excel('../data/Ex_2_Intervention/swe_ipi_mon.xlsx')

def compareData(df):
    for i in range(1, len(df.axes[1])):
        plt.plot(df.iloc[:,0],df.iloc[:,i], label= df.columns[i])

    print(df.head())
    plt.legend()
    plt.show()
    
#Identify outliers and replace them with mean
#compareData(df_swe_ipi)

mean_ipi = np.mean(df_swe_ipi)
adj_df_swe_ipi.iloc[64,:] = float(mean_ipi)
print(df_swe_ipi.iloc[64,:])
print(adj_df_swe_ipi.iloc[64,:])

difflogipi = pd.Series(np.diff(np.log(float(df_swe_ipi))))
difflogajdipi =  pd.Series(np.diff(np.log(float(adj_df_swe_ipi))))


fig, axs=plt.subplots(nrows=2, ncols=2)

#Seasonlity can be dealt with by: seasonality differencing- 


