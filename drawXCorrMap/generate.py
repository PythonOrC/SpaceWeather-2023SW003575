import copy
from glob import glob
import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt
names=[]
for file in glob('*.csv', recursive=True):
    names.append(file[:-4])
    
max_lag = float('-inf')
for name in names:
    data=pd.read_csv(name+'.csv', delimiter="	")
    data.index=list(data.columns)
    if name[-1:] != 'r':
        max_lag = max(max_lag,data.max().max())
        
max_lag = 60
    
for name in names:
    if name[-1:] == 'r':
        fmt = '.2f'
    else:
        fmt = '.0f'
    data=pd.read_csv(name+'.csv', delimiter="	")

    data.index=list(data.columns)
    
    plt.figure(figsize=(6, 4))
    plt.rc('font', size=12)
    if name[:4] == '1724':
        time = 'Storm-2'
    else:
        time = 'Storm-1'
        
    if name[-1:] == 'r':
        title = 'Correlation Coefficient Map of '+time + " " + name[4:-2].capitalize() +" Chain"
        label = 'Correlation Coefficient'
        cm = "viridis"
        lim_max = 1
    else:
        title = 'Lag Map of '+ time + " " + name[4:-4].capitalize()+" Chain"
        label = 'Lag (Minute)'
        cm = "viridis_r"
        lim_max = max_lag
    plt.suptitle(title,y=0.95)
    msk = np.invert(np.tril(np.ones_like(data, dtype=np.bool_)))
    data = np.abs(data)
    sns.heatmap(data, mask = msk, annot=False,fmt=fmt, color='white', cmap=sns.color_palette(cm, as_cmap=True), vmin = 0,vmax = lim_max, cbar_kws={'label': label})
    # , cmap = sns.color_palette("Spectral", as_cmap=True)
    plt.savefig("images/"+name+'.png')
    plt.show()
