import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
name = ['0509midnorth_r']
name = '0509uppernorth_r'

if name[-1:] == 'r':
    fmt = '.2f'
else:
    fmt = '.0f'
data=pd.read_csv(name+'.csv', delimiter="	")
data.index=list(data.columns)
print(data.head())
plt.figure(figsize=(19, 11))
        #    ,facecolor='#1e1f24')
sns.heatmap(data, annot=True,fmt=fmt, color='white')
plt.savefig("images/"+name+'.png')
plt.show()
